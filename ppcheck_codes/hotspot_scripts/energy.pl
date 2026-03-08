#!/usr/bin/perl

# To get residues from specific interactions (Hydrogen Bond, Electrostatic and Van der Waals into a single file named "residues.txt")
open(Read1,"hbonds.dat");
open(Write1,">>energy1.txt");
@data1=<Read1>;
close(Read1);

foreach $line1 (@data1)
{
@temp1=split(/\s+/,$line1);
printf Write1 "${temp1[3]}${temp1[1]}${temp1[2]}	${temp1[8]}${temp1[6]}${temp1[7]}	$temp1[-1]\n";
printf Write1 "${temp1[8]}${temp1[6]}${temp1[7]}	${temp1[3]}${temp1[1]}${temp1[2]}	$temp1[-1]\n";
}

open(Read2,"out_van_der_waals.dat");
@data2=<Read2>;
close(Read2);

foreach $line2 (@data2)
{
@temp2=split(/\s+/,$line2);
printf Write1 "${temp2[3]}${temp2[1]}${temp2[2]}	${temp2[8]}${temp2[6]}${temp2[7]}	$temp2[-1]\n";
printf Write1 "${temp2[8]}${temp2[6]}${temp2[7]}	${temp2[3]}${temp2[1]}${temp2[2]}	$temp2[-1]\n";
}

open(Read3,"out_unfavele_ints.dat");
@data3=<Read3>;
close(Read3);

foreach $line3 (@data3)
{
@temp3=split(/\s+/,$line3);
printf Write1 "${temp3[3]}${temp3[1]}${temp3[2]}	${temp3[8]}${temp3[6]}${temp3[7]}	$temp3[-1]\n";
printf Write1 "${temp3[8]}${temp3[6]}${temp3[7]}	${temp3[3]}${temp3[1]}${temp3[2]}	$temp3[-1]\n";
}

open(Read4,"out_ele_ints.dat");
@data4=<Read4>;
close(Read4);

foreach $line4 (@data4)
{
@temp4=split(/\s+/,$line4);
printf Write1 "${temp4[3]}${temp4[1]}${temp4[2]}	${temp4[8]}${temp4[6]}${temp4[7]}	$temp4[-1]\n";
printf Write1 "${temp4[8]}${temp4[6]}${temp4[7]}	${temp4[3]}${temp4[1]}${temp4[2]}	$temp4[-1]\n";
}

close (Write1);


# Sort the residues alphabetically.
system ('sort energy1.txt > output1.txt');
system ('rm -rf energy1.txt');

# To collect information about residues i.e. with how many different residues one residue is interacting.
open(Read5,"output1.txt");
open(Write2,">information1.txt");
@data5=<Read5>;
close(Read5);

$resi1="";
$resi2="";
$count=0;

foreach $line5 (@data5)
{
$line5=~s/\n//g;
@temp5=split(/\t+/,$line5);
 $chain1=substr($temp5[0],0,1);
 $res1=substr($temp5[0],-3);
 $num1=substr($temp5[0],1,-3);
 $chain2=substr($temp5[1],0,1);
 $res2=substr($temp5[1],-3);
 $num2=substr($temp5[1],1,-3);
 if(($temp5[0] ne $resi1) && ($temp5[1] ne $resi2) && ($count eq 0))
{
$count++;
$resi1=$temp5[0];
$resi2=$temp5[1];
$energy=$temp5[2];
print Write2 "$temp5[0]\t$temp5[1]\t$energy\n";
}
elsif(($temp5[0] eq $resi1) && ($temp5[1] eq $resi2))
{
$count++;
$resi1=$temp5[0];
$resi2=$temp5[1];
$total=$energy+$temp5[2];
print Write2 "$temp5[0]\t$temp5[1]\t$total\n";
$energy=$total;
}
elsif(($temp5[0] eq $resi1) && ($temp5[1] ne $resi2) || ($temp5[0] ne $resi1) && ($temp5[1] eq $resi2) || ($temp5[0] ne $resi1) && ($temp5[1] ne $resi2))
{
$count++;
$resi1=$temp5[0];
$resi2=$temp5[1];
$energy=$temp5[2];
print Write2 "$temp5[0]\t$temp5[1]\t$energy\n";
}
}
system ('rm -rf output1.txt');
close(Write2);

# To finally obtain the energy between interacting residues for a particular residue at the interface.
open(Read6,"information1.txt");
open(Write3,">interactors.txt");
@data6=<Read6>;
close(Read6);

