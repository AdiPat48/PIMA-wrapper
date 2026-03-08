open(Read,"comm1");
@ele=<Read>;
close(Read);

open(Read1,"comm2");
@ele1=<Read1>;
close(Read1);

foreach $line (@ele)
{
  $line=~s/\n//g;
  @var=split(' ',$line);
  $l1=@var;
  
foreach $line1(@ele1)
{
  $line1=~s/\n//g;
  @var1=split(' ',$line1);
  $l2=@var1;

  for($i=0;$i<$l1;$i++)
{
 for($j=0;$j<$l2;$j++)
{
       if ($var[$i] eq $var1[$j])
{
    $t++;
}
}
}
print "$t\n";
$t=0;
}
}      
