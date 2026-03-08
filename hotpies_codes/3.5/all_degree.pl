#!/usr/bin/perl
$bpath=$ARGV[0];

open (Read,"adj_list");
@hold=<Read>;
close(Read);

$j=1;

foreach $line(@hold)
{
	$line=~s/\n//g;
	print "processing $line\n";
	readpipe ("cp $line Adj");
	open(Write,">deg$j");
	readpipe("perl $bpath/3.5/adj_degree.pl");
	readpipe("mv tst_out deg$j");
	$j++;
}
