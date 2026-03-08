open(Write1,">tst_out");

open(Read,"Adj");
@hold=<Read>;
close(Read);

foreach $line(@hold)
{
	$line=~s/\n//g;
	@deg_val=split(' ',$line);
	$a=@deg_val;
	
	for($i=0;$i<$a;$i++)
	{
#		print $deg_val[$i],"\n";
		$deg_tot=$deg_tot+$deg_val[$i];
	}
	print Write1 "  ",$deg_tot,"\n";
	$deg_tot=0;
}
