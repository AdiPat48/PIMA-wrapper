import os
import shutil
from ppcheck import run_ppcheck, consolidate_ppcheck_results
from hotpies import run_hotpies, get_hotpies_results
from sasa import get_sasa
from Bio.PDB.MMCIFParser import MMCIFParser
from Bio.PDB.PDBParser import PDBParser
from Bio.PDB import Structure, Model, Chain
from Bio.PDB.MMCIF2Dict import MMCIF2Dict
from concurrent.futures import ProcessPoolExecutor, as_completed
from Bio.PDB.Polypeptide import is_aa





def run_pima(structure_file, ppcheck_results_dir, ppcheck_codes_folder, hotpies_codes_folder,  max_workers_combinations, max_number_of_chains, OVERWRITE, RUN_SASA, RUN_PPCHECK, RUN_HOTPIES, CLEANUP, freesasa_path):
    """
    Run PIMA analysis for a given structure file.
    
    """

    try:
        # Parse structure file
        pdb_name = os.path.basename(structure_file).split('.')[0] + os.path.basename(structure_file).split('.')[1][3:]        
        model, chains = parse_file(structure_file)
        if not 1 <= len(chains) <= max_number_of_chains:
            print(f"Error : Skipping {pdb_name} because it is a monomer or has more than {max_number_of_chains} chains.")
            with open(f"{ppcheck_results_dir}/skipped_files.txt", 'a') as f:
                f.write(f"{structure_file},Reason: Monomer or has more than {max_number_of_chains} chains\n")
            return (True,structure_file,)
        
        # Set up result directory
        pdb_result_dir = f"{ppcheck_results_dir}/{pdb_name}"
        
        chain_combinations = []  # Lets follow same chain order as in the input file
        for i in range(len(chains)):
            for j in range(i + 1, len(chains)):
                chain_a = chains[i]
                chain_b = chains[j]
                chain_combinations.append((chain_a, chain_b))


        if OVERWRITE:
            if os.path.exists(pdb_result_dir) and RUN_PPCHECK:
                shutil.rmtree(pdb_result_dir)
            if os.path.exists(f"{ppcheck_results_dir}/{pdb_name}_sasa.json") and RUN_SASA:
                os.remove(f"{ppcheck_results_dir}/{pdb_name}_sasa.json")
            if os.path.exists(f"{ppcheck_results_dir}/{pdb_name}_ppcheck_results.csv") and RUN_PPCHECK:
                os.remove(f"{ppcheck_results_dir}/{pdb_name}_ppcheck_results.csv")
            if os.path.exists(f"{ppcheck_results_dir}/{pdb_name}_hotpies.csv") and RUN_HOTPIES:
                os.remove(f"{ppcheck_results_dir}/{pdb_name}_hotpies.csv")

        else:
            if os.path.exists(f"{ppcheck_results_dir}/{pdb_name}_sasa.json"):
                print(f"SASA results already exist for {pdb_name}")
                RUN_SASA = False
            if os.path.exists(f"{ppcheck_results_dir}/{pdb_name}_ppcheck_results.csv"):
                print(f"PPCheck results already exist for {pdb_name}")
                RUN_PPCHECK = False
            if os.path.exists(f"{ppcheck_results_dir}/{pdb_name}_hotpies.csv"):
                print(f"HotPIES results already exist for {pdb_name}")
                RUN_HOTPIES = False


        if RUN_PPCHECK:
            os.makedirs(pdb_result_dir, exist_ok=True) 
            # Parallelizing ppcheck runs for all possible combinations of chain pairs 
            tasks = []               
            with ProcessPoolExecutor(max_workers=max_workers_combinations) as executor:  
                for combination in chain_combinations:
                    chain_a, chain_b = combination              
                    tasks.append(
                        executor.submit(
                            run_ppcheck,
                            pdb_name,
                            chain_a,
                            chain_b,
                            model,
                            pdb_result_dir,
                            ppcheck_codes_folder,) )

            # Ensure all tasks are completed
            for future in as_completed(tasks):
                chain_a, chain_b, success, *error = future.result()
                if not success:
                    print(f"Error running PPCheck for chains {chain_a} and {chain_b} of {pdb_name}: {error[0]}")

            # Combine results
            consolidate_ppcheck_results(pdb_name, chain_combinations, pdb_result_dir, ppcheck_results_dir)


        if RUN_HOTPIES:
            # Parallelizing hotpies runs for all possible combinations of chain pairs
            tasks = []
            with ProcessPoolExecutor(max_workers=max_workers_combinations) as executor:
                for combination in chain_combinations:
                    chain_a, chain_b = combination
                    tasks.append(
                        executor.submit(
                            run_hotpies,
                            pdb_name, 
                            chain_a, 
                            chain_b, 
                            pdb_result_dir, 
                            hotpies_codes_folder))

            # Ensure all tasks are completed
            for future in as_completed(tasks):
                chain_a, chain_b, success, *error = future.result()
                if not success:
                    print(f"Error running HotPIES for chains {chain_a} and {chain_b} of {pdb_name}: {error[0]}")

            
            hotpies_outputfile = f"{ppcheck_results_dir}/{pdb_name}_hotpies.csv"
            with open(hotpies_outputfile, 'w') as f:
                for combination in chain_combinations:
                    chain_a, chain_b = combination
                    combination_folder = f"{pdb_result_dir}/{pdb_name}.{chain_a}.{chain_b}"
                    hotpies_results_file = f"{combination_folder}/predicted-result.csv"
                    if os.path.exists(hotpies_results_file):
                        hotpies_results = get_hotpies_results(hotpies_results_file, chain_a, chain_b)
                        f.write(f"{pdb_name},{chain_a},{chain_b},{hotpies_results}\n")

        if RUN_SASA:
            try:
                get_sasa(structure_file,ppcheck_results_dir,freesasa_path)
            except Exception as e:
                raise ValueError(f"Error while calculating SASA for {structure_file}: {e}")    

        if CLEANUP:
            remove_temp_files(pdb_result_dir)


        return (True,structure_file,)
    
    except Exception as e:
        return (False,structure_file, str(e))
    
