#!/usr/bin/perl
open(Write1,">result.dat");
open(W1,">residue_info.dat");
open(W2,">chain_info.dat");

open(Read1,"temp.pdb");
@data1=<Read1>;
close(Read1);

open(Read2,"temp.pdb");
@data2=<Read2>;
close(Read2);

$chain='';
$res='';
$num='';
$count=0;
$count1=0;

foreach $line1 (@data1)
{
@temp1=split(/\s+/,$line1);
$atom1=substr($line1,13,4);
$chain1=substr($line1,21,1);
$res1=substr($line1,17,3);
$num1=substr($line1,22,4);
$num1=~s/\s+//g;
$coord11=substr($line1,30,8);
$coord12=substr($line1,38,8);
$coord13=substr($line1,46,8);
foreach $line2 (@data2)
{
@temp2=split(/\s+/,$line2);
$atom2=substr($line2,13,4);
$chain2=substr($line2,21,1);
$res2=substr($line2,17,3);
$num2=substr($line2,22,4);
$num2=~s/\s+//g;
$coord21=substr($line2,30,8);
$coord22=substr($line2,38,8);
$coord23=substr($line2,46,8);
$distance1=sqrt((($coord21-$coord11)*($coord21-$coord11))+(($coord22-$coord12)*($coord22-$coord12))+(($coord23-$coord13)*($coord23-$coord13)));
 if(($chain1 ne '') && ($count == 0) && ($res1 ne 'HOH'))
 {
 print W1 "$chain1\t$num1\t$res1\n";
 $chain=$chain1;
 $num=$num1;
 $res=$res1;
 $first_chain_init=$num1;
 $first_chain_iden=$chain1;
 $count++;
 print W2 "$first_chain_iden\t$first_chain_init\t";
 last;
 }
 elsif(($chain1 eq $chain) && ($num1 ne $num) && ($res1 ne 'HOH'))
 {
 print W1 "$chain1\t$num1\t$res1\t";
 $chain=$chain1;
 $res=$res1;
 $num=$num1;
 $count++;
 $count1++;
 $first_chain_term=$num1;
 $second_chain_term=$num1;
 last;
 }
 elsif(($chain1 ne $chain) && ($count ne 0) && ($res1 ne 'HOH'))
 {
 $length_chain1=$count;
 print W2 "$first_chain_term\t$count\t";
 print W1 "$chain1\t$num1\t$res1\n";
 $chain=$chain1;
 $res=$res1;
 $num=$num1;
 $second_chain_init=$num1;
 $second_chain_iden=$chain1;
 $count1++;
 print W2 "$second_chain_iden\t$second_chain_init\t";
 last;
 }
 if((($distance1 > 0) && ($distance1 <= 7.0)) && ($chain1 ne $chain2) && ($res1 ne $res2) && ($atom1 !~ /^H/) && ($atom2 !~ /^H/))
 {
 print Write1 "$chain2$num2$res2\t$atom2\t$distance1\t$chain1$num1$res1\t$atom1\n";
 next;
 }
 elsif((($distance1 > 0) && ($distance1 <= 10.0)) && ($chain1 ne $chain2) && ($res1 ne $res2) && ($atom1 !~ /^H/) && ($atom2 !~ /^H/) && ((($res1 eq 'ARG') && ($res2 eq 'ARG')) || (($res1 eq 'ARG') && ($res2 eq 'HIS')) || (($res1 eq 'ARG') && ($res2 eq 'LYS')) || (($res1 eq 'ARG') && ($res2 eq 'ASP')) || (($res1 eq 'ARG') && ($res2 eq 'GLU')) || (($res1 eq 'HIS') && ($res2 eq 'HIS')) || (($res1 eq 'HIS') && ($res2 eq 'ARG')) || (($res1 eq 'HIS') && ($res2 eq 'LYS')) || (($res1 eq 'HIS') && ($res2 eq 'ASP')) || (($res1 eq 'HIS') && ($res2 eq 'GLU')) || (($res1 eq 'LYS') && ($res2 eq 'ARG')) || (($res1 eq 'LYS') && ($res2 eq 'HIS')) || (($res1 eq 'LYS') && ($res2 eq 'LYS')) || (($res1 eq 'LYS') && ($res2 eq 'ASP')) || (($res1 eq 'LYS') && ($res2 eq 'GLU')) || (($res1 eq 'ASP') && ($res2 eq 'ARG')) || (($res1 eq 'ASP') && ($res2 eq 'HIS')) || (($res1 eq 'ASP') && ($res2 eq 'LYS')) || (($res1 eq 'ASP') && ($res2 eq 'ASP')) || (($res1 eq 'ASP') && ($res2 eq 'GLU')) || (($res1 eq 'GLU') && ($res2 eq 'ARG')) || (($res1 eq 'GLU') && ($res2 eq 'HIS')) || (($res1 eq 'GLU') && ($res2 eq 'LYS')) || (($res1 eq 'GLU') && ($res2 eq 'ASP')) || (($res1 eq 'GLU') && ($res2 eq 'GLU'))))
 {
 print Write1 "$chain2$num2$res2\t$atom2\t$distance1\t$chain1$num1$res1\t$atom1\n";
 next;
 }
 else
 {
 }
}
}
$final_count=$count1-$length_chain1+1;
print W2 "$second_chain_term\t$final_count\n";

