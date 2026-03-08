open(W,">zyx.txt");

open(R1,"updated_waterless_final_results.txt");
@data1=<R1>;
close(R1);

open(R2,"waterless_dataset.txt");
@data2=<R2>;
close(R2);


foreach $line1(@data1)
{
$line1=~s/\n//g;
@temp1=split(' ',$line1);

foreach $line2(@data2)
{
$line2=~s/\n//g;
@temp2=split(' ',$line2);

if($temp1[0] eq $temp2[0])
{
print W "$line1\n";
}
}
}
close (W);	