def parse_file(file_path):

    is_nmr = False

    # Validate Input
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File {file_path} does not exist.")
    file_extension = os.path.basename(file_path).split('.')[-1].lower()[:3]
    filename = os.path.basename(file_path)
    
    if file_extension not in ('pdb', 'cif'):
        raise ValueError(f"File {file_path} must be in .pdb or .cif format.")
    
    try:
        if file_extension == 'pdb':
            parser = PDBParser(QUIET=True)
            with open(file_path, 'r') as f:
                lines = f.readlines()
                for line in lines:
                    if line.startswith('EXPDTA'):
                        if 'NMR' in line:
                            is_nmr = True
                            break
        
        elif file_extension == 'cif':
            parser = MMCIFParser(QUIET=True)
            pdb_info = MMCIF2Dict(file_path)

            # Skip if method is not defined
            if '_exptl.method' in pdb_info: 
                assert isinstance(pdb_info['_exptl.method'], list)
                if 'NMR' in ' '.join(pdb_info['_exptl.method']):
                    is_nmr = True
        
        structure = parser.get_structure('structure', file_path)

    except Exception as e:
        raise ValueError(f"Error while parsing the file {file_path}: {e}")

    # Check the number of models
    models = list(structure)
    num_models = len(models)

    if num_models == 1 or is_nmr:
        chain_ids = [chain.id for chain in models[0] if check_is_protein(chain)]

        return models[0], chain_ids
    else:
        
        model = consolidate_chains(structure) 
        chain_ids = [chain.id for chain in model if check_is_protein(chain)]

        return model, chain_ids       

def check_is_protein(chain):
    """
    Check if the chain contains at least one standard amino acid.
    """
    for residue in chain.get_residues():
        if is_aa(residue, standard=True):
            return True
    print(f"Chain {chain.id} does not contain any standard amino acids. Skipping this chain")
    return False


def consolidate_chains(structure):
    """
    Combine chains from all models into a single model.
    """
    
    combined_structure = Structure.Structure("combined_structure")
    combined_model = Model.Model(0)
    combined_structure.add(combined_model)

    chain_ids = set()  # Track used chain IDs to avoid duplicates

    counter = 0
    for model in structure:
        counter += 1
        for chain in model:
            original_chain_id = chain.id
            new_chain_id = f"{original_chain_id}{counter}"        
            chain.id = new_chain_id  # Rename to avoid conflicts
            chain_ids.add(new_chain_id)
            combined_model.add(chain)
    return combined_structure[0]

def remove_temp_files(pdb_result_dir):
    try:
        shutil.rmtree(pdb_result_dir)
    except OSError as e:
        print(f"Error while removing temp files in {pdb_result_dir}: {e}")
