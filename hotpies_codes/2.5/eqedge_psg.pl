#! /usr/bin/perl

#Program to make adjacency and laplacian matrix representation of Protein Side chain Interaction Graph
#Cleaned PDB file is required as input

print "Running, please wait..\n";

open(Read1,"pdb.inp")or die("can not open pdb.inp as: $!\n");
@hold_pdb=<Read1>;
close(Read1);

open(Read2,"contfile")or die("Can not open contfile as: $!\n");
$Imin=<Read2>;
close(Read2);

$Norm_value{ALA}=55.75;
$Norm_value{ARG}=93.78;
$Norm_value{ASN}=73.40;
$Norm_value{ASP}=75.15;
$Norm_value{CYS}=54.95;
$Norm_value{GLN}=78.13;
$Norm_value{GLU}=78.82;
$Norm_value{GLY}=47.31;
$Norm_value{HIS}=83.73;
$Norm_value{ILE}=67.94;
$Norm_value{LEU}=72.25;
$Norm_value{LYS}=69.60;
$Norm_value{MET}=69.25;
$Norm_value{PHE}=93.30;
$Norm_value{PRO}=51.33;
$Norm_value{SER}=61.39;
$Norm_value{THR}=63.70;
$Norm_value{TRP}=106.70;
$Norm_value{TYR}=100.71;
$Norm_value{VAL}=62.36;


#Extract side chain atomic coordinates and take main chain for Glycine
#open(Write1,">Sidechain")or die("Can not open Sidechain as: $!\n");
foreach $line(@hold_pdb)
{
	$amino_name=substr($line,17,3);
	if($amino_name eq 'GLY')
	{
		#print Write1 "$line";
		push(@Sidechain,$line);
	}
	else
	{
		$atom_type=substr($line,13,3);
		$atom_type=~s/\s//gi;
		if($atom_type eq 'N' || $atom_type eq 'CA' || $atom_type eq 'O' || $atom_type eq 'C')
		{
			print "";#Do nothing :) I thought of using Unless(),but it does not work with this version of Perl
		}
		else
		{
			#print Write1 "$line";
			push(@Sidechain,$line);
		}
	}
}

#Put atomic cordinates in a 2D array for easy access

$length_side=@Sidechain;
$Totaa_no=substr($Sidechain[$length_side-1],22,5);

foreach $line(@Sidechain)
{
	$resno=substr($line,22,5);
	$resno=~s/\s//gi;
	for($i=1;$i<=$Totaa_no;$i++)
	{
		if($i==$resno)#Atoms of one amino acid are put in different columns of same row
		{
			push @{$dd_side[$i-1]},"$line";
		}
		last if($i>$resno);
	}
}
#print "$length_side\n$Totaa_no\n";

#Creating empty matrix

for($i=0;$i<$Totaa_no;$i++)
{
	for($j=0;$j<$Totaa_no;$j++)
	{
		$lap[$i][$j]=-(1/5000) if($i!=$j);#--CHANGE HERE--Edge weight for offdiagonal elements with no connection
		$lap[$i][$j]=0.0000 if($i==$j);#Edge weight for diagonal elements as self loop is insignificant
		$adj[$i][$j]=0;
	}
}

#Interaction calculation

for($i=0;$i<$Totaa_no;$i++)
{					
	for($j=0;$j<$Totaa_no;$j++)#These 2 loops compare each residue pair
	{
		if($j-$i>1)
		{
			$interacting_pair=0;
			$total_dist=0;
			for $m(0 .. $#{$dd_side[$i]})
			{
				for $n(0 .. $#{$dd_side[$j]})#These 2 loops compare each side chain atom pair
				{
					$x1=substr($dd_side[$i][$m],31,7);
					$y1=substr($dd_side[$i][$m],39,7);
					$z1=substr($dd_side[$i][$m],47,7);

					$x2=substr($dd_side[$j][$n],31,7);
					$y2=substr($dd_side[$j][$n],39,7);
					$z2=substr($dd_side[$j][$n],47,7);

					$dist=sqrt((($x2-$x1)**2)+(($y2-$y1)**2)+(($z2-$z1)**2));
					
					if($dist>1.7 && $dist<=4.5)
					{
						$interacting_pair++;
						$total_dist=$total_dist+$dist;
					}
				}
			}
			
			if($interacting_pair>0)
			{
				$res_i=substr($dd_side[$i][0],17,3);
				$res_j=substr($dd_side[$j][0],17,3);
				foreach(keys %Norm_value)
				{
					if($res_i eq $_)
					{
						$Norm_i=$Norm_value{$_};
					}
					if($res_j eq $_)
					{
						$Norm_j=$Norm_value{$_};
					}
				}
			}
			
			$Norm=sqrt($Norm_i*$Norm_j);
			
			if($Norm!=0)#Perl takes division by zero as illegal
			{
				$Interaction=($interacting_pair/$Norm)*100;

				if($Interaction>$Imin)
				{
					$pos_i=substr($dd_side[$i][0],22,5);
					$pos_i=~s/\s//gi;
					$pos_j=substr($dd_side[$j][0],22,5);
					$pos_j=~s/\s//gi;
					
					$avg_dist=$total_dist/$interacting_pair;#Average distance between residue i and j

					#print "$pos_i $pos_j $avg_dist   ";
					$lap[$pos_i-1][$pos_j-1]=-1;#--CHANGE HERE--Edge weight assigned
					$adj[$pos_i-1][$pos_j-1]=1;
				}
			}
		}
	}
}

#Fill up the lower triangular matrix

$len_lap=@lap;
for($i=0;$i<$len_lap;$i++)
{
	for($j=0;$j<$len_lap;$j++)
	{
		if($i<$j)
		{
			$lap[$j][$i]=$lap[$i][$j];
			$adj[$j][$i]=$adj[$i][$j];
		}
	}
}

#Filling up diagonal elements of laplacian matrix

for($i=0;$i<$len_lap;$i++)
{
        $degree=0;
        for($j=0;$j<$len_lap;$j++)
        {
        	$degree=$degree+$lap[$i][$j];
        }
        $lap[$i][$i]=(0-$degree);
}

#Checking for symmetry

$count=0;
for($i=0;$i<$len_lap;$i++)
{
        for($j=0;$j<$len_lap;$j++)
        {
        	if($lap[$i][$j]!=$lap[$j][$i])
		{
                	$count++;
                }
		if($adj[$i][$j]!=$adj[$j][$i])
		{
			$count++;
		}
        }
}
if($count==0)
{
	print "True symmetric matrix\n";
}
else
{
        print "Something is wrong!!\n";
}

#Put matrices in files

open(Write2,">Lap")or die("Can not open Lap as: $!\n");
open(Write3,">Adj")or die("can not open Adj as: $!\n");

for($i=0;$i<$len_lap;$i++)
{
	for($j=0;$j<$len_lap;$j++)
	{
		printf Write2 "%8.4f","$lap[$i][$j] ";
		print Write3 "$adj[$i][$j] ";
	}
	print Write2 "\n";
	print Write3 "\n";
}






