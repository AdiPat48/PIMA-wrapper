open(Read,"redo_list");
open(out,">>final_results.xls");
@pdb=<Read>;
close(Read);

foreach $line(@pdb)
{
 $line =~ s/\n//;
 @data=split(' ',$line);
 print "processing $data[0]\n";
 $ansh1=substr $data[0],0,4;
 $folder="$ansh1.$data[1].$data[2]";
 system("mkdir $folder");
 system("cp $data[0] $folder");
 system("cp *.pl $folder");
 system("cp *ncbs $folder");
 system("cp pro-procheck $folder");
 system ("perl waterless_ppi.pl $data[0]");
 system("./ncbs -h atoms.pdb h-fixed.pdb -cid $data[1] $data[2] >hbond.out");
 system("./ncbs -d atoms.pdb h-fixed.pdb -cid $data[1] $data[2] -cutoff 10.0 >ddd.out");
 system("./pro-procheck 8 $data[1] $data[2] h-fixed.pdb");
 print out ("$data[0] \($data[1]-$data[2]\) \t");
 system("perl grep_res.pl");
 system("perl networks.pl");
 system("mv *.dat $folder");
 system("mv *.txt $folder");
 system("mv *.log $folder");
 system("mv *.ras $folder");
 system("mv *.out $folder");
 system("mv atoms.pdb $folder");
 system("mv temp.pdb $folder");
 system("mv interface_residues $folder");
 system("mv chain_ids $folder");
}

