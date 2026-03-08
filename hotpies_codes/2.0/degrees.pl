#!/usr/bin/perl

$input = $ARGV[0];
$pdb = substr($ARGV[0],4);

open(W1,">>all-degrees.txt");
open(W2,">degrees-$pdb.txt");

open(R1,"$input");
@data=<R1>;
close (R1);

foreach $line(@data)
{
 $line =~ s/\n//g;
 @temp=split('\t',$line);
 print W1 "$pdb\t$temp[0]\t$temp[1]\n";
 print W2 "$pdb\t$temp[0]\t$temp[1]\n";
}

