pdb_name=$1
chain1=$2
chain2=$3
folder=$4
ppcheck_code_base=$5

cp $ppcheck_code_base/*.pl $folder
cp $ppcheck_code_base/ncbs $folder
cp $ppcheck_code_base/pro-procheck $folder
cd $folder

perl waterless_ppi_ap.pl $pdb_name 

./ncbs -h atoms.pdb h-fixed.pdb -cid $chain1 $chain2 >hbond.out

./ncbs -d atoms.pdb h-fixed.pdb -cid $chain1 $chain2 -cutoff 10.0 >ddd.out

./pro-procheck 8 $chain1 $chain2 h-fixed.pdb 
perl hotspot_grep_res.pl
perl energy.pl
perl hotspot_networks.pl
perl hotspot_analysis.pl
perl view_hotspots.pl

