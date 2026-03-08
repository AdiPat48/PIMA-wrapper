
#!/usr/local/bin/perl 


#######THIS PROGRAM CHECKS THE PDB FILE FOR THE AMIONO ACIDS MAPS TO THE SEQUENC######E NO LIKE 37,37A,37B,37C.......etc


open($fp,$ARGV[0]);
open($outfile,">output_file");
open($seq_fp,">seq_outfile");
open($check_more,">checkfile");

&main;



sub main
{
@all_lines=<$fp>;
$len=scalar(@all_lines);
$m=0;
$new_value=0;
for($m=0;$m<$len+1;$m++)
{
	$n=0;
	@each_word=split(' ',$all_lines[$m]);
	foreach $value(@each_word)
	{
		$seq[$m][$n]=$value;
		$n++;
	}
	$flag1=0;
	$flag2=0;
	$flag3=0;
	$flag4=0;
	$flag5=0;
	$equi_seq=$seq[$m][5];
	$last_char=chop($equi_seq);
	$i=0;
	if($last_char ne 'A' || $last_char ne 'B' || $last_char  ne 'C' || $last_char ne 'D' || $last_char ne 'E' || $last_char ne 'F' || $last_char ne 'G' || $last_char ne 'H' || $last_char ne 'I' || $last_char ne 'J' || $last_char ne 'K' || $last_char ne 'L' || $last_char ne 'M' || $last_char ne 'N' || $last_char ne 'O' || $last_char ne 'P')
	{
	        print $seq_fp "$seq[$m][4]\t";
		print $seq_fp $seq[$m][5];
	}
	if($last_char eq 'A' || $last_char eq 'B' || $last_char eq 'C' || $last_char eq 'D' || $last_char eq 'E' || $last_char eq 'F' || $last_char eq 'G' || $last_char eq 'H' || $last_char eq 'I' || $last_char eq 'J' || $last_char eq 'K' || $last_char eq 'L' || $last_char eq 'M' || $last_char eq 'N' || $last_char eq 'O' || $last_char eq 'P')
	{
		print $check_more $last_char;
		
		for($i=$m;$i<$len;$i++)
		{
			$flag1=0;
			$flag2=0;
			$flag3=0;
			$flag4=0;
			$flag5=0;
			$n=0;
			@each_word=split(' ',$all_lines[$i]);
			foreach $value(@each_word)
			{
				$seq[$i][$n]=$value;
				$n++;
			
			}
			$equi_seq=$seq[$i][5];
			$last_char=chop($equi_seq);
#			if($last_char eq 'A' || $last_char eq 'B' || $last_char eq 'C' || $last_char eq 'D' || $last_char eq 'E' || $last_char eq 'F' || $last_char eq 'G' || $last_char eq 'H' || $last_char eq 'I' || $last_char eq 'J' || $last_char eq 'K' || $last_char eq 'L' || $last_char eq 'M' || $last_char eq 'N' || $last_char eq 'O')
#			{
#			}
				print $seq_fp "$seq[$i][4]\t";
				print $seq_fp $seq[$i][5];
		        if($seq[$i][3] eq $seq[$i-1][3] && $seq[$i][2] eq 'N')
			{
				$new_value1=$new_value+1;
				$seq[$i][5]=$new_value1;
				$new_value=$new_value1;
				
			}
			elsif($seq[$i][3] eq $seq[$i-1][3])
			{
				$seq[$i][5]=$new_value;
			}
			elsif($seq[$i][3] ne $seq[$i-1][3]) 
			{

				$new_value1=$new_value+1;
				$seq[$i][5]=$new_value1;
				$new_value=$new_value1;
				
			}
			print $seq_fp "\t";
			print $seq_fp $seq[$i][5];	
			print $seq_fp "\n";
			print $outfile $seq[$i][0];

			$l=length($seq[$i][1]);
			&serial_subroutine($l);
			print $outfile $seq[$i][1];
			

			$l=length($seq[$i][2]);
			&atom_subroutine($l,$seq[$i][2]);


			print $outfile $seq[$i][3];

			print $outfile " ";
			print $outfile $seq[$i][4];


			$l=length($seq[$i][5]);
			&sequence_subroutine($l);
			print $outfile $seq[$i][5];

			$l=length($seq[$i][6]);
			&xcor_subroutine($l);
			print $outfile $seq[$i][6];
		
			$l=length($seq[$i][7]);
			&ycor_subroutine($l);
			print $outfile $seq[$i][7];
			

			$l=length($seq[$i][8]);
			&zcor_subroutine($l);
			print $outfile $seq[$i][8];
			print $outfile " ";
			print $outfile "\n";
		}
		last;
			
	}
	else
	{
		print $seq_fp "\t";
		print $seq_fp "$seq[$m][5]";
		print $seq_fp "\n";

		print $outfile $seq[$m][0];
		
		$l=length($seq[$m][1]);
		serial_subroutine($l);
		print $outfile $seq[$m][1];
	
		$l=length($seq[$m][2]);
		atom_subroutine($l,$seq[$m][2]);

		print $outfile $seq[$m][3];
	
		print $outfile " ";
		print $outfile $seq[$m][4];
		
		$l=length($seq[$m][5]);
		&sequence_subroutine($l);
		print $outfile $seq[$m][5];


		$l=length($seq[$m][6]);
		&xcor_subroutine($l);
		print $outfile $seq[$m][6];

		$l=length($seq[$m][7]);
		&ycor_subroutine($l);
		print $outfile $seq[$m][7];
		
		$l=length($seq[$m][8]);
		&zcor_subroutine($l);
		print $outfile $seq[$m][8];
		print $outfile " ";
		print $outfile "\n";
	}			 
}
	close($outfile);
	
}


