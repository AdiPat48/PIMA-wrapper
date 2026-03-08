#!/usr/bin/perl

system ("paste all-degrees-2.0.txt clustering-coefficient-2.0.txt all-degrees-2.5.txt clustering-coefficient-2.5.txt all-degrees-3.0.txt clustering-coefficient-3.0.txt all-degrees-3.5.txt clustering-coefficient-3.5.txt > temp-graph-data.txt");

open (W1,">graph-data.txt");
open (R1,"temp-graph-data.txt");
@data1 = <R1>;
close (R1);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\t+/,$line1);
	print W1 "$temp1[0]\t$temp1[1]\t$temp1[2]\t$temp1[6]\t$temp1[9]\t$temp1[13]\t$temp1[16]\t$temp1[20]\t$temp1[23]\t$temp1[27]\n";
	}
close (W1);
system ("rm -rf all-* clustering-* temp-graph-data.txt");
