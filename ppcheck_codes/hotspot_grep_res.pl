#!/usr/bin/perl

system('rm -rf fav_ele.ras');
system('rm -rf unfav_ele.ras');
system('rm -rf out_ele_int.dat');
system('rm -rf out_unfavele_int.dat');
system('rm -rf all_interactions.dat');

# Getting all the residues which are involved in Hydrogen Bonding in a new file "hbond.dat".
open(Write1,">hbond.dat");

open(Read1,"hbond.out");
@hbond1=<Read1>;
close Read1;

foreach $line1(@hbond1)
{
$line1 =~ s/\n//;
$line1=~s/\(//g;
$line1=~s/\)//g;
$line1=~s/=//g;
$line1=~s/\s+\-\s+/ /g;
@temp1=split(/\s+/,$line1);
if ($temp1[0] =~ m/\D{3}\d+\w/)
 {
 print Write1 "$line1\n";
 }
}
close Write1;


# To keep residue and chain information from hbonds.dat file in a proper format in a new file "hbond.dat"
open(Read2,"hbond.dat");
open(Write2,">hbondd.dat");

@data2=<Read2>;
close Read2;

foreach $line2(@data2)
{
$line2=~s/r.*D.*A/ /;
$line2=~s/Type:/ /g;
$line2=~s/\(//g;
$line2=~s/\)//g;
$line2=~s/=//g;
$line2=~s/\s+\-\s+/ /g;
$line2=~s/\s+E\s+/ /;
$line2=~s/\ HD/HDr/g;
@temp2 = split (/\s+/,$line2);
$ansh1=substr $temp2[0],0,3;
$ansh2=substr $temp2[0],3,-1;
$ansh3=substr $temp2[0],-1;
$ansh4=substr $temp2[3],0,3;
$ansh5=substr $temp2[3],3,-1;
$ansh6=substr $temp2[3],-1;
printf Write2 "%5s",${ansh2};
printf Write2 "%4s",${ansh1};
printf Write2 "%2s",${ansh3};
printf Write2 "%5s",${temp2[1]};
printf Write2 "%6s",${temp2[2]};
printf Write2 "%5s",${ansh5};
printf Write2 "%4s",${ansh4};
printf Write2 "%2s",${ansh6};
printf Write2 "%5s",${temp2[4]};
printf Write2 "%6s",${temp2[5]};
printf Write2 "%4s",${temp2[6]};
printf Write2 "%10s",${temp2[7]};
printf Write2 "%12s",${temp2[8]};
printf Write2 "\n";
}
close Write2;

# Taking only the relevant hydrogen-bond interactions coming out of water molecules.
open(Readx,"hbondd.dat");
open(Writex,">hbonde.dat");

@datax=<Readx>;
close Readx;

foreach $linex(@datax)
{
@tempx=split(/\s+/,$linex);
 if($tempx[2] ne 'HOH')
 {
 print Writex $linex;
 }
  elsif($tempx[2] eq 'HOH')
  {
   if($tempx[1].$tempx[2].$tempx[3] ne $prekey)
   {
    if($fl1==1 && $fl2==1)
    {
    print Writex $data{$prekey};
    }

    $fl1=0; $fl2=0;
   }
   $data{$tempx[1].$tempx[2].$tempx[3]}.="$linex";   
    if($tempx[8] ne $tempx[3])
    {
    $fl1=1;
    }
     if($tempx[8] eq $tempx[3])
     {
     $fl2=1;
     }
     $prekey=$tempx[1].$tempx[2].$tempx[3];
  }
      else
      {
      }
}
close Writex;

# Final output file with all amino acid-amino acid interactions and water-amino acid interactions and total energy coming from latter.
open(Ready,"hbonde.dat");
open(Writey,">hbonds.dat");
open(Writexy,">>hbond.out");

@datay=<Ready>;
close Ready;
foreach $liney(@datay)
{
@tempy=split(/\s+/,$liney);
 if($tempy[2] ne 'HOH')
 {
 print Writey $liney;
 }
  if($tempy[2] eq 'HOH')
  {
  print Writey $liney;
  $sum+=$tempy[13];
  }
}
print Writexy "Total energy from water-amino acid interactions: $sum\n";
close Writey;
close Writexy;


# To keep residue and chain information from out_hyd_int.dat file in a proper format in a new file "out_hyd_ints.dat"
open(Read3,"out_hyd_int.dat");
open(Write3,">out_hyd_ints.dat");

@data3=<Read3>;
close Read3;

