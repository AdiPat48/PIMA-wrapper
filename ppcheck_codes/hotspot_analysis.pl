#!/usr/bin/perl

# To include energy results along with the degree results.
open(W1,">high_degree_energy.txt");
open(R1,"final_energy.txt");
@data1=<R1>;
close(R1);

open(R2,"high_degrees_residues.txt");
@data2=<R2>;
close(R2);

foreach $line1 (@data1)
{
$line1 =~ s/\n//g;
@temp1 = split (/\t/, $line1);
 foreach $line2 (@data2)
 {
  $line2 =~ s/\n//g;
  @temp2 = split (/\t/, $line2);
  if(($temp2[0] eq $temp1[0]) && ($temp1[2] > 1))
  {
  print W1 "$temp1[0]\t$temp2[1]\t$temp1[2]\n";
  }
 }
}
close W1;

system ("sort -g -r -k 2 high_degree_energy.txt > temp_file.txt");


open (W2,">predicted_hotspots.txt");

open (R2,"temp_file.txt");
@data2 = <R2>;
close (R2);

$pdb = $ARGV[0];
$pdb_id = substr($pdb,0,4);
$chain_1 = substr($pdb,5,1);
$chain_2 = substr($pdb,7,1);

$count_1 = 0;

foreach $line2 (@data2)
	{
	$count_1++;
	$line2 =~ s/\n//g;
	@temp2 = split(/\t/,$line2);
	$chain = substr($temp2[0],0,1);
	$res_num = substr($temp2[0],1,-3);
	$res_type = substr($temp2[0],-3);
	if(($count_1 <= 9))
		{
		printf W2 "$res_num $res_type $chain\n";
		}
	}
close (W2);

# To print hotspot residues in a separate file.
open (W3,">hotspot_residues");

open (R3,"predicted_hotspots.txt");
@data3 = <R3>;
close (R3);

foreach $line3 (@data3)
	{
	$line3 =~ s/\n//g;
	@temp3 = split(/\s+/,$line3);
	print W3 "$temp3[2]$tmep3[0]$temp3[1] ";
	}
close (W3);
