
import os
from copy import deepcopy
import shutil
from Bio.PDB import PDBIO, Structure, Model



def run_ppcheck(pdb_name, chain_a, chain_b, model, pdb_result_dir, ppcheck_codes_folder):
    """
    Process a single chain pair: extract chains, save to file, make compatible, and run ppcheck.
    """
    try:       
        
        combination_folder = f"{pdb_result_dir}/{pdb_name}.{chain_a}.{chain_b}"
        os.makedirs(combination_folder, exist_ok=True)
        
        # Extract chains of interest
        atoms_structure_object = get_chains_of_interest(pdb_name, model, chain_a, chain_b)

        # Save the chains to a file
        preprocessed_pdb_file = f"{combination_folder}/{pdb_name}_{chain_a}_{chain_b}.pdb"
        io = PDBIO()
        io.set_structure(atoms_structure_object)
        io.save(preprocessed_pdb_file)

        # Make PDB file ppcheck-compatible
        make_ppcheck_compatible(preprocessed_pdb_file)

        os.system(f"bash {ppcheck_codes_folder}/run_ppcheck_2chains_1.sh {os.path.basename(preprocessed_pdb_file)} A B {combination_folder} {ppcheck_codes_folder}")

        return (chain_a, chain_b, True)
    
    except Exception as e:
        return (chain_a, chain_b, False, str(e))
    

def get_chains_of_interest(pdb_name,model, chain_a, chain_b):
    try:
        chain_a_obj = deepcopy(model[chain_a])  
    except KeyError:
        raise ValueError(f"Error: Chain {chain_a} not present in the model for {pdb_name}, {chain_a}, {chain_b}")
    
    try:
        chain_b_obj = deepcopy(model[chain_b])
    except KeyError:
        raise ValueError(f"Error: Chain {chain_b} not present in the model for {pdb_name}, {chain_a}, {chain_b}")
                
    # Extract chains
    atoms_structure_object = Structure.Structure("atoms")
    atoms_model = Model.Model(0)
    atoms_structure_object.add(atoms_model)

    # Rename chains and add to the model
    
    atoms_model.add(chain_a_obj)
    atoms_model.add(chain_b_obj)
    atoms_model[chain_a].id = 'chainA' # To make sure there is no clash with the original chain ids
    atoms_model[chain_b].id = 'chainB'
    atoms_model['chainA'].id = 'A'
    atoms_model['chainB'].id = 'B'

    for chain in atoms_model:
        if len(chain) > 10000:
            with open('Errors_max_chain_length.txt', 'a') as f:
                f.writelines(f'Error : Chain length is greater than 10000, i.e. {len(chain)}, for {chain.id} in {pdb_name}\n')
            print(f'Chain length is greater than 10000, i.e. {len(chain)}, for {chain.id} in {pdb_name}')    
            pass # Placeholder for a function to extract interface residues - Need to figure out a way to handle cases like this
               
    return atoms_structure_object
        
def make_ppcheck_compatible(pdb_file) :
    with open(pdb_file, 'r') as f:
        atoms_pdb=""
        for x in f.readlines():
            if x.startswith('ATOM'):
                atoms_pdb += x.strip()[:78] + '\n'

    with open(pdb_file, 'w') as f:
        f.write(atoms_pdb)
    
    return True


# Functions to fetch PPCheck Results

