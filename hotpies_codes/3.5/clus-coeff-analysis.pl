#!/usr/bin/perl

open(W2,">hotspots-clustering-coefficient.txt");
open(R3,"hotspots.txt");
@data3=<R3>;
close(R3);

open(R4,"clustering-coefficient.txt");
@data4=<R4>;
close(R4);

foreach $line3 (@data3)
{
$line3 =~ s/\n//g;
@temp3 = split(/\t/,$line3);
 foreach $line4 (@data4)
 {
  $line4 =~ s/\n//g;
  @temp4 = split(/\t/,$line4);
  if(($temp3[0] eq $temp4[0]) && ($temp3[1] eq $temp4[2]))
  {
  print W2 "$line4\n";
  }
 }
}
close (W2);


open(W3,">non-hotspots-clustering-coefficient.txt");
open(R5,"non-hotspots.txt");
@data5=<R5>;
close(R5);

open(R6,"clustering-coefficient.txt");
@data6=<R6>;
close(R6);

foreach $line5 (@data5)
{
$line5 =~ s/\n//g;
@temp5 = split(/\t/,$line5);
 foreach $line6 (@data6)
 {
  $line6 =~ s/\n//g;
  @temp6 = split(/\t/,$line6);
  if(($temp5[0] eq $temp6[0]) && ($temp5[1] eq $temp6[2]))
  {
  print W3 "$line6\n";
  }
 }
}
close (W3);
