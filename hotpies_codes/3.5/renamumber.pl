#!/usr/bin/perl

# To obtain the residue information for both the chains for the original file.
open(W1,">original.txt");
open(R1,"$ARGV[0]");
@data1=<R1>;
close(R1);

$prev=0;

foreach $line1 (@data1)
	{
	$line1=~s/\n//g;
	$res_type=substr($line1,17,3);
	$chain=substr($line1,21,1);
	$res_num=substr($line1,22,4);
	$res_num=~s/\s+//g;
	$now="$chain$res_num$res_type";
	if($prev ne $now)
		{
		print W1 "$chain$res_num$res_type\n";
		$prev="$chain$res_num$res_type";
		}
	else
		{
		}
	}
close (W1);


# To generate the modified PDB file with updated chain and residue information.
open(W2,">modified.pdb");
open(R2,"$ARGV[0]");
@data2=<R2>;
close(R2);

$count=0;

foreach $line2 (@data2)
	{
	$line2=~s/\n//g;
	$atom=substr($line2,0,4);
	$atom_num=substr($line2,4,7);
	$atom_type=substr($line2,11,5);
	$res_type=substr($line2,16,4);
	$chain=substr($line2,20,2);
	$res_num=substr($line2,22,4);
	$x_coord=substr($line2,26,12);
	$y_coord=substr($line2,38,8);
	$z_coord=substr($line2,46,8);
	$occ=substr($line2,54,6);
	$b_factor=substr($line2,60,6);
	$atom_symbol=substr($line2,66,12);
	$now="$chain$res_num$res_type";
	if($count eq 0)
		{
		$prev="$chain$res_num$res_type";
		$count++;
		printf W2 "%4s",$atom;
		printf W2 "%7s",$atom_num;
		printf W2 "%5s",$atom_type;
		printf W2 "%4s",$res_type;
		printf W2 " A";
		printf W2 "%4s",$count;
		printf W2 "%12s",$x_coord;
		printf W2 "%8s",$y_coord;
		printf W2 "%8s",$z_coord;
		printf W2 "%6s",$occ;
		printf W2 "%6s",$b_factor;
		printf W2 "%12s",$atom_symbol;
		printf W2 "\n";
		}
	elsif($prev eq $now)
		{
		$prev="$chain$res_num$res_type";
		printf W2 "%4s",$atom;
		printf W2 "%7s",$atom_num;
		printf W2 "%5s",$atom_type;
		printf W2 "%4s",$res_type;
		printf W2 " A";
		printf W2 "%4s",$count;
		printf W2 "%12s",$x_coord;
		printf W2 "%8s",$y_coord;
		printf W2 "%8s",$z_coord;
		printf W2 "%6s",$occ;
		printf W2 "%6s",$b_factor;
		printf W2 "%12s",$atom_symbol;
		printf W2 "\n";
		}
	else
		{
		$prev="$chain$res_num$res_type";
		$count++;
		printf W2 "%4s",$atom;
		printf W2 "%7s",$atom_num;
		printf W2 "%5s",$atom_type;
		printf W2 "%4s",$res_type;
		printf W2 " A";
		printf W2 "%4s",$count;
		printf W2 "%12s",$x_coord;
		printf W2 "%8s",$y_coord;
		printf W2 "%8s",$z_coord;
		printf W2 "%6s",$occ;
		printf W2 "%6s",$b_factor;
		printf W2 "%12s",$atom_symbol;
		printf W2 "\n";
		}
	}
close (W2);		



# To obtain the residue information for both the chains for the modified file.
open(W3,">modified.txt");
open(R3,"modified.pdb");
@data3=<R3>;
close(R3);

$prev=0;

foreach $line3 (@data3)
	{
	$line3=~s/\n//g;
	$res_type=substr($line3,17,3);
	$chain=substr($line3,21,1);
	$res_num=substr($line3,22,4);
	$res_num=~s/\s+//g;
	$now="$chain$res_num$res_type";
	if($prev ne $now)
		{
		print W3 "$chain$res_num$res_type\n";
		$prev="$chain$res_num$res_type";
		}
	else
		{
		}
	}
close (W3);
