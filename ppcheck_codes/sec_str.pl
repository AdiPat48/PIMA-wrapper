#!/usr/bin/perl

open(R,"abc.txt");
@data1=<R>;
close(R);

foreach $line1(@data1)
{
$line1=~s/\n//g;
@temp1=split(' ',$line1);
system("perl structured.pl $temp1[0]");
}


