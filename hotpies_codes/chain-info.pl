#!/usr/bin/perl

open (W1,">temp-chain.txt");
open (R1,"temp.pdb");
@data1 = <R1>;
close (R1);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	$chain = substr($line1,21,1);
	print W1 "$chain\n";
	}
close (W1);

system ("sort temp-chain.txt > abc.txt");
system ("uniq abc.txt > temp-chain.txt");


open (W2,">chain-info.txt");
open (R2,"temp-chain.txt");
@data2 = <R2>;
close (R2);

foreach $line2 (@data2)
	{
	$line2 =~ s/\n/ /g;
	print W2 "$line2";
	}
close (W2);

system ("rm -rf abc.txt");
system ("rm -rf temp-chain.txt");