def consolidate_ppcheck_results(pdb_name, chain_combinations, pdb_result_dir, ppcheck_results_dir):
    """
    Fetch PPCheck results for a given chain pair
    """
    # Combine results
    outputfile = f"{ppcheck_results_dir}/{pdb_name}_ppcheck_results.csv"
    with open(outputfile, 'w') as f:
        f.write(
                "pdb,chainA,chainB,Hydrogen Bond Energy,Electrostatic Energy,van der Waals Energy,"
                    "Total Stabilizing Energy,Number of interface residues,Normalized Energy per residue,"
                    "No. of Short Contacts,No. of Hydrophobic Interactions,No. of van der Waals Pairs,"
                    "No. of Salt Bridges,No. of Potential Favourable Electrostatic Interactions,"
                    "No. of Potential Unfavourable Electrostatic Interactions,Interface Residues,"
                    "Network,Predicted Hotspots,Hydrogen Bonds,Hydrophobic Interactions,Salt Bridges,"
                    "Electrostatic Interactions,Unfavourable Electrostatic Interactions,Short Contacts\n"
                )
        
        # Parse results for each chain pair
        for chain_combination in chain_combinations:
            chain_a = chain_combination[0]
            chain_b = chain_combination[1]
            combination_folder = f"{pdb_result_dir}/{pdb_name}.{chain_a}.{chain_b}"

            interface_residues_file = f"{combination_folder}/interface_residues"
            # Extract and write results
            interfaces = get_interface_residues(interface_residues_file, chain_a, chain_b)
            if not interfaces:
                # I'll delete this folder then
                shutil.rmtree(combination_folder)
                continue

            result_dat_file = f"{combination_folder}/results.dat"
            network_file = f"{combination_folder}/networks.txt"                
            predicted_hotspots_file = f"{combination_folder}/predicted_hotspots.txt"
            hydrogen_bonds_file = f"{combination_folder}/hbonds.dat"
            hydrophobic_interactions_file = f"{combination_folder}/out_hyd_ints.dat"
            salt_bridges_file = f"{combination_folder}/out_salt_brds.dat"
            electrostatic_interactions_file = f"{combination_folder}/out_ele_ints.dat"
            unfav_electrostatic_interactions_file = f"{combination_folder}/out_unfavele_ints.dat"
            short_contacts_file = f"{combination_folder}/out_shorts.dat"


            network = get_network(network_file, chain_a, chain_b)
            predicted_hotspots = get_predicted_hotspots(predicted_hotspots_file, chain_a, chain_b)
            hydrogen_bonds = get_hydrogen_bonds(hydrogen_bonds_file, chain_a, chain_b)
            hydrophobic_interactions = get_hydrophobic_interactions(hydrophobic_interactions_file, chain_a, chain_b)
            salt_bridges = get_salt_bridges(salt_bridges_file, chain_a, chain_b)
            electrostatic_interactions = get_electrostatic_interactions(electrostatic_interactions_file, chain_a, chain_b)
            unfav_electrostatic_interactions = get_unfav_electrostatic_interactions(unfav_electrostatic_interactions_file, chain_a, chain_b)
            short_contacts = get_short_contacts(short_contacts_file, chain_a, chain_b)
            results = get_results(result_dat_file)

            f.write(
                f"{pdb_name},{chain_a},{chain_b},{results},{interfaces},{network},{predicted_hotspots},"
                f"{hydrogen_bonds},{hydrophobic_interactions},{salt_bridges},{electrostatic_interactions},"
                f"{unfav_electrostatic_interactions},{short_contacts}\n"
            )
            # -------------------------
            # Removing all extra files
            # -------------------------

            for filename in os.listdir(combination_folder):
                if filename.endswith('.pl') or filename.endswith('.py') or filename in ['pro-procheck', 'ncbs']:
                    file_path = os.path.join(combination_folder, filename)
                    os.remove(file_path)

def get_results(result_dat_file):
	pima_list=[]
	with open(result_dat_file, 'r') as f:
		for ln in f.readlines():
				pima_list.append(ln.strip().split(":")[1].replace("kJ/mol","").strip(' '))
	return ",".join(pima_list)

def get_interface_residues(interface_residues_file,chain_a,chain_b):
    interface_residues = "" 
    try:    
        with open(interface_residues_file, 'r') as f:                
                for ln in f.readlines():
                    for interface_residue in ln.strip().split(' '):
                        if interface_residue.startswith('A'):
                            modified_residue = chain_a + interface_residue[1:]
                        elif interface_residue.startswith('B'):
                            modified_residue = chain_b + interface_residue[1:]
                        else:
                            print(f"Error: Interface residue does not start with A or B in {interface_residues_file}")
                        interface_residues += modified_residue + ";"

    except FileNotFoundError:
        print(f"Error: {interface_residues_file} not found")

    return interface_residues

def get_network(network_file, chain_a, chain_b):
	with open(network_file, 'r') as f:
		network=[]
		for ln in f.readlines():
			residue1= chain_a + ln.strip().split()[0][1:]
			interaction= ln.strip().split()[1]
			residue2= chain_b + ln.strip().split()[2][1:]
			network_details=residue1 + ":" + interaction + ":" + residue2
			network.append(network_details)
	return ";".join(network)

def get_predicted_hotspots(predicted_hotspots_file, chain_a, chain_b):
    predicted_hotspots = []
    
    with open(predicted_hotspots_file, 'r') as f:
        for ln in f.readlines():
            ln = ln.strip()
            
            if ln.endswith('A'):
                predicted_hotspot_details = ln[:-1] + chain_a
            elif ln.endswith('B'):
                predicted_hotspot_details = ln[:-1] + chain_b
            else:
                raise ValueError(f"Error: Hotspot residue does not end with A or B in {predicted_hotspots_file}")
            
            # Replace spaces with colons
            predicted_hotspot_details = predicted_hotspot_details.replace(" ", ":")
            
            # Append to the list
            predicted_hotspots.append(predicted_hotspot_details)
    
    # Join and return the predicted hotspots
    return ";".join(predicted_hotspots)

def get_hydrogen_bonds(hydrogen_bonds_file, chain_a, chain_b):
    hydrogen_bonds = []
    
    with open(hydrogen_bonds_file, 'r') as f:
        for ln in f.readlines():
            # Initialize the details for each line
            hydrogen_bonds_details = [x.strip() for x in ln.split()]
            
            for x in range(len(hydrogen_bonds_details)):
                # Replace 'A' and 'B' with chain IDs
                if hydrogen_bonds_details[x] == 'A':
                    assert x==2 , f"Unexpected position for 'A': {x}"
                    hydrogen_bonds_details[x] = chain_a
                elif hydrogen_bonds_details[x] == 'B':
                    assert x==7 , f"Unexpected position for 'B': {x}"
                    hydrogen_bonds_details[x] = chain_b
            
            # Join details with colon and append to the list
            hydrogen_bonds.append(":".join(hydrogen_bonds_details))
    
    # Join all hydrogen bond entries with a semicolon
    return ";".join(hydrogen_bonds)

