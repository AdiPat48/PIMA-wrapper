#!/usr/bin/perl

open (W1,">chain1.pdb");
open (W2,">chain2.pdb");
open (R1,"temp.pdb");
@data1=<R1>;
close(R1);

open (R2,"chain-info.txt");
@data2=<R2>;
close(R2);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	$chain = substr($line1,21,1);
	foreach $line2 (@data2)
		{
		$line2 =~ s/\n//g;
		@temp2 = split(/\s/,$line2);
		if($chain eq $temp2[0])
			{
			print W1 "$line1\n";
			}
		else
			{
			print W2 "$line1\n";
			}
		}
	}
close (W1);
close (W2);
