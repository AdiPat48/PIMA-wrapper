#!/usr/bin/perl
$bpath=$ARGV[1];

$training_data = $ARGV[0];

open(Read,"redo_list");
@pdb=<Read>;
close(Read);

foreach $line(@pdb)
{
 $line =~ s/\n//;
 @data=split(' ',$line);
 print "processing $pdbfile\n";
 $ansh1=substr $pdbfile,0,-4;
 $folder="$ansh1.$chainA.$chainB";
 system ("mkdir $folder");
 print "Calculation of Energies from PPCheck...\n";
 system ("perl $bpath/waterless-ppi.pl $pdbfile  > /dev/null 2>&1");
 system ("$bpath/ncbs -h atoms.pdb h-fixed.pdb -cid $chainA $chainB >hbond.out");
 system ("$bpath/ncbs -d atoms.pdb h-fixed.pdb -cid $chainA $chainB -cutoff 10.0 >ddd.out");
 system ("$bpath/pro-procheck 8 $chainA $chainB h-fixed.pdb  > /dev/null 2>&1");
 system ("perl $bpath/grep-res.pl  > /dev/null 2>&1");
 system ("perl $bpath/energy.pl  > /dev/null 2>&1");
 print "Calculation of Interacting residues & B-factor values within a Protein...\n";
 system ("perl $bpath/interactions-number-of-atoms.pl  > /dev/null 2>&1");
 system ("perl $bpath/networks.pl  > /dev/null 2>&1");
 system ("perl $bpath/distance.pl  > /dev/null 2>&1");
 system ("perl $bpath/b-fact.pl  > /dev/null 2>&1");
 system ("perl $bpath/degree-code.pl  > /dev/null 2>&1");
 system ("perl $bpath/analysis.pl $folder");
 system ("perl $bpath/energy-vdw.pl  > /dev/null 2>&1");
 print "Calculation of Solvent Accessibilities from NACCESS & Joy...\n";
 system ("perl $bpath/chain-info.pl  > /dev/null 2>&1");
 system ("perl $bpath/chain-split.pl  > /dev/null 2>&1");
 system ("$bpath/naccess chain1.pdb  > /dev/null 2>&1");
 system ("$bpath/naccess chain2.pdb  > /dev/null 2>&1");
 system ("perl $bpath/accessibility-chain1.pl $folder  > /dev/null 2>&1");
 system ("perl $bpath/accessibility-chain2.pl $folder  > /dev/null 2>&1");
 system ("cat accessibility_1.txt accessibility_2.txt > accessibility_monomer.txt");
 system ("perl $bpath/networks.pl  > /dev/null 2>&1");
 system ("$bpath/naccess temp.pdb  > /dev/null 2>&1");
 system ("perl $bpath/accessibility-naccess.pl  > /dev/null 2>&1");
 system ("paste accessibility_monomer.txt complex-accessibility.txt > accessibility.txt");
 system ("perl $bpath/grep-accessibility.pl  > /dev/null 2>&1");
 system ("perl $bpath/average-accessibility.pl  > /dev/null 2>&1");
 system ("perl $bpath/relative-accessibility.pl  > /dev/null 2>&1");
 system ("rm -rf temp.psa");
 system ("$bpath/joy temp.pdb  > /dev/null 2>&1");
 system ("perl $bpath/temp_psa.pl  > /dev/null 2>&1");
 system ("paste final-accessibility.txt average-accessibility.txt relative-accessibility.txt temp_psa.txt > temp-accessibility.txt");
 system ("rm -rf final-accessibility.txt");
 system ("perl $bpath/analyze-accessibility.pl $folder  > /dev/null 2>&1");
 print "Degree & Clustering-Coefficient Results from Graph Theory...\n";
 system ("sh $bpath/automate-graph-theory.sh $bpath  > /dev/null 2>&1");
 if ($training_data eq "2")
 	{
	system ("perl $bpath/dataset-analysis-partial-dataset.pl  > /dev/null 2>&1");
	print "Prediction of Results from WEKA using Partial Dataset...\n";
 	system ("export WEKA_HOME='./wekafiles';java -classpath $bpath/weka-3-6-10/weka.jar weka.classifiers.trees.RandomForest -t $bpath/partial-dataset.csv -T test-dataset.csv -I 10 -K 0 -S 1 -p 0 > predictions.txt 2> /dev/null");
 	}
 else
 	{
	system ("perl $bpath/dataset-analysis-full-dataset.pl  > /dev/null 2>&1");
	print "Prediction of Results from WEKA using Full Dataset...\n";
 	system ("export WEKA_HOME='./wekafiles';java -classpath $bpath/weka-3-6-10/weka.jar weka.classifiers.trees.RandomForest -t $bpath/full-dataset.csv -T test-dataset.csv -I 10 -K 0 -S 1 -p 0 > predictions.txt 2> /dev/null");
 	}
 system ("perl $bpath/predictions.pl  > /dev/null 2>&1");
 system ("rm -rf temp.ali");
 system ("rm -rf temp.rsa");
 system ("rm -rf temp.asa");
 system ("rm -rf temp.atm");
 system ("rm -rf atoms.pdb");
 system ("rm -rf chain1*");
 system ("rm -rf chain2*");
 system ("rm -rf final.pdb");
 system ("mv *.dat $folder");
 system ("mv *.txt $folder");
 system ("mv error.log favourableElectrosatic.log temp.log unfavourableElectrosatic.log $folder");
 system ("mv *.ras $folder");
 system ("mv *.out $folder");
 system ("mv temp.pdb $folder");
 system ("mv interface_residues $folder");
 system ("mv chain_ids $folder");
 system ("mv *.psa $folder");
}

