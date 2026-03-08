#!/usr/local/bin/perl -w
open($fp,$ARGV[0]);
open($outfile,">chain_output_file");
open($seq_fp,">chain_seq_outfile");
&main;
sub main
{
@all_lines=<$fp>;
$len=scalar(@all_lines);
$m=0;
$new_value=0;
for($m=0;$m<$len;$m++)
{
	$seq[$m][0]=substr $all_lines[$m],0,4;
        $seq[$m][1]=substr $all_lines[$m],4,7;
        $seq[$m][2]=substr $all_lines[$m],11,5;
        $seq[$m][3]=substr $all_lines[$m],16,4;
        $seq[$m][4]=substr $all_lines[$m],20,2;
        $seq[$m][5]=substr $all_lines[$m],22,8;
        $seq[$m][6]=substr $all_lines[$m],31,8;
        $seq[$m][7]=substr $all_lines[$m],39,8;
        $seq[$m][8]=substr $all_lines[$m],47,7;

	$flag1=0;
	$flag2=0;
	$flag3=0;
	$flag4=0;
	$flag5=0;
       		        
	
			$seq[$m][2]=~s/^\s+//;
			$seq[$m][2]=~s/\s+$//;
			$seq[$m][3]=~s/^\s+//;
			$seq[$m][3]=~s/\s+$//;
			$seq[$m][4]=~s/^\s+//;
			$seq[$m][4]=~s/\s+$//;
			$seq[$m][5]=~s/^\s+//;
			$seq[$m][5]=~s/\s+$//;
			$seq[$m][6]=~s/^\s+//;
			$seq[$m][6]=~s/\s+$//;
			$seq[$m][7]=~s/^\s+//;
			$seq[$m][7]=~s/\s+$//;
			$seq[$m][8]=~s/^\s+//;
			$seq[$m][8]=~s/\s+$//;

			print $seq_fp "$seq[$m][4]\t";
			print $seq_fp "$seq[$m][5]";
			
			if($seq[$m][3] eq $seq[$m-1][3] && $seq[$m][2] eq 'N')
                        {	
                                $new_value1=$new_value+1;
                                $seq[$m][5]=$new_value1;
                                $new_value=$new_value1;

                        }
                        elsif($seq[$m][3] eq $seq[$m-1][3])
                        {
                                $seq[$m][5]=$new_value;
                        }
                        elsif($seq[$m][3] ne $seq[$m-1][3])
                        {

                                $new_value1=$new_value+1;
                                $seq[$m][5]=$new_value1;
                                $new_value=$new_value1;

                        }

			print $seq_fp "\t$seq[$m][5]\n";
			
			print $outfile $seq[$m][0];

	        	$l=length($seq[$m][1]);
			&serial_subroutine($l);
			print $outfile $seq[$m][1];
			

			$l=length($seq[$m][2]);
			&atom_subroutine($l,$seq[$m][2]);


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
			print $outfile "\n";

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
				elsif($last_atom eq 'T')
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
