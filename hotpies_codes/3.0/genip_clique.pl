#! /usr/bin/perl

#Program to make I/P for CFinder

open(Read,"adj_list");
@hold=<Read>;
close(Read);

foreach $line (@hold)
{
	$line=~s/\n//g;
	print "processing $line\n";
	$mat=$line;
	
  open(R1,"$mat")or die("Can not open $mat as: \n");
  @matrix=<R1>;
  close(R1);
  
$size_mat=@matrix;
$i=0;
foreach $line(@matrix)
{	
	$j=0;
	@ele=split(" ",$line);
	foreach $element(@ele)
	{
		$hold_mat[$i][$j]=$element;
		$j++;
	}
	$i++;
}
#print $hold_mat[0][0];
open(W1,">nCFinder_$mat")or die("Can not open CFinder_$mat as: $!\n");
for($x=0;$x<$size_mat;$x++)
{
	for($y=$x+1;$y<$size_mat;$y++)
	{
		if($hold_mat[$x][$y]==1)
		{
			$a=$x+1;
			$b=$y+1;
			print W1 "$a	$b\n";
		}
	}
}
close(W1);
}
