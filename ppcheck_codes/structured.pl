#!/usr/bin/perl

open(W,">>search.txt");

$read = $ARGV[0];
open(Read,$read);
@pdb=<Read>;
close(Read);

foreach $line(@pdb)
{
 $line =~ s/\n//;
 @data=split(' ',$line);
 if(($data[0] eq "HELIX") || ($data[0] eq "SHEET"))
 {
 $ansh=substr($data[0],0,8);
 print W "$read\n";
 }
 elsif(($data[0] eq "HELIX") || ($data[0] eq "SHEET"))
 {
 $ansh=substr($data[0],0,8);
 print W "$read\n";
 }
 else
 {
 }
}

close (W);

system('uniq search.txt >> structured.txt');
system('rm -rf search.txt');
