"""
Python wrapper for hotspot prediction using HotPies
"""

import os
from ppcheck import get_interface_residues

def run_hotpies(pdb_name, chain_a, chain_b, pdb_result_dir, hotpies_codes_folder):
    """
    Run HotPies for a given chain pair
    """
    try:
        combinations_dir = f"{pdb_result_dir}/{pdb_name}.{chain_a}.{chain_b}"
        pdb_filename = f"{pdb_name}_{chain_a}_{chain_b}"

        # Check if PPCheck already ran
        interface_residues_file = f"{combinations_dir}/interface_residues"

        if not os.path.exists(interface_residues_file):
            return (chain_a, chain_b, False, f"No PPCheck results for combination {pdb_name}.{chain_a}.{chain_b}")
        else:
            if get_interface_residues(interface_residues_file, chain_a, chain_b):
                # Run HotPIES
                command = f"bash {hotpies_codes_folder}/automate_hotpies_ap.sh {hotpies_codes_folder} {pdb_filename} A B {combinations_dir}"
                os.system(command)                    
            else:
                return (chain_a, chain_b, False, "No interface residues found")

        
        return (chain_a, chain_b, True)
    
    except Exception as e:
        return (chain_a, chain_b, False, str(e))

def get_hotpies_results(hotpies_results_file, chain_a, chain_b):
    chains_dict = {'A': chain_a, 'B': chain_b}
    with open(hotpies_results_file, 'r') as f:
        hotspots=[]
        lines = f.readlines()
        if len(lines) == 0:
            hotspots.append("No Hotspots Predicted")
        else:
            for ln in lines:
                hotspot = ln.strip().split(',')[3]
                hotspot = chains_dict[hotspot[0]] + hotspot[1:]
                hotspots.append(hotspot)
    return ";".join(hotspots)



