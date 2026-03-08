#!/usr/bin/perl

open (W,">temp_psa.txt");

open (R,"temp.psa");
@data = <R>;
close (R);

foreach $line (@data)
	{
	$line =~ s/\n//g;
	@temp = split (/\s+/,$line);
	if ($temp[0] eq 'ACCESS')
		{
		$accessibility = substr($line,61,5);
		print W "$accessibility\n";
		}
	}
close (W);


