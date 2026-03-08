#!/usr/bin/perl
$bpath=$ARGV[0];

open(Read,"redo-list");
@pdb=<Read>;
close(Read);

foreach $line(@pdb)
{
 $line =~ s/\n//;
 @data=split(' ',$line);
 print "processing $data[0]\n";
 system("perl $bpath/3.0/clustering-coefficient.pl $line");
}

