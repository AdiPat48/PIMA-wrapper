import os 

def get_sasa(file_path,ppcheck_results_dir,freesasa_path):

    filename = os.path.basename(file_path)
    file_extension = filename.split('.')[-1].lower()[:3]
    pdb_name = filename.split('.')[0]
    if file_extension == 'cif':
        input_structure_argument = f"--cif {file_path}"
    elif file_extension == 'pdb':
        input_structure_argument = f"--pdb {file_path}"
    else:
        raise ValueError("File must be in .pdb or .cif format.")
    
    outputfile = f"{ppcheck_results_dir}/{pdb_name}_sasa.json"
    command = f"{freesasa_path} {input_structure_argument} --format=json --output={outputfile} --lee-richards --probe-radius=1.4 --depth=atom"
    os.system(command)



""" get sasa results from json file """
# def get_sasa_results(sasa_results_file):
#     with open(sasa_results_file, 'r') as f:
#         sasa_dict = json.load(f)
