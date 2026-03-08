#!/usr/bin/perl

open (W1,">temp_accessibility.txt");
open (R1,"temp.rsa");
@data1 = <R1>;
close (R1);

foreach $line1 (@data1)
{
$line1 =~ s/!/ /g;
@temp1 = split (/\s+/, $line1);
$ansh1 = substr ($line1,61,5);
if ($temp1[0] eq 'ACCESS')
{
print W1 "$temp1[0]	$temp1[1]	$temp1[2]	$ansh1\n";
}
}
close W1;

# To include chain ids of residues from the temp.pdb file.

open (W2,">accessibility_complex.txt");
open (R2,"temp_accessibility.txt");
@data2 = <R2>;
close (R2);

open (R3,"chain_info.dat");
@data3 = <R3>;
close (R3);

$count=1;

foreach $line2 (@data2)
{
$line2 =~ s/\n//g;
@temp2 = split (/\t+/, $line2);
 foreach $line3 (@data3)
 {
 $line3 =~ s/\n/ /g;
 @temp3=split(/\t/,$line3);
  if(($count <= $temp3[3]))
  {
  $chain1=$temp3[0];
  print W2 "$temp3[0]$temp2[1]$temp2[2]\t$temp2[3]\n";
  $count++;
  last;
  }
  else
  {
  print W2 "$temp3[4]$temp2[1]$temp2[2]\t$temp2[3]\n";
  $count++;
  last;
  }
 }
}
close (W2);
system ('rm -rf temp_accessibility.txt');
