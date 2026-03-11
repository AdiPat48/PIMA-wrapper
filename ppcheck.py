import os
import csv
import json
import pandas as pd
import numpy as np
from numba import njit
from Bio.PDB import MMCIFParser, MMCIF2Dict

# --- CONFIGURATION ---
cif_list_csv = "/home/mini/aditipathak/PIMADB_Update_Nov2024/pdbs/assembly1_cif_files/assembly1_cif_files_list.csv"
results_manifest = "/home/mini/aditipathak/PIMADB_Update_Nov2024/ppcheck_results/pima_done_09032026.txt"
homology_file = "/home/mini/aditipathak/PIMADB_Update_Nov2024/ppcheck_results/homologous_chains_pairs.tsv"
standard_amino_acids = ['ALA', 'ARG', 'ASN', 'ASP', 'CYS', 'GLN', 'GLU', 'GLY', 'HIS', 'ILE', 'LEU', 'LYS', 'MET', 'PHE', 'PRO', 'SER', 'THR', 'TRP', 'TYR', 'VAL']
log_path = "progress_check.log"
summary_csv_path = "pima_checks_summary.csv"

ATOMIC_MASSES = {'C': 12.011, 'N': 14.007, 'O': 15.999, 'S': 32.06, 'H': 1.008, 'P': 30.974}
BACKBONE_ATOMS = {'N', 'CA', 'C', 'O', 'H', 'HA'}

# --- NUMBA TOOLS ---
@njit
def calculate_interactions(coords1, coords2, cutoff):
    for i in range(len(coords1)):
        for j in range(len(coords2)):
            dist = np.sqrt(np.sum((coords1[i] - coords2[j])**2))
            if dist <= cutoff:
                return True
    return False

# --- PRE-PROCESSING: BUILD PATH LOOKUP ---
if not os.path.exists(results_manifest):
    raise FileNotFoundError(f"VIOLENT ERROR: Manifest {results_manifest} missing.")

path_lookup = {}
with open(results_manifest, 'r') as f:
    for line in f:
        path = line.strip()
        if not path: continue
        fname = os.path.basename(path)
        if "_ppcheck_results.csv" in fname:
            pid = fname.replace("_ppcheck_results.csv", "")
            path_lookup.setdefault(pid, {})['ppcheck'] = path
        elif "_hotpies.csv" in fname:
            pid = fname.replace("_hotpies.csv", "")
            path_lookup.setdefault(pid, {})['hotpies'] = path
        elif "_sasa.json" in fname:
            pid = fname.replace("_sasa.json", "")
            path_lookup.setdefault(pid, {})['sasa'] = path

# --- MAIN LOOP ---
if os.path.exists(log_path): os.remove(log_path)
summary_data = []

