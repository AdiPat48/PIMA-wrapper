#!/usr/bin/perl

# Grep only the predicted results for the residues in a protein-protein complex.
open (W1,">temp-predictions.txt");
open (R1,"predictions.txt");
@data1 = <R1>;
close (R1);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\s+/,$line1);
	if ($temp1[2] eq "1:?")
		{
		$temp1[3] =~ s/1://g;
		$temp1[3] =~ s/2://g;
		print W1 "$temp1[3]\t$temp1[-1]\n";
		}
	}
close W1;

# Paste predicted results in front of the respective residues.
system ("paste residues.txt temp-predictions.txt > results.txt");

# Display only the predicted hotspot residues in the final results file.
open (W2,">predicted-result.csv");
open (R2,"results.txt");
@data2 = <R2>;
close (R2);

foreach $line2 (@data2)
	{
	$line2 =~ s/\n//g;
	@temp2 = split(/\t/,$line2);
	if ($temp2[2] eq "Hotspot")# && ($temp2[3] >= 0.7))
		{
		@chain = split(/\./,$temp2[0]);
		$chain1 = $chain[-2];
		$chain2 = $chain[-1];
		$pdb = $chain[0];
		print W2 "$pdb,$chain1,$chain2,$temp2[1],$temp2[2]\n";
		}
	}
close (W2);
