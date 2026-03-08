#!/usr/bin/perl

open (W1,">average-chain-accessibility.txt");
open (R1,"final-accessibility.txt");
@data1 = <R1>;
close (R1);

open (R2,"chain-info.txt");
@data2 = <R2>;
close (R2);

$count_c1_1 = 0;
$count_c1_2 = 0;
$count_c1_3 = 0;
$count_c1_4 = 0;
$count_c1_5 = 0;
$count_c1_6 = 0;
$count_c1_7 = 0;
$count_c1_8 = 0;
$count_c1_9 = 0;
$count_c1_10 = 0;
$count_c1_11 = 0;
$count_c1_12 = 0;
$count_c1_13 = 0;
$count_c1_14 = 0;
$count_c1_15 = 0;
$count_c1_16 = 0;
$count_c1_17 = 0;
$count_c1_18 = 0;
$count_c1_19 = 0;
$count_c1_20 = 0;

$count_c2_1 = 0;
$count_c2_2 = 0;
$count_c2_3 = 0;
$count_c2_4 = 0;
$count_c2_5 = 0;
$count_c2_6 = 0;
$count_c2_7 = 0;
$count_c2_8 = 0;
$count_c2_9 = 0;
$count_c2_10 = 0;
$count_c2_11 = 0;
$count_c2_12 = 0;
$count_c2_13 = 0;
$count_c2_14 = 0;
$count_c2_15 = 0;
$count_c2_16 = 0;
$count_c2_17 = 0;
$count_c2_18 = 0;
$count_c2_19 = 0;
$count_c2_20 = 0;

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\t/,$line1);
	$residue = substr($temp1[0],-3);
	$chain = substr($temp1[0],0,1);
	foreach $line2 (@data2)
		{
		$line2 =~ s/\n//g;
		@temp2 = split(/\s/,$line2);
		if(($chain eq $temp2[0]) && ($residue eq "GLY"))
			{
			$count_c1_1++;
			$acc_gly_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "ALA"))
			{
			$count_c1_2++;
			$acc_ala_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "CYS"))
			{
			$count_c1_3++;
			$acc_cys_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "ASP"))
			{
			$count_c1_4++;
			$acc_asp_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "GLU"))
			{
			$count_c1_5++;
			$acc_glu_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "PHE"))
			{
			$count_c1_6++;
			$acc_phe_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "HIS"))
			{
			$count_c1_7++;
			$acc_his_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "ILE"))
			{
			$count_c1_8++;
			$acc_ile_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "LYS"))
			{
			$count_c1_9++;
			$acc_lys_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "LEU"))
			{
			$count_c1_10++;
			$acc_leu_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "MET"))
			{
			$count_c1_11++;
			$acc_met_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "ASN"))
			{
			$count_c1_12++;
			$acc_asn_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "PRO"))
			{
			$count_c1_13++;
			$acc_pro_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "GLN"))
			{
			$count_c1_14++;
			$acc_gln_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "ARG"))
			{
			$count_c1_15++;
			$acc_arg_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "SER"))
			{
			$count_c1_16++;
			$acc_ser_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "THR"))
			{
			$count_c1_17++;
			$acc_thr_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "VAL"))
			{
			$count_c1_18++;
			$acc_val_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "TRP"))
			{
			$count_c1_19++;
			$acc_trp_1+=$temp1[1];
			}
		if(($chain eq $temp2[0]) && ($residue eq "TYR"))
			{
			$count_c1_20++;
			$acc_tyr_1+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "GLY"))
			{
			$count_c2_1++;
			$acc_gly_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "ALA"))
			{
			$count_c2_2++;
			$acc_ala_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "CYS"))
			{
			$count_c2_3++;
			$acc_cys_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "ASP"))
			{
			$count_c2_4++;
			$acc_asp_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "GLU"))
			{
			$count_c2_5++;
			$acc_glu_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "PHE"))
			{
			$count_c2_6++;
			$acc_phe_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "HIS"))
			{
			$count_c2_7++;
			$acc_his_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "ILE"))
			{
			$count_c2_8++;
			$acc_ile_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "LYS"))
			{
			$count_c2_9++;
			$acc_lys_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "LEU"))
			{
			$count_c2_10++;
			$acc_leu_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "MET"))
			{
			$count_c2_11++;
			$acc_met_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "ASN"))
			{
			$count_c2_12++;
			$acc_asn_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "PRO"))
			{
			$count_c2_13++;
			$acc_pro_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "GLN"))
			{
			$count_c2_14++;
			$acc_gln_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "ARG"))
			{
			$count_c2_15++;
			$acc_arg_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "SER"))
			{
			$count_c2_16++;
			$acc_ser_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "THR"))
			{
			$count_c2_17++;
			$acc_thr_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "VAL"))
			{
			$count_c2_18++;
			$acc_val_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "TRP"))
			{
			$count_c2_19++;
			$acc_trp_2+=$temp1[1];
			}
		if(($chain eq $temp2[1]) && ($residue eq "TYR"))
			{
			$count_c2_20++;
			$acc_tyr_2+=$temp1[1];
			}
		}
	}