foreach $line3(@data3)
{
@temp3 = split (/\s+/,$line3);
printf Write3 "%5s",${temp3[0]};
printf Write3 "%4s",${temp3[1]};
printf Write3 "%2s",${temp3[2]};
printf Write3 "%6s",${temp3[3]};
printf Write3 "%3s",${temp3[4]};
printf Write3 "%5s",${temp3[5]};
printf Write3 "%4s",${temp3[6]};
printf Write3 "%2s",${temp3[7]};
printf Write3 "%6s",${temp3[8]};
printf Write3 "%3s",${temp3[9]};
printf Write3 "%6.2f",${temp3[10]};
printf Write3 "\n";
}
close Write3;


# To keep residue and chain information from out_salt_brd.dat file in a proper format in a new file "out_salt_brds.dat"
open(Read4,"out_salt_brd.dat");
open(Write4,">out_salt_brds.dat");

@data4=<Read4>;
close Read4;

foreach $line4(@data4)
{
@temp4 = split (/\s+/,$line4);
printf Write4 "%5s",${temp4[0]};
printf Write4 "%4s",${temp4[1]};
printf Write4 "%2s",${temp4[2]};
printf Write4 "%6s",${temp4[3]};
printf Write4 "%5s",${temp4[4]};
printf Write4 "%5s",${temp4[5]};
printf Write4 "%4s",${temp4[6]};
printf Write4 "%2s",${temp4[7]};
printf Write4 "%6s",${temp4[8]};
printf Write4 "%5s",${temp4[9]};
printf Write4 "%6.2f",${temp4[10]};
printf Write4 "\n";
}
close Write4;


# To keep residue and chain information from out_short.dat file in a proper format in a new file "out_shorts.dat"
open(Read5,"out_short.dat");
open(Write5,">out_shorts.dat");

@data5=<Read5>;
close Read5;

foreach $line5(@data5)
{
@temp5 = split (/\s+/,$line5);
printf Write5 "%5s",${temp5[0]};
printf Write5 "%4s",${temp5[1]};
printf Write5 "%2s",${temp5[2]};
printf Write5 "%6s",${temp5[3]};
printf Write5 "%5s",${temp5[4]};
printf Write5 "%5s",${temp5[5]};
printf Write5 "%4s",${temp5[6]};
printf Write5 "%2s",${temp5[7]};
printf Write5 "%6s",${temp5[8]};
printf Write5 "%5s",${temp5[9]};
printf Write5 "%6.2f",${temp5[10]};
printf Write5 "\n";
}
close Write5;

# To fetch information for favorable electrostatic interactions from "ddd.out" file and put it in "out_ele_int.dat" file.
open(Read17,"ddd.out");
open(Write17,">out_ele_int.dat");
open(Write18,">out_unfavele_int.dat");

@data17=<Read17>;
close (Read17);

foreach $line17(@data17)
{
@temp17= split(/\s+/,$line17);
if(($temp17[0] eq "") && ($temp17[11]<10) && ($temp17[13]<0))
{
print Write17 "$line17";
}
elsif(($temp17[0] eq "") && ($temp17[11]<10) && ($temp17[13]>0))
{
print Write18 "$line17";
}
}

close Write17;
close Write18;

# To keep residue and chain information from out_ele_int.dat file in a proper format in a new file "out_ele_ints.dat"
open(Read6,"out_ele_int.dat");
open(Write6,">out_ele_ints.dat");

@ydata=<Read6>;
close Read6;

