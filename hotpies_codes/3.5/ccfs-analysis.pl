#!/usr/bin/perl

open(W1,">ccfs-hotspots.txt");
open(R1,"hotspots-clustering-coefficient.txt");
@data1=<R1>;
close(R1);

foreach $line1 (@data1)
{
$line1 =~ s/\n//g;
@temp1 = split(/\t/,$line1);
if($temp1[3] > '0')
 {
 print W1 "$temp1[0]\t$temp1[2]\t$temp1[3]\n";
 }
}
close (W1);


open(W2,">ccfs-nonhotspots.txt");
open(R2,"non-hotspots-clustering-coefficient.txt");
@data2=<R2>;
close(R2);

foreach $line2 (@data2)
{
$line2 =~ s/\n//g;
@temp2 = split(/\t/,$line2);
if($temp2[3] > '0')
 {
 print W2 "$temp2[0]\t$temp2[2]\t$temp2[3]\n";
 }
}
close (W2);