if($count_c1_1 ne 0)
	{
	$gly_ave_1 = $acc_gly_1/$count_c1_1;
	printf W1 "$temp2[0]\tGLY\t%.4f\n",$gly_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tGLY\t0.0000\n";
	}
if($count_c1_2 ne 0)
	{
	$ala_ave_1 = $acc_ala_1/$count_c1_2;
	printf W1 "$temp2[0]\tALA\t%.4f\n",$ala_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tALA\t0.0000\n";
	}
if($count_c1_3 ne 0)
	{
	$cys_ave_1 = $acc_cys_1/$count_c1_3;
	printf W1 "$temp2[0]\tCYS\t%.4f\n",$cys_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tCYS\t0.0000\n";
	}
if($count_c1_4 ne 0)
	{
	$asp_ave_1 = $acc_asp_1/$count_c1_4;
	printf W1 "$temp2[0]\tASP\t%.4f\n",$asp_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tASP\t0.0000\n";
	}
if($count_c1_5 ne 0)
	{
	$glu_ave_1 = $acc_glu_1/$count_c1_5;
	printf W1 "$temp2[0]\tGLU\t%.4f\n",$glu_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tGLU\t0.0000\n";
	}
if($count_c1_6 ne 0)
	{
	$phe_ave_1 = $acc_phe_1/$count_c1_6;
	printf W1 "$temp2[0]\tPHE\t%.4f\n",$phe_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tPHE\t0.0000\n";
	}
if($count_c1_7 ne 0)
	{
	$his_ave_1 = $acc_his_1/$count_c1_7;
	printf W1 "$temp2[0]\tHIS\t%.4f\n",$his_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tHIS\t0.0000\n";
	}
if($count_c1_8 ne 0)
	{
	$ile_ave_1 = $acc_ile_1/$count_c1_8;
	printf W1 "$temp2[0]\tILE\t%.4f\n",$ile_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tILE\t0.0000\n";
	}
if($count_c1_9 ne 0)
	{
	$lys_ave_1 = $acc_lys_1/$count_c1_9;
	printf W1 "$temp2[0]\tLYS\t%.4f\n",$lys_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tLYS\t0.0000\n";
	}
if($count_c1_10 ne 0)
	{
	$leu_ave_1 = $acc_leu_1/$count_c1_10;
	printf W1 "$temp2[0]\tLEU\t%.4f\n",$leu_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tLEU\t0.0000\n";
	}
if($count_c1_11 ne 0)
	{
	$met_ave_1 = $acc_met_1/$count_c1_11;
	printf W1 "$temp2[0]\tMET\t%.4f\n",$met_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tMET\t0.0000\n";
	}
if($count_c1_12 ne 0)
	{
	$asn_ave_1 = $acc_asn_1/$count_c1_12;
	printf W1 "$temp2[0]\tASN\t%.4f\n",$asn_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tASN\t0.0000\n";
	}
if($count_c1_13 ne 0)
	{
	$pro_ave_1 = $acc_pro_1/$count_c1_13;
	printf W1 "$temp2[0]\tPRO\t%.4f\n",$pro_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tPRO\t0.0000\n";
	}
