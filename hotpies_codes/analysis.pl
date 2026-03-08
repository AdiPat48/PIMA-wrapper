#!/usr/bin/perl

# To include energy results along with the degree results.
open(W1,">output1.txt");
open(R1,"final_energy.txt");
@data1=<R1>;
close(R1);

open(R2,"degree_result.txt");
@data2=<R2>;
close(R2);

foreach $line1 (@data1)
{
$line1 =~ s/\n//g;
@temp1 = split (/\t/, $line1);
 foreach $line2 (@data2)
 {
  $line2 =~ s/\n//g;
  $line2 =~ s/Average is: //g;
  @temp2 = split (/\t/, $line2);
  if($temp2[0] eq $temp1[0])
  {
  $energy_per_atom = ($temp1[1]/$temp2[1]);
  printf W1 "$temp2[0]\t$temp2[1]\t$temp2[2]\t$temp2[4]\t$temp2[5]\t$temp1[1]\t$temp1[2]\t%.2f",$energy_per_atom;
  print W1 "\n";
  }
 }
}
close W1;

# To obtain the average energy_per_atom for each interfacial residue in the protein.
open(R3,"output1.txt");
open(WR2,">degrees_temp.txt");
@data3=<R3>;
close(R3);

$count=0;
foreach $line3 (@data3)
{
 @temp3=split(/\s/,$line3);
 $total+=$temp3[-1];
 $count++;
}
 $avg=($total/$count);
 print WR2 "$avg";
close (WR2);

# To obtain the absolute and normalized energy per atom value for all the interfacial residues present in the protein.
open (W3,">output2.txt");

open (R4, "output1.txt");
@data4=<R4>;
close(R4);

open (R5, "degrees_temp.txt");
@data5=<R5>;
close(R);

foreach $line4 (@data4)
{
$line4=~s/\n//g;
@temp4=split(/\t/,$line4);
	foreach $line5 (@data5)
	{
	if($line5>0)
	{
	$norm_degree_per_atom=($temp4[-1]/(-1*$line5));
	printf W3 "$line4\t%.2f",$norm_degree_per_atom;
	print W3 "\n";
	}
	elsif($line5<0)
	{
	$norm_degree_per_atom=($temp4[-1]/$line5);
	printf W3 "$line4\t%.2f",$norm_degree_per_atom;
	print W3 "\n";
	}
	}
}
close (W3);

# To include B-factor values along with degrees, energy, accessibility and conservation scores.
open(WR6, ">output3.txt");
open(R9, "output2.txt");
@data9=<R9>;
close(R9);

open(R10,"B_fact.txt");
@data10=<R10>;
close(R10);

foreach $line9 (@data9)
{
$line9 =~ s/\n//g;
@temp9 = split (/\t/, $line9);
 foreach $line10 (@data10)
 {
  $line10 =~ s/\n//g;
  @temp10 = split (/\t/, $line10);
  if($temp9[0] eq $temp10[0])
  {
  print WR6 "$ARGV[0]\t$line9\t$temp10[1]\t$temp10[2]\n";
  last;
  }
 }
}
close (WR6);


#system('rm -rf output*.txt');
system('rm -rf degrees_temp.txt');
