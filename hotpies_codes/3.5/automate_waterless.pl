#!/usr/bin/perl
$bpath=$ARGV[0];

open(Read,"redo_list");
@pdb=<Read>;
close(Read);

foreach $line(@pdb)
{
 $line =~ s/\n//;
 @data=split(' ',$line);
 print "processing $data[0]\n";
 $ansh1=substr $data[0],0,-4;
 $folder="$ansh1.$data[1].$data[2]";
 system ("perl $bpath/3.5/waterless-ppi.pl $data[0]");
 system ("$bpath/3.5/ncbs -h atoms.pdb h-fixed.pdb -cid $data[1] $data[2] >hbond.out");
 system ("$bpath/3.5/ncbs -d atoms.pdb h-fixed.pdb -cid $data[1] $data[2] -cutoff 10.0 >ddd.out");
 system ("$bpath/3.5/pro-procheck 8 $data[1] $data[2] h-fixed.pdb");
 system ("mv temp.pdb $folder.pdb");
 system ("perl $bpath/3.5/waterless-ppi.pl $folder.pdb");
 system ("mv atoms.pdb $folder.pdb");
 system ("perl $bpath/3.5/waterless-ppi.pl $folder.pdb");
 system ("perl $bpath/3.5/renamumber.pl $folder.pdb");
 system ("mv modified.pdb $folder.cln.pdb");
 system ("mv original.txt $folder.original");
 system ("mv modified.txt $folder.modified");
 system ("rm -rf *.dat");
 system ("rm -rf *.txt");
 system ("rm -rf *.log");
 system ("rm -rf *.ras");
 system ("rm -rf *.out");
 system ("rm -rf temp.pdb");
 system ("rm -rf atoms.pdb");
 system ("rm -rf interface_residues");
 system ("rm -rf chain_ids");
}

