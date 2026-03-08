#!/usr/bin/perl
$bpath=$ARGV[0];

# Enter the PDB-ID along with interacting chains in the file named as "redo_list".
system ("perl $bpath/2.5/automate_waterless.pl $bpath");
# Enter list of all the "clean PDBs" in a file named "cleanPDBlist".
system ("ls *.cln.pdb > cleanPDBlist");
# Enter the correct Imin value in the file named "contfile".
system ("echo 2.5 > contfile");
system ("perl $bpath/2.5/make_mat.pl $bpath");
# Enter list of all the generated matrices (starting with nAdj) in the file named as "adj_list".
system ("ls nAdj* > adj_list");
# Enter all the generated matrices (starting with nAdj) in the file named as "adj_list".
system ("perl $bpath/2.5/all_degree.pl $bpath");
system ("perl $bpath/2.5/genip_clique.pl");
# Enter list of complexes in "redo-list" from "redo_list" file and generate the "degrees and clustering-coefficient" for all the residues in the complexes.
system ("perl $bpath/2.5/redo.pl");
system ("sh ./deg.sh");
system ("perl $bpath/2.5/automate-degrees.pl $bpath");
system ("perl $bpath/2.5/automate-clustering-coefficient.pl $bpath");
