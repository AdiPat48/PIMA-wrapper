#!/usr/bin/perl

open (W1,">redo-list");
open (W2,">deg.sh");
open (W3,">deg-list");
open (R1,"redo_list");
@data1 = <R1>;
close (R1);

$count=0;

foreach $line1 (@data1)
	{
	$count++;
	$line1 =~s/\n//g;
	@temp1 = split(/\s+/,$line1);
	$pdb = substr($temp1[0],0,-4);
	$complex = "$pdb.$temp1[1].$temp1[2]";
	print W1 "$complex\n";
	print W2 "paste $complex.original deg$count > deg-$complex\n";
	print W3 "deg-$complex\n";
	}
close (W1);
close (W2);
close (W3);
