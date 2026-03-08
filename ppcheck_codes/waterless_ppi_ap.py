#!/usr/bin/env python
"""
This script performs a complete cleanup of an NMR PDB file using Biopython.
Operations include:
  • Selecting only the first model.
  • Filtering out ATOM records that start with H, D, or a digit and removing nucleotide residues.
  • For each residue, if multiple atoms with the same name exist (i.e. alternate locations),
    keeping only the one with the highest occupancy.
  • Writing out the cleaned structure in PDB format.
  
Usage:
    python cleanup_pdb_biopython.py input.pdb output.pdb
"""

import sys
from collections import defaultdict
from Bio.PDB import PDBParser, PDBIO, Select

# --- Filtering criteria functions ---

def atom_filter(atom):
    """
    Returns True if the atom should be kept.
    Excludes atoms whose name starts with H, D, '1', '2', or '3'.
    """
    name = atom.get_name().strip()
    if not name:
        return False
    if name[0] in ['H', 'D', '1', '2', '3']:
        return False
    return True

def residue_filter(residue):
    """
    Returns True if the residue should be kept.
    Excludes residues with names matching common nucleotides:
    A, U, C, G, T or starting with 'D' (as in deoxynucleotides).
    """
    resname = residue.get_resname().strip()
    if resname in ['A', 'U', 'C', 'G', 'T'] or resname.startswith('D'):
        return False
    return True

# --- Processing the structure ---

def process_structure(structure):
    """
    Given a Biopython Structure object, modify it in place:
      - Only keep the first model.
      - Remove residues that do not pass the residue_filter.
      - For remaining residues, remove atoms that fail atom_filter.
      - Resolve duplicate atoms (e.g. alternate locations) by keeping the one
        with the highest occupancy.
    """
    model = structure[0]  # Select only the first model

    for chain in list(model):
        for residue in list(chain):
            # Remove unwanted residues (e.g. nucleotides)
            if not residue_filter(residue):
                chain.detach_child(residue.id)
                continue

            # Remove atoms that do not pass the filter.
            for atom in list(residue.get_list()):
                if not atom_filter(atom):
                    residue.detach_child(atom.get_id())

            # Group atoms by their name to resolve alternate locations.
            atoms = list(residue.get_list())
            atom_groups = defaultdict(list)
            for atom in atoms:
                atom_groups[atom.get_name()].append(atom)
            for name, atom_list in atom_groups.items():
                if len(atom_list) > 1:
                    # Pick the atom with the highest occupancy (defaulting missing occupancy to 0.0)
                    best_atom = max(atom_list, key=lambda a: a.get_occupancy() if a.get_occupancy() is not None else 0.0)
                    for atom in atom_list:
                        if atom != best_atom:
                            try:
                                residue.detach_child(atom.get_id())
                            except KeyError:
                                pass  # Already removed

class AllSelect(Select):
    """Simple Select subclass that accepts all atoms (the structure is already filtered)."""
    def accept_atom(self, atom):
        return True

# --- Main function ---

def main(input_pdb, output_pdb):
    # Parse the PDB file
    parser = PDBParser(QUIET=True)
    structure = parser.get_structure("structure", input_pdb)

    # Process the structure (filtering, resolving alternate locations, etc.)
    process_structure(structure)

    # Write out the first model only using Biopython's PDBIO.
    io = PDBIO()
    io.set_structure(structure[0])
    io.save(output_pdb, AllSelect())

if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit("Usage: python cleanup_pdb_biopython.py input.pdb output.pdb")
    main(sys.argv[1], sys.argv[2])
