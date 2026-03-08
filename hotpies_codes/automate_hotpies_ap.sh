bpath=$1
pdb_name=$2
pdbfile="$pdb_name.pdb"
chainA=$3
chainB=$4
output_dir=$5
combination="$pdb_name.$chainA.$chainB"

cd $output_dir

# Make a 'redo_list' file with the pdb name, chainA and chainB
echo "${pdb_name}.pdb $chainA $chainB" > redo_list

# # PPCheck Module
# perl $bpath/waterless-ppi.pl $pdbfile
# $bpath/ncbs -h atoms.pdb h-fixed.pdb -cid $chainA $chainB >hbond.out
# $bpath/ncbs -d atoms.pdb h-fixed.pdb -cid $chainA $chainB -cutoff 10.0 >ddd.out
# $bpath/pro-procheck 8 $chainA $chainB h-fixed.pdb
# perl $bpath/grep-res.pl


perl $bpath/energy.pl 
perl $bpath/interactions-number-of-atoms.pl 
perl $bpath/networks.pl
perl $bpath/distance.pl 
perl $bpath/b-fact.pl
perl $bpath/degree-code.pl
perl $bpath/analysis.pl $combination
perl $bpath/energy-vdw.pl 

perl $bpath/chain-info.pl
perl $bpath/chain-split.pl
$bpath/Naccess/naccess -r $bpath/vdw.radii chain1.pdb
$bpath/Naccess/naccess -r $bpath/vdw.radii chain2.pdb
perl $bpath/accessibility-chain1.pl $combination
perl $bpath/accessibility-chain2.pl $combination 
cat accessibility_1.txt accessibility_2.txt > accessibility_monomer.txt
perl $bpath/networks.pl
$bpath/Naccess/naccess -r $bpath/vdw.radii temp.pdb 
perl $bpath/accessibility-naccess.pl
paste accessibility_monomer.txt complex-accessibility.txt > accessibility.txt
perl $bpath/grep-accessibility.pl
perl $bpath/average-accessibility.pl
perl $bpath/relative-accessibility_ap.pl $bpath

rm -rf temp.psa
$bpath/joy temp.pdb
perl $bpath/temp_psa.pl 
paste final-accessibility.txt average-accessibility.txt relative-accessibility.txt temp_psa.txt > temp-accessibility.txt
rm -rf final-accessibility.txt
perl $bpath/analyze-accessibility_ap.pl $combination $bpath

sh $bpath/automate-graph-theory_ap.sh $bpath
perl $bpath/dataset-analysis-full-dataset_ap.pl $bpath
java -classpath $bpath/weka-3-6-10/weka.jar weka.classifiers.trees.RandomForest -t $bpath/full-dataset.csv -T test-dataset.csv -I 10 -K 0 -S 1 -p 0 > predictions.txt
perl $bpath/predictions.pl
