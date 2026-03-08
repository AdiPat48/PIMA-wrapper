open(Read,"mono2");
@hold=<Read>;
close(Read);

foreach $pdb (@hold)
{
	$pdb=~s/\n//g;
readpipe("./cgi_cut.exe $pdb");
$multi_pdb=substr $pdb,0,7;

$multi_pdb=$multi_pdb.".cln";
readpipe("./show_multi.exe $multi_pdb");
readpipe("./cgi_getmulti.exe $multi_pdb");
$multi_pdb=$multi_pdb.".cls";
readpipe "perl seq_multiple.pl $multi_pdb";
readpipe "cp output_file $multi_pdb";
readpipe "perl chain_align1.pl $multi_pdb";
readpipe "cp chain_output_file $multi_pdb";
}
