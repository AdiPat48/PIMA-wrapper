open(W,">zyx.txt");

open(R1,"waterless_dataset.txt");
@data1=<R1>;
close(R1);


foreach $line1(@data1)
{
$line1=~s/\n//g;
@temp1=split(' ',$line1);
print W "$temp1[0]\n";
}
close (W);	
