#!/usr/bin/perl

# To obtain the degree of residues present in the protein in a separate file.
open(W22,">degrees.txt");
open(R42,"degrees_residues.txt");
@data42=<R42>;
close(R42);

open(R52,"degrees_atoms.txt");
@data52=<R52>;
close(R52);

foreach $line42 (@data42)
{
$line42=~ s/\n//g;
@temp42=split(/\t/,$line42);
	foreach $line52 (@data52)
	{
	$line52=~ s/\n//g;
	@temp52=split(/\t/,$line52);
		if($temp42[0] eq $temp52[0])
		{
		print W22 "$temp42[0]\t$temp52[2]\t$temp42[1]\n";
		}
	}
}
close W22;

# To print Inter-degrees, intra-degrees, and their average degree for all the residues in the protein.
#open (W3,">>degree_inter_intra.xls");
open(W1,">degree_result.txt");
open(R1,"degrees.txt");
@data1=<R1>;
close (R1);

open(R2,"final-result2.dat");
@data2=<R2>;
close (R2);

foreach $line1 (@data1)
{
$line1=~s/\n//g;
$inter = @data1;
@temp1=split(/\t/,$line1);
$flg=0;
$res_line1 = '';
 foreach $line2 (@data2)
 {
 $line2=~s/\n//g;
 $intra = @data2;
 @temp2=split(/\t/,$line2);
   if($temp1[0] eq $temp2[0])
   {
   $res_line1 = $line2;
   $flg = 1;
   last;
   }
 }
   if($flg == 1)
   {
   $avg=($temp1[2]+$temp2[1])/2;
   print W1 "$temp1[0]\t$temp1[1]\t$temp1[2]\t$temp2[0]\t$temp2[1]\tAverage is: $avg\n";
   }
   else
   {
   $avg=(($temp1[2]+0)/2);
   print W1 "$temp1[0]\t$temp1[1]\t$temp1[2]\t$temp1[0]\t0\tAverage is: $avg\n";
   }
}
print W3 "$inter\t$intra\t";
close (W1);

open(R3,"degree_result.txt");
@data3=<R3>;
close(R3);

foreach $line3 (@data3)
{
$line3=~s/\n//g;
$overlap = @data3;
}
print W3 "$overlap\n";
close (W3);

# To obtain the higher degree residues (than average degree) present in the protein in a separate file.
open(W2,">>high_degrees.txt");
open(R4,"high_degrees_atoms.txt");
@data4=<R4>;
close(R4);

open(R5, "degrees_residues.txt");
@data5=<R5>;
close(R5);

foreach $line4 (@data4)
{
$line4=~ s/\n//g;
@temp4=split(/\t/,$line4);
	foreach $line5 (@data5)
	{
	$line5=~ s/\n//g;
	@temp5=split(/\t/,$line5);
		if($temp4[0] eq $temp5[0])
		{
		print W2 "$temp4[0]\t$temp4[1]\t$temp5[1]\n";
		}
	}
}

open(R14,"high_degrees_residues.txt");
@data14=<R14>;
close(R14);

open(R15, "degrees_atoms.txt");
@data15=<R15>;
close(R15);

foreach $line14 (@data14)
{
$line14=~ s/\n//g;
@temp14=split(/\t/,$line14);
	foreach $line15 (@data15)
	{
	$line15=~ s/\n//g;
	@temp15=split(/\t/,$line15);
		if($temp14[0] eq $temp15[0])
		{
		print W2 "$temp14[0]\t$temp15[2]\t$temp14[1]\n";
		}
	}
}

close (W2);

system('sort high_degrees.txt > sorted_degrees.txt');
system('uniq sorted_degrees.txt > high_degrees.txt');


# To obtain only those interactions which are made by the higher degree residues (than average degree) present in the protein in a separate file.
open(WR,">high_info.txt");

open(R6,"high_degrees.txt");
@data6=<R6>;
close(R6);

open(R7,"info.txt");
@data7=<R7>;
close(R7);

foreach $line6 (@data6)
{
$line6=~s/\n//g;
@temp6=split(/\t/,$line6);
	foreach $line7 (@data7)
	{
	$line7=~s/\n//g;
	@temp7=split(/\t/,$line7);
		if($temp7[0] eq $temp6[0])
		{
		print WR "$line7\n";
		}
	}
}
close (W3);

=h
# To print Inter-degrees, intra-degrees, and their average degree for the residues with higher inter-degrees.
open(W4,">high_degree_result.txt");
open(R8,"high_degrees.txt");
@data8=<R8>;
close (R8);

open(R9,"final-result2.dat");
@data9=<R9>;
close(R9);

$flag=0;
$res_line2='';

foreach $line8 (@data8)
{
$line8=~s/\n//g;
$inter1 = @data8;
@temp8=split(/\t/,$line8);
 foreach $line9 (@data9)
 {
 $line9=~s/\n//g;
 $intra1 = @data9;
 @temp9=split(/\t/,$line9);
  if($temp8[0] eq $temp9[0])
  {
  $flag=1;
  $res_line2=$line8;
  last;
  }
 }
 if($flag=1)
 {
 $avg1=($temp8[2]+$temp9[1])/2;
 print W4 "$line8\t$temp9[0]\t$temp9[1]\tAverage is: $avg1\n";
 }
 else
 {
 $avg1=(($temp8[2]+0)/2);
 print W4 "$line8\t$temp8[0]\t0\tAverage is: $avg1\n";
 }
}
close (W4);

=cut

# To obtain only those intramolecular interactions which are made by the higher degree residues (than average degree) present in the protein.
open(W5,">high_network2.txt");

open(R10,"high_degrees.txt");
@data10=<R10>;
close(R10);

open(R11,"network2.txt");
@data11=<R11>;
close(R11);

foreach $line10 (@data10)
{
$line10=~s/\n//g;
@temp10=split(/\t/,$line10);
	foreach $line11(@data11)
	{
	$temp11=~s/\n//g;
	@temp11=split(/\t/,$line11);
		if($temp11[0] eq $temp10[0])
		{
		print W5 "$line11";
		}
	}
}
close (W5);

system ('rm -rf temp_high_degrees.txt');
system ('rm -rf sorted_degrees.txt');
system ('rm -rf temp_degrees_1.txt');
system ('rm -rf temp_degrees_2.txt');
