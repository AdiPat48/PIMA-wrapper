# ---------------------------------------------------------
default_configuration_file = '/home/mini/aditipathak/PIMADB_Update_Nov2024/PIMA/plangpu_default.conf'
# ---------------------------------------------------------

import os
import ast
import argparse
from pima import run_pima
from concurrent.futures import ProcessPoolExecutor, as_completed
import resource


# -- Functions -- #

def get_default_configuration():
    """
    Load the default configuration from a conf file.
    """

    conf_dict = {}
    with open(default_configuration_file, 'r') as f:
        for ln in f.readlines():
            if ln == '\n' or ln.startswith('#'):  # Skip empty lines and comments
                continue
            key, value = ln.split('#')[0].strip().split('=', 1)  # Remove comments
            try:
                conf_dict[key] = ast.literal_eval(value)
            except (ValueError, SyntaxError):
                conf_dict[key] = value
    return conf_dict

def parse_arguments():
    """
    Parse command-line arguments.
    """

    parser = argparse.ArgumentParser(description="Process PDB files with multiprocessing.")
    parser.add_argument("--pdbs_list", type=str, help="File containing a list of PDB IDs (to be plugged into the structure_file_format) or full path to structure files")
    parser.add_argument("--max_workers_pima", type=int, help="Maximum number of PDBs to be processed")
    parser.add_argument("--max_workers_ppcheck", type=int, help="Maximum number of chain combinations to be processed per PDB")
    parser.add_argument("--pdb_number_start", type=int, help="Start PDB number")
    parser.add_argument("--pdb_number_end", type=int, help="End PDB number")
    parser.add_argument("--output_folder", type=str, help="Batch number")
    parser.add_argument("--input_folder", type=str, help="Folder containing the PDB structure files")
    parser.add_argument("--structure_file", type=str, help="Input file")
    parser.add_argument("--structure_file_format", type=str, help="Format for path to the PDB structure files")
    parser.add_argument("--size_sort", type=bool, help="Sort PDBs by size (smallest to largest)")
    parser.add_argument("--max_ram_mb", type=int, help="Maximum memory usage")
    parser.add_argument("--max_number_of_chains", type=int, help="Maximum number of chains to process")
    parser.add_argument("--skip_list", type=str, help="File containing the list of structure files to skip. Give full path of files to skip")


    return parser.parse_args()

def limit_memory(max_ram_mb):
    """
    Limit the memory usage of the process to `max_ram_mb` megabytes.
    """    
    soft, hard = resource.getrlimit(resource.RLIMIT_AS)
    resource.setrlimit(resource.RLIMIT_AS, (max_ram_mb * 1024 * 1024, hard))

def get_structure_files(args, size_sort=False):
    """
    Load PDB IDs from the given a pdb_list file, input folder or structure file. 
    Returns a list of paths to the structure files.
    """
    structure_files =[]

    if args.pdbs_list:
        pdb_list_file_path = args.pdbs_list
        print(f"--- Reading PDB IDs from {pdb_list_file_path} ---")
        with open(pdb_list_file_path , "r") as f:
            for pdb_id in f.read().splitlines():
                if os.path.isfile(structure_file_format.format(pdb_id)):
                    structure_files.append(structure_file_format.format(pdb_id))
                elif os.path.isfile(pdb_id):
                    print(f"File {pdb_id} exists. Ignoring the structure file format.")
                    structure_files.append(pdb_id)
                else:
                    print(f"File {structure_file_format.format(pdb_id)} does not exist")

    elif args.input_folder:
        folder_path = args.input_folder
        print(f"--- Reading structure files from '{folder_path}' ---")
        structure_files = [f'{folder_path}/{x}' for x in os.listdir(folder_path) if (x.startswith(structure_file_format.split('{')[0]) and x.endswith(structure_file_format.split('}')[1]))]
    elif args.structure_file:
        structure_files.append(args.structure_file)
    else:
        print("No structure files to process")
        quit()
    print(len(structure_files), " structure files to process")
    if args.skip_list:
        skip_list_file_path = args.skip_list
        print(f"--- Skipping structure files from {skip_list_file_path} ---")
        with open(skip_list_file_path , "r") as f:
            skip_list = f.read().splitlines()
        structure_files = [x for x in structure_files if not any(skip in x for skip in skip_list)]
        print(len(structure_files), "structure files to process after skipping")

    if size_sort:
        structure_files = sorted( structure_files, key=lambda structure_file: os.path.getsize(structure_file))

    return structure_files



def main():
    # Load defaults and command-line arguments
    config = get_default_configuration()
    args = parse_arguments()

    # Only override defaults if argument is provided
    for key, value in vars(args).items():
        if value is not None:  
            config[key] = value

    # Assign variables dynamically
    globals().update(config)

    # Limit memory usage
    if max_ram_mb : 
        limit_memory(max_ram_mb) 
    

    # Get the list of input structure files
    structures_list = get_structure_files(size_sort=size_sort, args=args)

    os.makedirs(output_folder, exist_ok=True)
        
    with ProcessPoolExecutor(max_workers=max_workers_pima) as executor: 
        tasks = []
        for structure_file in structures_list:
            print(f"Processing {structure_file}...")        
            tasks.append(
                executor.submit(
                    run_pima,
                    structure_file, 
                    output_folder, 
                    ppcheck_codes_folder,
                    hotpies_codes_folder, 
                    max_workers_ppcheck,
                    max_number_of_chains,
                    OVERWRITE, 
                    RUN_SASA, 
                    RUN_PPCHECK, 
                    RUN_HOTPIES,
                    CLEANUP,
                    freesasa_path ))
        # Ensure all tasks are completed
    for future in as_completed(tasks):
        success, structure_file, *error = future.result()
        if not success:
            print(f"Error processing {structure_file}: {error[0]}")
        else:
            print(f"Finished processing {structure_file}")

# -- Main -- #

if __name__ == "__main__":
    main()
    os.system("date")
    os.system("echo 'All done!'")