sub serial_subroutine()
{
	 $a=$_[0];
			if($a == 1)
			{
				print $outfile "      ";
			}
			elsif($a==2)
			{
				print $outfile "     ";
			}
			elsif($a==3)
			{
				print $outfile "    ";
			}
			elsif($a==4)
			{
				print $outfile "   ";
			}
			elsif($a==5)
			{
				print $outfile "  ";
			}
}


sub atom_subroutine()
{
	$a=$_[0];
	$b=$_[1];
			if($a==1)
			{
				print $outfile "  ";
				$flag1=1;
			}
			elsif($a==2)
			{
				print $outfile "  ";
				$flag2=1;
			}
			elsif($a==3)
		     	{
				$first_atom=substr $b,0,1;
				$last_atom=substr $b,2,1;
		    	 	if(($first_atom eq '1') || ($first_atom eq '2') || ($first_atom eq '3') || ($first_atom eq '4'))
				{
					print $outfile " ";
					$flag3=1;
				}
		    	 	elsif(($last_atom eq '1') || ($last_atom eq '2') || ($last_atom eq '3') || ($last_atom eq '4'))
				{
					print $outfile "  ";
					$flag4=1;
				}	
		    	 	elsif($last_atom eq 'T' )
				{
					print $outfile "  ";
					$flag5=1;
				}
			}
			elsif($a==4)
			{
				print $outfile " ";
				$flag5=1;
			}
			print $outfile $b;
			if($flag1==1)
			{
				print $outfile "   ";
			}
			elsif($flag2==1 || $flag3==1)
			{
				print $outfile "  ";
			}
			elsif($flag4==1 || $flag5==1)
			{
				print $outfile " ";
			}
}


sub sequence_subroutine()
{
	$a=$_[0];
	
			if($a==1)
			{
				print $outfile "   ";
			}
			elsif($a==2)
			{
				print $outfile "  ";
			}
			elsif($a==3)
			{
				print $outfile " ";
			}
}


sub xcor_subroutine()
{
	$a=$_[0];
			if($a==5)
			{
				print $outfile "       ";
			}
			elsif($a==6)
			{
				print $outfile "      ";
			}
			elsif($a==7)
			{
				print $outfile "     ";
			}
}


sub ycor_subroutine()
{
	$a=$_[0];
			if($a==5)
			{
				print $outfile "   ";
			}
			elsif($a==6)
			{
				print $outfile "  ";
			}
			elsif($a==7)
			{
				print $outfile " ";
			}
}


sub zcor_subroutine()
{
	$a=$_[0];
			if($l==5)
			{
				print $outfile "   ";
			}
			elsif($l==6)
			{
				print $outfile "  ";
			}
			elsif($l==7)
			{
				print $outfile " ";
			}
}