close (Write1);
close (W1);

# To collect information about residues i.e. with how many different residues one residue is interacting "in a proper format".
open(Read3,"result.dat");
open(Write3,">residues.txt");
open(Write4,">resi.dat");
@data3=<Read3>;
close(Read3);

$prev='';

foreach $line3 (@data3)
{
$line3=~s/\n//g;
@temp3=split(/\s+/,$line3);
$ansh1=substr($temp3[0],0,1);
$ansh2=substr($temp3[3],0,1);
$chain1=substr($temp3[0],0,1);
$res1=substr($temp3[0],-3);
$num1=substr($temp3[0],1,-3);
$chain2=substr($temp3[3],0,1);
$res2=substr($temp3[3],-3);
$num2=substr($temp3[3],1,-3);
if(($temp3[3] ne $prev) && ($ansh1 ne $ansh2))
{
$max1=1;
$prev=$temp3[3];
print Write3 "$temp3[3]		$max1\n";
print Write4 "$chain2$num2$res2	$chain1$num1$res1\n";
}
elsif(($temp3[3] eq $prev)  && ($ansh1 ne $ansh2))
{
$max1++;
print Write3 "$prev		$max1\n";
print Write4 "$chain2$num2$res2	$chain1$num1$res1\n";
}
}

close (Write3);
close (Write4);

system ('sort resi.dat > resi12.dat');
system ('uniq resi12.dat > output.dat');

open(Read5,"output.dat");
open(Write5,">anshul.txt");
open(Write2,">info.txt");
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
  print Write2 "$temp5[0]	$temp5[1]\n";
  }
  elsif(($temp5[0] eq $previous) && ($preva eq 1) && (($anshul2 ne $anshul3) && ($anshul2 ne $anshul4)))
  {
  push(@ansh,$temp5[1]);
  $previous=$temp5[0];
  $preva=1;
  print Write5 "$temp5[0] @ansh\n";
  print Write2 "$temp5[0]	$temp5[1]\n";
  }
  elsif(($temp5[0] ne $previous) && ($preva eq 1) && (($anshul2 ne $anshul3) && ($anshul2 ne $anshul4)))
  {
  print Write5 "$line5\n";
  print Write2 "$temp5[0]	$temp5[1]\n";
  $previous=$temp5[0];
  $preva=1;
  @ansh="";
  push(@ansh,$temp5[1]);
  }
}

close (Write5);

open(Read6,"anshul.txt");
open(Write6,">interactors.txt");
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
system ("awk 'END{print}' anshul.txt >> interactors.txt"); 

close (Write6);


# To obtain all the different types of atoms of a residues which are participating in intramolecular interactions.

system ('sort result.dat > file1.dat');

open(Read9,"file1.dat");
open(Write7,">atoms.dat");
@data9=<Read9>;
close(Read9);

$pre1='';
$res1='';
$count1=0;
foreach $line9 (@data9)
{
 @temp9=split(/\s/,$line9);
 if(($res1 eq '') && ($temp9[1] ne $pre1))
 {
 $res1=$temp9[0];
 $pre1=$temp9[1];
 $count1++;
 print Write7 "$temp9[0]\t$temp9[1]\t$count1\n";
 }
 elsif(($temp9[0] eq $res1) && ($temp9[1] ne $pre1))
 {
 $res1=$temp9[0];
 $pre1=$temp9[1];
 $count1++;
 print Write7 "$temp9[0]\t$temp9[1]\t$count1\n";
 }
 elsif(($temp9[0] ne $res1) && (($temp9[1] eq $pre1) || ($temp9[1] ne $pre1)))
 {
 $res1=$temp9[0];
 $pre1=$temp9[1];
 $count1=1;
 print Write7 "$temp9[0]\t$temp9[1]\t$count1\n";
 } 
 else
 {
 }
}
close Write7;

open(Read10,"atoms.dat");
open(Write9,">degrees_atoms.txt");
@data10=<Read10>;
close(Read10);

$pre2="";

