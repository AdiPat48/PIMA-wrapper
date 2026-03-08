#!/usr/bin/perl

$pdb = $ARGV[0];
$bpath=$ARGV[1];

open(W1,">>final-accessibility.txt");
open(R1,"temp-accessibility.txt");
@data1 = <R1>;
close (R1);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\t/,$line1);
	print W1 "$pdb\t$temp1[0]\t$temp1[-1]\t$temp1[1]\t$temp1[2]\t$temp1[3]\t$temp1[4]\t$temp1[42]\t$temp1[43]\t$temp1[44]\t$temp1[45]\t$temp1[47]\t$temp1[48]\t$temp1[49]\t$temp1[50]\n";
	}
close (W1);


# To include all the results into one final file.
open(WR6, ">>results.txt");
open(R9, "output3.txt");
@data9=<R9>;
close(R9);

open(R10,"final-accessibility.txt");
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
  if(($temp9[0] eq $temp10[0]) && ($temp9[1] eq $temp10[1]))
  {
  print WR6 "$line9\t$temp10[2]\t$temp10[3]\t$temp10[4]\t$temp10[5]\t$temp10[6]\t$temp10[7]\t$temp10[8]\t$temp10[9]\t$temp10[10]\t$temp10[11]\t$temp10[12]\t$temp10[13]\t$temp10[14]\n";
  last;
  }
 }
}
close (WR6);

# To include sequence features along with the structural features.
open(W2,">>temp-dataset.xls");
open(R3,"results.txt");
@data3=<R3>;
close(R3);

open(R4,"$bpath/aa-sequence-features");
@data4=<R4>;
close(R4);

foreach $line3 (@data3)
{
$line3 =~ s/\n//g;
@temp3 = split(/\t/,$line3);
$resi_1 = substr($temp3[1],-3);
 foreach $line4 (@data4)
 {
  $line4 =~ s/\n//g;
  @temp4 = split(/\t/,$line4);
  if($resi_1 eq $temp4[0])
  {
  print W2 "$line3\t$line4\n";
  }
 }
}
close (W2);
