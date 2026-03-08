#!/usr/bin/perl
$bpath=$ARGV[0];

open(Read,"deg-list");
@pdb=<Read>;
close(Read);

foreach $line(@pdb)
{
 $line =~ s/\n//;
 print "processing $line\n";
 system("perl $bpath/3.0/degrees.pl $line");
}

