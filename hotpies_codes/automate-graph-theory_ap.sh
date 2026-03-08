bpath=$1

mkdir 2.0 2.5 3.0 3.5
cp *.pdb redo_list ./2.0/
cd ./2.0/
perl $bpath/2.0/automate-graph-theory.pl $bpath
cp all-degrees.txt ../all-degrees-2.0.txt
cp clustering-coefficient.txt ../clustering-coefficient-2.0.txt
cd ..
cp *.pdb redo_list ./2.5/
cd ./2.5/
perl $bpath/2.5/automate-graph-theory.pl $bpath
cp all-degrees.txt ../all-degrees-2.5.txt
cp clustering-coefficient.txt ../clustering-coefficient-2.5.txt
cd ..
cp *.pdb redo_list ./3.0/
cd ./3.0/
perl $bpath/3.0/automate-graph-theory.pl $bpath
cp all-degrees.txt ../all-degrees-3.0.txt
cp clustering-coefficient.txt ../clustering-coefficient-3.0.txt
cd ..
cp *.pdb redo_list ./3.5/
cd ./3.5/
perl $bpath/3.5/automate-graph-theory.pl $bpath
cp all-degrees.txt ../all-degrees-3.5.txt
cp clustering-coefficient.txt ../clustering-coefficient-3.5.txt
cd ..
perl $bpath/graph-data-analysis.pl