$pre_1="";
$pre_2="";
$count_1 = 0;
foreach $line6 (@data6)
{
 @temp6=split(/\s/,$line6);
 if(($temp6[0] ne $pre_1) && ($temp6[1] ne $pre_2) && ($count_1 eq 0))
 {
 $pre_1=$temp6[0];
 $pre_2=$temp6[1];
 $count_1++;
 $ke=$line6;
 }
 elsif((($temp6[0] ne $pre_1) && ($temp6[1] ne $pre_2)) || (($temp6[0] ne $pre_1) && ($temp6[1] eq $pre_2)))
 {
 if (($ke ne '') && ($count_1 eq 1))
 {
 print Write3 "$line6";
 }
 else
 {
 print Write3 "$ke";
 }
 $pre_1=$temp6[0];
 $pre_2=$temp6[1];
 $count_1++;
 $ke=$line6;
 }
 elsif(($temp6[0] eq $pre_1) && ($temp6[1] eq $pre_2))
 {
 $pre_1=$temp6[0];
 $pre_2=$temp6[1];
 $count_1++;
 $ke=$line6;
 }
 elsif (($temp6[0] eq $pre_1) && ($temp6[1] ne $pre_2))
 {
 print Write3 "$ke";
 $pre_1=$temp6[0];
 $pre_2=$temp6[1];
 $count_1++;
 $ke=$line6;
 }
}
system ("awk 'END{print}' information1.txt >> interactors.txt"); 

close (Write3);

system ('rm -rf information1.txt');
system ('sort interactors.txt > energy2.txt');
system ('rm -rf interactors.txt');


# To collect information about residues i.e. with how many different residues one residue is interacting.
open(Read7,"energy2.txt");
open(Write4,">information2.txt");
@data7=<Read7>;
close(Read7);

$resi_1="";
$resi_2="";
$count_2=0;

foreach $line7 (@data7)
{
$line7=~s/\n//g;
@temp7=split(/\t+/,$line7);
 if ($count_2 eq 0)
 {
 $count_2++;
 $resi_1=$temp7[0];
 $resi_2=$temp7[1];
 $energy_1=($temp7[2]/2);
 printf Write4 "$temp7[0]\t%.2f",$energy_1;
 print Write4 "\n";
 }
 elsif ($temp7[0] eq $resi_1)
 {
 $count_2++;
 $resi_1=$temp7[0];
 $resi_2=$temp7[1];
 $value=($temp7[2]/2) ;
 $total_1=$energy_1+$value;
 printf Write4 "$temp7[0]\t%.2f",$total_1;
 print Write4 "\n";
 $energy_1=$total_1;
 }
 elsif ($temp7[0] ne $resi_1)
 {
 $count_2++;
 $resi_1=$temp7[0];
 $resi_2=$temp7[1];
 $energy_1=($temp7[2]/2);
 printf Write4 "$temp7[0]\t%.2f",$energy_1;
 print Write4 "\n";
 }
}
close(Write4);


# To finally obtain the energy between interacting residues for a particular residue at the interface.
open(Read8,"information2.txt");
open(Write5,">final_energy_temp.txt");
@data8=<Read8>;
close(Read8);

$prev_1="";
$prev_2="";
$counting = 0;
foreach $line8 (@data8)
{
 @temp8=split(/\s/,$line8);
 if($temp8[0] eq $prev_1)
 {
 $prev_1=$temp8[0];
 $prev_2=$temp8[1];
 $counting++;
 $ke_1=$line8;
 }
 elsif ($temp8[0] eq $prev_1)
 {
 $prev_1=$temp8[0];
 $prev_2=$temp8[1];
 $counting++;
 $ke_1=$line8;
 }
 elsif(($temp8[0] ne $prev_1))
 {
 print Write5 "$ke_1";
 $prev_1=$temp8[0];
 $prev_2=$temp8[1];
 $counting++;
 $ke_1=$line8;
 }
}
system ("awk 'END{print}' information2.txt >> final_energy_temp.txt"); 
close (Write5);


# To obtain the average energy of all the residues in the protein.
open(Read9,"final_energy_temp.txt");
open(Write6,">temp_energy.txt");
@data9=<Read9>;
close(Read9);

$count=0;
foreach $line9 (@data9)
{
 @temp9=split(/\s/,$line9);
 $total+=$temp9[1];
 $count++;
}
 $avg=($total/$count);
 print Write6 "$avg";
close (Write6);

# To obtain the absolute and normalized energy for all the residues present in the protein.
open (Write7,">final_energy.txt");

open (Read10, "final_energy_temp.txt");
@data10=<Read10>;
close(Read10);

open (Read11, "temp_energy.txt");
@data11=<Read11>;
close(Read11);

foreach $line10 (@data10)
{
$line10=~s/\n//g;
@temp10=split(/\t/,$line10);
	foreach $line11 (@data11)
	{
	if($line11>0)
	{
	$norm_energy=($temp10[1]/(-1*$line11));
	printf Write7 "$line10\t%.2f",$norm_energy;
	print Write7 "\n";
	}
	elsif($line11<0)
	{
	$norm_energy=($temp10[1]/$line11);
	printf Write7 "$line10\t%.2f",$norm_energy;
	print Write7 "\n";
	}
	elsif($line11==0)
	{
	$norm_energy=($temp10[1]/1);
	printf Write7 "$line10\t%.2f",$norm_energy;
	print Write7 "\n";
	}
	}
}
close (Write7);
system ('rm -rf energy2.txt');
system ('rm -rf information2.txt');
system ('rm -rf final_energy_temp.txt');
system ('rm -rf temp_energy.txt');
