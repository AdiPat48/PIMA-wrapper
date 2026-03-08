#!/usr/bin/perl

open(W1,">hub-hotspots.txt");
open(R1,"hotspots.txt");
@data1=<R1>;
close(R1);

open(R2,"all-degrees.txt");
@data2=<R2>;
close(R2);

foreach $line1 (@data1)
{
$line1 =~ s/\n//g;
@temp1 = split(/\t/,$line1);
 foreach $line2 (@data2)
 {
  $line2 =~ s/\n//g;
  @temp2 = split(/\s+/,$line2);
  if(($temp1[0] eq $temp2[0]) && ($temp1[1] eq $temp2[1]) && ($temp2[2] >= '4'))
  {
  print W1 "$line2\n";
  }
 }
}
close (W1);


open(W2,">hub-non-hotspots.txt");
open(R3,"non-hotspots.txt");
@data3=<R3>;
close(R3);

open(R4,"all-degrees.txt");
@data4=<R4>;
close(R4);

foreach $line3 (@data3)
{
$line3 =~ s/\n//g;
@temp3 = split(/\t/,$line3);
 foreach $line4 (@data4)
 {
  $line4 =~ s/\n//g;
  @temp4 = split(/\s+/,$line4);
  if(($temp3[0] eq $temp4[0]) && ($temp3[1] eq $temp4[1]) && ($temp4[2] >= '4'))
  {
  print W2 "$line4\n";
  }
 }
}
close (W2);
