#!/usr/bin/perl

$pdb = $ARGV[0];

open (W,">residues.txt");
open (R,"$pdb.modified");
@data = <R>;
close (R);

foreach $line (@data)
	{
	$line =~ s/\n//g;
	$res_num = substr($line,1,-3);
	print W "$res_num\n";
	}
close (W);

system ("cp nCFinder_nAdj$pdb interactions.txt");
system ("paste $pdb.modified $pdb.original > protein-residues.txt");

open (W1,">interactors.txt");
open (R1,"residues.txt");
@data1 = <R1>;
close (R1);

open (R2,"interactions.txt");
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
		if($line1 eq $temp2[0])
			{
			print W1 "$temp2[1] ";
			next;
			}
		if($line1 eq $temp2[1])
			{
			print W1 "$temp2[0] ";
			next;
			}
		}
	print W1 "\n";
	}
close (W1);


# Sort individual lines.
open (W3,">sorted-lines.txt");

open (R3,"interactors.txt");
@data3 = <R3>;
close (R3);

foreach $line3 (@data3)
{
@ansh3 = split(/\s+/,$line3);
@temp3 = sort {$a <=> $b} @ansh3;
print W3 "@temp3 X\n";
}
close (W3);

# Unique residues in individual lines.
open (W4,">unique-lines.txt");

open (R4,"sorted-lines.txt");
@data4 = <R4>;
close (R4);

foreach $line4 (@data4)
{
@ansh4 = split(/ /,$line4);
@out = grep($_ ne $prev && ($prev = $_), @ansh4);
print W4 "@out";
}
close (W4);

open (W5,">residue-neighbors.txt");

open (R5,"unique-lines.txt");
@data5 = <R5>;
close (R5);

foreach $line5 (@data5)
	{
	$line5 =~ s/X//g;
	print W5 "$line5";
	}
close (W5);


open (W6,">residue-degree.txt");
open (W7,">pairwise-interactions.txt");

open (R6,"residue-neighbors.txt");
@data6 = <R6>;
close (R6);

foreach $line6 (@data6)
	{
	$line6 =~ s/\n//g;
	@temp6 = split(/\s+/,$line6);
	$Kv = $#temp6 + 1;
	print W6 "$Kv\n";
	if($Kv >= 2)
		{
		for($i=0;$i<=$#temp6;$i++)
			{
			for($j=1;$j<=$#temp6;$j++)
				{
				if(($i eq $j) || ($i > $j))
					{
					}
				else
					{
					print W7 "$temp6[$i]\t$temp6[$j] ";
					}
				}
			}
		print W7 "\n";
		}
	else
		{
		print W7 "$line6\n";
		}
	}
close (W6);
close (W7);

open (W8,">neighboring-links.txt");
open (R7,"pairwise-interactions.txt");
@data7 = <R7>;
close (R7);

open (R8,"interactions.txt");
@data8 = <R8>;
close (R8);

foreach $line7 (@data7)
	{
	$count=0;
	$line7 =~ s/\n//g;
	@temp7 = split(/ /,$line7);
	foreach $line8 (@data8)
		{
		$line8 =~ s/\n//g;
		@temp8 = split(/\t/,$line8);
		for($i=0;$i<=$#temp7;$i++)
			{
			if(("$temp7[$i]" eq "$line8") || ("$temp7[$i]" eq "$temp8[1]	$temp8[0]"))
				{
#				print W8 "$temp7[$i] ";
				$count++;
				}
			}
		}
		print W8 "$count\n";
	}
close (W8);

system ('paste residues.txt residue-degree.txt neighboring-links.txt > input-ccfs.txt');

open (W9,">temp-clustering-coefficient.txt");
open (R9,"input-ccfs.txt");
@data9 = <R9>;
close (R9);

foreach $line9 (@data9)
	{
	$line9 =~ s/\n//g;
	@temp9 = split(/\t/,$line9);
	if(($temp9[1] eq 0) || ($temp9[2] eq 0))
		{
		printf W9 "$temp9[0]\t0.000\n";
		}
	else
		{
		$clustering_coefficient = 2*$temp9[2]/($temp9[1]*($temp9[1]-1));
		printf W9 "$temp9[0]\t%.3f\n",$clustering_coefficient;
		}
	}
close (W9);

open (W10,">>clustering-coefficient.txt");
open (R10,"temp-clustering-coefficient.txt");
@data10 = <R10>;
close (R10);

open (R11,"protein-residues.txt");
@data11 = <R11>;
close (R11);

foreach $line10 (@data10)
	{
	$line10 =~ s/\n//g;
	@temp10 = split(/\t/,$line10);
	foreach $line11 (@data11)
		{
		$line11 =~ s/\n//g;
		@temp11 = split(/\t/,$line11);
		$resi = substr($temp11[0],1,-3);
		if($temp10[0] eq $resi)
			{
			print W10 "$pdb\t$resi\t$temp11[1]\t$temp10[1]\n";
			}
		}
	}
close (W10);

system ("rm -rf interactors.txt");
system ("rm -rf sorted-lines.txt");
system ("rm -rf unique-lines.txt");
system ("rm -rf interactions.txt");
system ("rm -rf residues.txt");
system ("rm -rf neighboring-links.txt");
system ("rm -rf protein-residues.txt");
system ("rm -rf residue-neighbors.txt");
system ("rm -rf residue-degree.txt");
system ("rm -rf pairwise-interactions.txt");
system ("rm -rf input-ccfs.txt");
system ("rm -rf temp-clustering-coefficient.txt");
