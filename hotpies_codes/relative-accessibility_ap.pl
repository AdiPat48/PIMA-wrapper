#!/usr/bin/perl

$bpath=$ARGV[0];

open(W1,">relative-accessibility.txt");
open(R1,"final-accessibility.txt");
@data1 = <R1>;
close (R1);

open(R2,"$bpath/res-sasa");
@data2 = <R2>;
close (R2);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\t/,$line1);
	$residue = substr($temp1[0],-3);
	foreach $line2 (@data2)
		{
		$line2 =~ s/\n//g;
		@temp2 = split(/\s+/,$line2);
		if($residue eq $temp2[0])
			{
			$mono_res = $temp1[1]/$temp2[2];
			$comp_res = $temp1[2]/$temp2[2];
			$diff_res = $temp1[3]/$temp2[2];
			$rela_res = $temp1[4]/$temp2[2];
			printf W1 "$temp1[0]\t%.4f\t%.4f\t%.4f\t%.4f\n",$mono_res,$comp_res,$diff_res,$rela_res;
			}
		}
	}
close (W1);