if($count_c1_14 ne 0)
	{
	$gln_ave_1 = $acc_gln_1/$count_c1_14;
	printf W1 "$temp2[0]\tGLN\t%.4f\n",$gln_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tGLN\t0.0000\n";
	}
if($count_c1_15 ne 0)
	{
	$arg_ave_1 = $acc_arg_1/$count_c1_15;
	printf W1 "$temp2[0]\tARG\t%.4f\n",$arg_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tARG\t0.0000\n";
	}
if($count_c1_16 ne 0)
	{
	$ser_ave_1 = $acc_ser_1/$count_c1_16;
	printf W1 "$temp2[0]\tSER\t%.4f\n",$ser_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tSER\t0.0000\n";
	}
if($count_c1_17 ne 0)
	{
	$thr_ave_1 = $acc_thr_1/$count_c1_17;
	printf W1 "$temp2[0]\tTHR\t%.4f\n",$thr_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tTHR\t0.0000\n";
	}
if($count_c1_18 ne 0)
	{
	$val_ave_1 = $acc_val_1/$count_c1_18;
	printf W1 "$temp2[0]\tVAL\t%.4f\n",$val_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tVAL\t0.0000\n";
	}
if($count_c1_19 ne 0)
	{
	$trp_ave_1 = $acc_trp_1/$count_c1_19;
	printf W1 "$temp2[0]\tTRP\t%.4f\n",$trp_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tTRP\t0.0000\n";
	}
if($count_c1_20 ne 0)
	{
	$tyr_ave_1 = $acc_tyr_1/$count_c1_20;
	printf W1 "$temp2[0]\tTYR\t%.4f\n",$tyr_ave_1;
	}
else
	{
	printf W1 "$temp2[0]\tTYR\t0.0000\n";
	}
if($count_c2_1 ne 0)
	{
	$gly_ave_2 = $acc_gly_2/$count_c2_1;
	printf W1 "$temp2[1]\tGLY\t%.4f\n",$gly_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tGLY\t0.0000\n";
	}
if($count_c2_2 ne 0)
	{
	$ala_ave_2 = $acc_ala_2/$count_c2_2;
	printf W1 "$temp2[1]\tALA\t%.4f\n",$ala_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tALA\t0.0000\n";
	}
if($count_c2_3 ne 0)
	{
	$cys_ave_2 = $acc_cys_2/$count_c2_3;
	printf W1 "$temp2[1]\tCYS\t%.4f\n",$cys_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tCYS\t0.0000\n";
	}
if($count_c2_4 ne 0)
	{
	$asp_ave_2 = $acc_asp_2/$count_c2_4;
	printf W1 "$temp2[1]\tASP\t%.4f\n",$asp_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tASP\t0.0000\n";
	}
if($count_c2_5 ne 0)
	{
	$glu_ave_2 = $acc_glu_2/$count_c2_5;
	printf W1 "$temp2[1]\tGLU\t%.4f\n",$glu_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tGLU\t0.0000\n";
	}
if($count_c2_6 ne 0)
	{
	$phe_ave_2 = $acc_phe_2/$count_c2_6;
	printf W1 "$temp2[1]\tPHE\t%.4f\n",$phe_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tPHE\t0.0000\n";
	}
if($count_c2_7 ne 0)
	{
	$his_ave_2 = $acc_his_2/$count_c2_7;
	printf W1 "$temp2[1]\tHIS\t%.4f\n",$his_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tHIS\t0.0000\n";
	}
if($count_c2_8 ne 0)
	{
	$ile_ave_2 = $acc_ile_2/$count_c2_8;
	printf W1 "$temp2[1]\tILE\t%.4f\n",$ile_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tILE\t0.0000\n";
	}
if($count_c2_9 ne 0)
	{
	$lys_ave_2 = $acc_lys_2/$count_c2_9;
	printf W1 "$temp2[1]\tLYS\t%.4f\n",$lys_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tLYS\t0.0000\n";
	}
