#!/usr/bin/perl

# To get residues from specific interactions (Hydrogen Bond, Electrostatic and Van der Waals into a single file named "residues.txt")
open(Read1,"hbonds.dat");
open(Write1,">>data.txt");
open(Write11,">>data2.txt");
@data1=<Read1>;
close(Read1);

foreach $line1 (@data1)
{
@temp1=split(/\s+/,$line1);
printf Write1 "${temp1[2]}${temp1[1]}${temp1[3]}	${temp1[7]}${temp1[6]}${temp1[8]}\n";
printf Write11 "${temp1[3]}${temp1[1]}${temp1[2]}	H	${temp1[8]}${temp1[6]}${temp1[7]}\n";
}

open(Read12,"out_van_der_waals.dat");
@data12=<Read12>;
close(Read12);

foreach $line12 (@data12)
{
@temp12=split(/\s+/,$line12);
printf Write1 "${temp12[2]}${temp12[1]}${temp12[3]}	${temp12[7]}${temp12[6]}${temp12[8]}\n";
printf Write11 "${temp12[3]}${temp12[1]}${temp12[2]}	V	${temp12[8]}${temp12[6]}${temp12[7]}\n";
}

open(Read13,"out_unfavele_ints.dat");
@data13=<Read13>;
close(Read13);

foreach $line13 (@data13)
{
@temp13=split(/\s+/,$line13);
printf Write1 "${temp13[2]}${temp13[1]}${temp13[3]}	${temp13[7]}${temp13[6]}${temp13[8]}\n";
printf Write11 "${temp13[3]}${temp13[1]}${temp13[2]}	E	${temp13[8]}${temp13[6]}${temp13[7]}\n";
}

open(Read14,"out_ele_ints.dat");
@data14=<Read14>;
close(Read14);

foreach $line14 (@data14)
{
@temp14=split(/\s+/,$line14);
printf Write1 "${temp14[2]}${temp14[1]}${temp14[3]}	${temp14[7]}${temp14[6]}${temp14[8]}\n";
printf Write11 "${temp14[3]}${temp14[1]}${temp14[2]}	E	${temp14[8]}${temp14[6]}${temp14[7]}\n";
}

close (Write1);


# Sort the residues alphabetically.
system ('sort data.txt > output.txt');
system ('rm -rf data.txt');

system ('sort data2.txt > sorted.txt');
system ('uniq sorted.txt > network.txt');

system ('rm -rf data2.txt');
system ('rm -rf sorted.txt');

# To collect information about residues i.e. with how many different residues one residue is interacting.
open(Read2,"output.txt");
open(Write2,">information.txt");
open(Write3,">info.txt");
@data2=<Read2>;
close(Read2);

$resi1="";
$resi2="";
$count=0;

foreach $line2 (@data2)
{
$line2=~s/\n//g;
@temp2=split(/\t+/,$line2);
 $chain1=substr($temp2[0],-1);
 $res1=substr($temp2[0],0,3);
 $num1=substr($temp2[0],3,-1);
 $chain2=substr($temp2[1],-1);
 $res2=substr($temp2[1],0,3);
 $num2=substr($temp2[1],3,-1);
 if(($temp2[0] ne $resi1) && (($temp2[1] ne $resi2)||($temp2[1] eq $resi2)))
{
$count++;
$resi1=$temp2[0];
$resi2=$temp2[1];
print Write2 "$temp2[0] has $count interacting residues.\n";
print Write3 "$chain1$num1$res1	$chain2$num2$res2\n";
}
elsif(($temp2[0] eq $resi1) && ($temp2[1] ne $resi2))
{
$count++;
$resi1=$temp2[0];
$resi2=$temp2[1];
print Write2 "$temp2[0] has $count interacting residues.\n";
print Write3 "$chain1$num1$res1	$chain2$num2$res2\n";
}
}
system ('rm -rf output.txt');
close(Write2);


# To collect information about residues i.e. with how many different residues one residue is interacting "in a proper format".
open(Read3,"information.txt");
open(Write3,">residues.txt");
@data3=<Read3>;
close(Read3);

foreach $line3 (@data3)
{
@temp3=split(/\s+/,$line3);
if($temp3[0] ne $prev)
{
$max1=1;
$prev=$temp3[0];
$value=$temp3[2];
print Write3 "$temp3[0]		$max1\n";
}
elsif($temp3[0] eq $prev)
{
$max1++;
print Write3 "$prev		$max1\n";
}
if(($temp3[0] ne $prev) && ($temp3[2]>$max1))
{
print Write3 "$prev		$max1\n";
}
}

close (Write3);


# To finally obtain the number of interacting residues for a particular residue at the interface.
open(Read4,"residues.txt");
open(Write4,">final_result.txt");
@data4=<Read4>;
close(Read4);

foreach $line4 (@data4)
{
  @temp4 = split(/\t+/,$line4);
  $key = $temp4[0];
  push(@{$ochash{$key}},$temp4[1]);
  push(@{$lihash{$key}},$line4);
}
$prekey = "";
foreach $line5(@data4)
{
  $flag = 0;
  @tmp = split(/\s+/,$line5);
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
  print Write4"${$lihash{$key}}[$index]";
 }
 $prekey = $key;
}

undef @bclean;
undef %ochash;
undef %lihash;
close Write4;

system ('rm -rf information.txt');
system ('rm -rf residues.txt');

open(Read6,"info.txt");
open(Write6,">anshul.txt");
@data6=<Read6>;
close(Read6);

$preva="";

foreach $line6 (@data6)
{
  $line6=~s/\n//g;
  $line6=~s/\t/ /g;
  @temp6 = split(/\s+/,$line6);
  if(($temp6[0] ne $previous) && ($preva eq ""))
  {
  push(@ansh,$temp6[1]);
  $previous=$temp6[0];
  $preva=1;
  print Write6 "$temp6[0] @ansh";
  }
  elsif(($temp6[0] eq $previous) && ($preva eq 1))
  {
  push(@ansh,$temp6[1]);
  $previous=$temp6[0];
  $preva=1;
  print Write6 "$temp6[0] @ansh";
  }
  elsif(($temp6[0] ne $previous) && ($preva eq 1))
  {
  print Write6 "$line6";
  $previous=$temp6[0];
  $preva=1;
  @ansh="";
  push(@ansh,$temp6[1]);
  }
  print Write6 "\n";
}

close (Write6);
system ('rm -rf info.txt');

open(Read7,"anshul.txt");
open(Write7,">interactors.txt");
@data7=<Read7>;
close(Read7);

$pre="";

foreach $line7 (@data7)
{
 @temp7=split(/\s/,$line7);
 if($temp7[0] eq $pre)
 {
 $pre=$temp7[0];
 $ke=$line7;
 }
 elsif($temp7[0] ne $pre)
 {
 print Write7 "$ke";
 $ke=$line7;
 $pre=$temp7[0];
 }
}
system ("awk 'END{print}' anshul.txt >> interactors.txt"); 

close (Write7);

system ('rm -rf anshul.txt');
