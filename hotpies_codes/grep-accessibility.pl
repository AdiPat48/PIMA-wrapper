#!/usr/bin/perl

open (W1,">final-accessibility.txt");
open (R1,"accessibility.txt");
@data1 = <R1>;
close (R1);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\t/,$line1);
	$del_abs_aa = $temp1[1]-$temp1[12];
	if(($del_abs_aa eq 0) || ($temp1[1] == 0))
		{
		printf W1 "$temp1[0]\t$temp1[1]\t$temp1[12]\t%.4f\t0.00\t",$del_abs_aa;
		}
	else
		{
		$del_1 = $del_abs_aa/$temp1[1];
		printf W1 "$temp1[0]\t$temp1[1]\t$temp1[12]\t%.4f\t%.4f\t",$del_abs_aa,$del_1;
		}
	$rel_abs_aa = $temp1[2]-$temp1[13];
	if(($rel_abs_aa eq 0) || ($temp1[2] == 0))
		{
		printf W1 "$temp1[2]\t$temp1[13]\t%.4f\t0.00\t",$rel_abs_aa;
		}
	else
		{
		$rel_1 = $rel_abs_aa/$temp1[2];
		printf W1 "$temp1[2]\t$temp1[13]\t%.4f\t%.4f\t",$rel_abs_aa,$rel_1;
		}
	$del_abs_ts = $temp1[3]-$temp1[14];
	if(($del_abs_ts eq 0) || ($temp1[3] == 0))
		{
		printf W1 "$temp1[3]\t$temp1[14]\t%.4f\t0.00\t",$del_abs_ts;
		}
	else
		{
		$del_2 = $del_abs_ts/$temp1[3];
		printf W1 "$temp1[3]\t$temp1[14]\t%.4f\t%.4f\t",$del_abs_ts,$del_2;
		}
	$rel_abs_ts = $temp1[4]-$temp1[15];
	if(($rel_abs_ts eq 0) || ($temp1[4] == 0))
		{
		printf W1 "$temp1[4]\t$temp1[15]\t%.4f\t0.00\t",$rel_abs_ts;
		}
	else
		{
		$rel_2 = $rel_abs_ts/$temp1[4];
		printf W1 "$temp1[4]\t$temp1[15]\t%.4f\t%.4f\t",$rel_abs_ts,$rel_2;
		}
	$del_abs_mc = $temp1[5]-$temp1[16];
	if(($del_abs_mc eq 0) || ($temp1[5] == 0))
		{
		printf W1 "$temp1[5]\t$temp1[16]\t%.4f\t0.00\t",$del_abs_mc;
		}
	else
		{
		$del_3 = $del_abs_mc/$temp1[5];
		printf W1 "$temp1[5]\t$temp1[16]\t%.4f\t%.4f\t",$del_abs_mc,$del_3;
		}
	$rel_abs_mc = $temp1[6]-$temp1[17];
	if(($rel_abs_mc eq 0) || ($temp1[6] == 0))
		{
		printf W1 "$temp1[6]\t$temp1[17]\t%.4f\t0.00\t",$rel_abs_mc;
		}
	else
		{
		$rel_3 = $rel_abs_mc/$temp1[6];
		printf W1 "$temp1[6]\t$temp1[17]\t%.4f\t%.4f\t",$rel_abs_mc,$rel_3;
		}
	$del_abs_np = $temp1[7]-$temp1[18];
	if(($del_abs_np eq 0) || ($temp1[7] == 0))
		{
		printf W1 "$temp1[7]\t$temp1[18]\t%.4f\t0.00\t",$del_abs_np;
		}
	else
		{
		$del_4 = $del_abs_np/$temp1[7];
		printf W1 "$temp1[7]\t$temp1[18]\t%.4f\t%.4f\t",$del_abs_np,$del_4;
		}
	$rel_abs_np = $temp1[8]-$temp1[19];
	if(($rel_abs_np eq 0) || ($temp1[8] == 0))
		{
		printf W1 "$temp1[8]\t$temp1[19]\t%.4f\t0.00\t",$rel_abs_np;
		}
	else
		{
		$rel_4 = $rel_abs_np/$temp1[8];
		printf W1 "$temp1[8]\t$temp1[19]\t%.4f\t%.4f\t",$rel_abs_np,$rel_4;
		}
	$del_abs_ap = $temp1[9]-$temp1[20];
	if(($del_abs_ap eq 0) || ($temp1[9] == 0))
		{
		printf W1 "$temp1[9]\t$temp1[20]\t%.4f\t0.00\t",$del_abs_ap;
		}
	else
		{
		$del_5 = $del_abs_ap/$temp1[9];
		printf W1 "$temp1[9]\t$temp1[20]\t%.4f\t%.4f\t",$del_abs_ap,$del_5;
		}
	$rel_abs_ap = $temp1[10]-$temp1[21];
	if(($rel_abs_ap eq 0) || ($temp1[10] == 0))
		{
		printf W1 "$temp1[10]\t$temp1[21]\t%.4f\t0.00\n",$rel_abs_ap;
		}
	else
		{
		$rel_5 = $rel_abs_ap/$temp1[10];
		printf W1 "$temp1[10]\t$temp1[21]\t%.4f\t%.4f\n",$rel_abs_ap,$rel_5;
		}
	}
close (W1);
