#!/usr/bin/perl

# To take coordinates and B-factor information of all the atoms which are common in "temp.pdb" and "atoms.pdb" files.
open (W1,">final.pdb");
open (R1,"temp.pdb");
@data1 = <R1>;
close (R1);

open (R2,"atoms.pdb");
@data2 = <R2>;
close (R2);


foreach $line1 (@data1)
{
@temp1 = split(/\s+/,$line1);
foreach $line2 (@data2)
{
@temp2 = split(/\s+/,$line2);
if(($temp1[2] eq $temp2[2]) && ($temp1[3] eq $temp2[3]) && ($temp1[4] eq $temp2[4]) && ($temp1[5] eq $temp2[5]))
{
print W1 "$line2";
last;
}
}
}
close (W1);

# To collect "average" B-factor values for all the residues *atom-wise*.
open (W2,">b-fact.txt");
open (R3,"final.pdb");
@data3 = <R3>;
close (R3);

$prenum="";

foreach $line3 (@data3)
{
@temp3 = split (/\s+/,$line3);
$resi_type=substr($line3,17,3);
$atom_type=substr($line3,12,4);
$resi_num=substr($line3,22,4);
$resi_num=~s/\s+//g;
$chain=substr($line3,21,1);
$b_fact=substr($line3,60,6);
$b_fact=~s/\s+//g;
 if (($resi_num ne $prenum))
 {
  $count=0;
  $total_b_fact = 0;  
  $total_b_fact += $b_fact;
  $count++;
  $prenum = $resi_num;
 $bfact = $total_b_fact/$count;
 printf W2 ("$chain$resi_num$resi_type	%5.2f \n", $bfact);
 }
 elsif (($temp3[5] eq $prenum))
 {
  $total_b_fact += $b_fact;
  $count++;
  $prenum = $resi_num;
 $bfact = $total_b_fact/$count;
 printf W2 ("$chain$resi_num$resi_type	%5.2f \n", $bfact);
 }
 else
 {
 }
}
close (W2);

# To collect "average" B-factor values *residue-wise*.
open(Read4,"b-fact.txt");
open(W3,">b_fact.txt");
@data4=<Read4>;
close(Read4);

$pre="";

foreach $line4 (@data4)
{
 @temp4=split(/\s/,$line4);
 if($temp4[0] eq $pre)
 {
 $pre=$temp4[0];
 $ke=$line4;
 }
 elsif($temp4[0] ne $pre)
 {
 print W3 "$ke";
 $ke=$line4;
 $pre=$temp4[0];
 }
}
system ("awk 'END{print}' b-fact.txt >> b_fact.txt"); 

close (W3);
system ('rm -rf b-fact.txt');


# To obtain the average B-factor value of all the residues in the protein.
open(Read4,"b_fact.txt");
open(W4,">temp_b_fact.txt");
@data4=<Read4>;
close(Read4);

$count=0;
foreach $line4 (@data4)
{
 @temp4=split(/\s/,$line4);
 $total+=$temp4[1];
 $count++;
}
 $avg=($total/$count);
 printf W4 "%.2f\t",$avg;
close (W4);

# To obtain the absolute and normalized B-factor value for all the residues present in the protein.
open (W5,">B_fact.txt");

open (Read5, "b_fact.txt");
@data5=<Read5>;
close(Read5);

open (Read6, "temp_b_fact.txt");
@data6=<Read6>;
close(Read6);

foreach $line5 (@data5)
{
$line5=~s/\n//g;
@temp5=split(/\t/,$line5);
foreach $line6 (@data6)
{
$norm_b_fact=($temp5[1]/$line6);
printf W5 "$line5\t%.2f\t",$norm_b_fact;
print W5 "\n";
}
}
close (W5);
system ('rm -rf b_fact.txt');
#system ('rm -rf final.pdb');
system ('rm -rf temp_b_fact.txt');