if($count_c2_10 ne 0)
	{
	$leu_ave_2 = $acc_leu_2/$count_c2_10;
	printf W1 "$temp2[1]\tLEU\t%.4f\n",$leu_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tLEU\t0.0000\n";
	}
if($count_c2_11 ne 0)
	{
	$met_ave_2 = $acc_met_2/$count_c2_11;
	printf W1 "$temp2[1]\tMET\t%.4f\n",$met_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tMET\t0.0000\n";
	}
if($count_c2_12 ne 0)
	{
	$asn_ave_2 = $acc_asn_2/$count_c2_12;
	printf W1 "$temp2[1]\tASN\t%.4f\n",$asn_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tASN\t0.0000\n";
	}
if($count_c2_13 ne 0)
	{
	$pro_ave_2 = $acc_pro_2/$count_c2_13;
	printf W1 "$temp2[1]\tPRO\t%.4f\n",$pro_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tPRO\t0.0000\n";
	}
if($count_c2_14 ne 0)
	{
	$gln_ave_2 = $acc_gln_2/$count_c2_14;
	printf W1 "$temp2[1]\tGLN\t%.4f\n",$gln_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tGLN\t0.0000\n";
	}
if($count_c2_15 ne 0)
	{
	$arg_ave_2 = $acc_arg_2/$count_c2_15;
	printf W1 "$temp2[1]\tARG\t%.4f\n",$arg_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tARG\t0.0000\n";
	}
if($count_c2_16 ne 0)
	{
	$ser_ave_2 = $acc_ser_2/$count_c2_16;
	printf W1 "$temp2[1]\tSER\t%.4f\n",$ser_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tSER\t0.0000\n";
	}
if($count_c2_17 ne 0)
	{
	$thr_ave_2 = $acc_thr_2/$count_c2_17;
	printf W1 "$temp2[1]\tTHR\t%.4f\n",$thr_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tTHR\t0.0000\n";
	}
if($count_c2_18 ne 0)
	{
	$val_ave_2 = $acc_val_2/$count_c2_18;
	printf W1 "$temp2[1]\tVAL\t%.4f\n",$val_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tVAL\t0.0000\n";
	}
if($count_c2_19 ne 0)
	{
	$trp_ave_2 = $acc_trp_2/$count_c2_19;
	printf W1 "$temp2[1]\tTRP\t%.4f\n",$trp_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tTRP\t0.0000\n";
	}
if($count_c2_20 ne 0)
	{
	$tyr_ave_2 = $acc_tyr_2/$count_c2_20;
	printf W1 "$temp2[1]\tTYR\t%.4f\n",$tyr_ave_2;
	}
else
	{
	printf W1 "$temp2[1]\tTYR\t0.0000\n";
	}
close (W1);


#!/usr/bin/perl

open(W2,">average-accessibility.txt");
open(R1,"final-accessibility.txt");
@data1 = <R1>;
close (R1);

open(R2,"average-chain-accessibility.txt");
@data2 = <R2>;
close (R2);

foreach $line1 (@data1)
	{
	$line1 =~ s/\n//g;
	@temp1 = split(/\t/,$line1);
	$residue = substr($temp1[0],-3);
	$chain = substr($temp1[0],0,1);
	foreach $line2 (@data2)
		{
		$line2 =~ s/\n//g;
		@temp2 = split(/\s+/,$line2);
		if(($chain eq $temp2[0]) && ($residue eq $temp2[1]) && ($temp2[2] == 0.0000))
			{
			printf W2 "$temp1[0]\t0.0000\t0.0000\t0.0000\t0.0000\n";
			}
		if(($chain eq $temp2[0]) && ($residue eq $temp2[1]) && ($temp2[2] != 0.0000))
			{
			$mono_res = $temp1[1]/$temp2[2];
			$comp_res = $temp1[2]/$temp2[2];
			$diff_res = $temp1[3]/$temp2[2];
			$rela_res = $temp1[4]/$temp2[2];
			printf W2 "$temp1[0]\t%.4f\t%.4f\t%.4f\t%.4f\n",$mono_res,$comp_res,$diff_res,$rela_res;
			}
		}
	}
close (W2);
