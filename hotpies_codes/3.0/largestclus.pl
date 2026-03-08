#! usr/bin/perl

#Program to calculate the size of the largest cluster from DFS output for RANDOM

open(R,"dfsOutput")or die("can not open dfsOutput as: $!\n");
@opt=<R>;
close(R);

$out=join("",@opt);

@op=split("Cluster.no:.*",$out);
shift @op;
foreach $ele(@op)
{
	@arr1=split("\n",$ele);
	shift @arr1;
	$len=@arr1;
	push @length,$len;
	
}
$largest=0;
foreach $x(@length)
{
	if($x>$largest)
	{
		$largest=$x;
	}
}

open(WR,">>largestclus")or die("Can not open largestclus as: $!\n");
print WR "$largest\n";
close(WR);

