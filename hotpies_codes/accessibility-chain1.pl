#!/usr/bin/perl

open (W1,">accessibility_1.txt");
open (R1,"chain1.rsa");
@data1 = <R1>;
close (R1);

foreach $line1 (@data1)
{
$line1 =~ s/!/ /g;
$ansh1 = substr ($line1,0,3);
$abs_aa = substr ($line1,16,6);
$rel_aa = substr ($line1,22,6);
$abs_ts = substr ($line1,28,7);
$rel_ts = substr ($line1,35,6);
$abs_mc = substr ($line1,41,7);
$rel_mc = substr ($line1,48,6);
$abs_np = substr ($line1,54,7);
$rel_np = substr ($line1,61,6);
$abs_ap = substr ($line1,67,7);
$rel_ap = substr ($line1,74,6);
$chain = substr ($line1,8,1);
$res_type = substr ($line1,4,3);
$res_num = substr ($line1,9,4);
$res_num =~ s/\s+//g;
$abs_aa =~ s/\s+//g;
$rel_aa =~ s/\s+//g;
$abs_ts =~ s/\s+//g;
$rel_ts =~ s/\s+//g;
$abs_mc =~ s/\s+//g;
$rel_mc =~ s/\s+//g;
$abs_np =~ s/\s+//g;
$rel_np =~ s/\s+//g;
$abs_ap =~ s/\s+//g;
$rel_ap =~ s/\s+//g;
$residue = "$chain$res_num$res_type";
if ($ansh1 eq 'RES')
{
print W1 "$residue\t$abs_aa\t$rel_aa\t$abs_ts\t$rel_ts\t$abs_mc\t$rel_mc\t$abs_np\t$rel_np\t$abs_ap\t$rel_ap\n";
}
}
close W1;