def get_hydrophobic_interactions(hydrophobic_interactions_file, chain_a, chain_b):
    hydrophobic_interactions = []
    
    with open(hydrophobic_interactions_file, 'r') as f:
        for ln in f.readlines():
            hydrophobic_interactions_details = [x.strip() for x in ln.split()]
            

            for i in range(len(hydrophobic_interactions_details)):
                if hydrophobic_interactions_details[i] == 'A':
                    assert i == 2, f"Unexpected position for 'A': {i}"
                    hydrophobic_interactions_details[i] = chain_a
                elif hydrophobic_interactions_details[i] == 'B':
                    assert i == 7, f"Unexpected position for 'B': {i}"
                    hydrophobic_interactions_details[i] = chain_b
            
            # Join the details with a colon and append to the list
            hydrophobic_interactions.append(":".join(hydrophobic_interactions_details))
    
    # Join all interactions with a semicolon and return
    return ";".join(hydrophobic_interactions)

def get_salt_bridges(salt_bridges_file, chain_a, chain_b):
    salt_bridges = []
    
    with open(salt_bridges_file, 'r') as f:
        for ln in f.readlines():
            salt_bridges_details = [x.strip() for x in ln.split()]
            for i in range(len(salt_bridges_details)):
                if salt_bridges_details[i] == 'A':
                    assert i == 2, f"Unexpected position for 'A': {i}"
                    salt_bridges_details[i] = chain_a
                elif salt_bridges_details[i] == 'B':
                    assert i == 7, f"Unexpected position for 'B': {i}"
                    salt_bridges_details[i] = chain_b
            
            # Join the details with a colon and append to the list
            salt_bridges.append(":".join(salt_bridges_details))
    
    # Join all interactions with a semicolon and return
    return ";".join(salt_bridges)

def get_electrostatic_interactions(electrostatic_interactions_file, chain_a, chain_b):	
    electrostatic_interactions = []
    
    with open(electrostatic_interactions_file, 'r') as f:
        for ln in f.readlines():
            electrostatic_interactions_details = [x.strip() for x in ln.split()]

            for i in range(len(electrostatic_interactions_details)):
                if electrostatic_interactions_details[i] == 'A':
                    assert i == 2, f"Unexpected position for 'A': {i}"
                    electrostatic_interactions_details[i] = chain_a
                elif electrostatic_interactions_details[i] == 'B':
                    assert i == 7, f"Unexpected position for 'B': {i}"
                    electrostatic_interactions_details[i] = chain_b

            electrostatic_interactions.append(":".join(electrostatic_interactions_details))

    return ";".join(electrostatic_interactions)

def get_unfav_electrostatic_interactions(unfav_electrostatic_interactions_file, chain_a, chain_b):
    unfav_electrostatic_interactions = []

    with open(unfav_electrostatic_interactions_file, 'r') as f:
        for ln in f.readlines():
            # Split the line into components
            unfav_electrostatic_interactions_details = [x.strip() for x in ln.split()]
            
            # Replace 'A' and 'B' with chain IDs
            for i in range(len(unfav_electrostatic_interactions_details)):
                if unfav_electrostatic_interactions_details[i] == 'A':
                    assert i == 2, f"Unexpected position for 'A': {i}"
                    unfav_electrostatic_interactions_details[i] = chain_a
                elif unfav_electrostatic_interactions_details[i] == 'B':
                    assert i == 7, f"Unexpected position for 'B': {i}"
                    unfav_electrostatic_interactions_details[i] = chain_b
            
            # Join the details with colons and append
            unfav_electrostatic_interactions.append(":".join(unfav_electrostatic_interactions_details))
    
    # Join all interactions with a semicolon and return
    return ";".join(unfav_electrostatic_interactions)

def get_short_contacts(short_contacts_file, chain_a, chain_b):
    short_contacts = []

    with open(short_contacts_file, 'r') as f:
        for ln in f.readlines():
            # Split the line into components
            short_contacts_details = [x.strip() for x in ln.split()]
            
            # Replace 'A' and 'B' with chain IDs
            for i in range(len(short_contacts_details)):
                if short_contacts_details[i] == 'A':
                    assert i == 2, f"Unexpected position for 'A': {i}"
                    short_contacts_details[i] = chain_a
                elif short_contacts_details[i] == 'B':
                    assert i == 7, f"Unexpected position for 'B': {i}"
                    short_contacts_details[i] = chain_b
            
            # Join the details with colons and append
            short_contacts.append(":".join(short_contacts_details))
    
    # Join all interactions with a semicolon and return
    return ";".join(short_contacts)
