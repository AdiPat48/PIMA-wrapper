open(INIS,"<matr");
open(fp,">matrl");

while(<INIS>)
{
    push @AoA, [ split ];
}
$length = scalar@AoA;
print "$length\n";


for($i=0;$i<$length;$i++)
     {
      for($j=0;$j<$length;$j++)
        {
        if($AoA[$i][$j] >  $AoA[$j][$i])
          {
		  $AoA[$j][$i] = $AoA[$i][$j];
           }                           
        else
             {
		       $AoA[$i][$j]=$AoA[$j][$i];
            }
      }
                                                                                                                             
}
#  for($i=0;$i<$length;$i++)
#     {
#         $t=0;
#         for($j=0;$j<$length;$j++)
#           {       
#		   if($AoA[$i][$j]==1)
#		     {
#			     $t++;
#			     $x=$i;
#			     $y=$j;
#		      }	     
#		   if($AoA[$i][$j] != $AoA[$j][$i])
#                       {
#                             print "ERROR";         
#                        }
#            printf fp "$AoA[$i][$j]  ";
#           }
#	   if($t==1)
#           {$AoA[$x][$y]=0;
#            $AoA[$y][$x]=0;}
    #       print fp "\n";
    
#    }
     
for($i=0;$i<$length;$i++)
     {
  for($j=0;$j<$length;$j++)
        {
		printf fp "$AoA[$i][$j]  ";
	}
   print fp "\n";
     }
    
						  