with open(cif_list_csv, 'r') as f:
    reader = csv.DictReader(f)
    for entry in reader:
        cif_path = entry['cif_path']
        pdb_id = entry['cif_id']
        
        # Initialize flags for this PDB
        flags = {
            "pdb_id": pdb_id,
            "num_protein_chains": 0,
            "int_pairs_cb": 0, "int_pairs_atom": 0, "int_pairs_com": 0,
            "ppcheck_found": False, "ppcheck_pairs_match": False, "all_energies_neg": True,
            "hotpies_found": False, "hotpies_pairs_match": False,
            "sasa_found": False, "homology_pairs": 0, "nucleic_acid": False, "naming_collision": False
        }
        
        with open(log_path, 'a') as log:
            log.write(f"\n--- Processing {pdb_id} ---\n")
            if not os.path.exists(cif_path):
                raise FileNotFoundError(f"VIOLENT ERROR: CIF {cif_path} not found.")

            # Detect NMR
            is_nmr = False
            try:
                mmcif_dict = MMCIF2Dict(cif_path)
                if '_exptl.method' in mmcif_dict:
                    methods = mmcif_dict['_exptl.method']
                    if isinstance(methods, str): methods = [methods]
                    if 'NMR' in ' '.join(methods): is_nmr = True
            except: pass

            parser = MMCIFParser(QUIET=True)
            structure = parser.get_structure(pdb_id, cif_path)
            num_models = len(list(structure))
            use_model_suffix = (num_models > 1 and not is_nmr)

            all_original_ids = set(str(c.id) for m in structure for c in m)
            valid_protein_chains = {}
            dna_rna_found = []
            
            model_counter = 0
            for model in structure:
                model_counter += 1
                for chain in model:
                    original_id = str(chain.id)
                    new_id = f"{original_id}{model_counter}" if use_model_suffix else original_id
                    
                    if use_model_suffix and new_id in all_original_ids and new_id != original_id:
                        flags["naming_collision"] = True

                    protein_res = [r for r in chain if r.get_resname().upper() in standard_amino_acids]
                    if any(r.get_resname().upper() in ['DA', 'DT', 'DC', 'DG', 'A', 'U', 'C', 'G'] for r in chain):
                        dna_rna_found.append(new_id)
                    
                    if len(protein_res) > 10:
                        valid_protein_chains[new_id] = protein_res

            flags["num_protein_chains"] = len(valid_protein_chains)
            flags["nucleic_acid"] = len(dna_rna_found) > 0

            # 2. Distance Calculations
            v_ids = list(valid_protein_chains.keys())
            coords_cache = {}
            for cid in v_ids:
                cb, atoms, com = [], [], []
                for res in valid_protein_chains[cid]:
                    if 'CB' in res: cb.append(res['CB'].coord)
                    elif 'CA' in res: cb.append(res['CA'].coord)
                    for atom in res: atoms.append(atom.coord)
                    sc = [a for a in res if a.name not in BACKBONE_ATOMS]
                    if sc:
                        m_sum = sum(ATOMIC_MASSES.get(a.element, 12.01) for a in sc)
                        weighted = sum(a.coord * ATOMIC_MASSES.get(a.element, 12.01) for a in sc)
                        com.append(weighted / m_sum)
                    elif 'CA' in res: com.append(res['CA'].coord)
                coords_cache[cid] = {'cb': np.array(cb), 'all': np.array(atoms), 'com': np.array(com)}

            interacting_pairs = []
            for i in range(len(v_ids)):
                for j in range(i + 1, len(v_ids)):
                    c1, c2 = v_ids[i], v_ids[j]
                    i_cb = calculate_interactions(coords_cache[c1]['cb'], coords_cache[c2]['cb'], 10.0)
                    i_at = calculate_interactions(coords_cache[c1]['all'], coords_cache[c2]['all'], 4.0)
                    i_cm = calculate_interactions(coords_cache[c1]['com'], coords_cache[c2]['com'], 5.0)
                    if i_cb: flags["int_pairs_cb"] += 1
                    if i_at: flags["int_pairs_atom"] += 1
                    if i_cm: flags["int_pairs_com"] += 1
                    if i_cb or i_at or i_cm:
                        interacting_pairs.append((c1, c2))

            # 3, 4, 5. Result Validation
            pdb_files = path_lookup.get(pdb_id, {})
            
            # PPCheck Check
            pp_path = pdb_files.get('ppcheck')
            if pp_path and os.path.exists(pp_path):
                flags["ppcheck_found"] = True
                df = pd.read_csv(pp_path)
                found = set(zip(df['chainA'].astype(str), df['chainB'].astype(str)))
                match = True
                for p1, p2 in interacting_pairs:
                    if (p1, p2) not in found and (p2, p1) not in found: match = False
                flags["ppcheck_pairs_match"] = match
                if not match: raise ValueError(f"VIOLENT ERROR: Missing pairs in {pp_path}")
                if not df[df['Total Stabilizing Energy'] >= 0].empty: flags["all_energies_neg"] = False
            
            # Hotpies Check
            hp_path = pdb_files.get('hotpies')
            if hp_path and os.path.exists(hp_path):
                flags["hotpies_found"] = True
                hp_df = pd.read_csv(hp_path, header=None)
                hp_pairs = set(zip(hp_df[1].astype(str), hp_df[2].astype(str)))
                match = True
                for p1, p2 in interacting_pairs:
                    if (p1, p2) not in hp_pairs and (p2, p1) not in hp_pairs: match = False
                flags["hotpies_pairs_match"] = match
                if not match: raise ValueError(f"VIOLENT ERROR: Missing pairs in {hp_path}")

            # SASA & Homology
            flags["sasa_found"] = True if pdb_files.get('sasa') else False
            if os.path.exists(homology_file):
                hom_df = pd.read_csv(homology_file, sep='\t')
                flags["homology_pairs"] = len(hom_df[hom_df['Query_Chain'].str.startswith(pdb_id)])

            summary_data.append(flags)

# Write Summary CSV
pd.DataFrame(summary_data).to_csv(summary_csv_path, index=False)
print(f"Workflow Complete. Summary saved to {summary_csv_path}")