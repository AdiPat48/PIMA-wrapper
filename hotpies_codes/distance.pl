#!/usr/bin/perl
open(Write1,">result.dat");

open(Read1,"temp.pdb");
@data1=<Read1>;
close(Read1);

open(Read2,"temp.pdb");
@data2=<Read2>;
close(Read2);

foreach $line1 (@data1)
{
@temp1=split(/\s+/,$line1);
$chain1=substr($line1,21,1);
$res1=substr($line1,17,3);
$num1=substr($line1,22,4);
$num1=~s/\s+//g;
foreach $line2 (@data2)
{
@temp2=split(/\s+/,$line2);
$chain2=substr($line2,21,1);
$res2=substr($line2,17,3);
$num2=substr($line2,22,4);
$num2=~s/\s+//g;
if(($temp2[2] eq CA) && ($temp1[2] eq CA))
{
$distance1=sqrt((($temp2[6]-$temp1[6])*($temp2[6]-$temp1[6]))+(($temp2[7]-$temp1[7])*($temp2[7]-$temp1[7]))+(($temp2[8]-$temp1[8])*($temp2[8]-$temp1[8])));
 if(($distance1 > 0) && ($distance1 <= 6.5))
 {
 print Write1 "Distance between $res2$num2$chain2 & $res1$num1$chain1 is $distance1\n";
 }
}
}
}

close (Write1);

# To collect information about residues i.e. with how many different residues one residue is interacting "in a proper format".
open(Read3,"result.dat");
open(Write3,">residues.dat");
open(Write4,">resi.dat");
@data3=<Read3>;
close(Read3);

foreach $line3 (@data3)
{
$line3=~s/\n//g;
@temp3=split(/\s+/,$line3);
$ansh1=substr($temp3[2],-1);
$ansh2=substr($temp3[4],-1);
$chain1=substr($temp3[2],-1);
$res1=substr($temp3[2],0,3);
$num1=substr($temp3[2],3,-1);
$chain2=substr($temp3[4],-1);
$res2=substr($temp3[4],0,3);
$num2=substr($temp3[4],3,-1);
if(($temp3[4] ne $prev) && ($ansh1 eq $ansh2))
{
$max1=1;
$prev=$temp3[4];
print Write3 "$temp3[4]		$max1\n";
print Write4 "$chain2$num2$res2	$chain1$num1$res1\n";
}
elsif(($temp3[4] eq $prev)  && ($ansh1 eq $ansh2))
{
$max1++;
print Write3 "$prev		$max1\n";
print Write4 "$chain2$num2$res2	$chain1$num1$res1\n";
}
}

close (Write3);
close (Write4);

system ('sort resi.dat > output.dat');

open(Read5,"output.dat");
open(Write5,">anshul.dat");
open(Write9,">network2.txt");
@data5=<Read5>;
close(Read5);

$preva="";

foreach $line5 (@data5)
{
  $line5=~s/\n//g;
  $line5=~s/\t/ /g;
  @temp5 = split(/\s+/,$line5);
  $anshul1=substr($temp5[0],1,-3);
  $anshul2=substr($temp5[1],1,-3);  
  $anshul3=$anshul1+1;
  $anshul4=$anshul1-1;
  if(($temp5[0] ne $previous) && ($preva eq "") && (($anshul2 ne $anshul3) && ($anshul2 ne $anshul4)))
  {
  push(@ansh,$temp5[1]);
  $previous=$temp5[0];
  $preva=1;
  print Write5 "$temp5[0] @ansh\n";
  print Write9 "$temp5[0]	$temp5[1]\n";
  }
  elsif(($temp5[0] eq $previous) && ($preva eq 1) && (($anshul2 ne $anshul3) && ($anshul2 ne $anshul4)))
  {
  push(@ansh,$temp5[1]);
  $previous=$temp5[0];
  $preva=1;
  print Write5 "$temp5[0] @ansh\n";
  print Write9 "$temp5[0]	$temp5[1]\n";
  }
  elsif(($temp5[0] ne $previous) && ($preva eq 1) && (($anshul2 ne $anshul3) && ($anshul2 ne $anshul4)))
  {
  print Write5 "$line5\n";
  print Write9 "$temp5[0]	$temp5[1]\n";
  $previous=$temp5[0];
  $preva=1;
  @ansh="";
  push(@ansh,$temp5[1]);
  }
}

close (Write5);

open(Read6,"anshul.dat");
open(Write6,">interactors2.dat");
@data6=<Read6>;
close(Read6);

$pre="";

foreach $line6 (@data6)
{
 @temp6=split(/\s/,$line6);
 if($temp6[0] eq $pre)
 {
 $pre=$temp6[0];
 $ke=$line6;
 }
 elsif($temp6[0] ne $pre)
 {
 print Write6 "$ke";
 $ke=$line6;
 $pre=$temp6[0];
 }
}
system ("awk 'END{print}' anshul.dat >> interactors2.dat"); 

close (Write6);


open(Read7,"interactors2.dat");
open(Write7,">final-result2.dat");
#open(Write8,">>all_final_result2.xls");
@data7=<Read7>;
close(Read7);

foreach $line7 (@data7)
{
 $line7=~s/\s+/ /g;
 @temp7=split(/\s/,$line7);
 $ansh=scalar@temp7;
 $value=$ansh-1;
 print Write7 "$temp7[0]	$value\n";
 print Write8 "$temp7[0]	$value\n";
}

close (Write7);
=h
# To obtain the average number of interacting residues for all the nodes at the interface.
open(Read8,"final-result2.dat");
open(Write9,">>avg_degrees.xls");
@data8=<Read8>;
close(Read8);

$count=0;
foreach $line8 (@data8)
{
 @temp8=split(/\s/,$line8);
 $total+=$temp8[1];
 $count++;
}
 if($count eq '0')
 {
 printf Write9 "0\t";
 }
 else
 {
 $avg=($total/$count);
 printf Write9 "%.2f\t",$avg;
 }
 print Write9 "\n";
close (Write9); 
=cut
system ('rm -rf result.dat');
system ('rm -rf residues.dat');
system ('rm -rf info.dat');
system ('rm -rf resi.dat');
system ('rm -rf anshul.dat');
system ('rm -rf interators2.dat');
