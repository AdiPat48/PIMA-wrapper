#!/usr/bin/perl
$bpath=$ARGV[0];


open (W1,">dataset.txt");
open (W2,">residues.txt");
open (R1,"graph-data.txt");
@data1 = <R1>;
close (R1);

open (R2,"temp-dataset.xls");
@data2 = <R2>;
close (R2);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\t/,$line1);
	foreach $line2 (@data2)
		{
		$line2 =~ s/\n//g;
		@temp2 = split(/\t/,$line2);
		if(($temp1[0] eq $temp2[0]) && ($temp1[1] eq $temp2[1]))
			{
			print W1 "$line1\t$line2\n";
			print W2 "$temp1[0]\t$temp1[1]\n";
			}
		}
	}
close (W1);


open (W3,">temp-test-dataset.csv");
open (R3,"dataset.txt");
@data3 = <R3>;
close (R3);

foreach $line3 (@data3)
	{
	$line3 =~ s/\n//g;
	@temp3 = split (/\t/,$line3);
	print W3 "$temp3[2],$temp3[5],$temp3[8],$temp3[12],$temp3[13],$temp3[15],$temp3[16],$temp3[17],$temp3[18],$temp3[20],$temp3[21],$temp3[22],$temp3[29],$temp3[30],$temp3[347],$temp3[400],$temp3[448],$temp3[543],?\n";
	}
close (W3);

system ("cat $bpath/sample-partial-test.csv temp-test-dataset.csv > test-dataset.csv");
#system ("rm -rf dataset.txt temp-test-dataset.csv");