foreach $line10 (@data10)
{
 @temp10=split(/\s/,$line10);
 if($temp10[0] eq $pre2)
 {
 $pre2=$temp10[0];
 $ke1=$line10;
 }
 elsif($temp10[0] ne $pre2)
 {
 print Write9 "$ke1";
 $ke1=$line10;
 $pre2=$temp10[0];
 }
}
system ("awk 'END{print}' atoms.dat >> degrees_atoms.txt"); 

close (Write9);

# To obtain the average number of atoms present in the interacting residues.
open(Read11,"degrees_atoms.txt");
open(Write10,">temp_avg_atom_degree.txt");
@data11=<Read11>;
close(Read11);

$count1=0;
foreach $line11 (@data11)
{
 @temp11=split(/\s/,$line11);
 $resi1=substr($temp11[0],-3);
 if($resi1 ne 'HOH')
 {
 $total1+=$temp11[2];
 $count1++;
 }
}
 if($count1 eq '0')
 {
 printf Write8 "0\t";
 printf Write10 "0\t";
 }
 else
 {
 $avg1=($total1/$count1);
 printf Write10 "%.2f\t",$avg1;
 }
close (Write8); 
close (Write10); 

=h
# To collect information about residues i.e. with how many different residues one residue is interacting "in a proper format".
open(Read20,"info.txt");
open(Write15,">residues.txt");
@data20=<Read20>;
close(Read20);

foreach $line20 (@data20)
{
@temp20=split(/\s+/,$line20);
if($temp20[0] ne $prev)
{
$max1=1;
$prev=$temp20[0];
$value=$temp20[2];
print Write15 "$temp20[0]	$max1\n";
}
elsif($temp20[0] eq $prev)
{
$max1++;
print Write15 "$prev	$max1\n";
}
if(($temp20[0] ne $prev) && ($temp20[2]>$max1))
{
print Write15 "$prev	$max1\n";
}
}

close (Write15);

# To finally obtain the number of interacting residues for a particular residue at the interface.
open(Read16,"residues.txt");
open(Write13,">temp_degrees.txt");
@data16=<Read16>;
close(Read16);

foreach $line16 (@data16)
{
  @temp16 = split(/\t+/,$line16);
  $key = $temp16[0];
  push(@{$ochash{$key}},$temp16[1]);
  push(@{$lihash{$key}},$line16);
}
$prekey = "";
foreach $line17(@data16)
{
  $flag = 0;
  @tmp = split(/\s+/,$line17);
  $key = $tmp[0];
  if($key eq $prekey)
  {
    $flag = 1;
  }
  if($flag == 0)
  {
  $length = @{$ochash{$key}};
  $index = 0;
  $maxval = ${$ochash{$key}}[$index];
  for ($i= 0;$i<$length;$i++)
 {
    if ($maxval < ${$ochash{$key}}[$i])
    {
        $index = $i;
        $maxval = ${$ochash{$key}}[$i];
    }
 }
  print Write13"${$lihash{$key}}[$index]";
 }
 $prekey = $key;
}

undef @bclean;
undef %ochash;
undef %lihash;
close Write13;

# To obtain inter-atomic interactions which are made by the residues along with their number of atoms participating in interactions in a separate file.
open (Write14,">degrees.txt");

open (Read18,"degrees_atoms.txt");
@data18=<Read18>;
close(Read18);

open (Read19, "temp_degrees.txt");
@data19=<Read19>;
close(Read19);

foreach $line18 (@data18)
{
$line18=~s/\n//g;
@temp18=split(/\t/,$line18);
foreach $line19 (@data19)
{
$line19=~s/\n//g;
@temp19=split(/\t/,$line19);
if($temp19[0] eq $temp18[0])
{
printf Write14 "$temp18[0]\t$temp18[2]\t$temp19[1]\n";
}
}
}
close (Write14);
=cut

# To obtain the higher degree residues (than average degree) present in the protein in a separate file.
open (Write11,">high_degrees_atoms.txt");
open (Read12,"degrees_atoms.txt");
@data12=<Read12>;
close(Read12);

open (Read13, "temp_avg_atom_degree.txt");
@data13=<Read13>;
close(Read13);

foreach $line12 (@data12)
{
@temp12=split(/\t/,$line12);
foreach $line13 (@data13)
{
if($temp12[2] > $line13)
{
printf Write11 "$temp12[0]\t$temp12[2]";
}
}
}
close (Write11);
system ('rm -rf temp_avg_atom_degree.txt');

system ('rm -rf residue_info.dat');
system ('rm -rf atoms.dat');
system ('rm -rf resi12.dat');
system ('rm -rf file1.dat');
system ('rm -rf result.dat');
system ('rm -rf residues.txt');
system ('rm -rf info.dat');
system ('rm -rf resi.dat');
system ('rm -rf interactors.txt');
system ('rm -rf anshul.txt');
system ('rm -rf temp_degrees.txt');
