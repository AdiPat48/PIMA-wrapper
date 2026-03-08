#!/usr/bin/perl
$bpath=$ARGV[0];

open(Read,"cleanPDBlist");
@hold=<Read>;
close(Read);

foreach $line(@hold)
{
	$line=~s/\n//g;
	print "processing $line\n";
        readpipe("cat $line|grep ^ATOM > pdb.inp");
	
	@r=split('\.cln',$line);
#        $r[0]=~s/pdb//g;
        $i=$r[0];	
#       print $r[1],"\n";

#	readpipe("cp $line pdb.inp");

	readpipe ("perl $bpath/2.5/eqedge_psg.pl");
	readpipe "cp Adj nAdj$i";
        readpipe "cp Lap nLap$i";
}