foreach $line6(@ydata)
{
$line6=~s/\(  /\(/g;
$line6=~s/\( //g;
$line6=~s/\(//g;
$line6=~s/\)//g;
$line6=~s/\|//g;
$line6=~s/ - /   /g;
$line6=~s/   //g;
@temp6 = split (/\s+/,$line6);
$ansh31=substr $temp6[0],0,3;
$ansh32=substr $temp6[0],3,-1;
$ansh33=substr $temp6[0],-1;
$ansh34=substr $temp6[3],0,3;
$ansh35=substr $temp6[3],3,-1;
$ansh36=substr $temp6[3],-1;
printf Write6 "%5s",${ansh32};
printf Write6 "%4s",${ansh31};
printf Write6 "%2s",${ansh33};
printf Write6 "%6s",${temp6[1]};
printf Write6 "%3s",${temp6[2]};
printf Write6 "%5s",${ansh35};
printf Write6 "%4s",${ansh34};
printf Write6 "%2s",${ansh36};
printf Write6 "%6s",${temp6[4]};
printf Write6 "%3s",${temp6[5]};
printf Write6 "%9.2f",${temp6[6]};
printf Write6 "%12s",${temp6[7]};
printf Write6 "%12s",${temp6[8]};
printf Write6 "\n";
}
close Write6;


# To keep residue and chain information from out_unfavele_int.dat file in a proper format in a new file "out_ele_ints.dat"
open(Read7,"out_unfavele_int.dat");
open(Write7,">out_unfavele_ints.dat");

@data7=<Read7>;
close Read7;

foreach $line7(@data7)
{
$line7=~s/\(  /\(/g;
$line7=~s/\( //g;
$line7=~s/\(//g;
$line7=~s/\)//g;
$line7=~s/\|//g;
$line7=~s/ - /   /g;
$line7=~s/   //g;
@temp7 = split (/\s+/,$line7);
$ansh21=substr $temp7[0],0,3;
$ansh22=substr $temp7[0],3,-1;
$ansh23=substr $temp7[0],-1;
$ansh24=substr $temp7[3],0,3;
$ansh25=substr $temp7[3],3,-1;
$ansh26=substr $temp7[3],-1;
printf Write7 "%5s",${ansh22};
printf Write7 "%4s",${ansh21};
printf Write7 "%2s",${ansh23};
printf Write7 "%6s",${temp7[1]};
printf Write7 "%3s",${temp7[2]};
printf Write7 "%5s",${ansh25};
printf Write7 "%4s",${ansh24};
printf Write7 "%2s",${ansh26};
printf Write7 "%6s",${temp7[4]};
printf Write7 "%3s",${temp7[5]};
printf Write7 "%9.2f",${temp7[6]};
printf Write7 "%12s",${temp7[7]};
printf Write7 "%12s",${temp7[8]};
printf Write7 "\n";
}
close Write7;


# To keep residue and chain information from out_van_der_waal.dat file in a proper format in a new file "out_van_der_waals.dat"
open(Readz,"out_van_der_waal.dat");
open(Writez,">out_van_der_waals.dat");

@dataz=<Readz>;
close Readz;

foreach $linez(@dataz)
{
@tempz= split(/\s+/,$linez);
printf Writez "%5s",${tempz[0]};
printf Writez "%4s",${tempz[1]};
printf Writez "%2s",${tempz[2]};
printf Writez "%6s",${tempz[3]};
printf Writez "%5s",${tempz[4]};
printf Writez "%5s",${tempz[5]};
printf Writez "%4s",${tempz[6]};
printf Writez "%2s",${tempz[7]};
printf Writez "%6s",${tempz[8]};
printf Writez "%5s",${tempz[9]};
printf Writez "%9s",${tempz[10]};
printf Writez "%14s",${tempz[11]};
printf Writez "\n";
}
close Writez;


# Getting the information of the residues which are present at the *interface only* as obtained from various energy calculations.

open(Write8,">>residues");
open(Read8,"hbonds.dat");
@data8=<Read8>;
close Read8;

foreach $line8(@data8)
{
$line8 =~ s/\n//;
@temp8=split(/\s+/,$line8);
@ansh8="$temp8[3]$temp8[1]$temp8[2] "."$temp8[8]$temp8[6]$temp8[7] ";
@unique8 = grep{$_ =~ /\w+/ and ++$counts{$_} < 2;} @ansh8;
print Write8 "@unique8";
}

open(Read9,"out_unfavele_ints.dat");
@data9=<Read9>;
close Read9;

foreach $line9(@data9)
{
@temp9=split(/\s+/,$line9);
  $key9="$temp9[3]$temp9[1]$temp9[2] ";
  $value9="$temp9[8]$temp9[6]$temp9[7] ";
  @ansh9="$key9".' '."$value9".' ';
  @out9 = grep{$_ =~ /\w+/ and ++$counts{$_} < 2;} @ansh9;
  @anshu9 = "@out9 ";
  print Write8 "@anshu9";
}

open(Read10,"out_ele_ints.dat");
@data10=<Read10>;
close Read10;

foreach $line10(@data10)
{
@temp10=split(/\s+/,$line10);
  $key10="$temp10[3]$temp10[1]$temp10[2] ";
  $value10="$temp10[8]$temp10[6]$temp10[7] ";
  @ansh10="$key10".' '."$value10".' ';
  @out10 = grep{$_ =~ /\w+/ and ++$counts{$_} < 2;} @ansh10;
  @anshu10 = "@out10 ";
  print Write8 "@anshu10";
}

open(Read11,"out_van_der_waals.dat");
@data11=<Read11>;
close Read11;

foreach $line11(@data11)
{
$line11 =~ s/\n//;
@temp11=split(/\s+/,$line11);
  $key11="$temp11[3]$temp11[1]$temp11[2] ";
  $value11="$temp11[8]$temp11[6]$temp11[7] ";
  @ansh11="$key11".' '."$value11".' ';
  @out11 = grep{$_ =~ /\w+/ and ++$counts{$_} < 2;} @ansh11;
  @anshu11 = "@out11 ";
  print Write8 "@anshu11";
}
close Write8;


# Obtaining only the non-redundant residues at the interface.

open(Write12,">interface_residues");

open(Read12,"residues");
@data12=<Read12>;
close Read12;

foreach $line12(@data12)
{
$line12 =~ s/\n//;
@temp12=split(/\s+/,$line12);
@sort12= sort@temp12;
}
@unique12 = grep($_ ne $prev && ($prev = $_), @sort12);
print Write12 "@unique12";

close Write12;


# Getting a correct "results.dat" file with hydrogen bond energy & correct total energy along with other energies and obtaining the normalized energy per residues for the protein-protein complex.

open(Write13,">results.dat"); 
open(Read13,"hbond.out");
@data13=<Read13>;
close Read13;

foreach $line13(@data13)
{
$line13 =~ s/\n//;
@temp13=split(/\s+/,$line13);
if (($temp13[0] eq 'Total') && ($temp13[1] eq 'Energy'))
 {
 $energy13+=$temp13[3];
 }
if (($temp13[0] eq 'Total') && ($temp13[1] eq 'energy' && ($temp13[2] eq 'from')))
 {
  $energy13+=$temp13[6];
 }
}
printf Write13 ("Hydrogen Bond Energy : %8.2f kJ/mol \n", $energy13);


open(Read14,"ddd.out");
@data14=<Read14>;
close Read14;

foreach $line14(@data14)
{
@temp14=split(/\s+/,$line14);
if(($temp14[0] eq "") && ($temp14[11]<10))
{
$energy14+=$temp14[13];
}
}
printf Write13 ("Electrostatic Energy : %8.2f kJ/mol \n", $energy14);

open(Read15,"result.dat");
@data15=<Read15>;
close Read15;

foreach $line15(@data15)
{
@temp15=split(/\s+/,$line15);
if($temp15[0] ne 'Hydrogen')
 {
 push (@ansh15,$line15);
 }
}
foreach $part15(@ansh15)
{
$part15 =~ s/\n//;
@temp16=split(/\s+/,$part15);
if($temp16[0] eq 'van')
 {
 $energy15=$temp16[5];
 printf Write13 ("Van der Waals Energy : %8.2f kJ/mol \n", $energy15);
 }
elsif($temp16[0] eq 'Total')
 {
 $energy_total=($energy13+$energy14+$energy15);
 printf Write13 ("Total Stabilizing Energy : %8.2f kJ/mol \n", $energy_total);
 }
else
 {
 }
}

open(Read16,"interface_residues");
@data16=<Read16>;
close Read16;

foreach $line16(@data16)
{
$line16 =~ s/\n//;
@temp16=split(/\s+/,$line16);
$number16=@temp16;
$norm_energy16=($energy_total/$number16);
print Write13 "Number of interface residues : $number16\n";
printf Write13 ("Normalized Energy per residue : %8.2f kJ/mol \n", $norm_energy16);
}

open(Read17,"result.dat");
@data17=<Read17>;
close Read17;

foreach $line17(@data17)
{
@temp17=split(/\s+/,$line17);
if($temp17[0] eq 'No.')
 {
 print Write13 "$line17";
 }
}
close Write13;

open(Rea2,"interface_residues");
open(Writ1,">chain1.dat");
open(Writ2,">chain2.dat");
open(Writ3,">chain_1.dat");
open(Writ4,">chain_2.dat");

@datam2=<Rea2>;
close Rea2;

$chain1="";
$chain2="";
foreach $liner2(@datam2)
{
$liner2=~s/ /\n/g;
@tempo = split (/\s+/,$liner2);
foreach $tempo2 (@tempo)
{
$anshs3=substr $tempo2,0, 1;
$anshs4=substr $tempo2,1,-3;
 if($chain1 eq "")
 {
 print Writ1 "$tempo2 ";
 print Writ3 "$anshs4 ";
 $chain1=$anshs3;
 }
 elsif(($chain1 ne "") && ($chain2 eq "") && ($anshs3 ne $chain1))
 {
 print Writ2 "$tempo2 ";
 print Writ4 "$anshs4 ";
 $chain2=$anshs3;
 }
 else
 {
  if($anshs3 eq $chain1)
  {
  print Writ1 "$tempo2 ";
  print Writ3 "$anshs4 ";
  }
  else
  {
  print Writ2 "$tempo2 ";
  print Writ4 "$anshs4 ";
  }
 }
}
}
close Writ1;
close Writ2;

system ('rm -rf hbondd.dat');
system ('rm -rf hbonde.dat');
system('rm -rf out_hyd_int.dat');
system('rm -rf out_salt_brd.dat');
system('rm -rf out_short.dat');
system('rm -rf out_unfavele_int.dat');
system('rm -rf out_ele_int.dat');
system('rm -rf hbond.dat');
system('rm -rf out_hy_bond.dat');
system('rm -rf out_van_der_waal.dat');
system ('rm -rf result.dat');
system ('rm -rf residues');
