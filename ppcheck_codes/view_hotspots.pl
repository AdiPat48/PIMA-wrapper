# To display interface residues in B-factor field of PDB file (i.e. for interface residues, B-factor =6; non-interface residues, B-factor =0)
open(Write1,">123.pdb");

open(Read1,"temp.pdb");
@data1=<Read1>;
close Read1;

open(Read2, "interface_residues");
@data2=<Read2>;
close Read2;

foreach $line1(@data1)
{
@temp1= split(/\s+/,$line1);

foreach $line2(@data2)
 {
 @temp2= split(/\s+/,$line2);
 for($i=0;$i<=$#temp2;$i++)
  {
  $ansh1=substr($temp2[$i],0,1);
  $ansh2=substr($temp2[$i],-3);
  $ansh3=substr($temp2[$i],1,-3);
  if((($temp1[4]) eq ($ansh1)) && (($temp1[3]) eq ($ansh2)) && (($temp1[5]) eq ($ansh3)))
   {
   printf Write1 "%4s",${temp1[0]};
   printf Write1 "%7s",${temp1[1]};
   printf Write1 "%5s",${temp1[2]};
   printf Write1 "%4s",${temp1[3]};
   printf Write1 "%2s",${temp1[4]};
   printf Write1 "%4s",${temp1[5]};
   printf Write1 "%12s",${temp1[6]};
   printf Write1 "%8s",${temp1[7]};
   printf Write1 "%8s",${temp1[8]};
   printf Write1 "%6s",${temp1[9]};
   printf Write1 "%6.2f", 6.00;
   printf Write1 "%12s",${temp1[11]};
   printf Write1 "\n";
   }
    else
    {
    printf Write1 "%4s",${temp1[0]};
    printf Write1 "%7s",${temp1[1]};
    printf Write1 "%5s",${temp1[2]};
    printf Write1 "%4s",${temp1[3]};
    printf Write1 "%2s",${temp1[4]};
    printf Write1 "%4s",${temp1[5]};
    printf Write1 "%12s",${temp1[6]};
    printf Write1 "%8s",${temp1[7]};
    printf Write1 "%8s",${temp1[8]};
    printf Write1 "%6s",${temp1[9]};
   printf Write1 "%6.2f", 0.00;
    printf Write1 "%12s",${temp1[11]};
    printf Write1 "\n";
    }
 }
}
}

system('uniq 123.pdb > 456.pdb');
system('rm -rf 123.pdb');

open(Read3,"456.pdb");
open(Write3,">view_1.pdb");

@bclean=<Read3>;
close Read3;

%ochash;
%lihash;

foreach $line(@bclean)
{
  @temp = split(/\s+/,$line);
  $key = $temp[2].'s'.$temp[4].'s'.$temp[5];
  push(@{$ochash{$key}},$temp[10]);
  push(@{$lihash{$key}},$line);
}
$prekey = "";
foreach $line1(@bclean)
{
  $flag = 0;
  @tmp = split(/\s+/,$line1);
  $key = $tmp[2].'s'.$tmp[4].'s'.$tmp[5];
  if($key eq $prekey)
  {
    $flag = 1;
  }
  if($flag == 0)
  {
  $length = @{$ochash{$key}};
  $index = 0;
  $maxval = ${$ochash{$key}}[$index];
  for ($i= 0;$i<$length;$i++)
 {
    if ($maxval < ${$ochash{$key}}[$i])
    {
        $index = $i;
        $maxval = ${$ochash{$key}}[$i];
    }
 }
  print Write3"${$lihash{$key}}[$index]";
 }
 $prekey = $key;
}

undef @bclean;
undef %ochash;
undef %lihash;
close (Write3);

system('rm -rf 456.pdb');


# 1st Level Annotation: Residues of chain 1 has B-factor=0, Residues in chain 2 has B-factor=3, and all interface residues has B-factor=6. 
open (Write4,">123.pdb");

open (Read4,"view_1.pdb");
@data4 = <Read4>;
close (Read4);

$pre='';
$count=1;

foreach $line4 (@data4)
	{
	$line4 =~ s/\n//g;
	@temp4 = split(/\s+/,$line4);
	$res_type_1 = substr($line4,17,3);
	$chain_1 = substr($line4,21,1);
	$res_num_1 = substr($line4,22,4);
	$res_num_1 =~ s/\s+//g;
	if((($pre eq '') || ($chain_1 eq $pre)) && ($count == 1) && ($temp4[10] == '0.00'))
		{
		$pre=$chain_1;
		printf Write4 "%4s",$temp4[0];
		printf Write4 "%7s",$temp4[1];
		printf Write4 "%5s",$temp4[2];
		printf Write4 "%4s",$temp4[3];
		printf Write4 "%2s",$temp4[4];
		printf Write4 "%4s",$temp4[5];
		printf Write4 "%12s",$temp4[6];
		printf Write4 "%8s",$temp4[7];
		printf Write4 "%8s",$temp4[8];
		printf Write4 "%6s",$temp4[9];
		printf Write4 "  0.00";
		printf Write4 "%12s",$temp4[11];
		printf Write4 "\n";
		}
	if((($pre eq '') || ($chain_1 eq $pre)) && ($count == 1) && ($temp4[10] ne '0.00'))
		{
		$pre=$chain_1;
		printf Write4 "$line4\n";
		}
	elsif($chain_1 ne $pre)
		{
		$pre=$chain_1;
		$count++;
		}
	elsif(($chain_1 eq $pre) && ($count == 2) && ($temp4[10] ne '6.00'))
		{
		$pre=$chain_1;
		printf Write4 "%4s",$temp4[0];
		printf Write4 "%7s",$temp4[1];
		printf Write4 "%5s",$temp4[2];
		printf Write4 "%4s",$temp4[3];
		printf Write4 "%2s",$temp4[4];
		printf Write4 "%4s",$temp4[5];
		printf Write4 "%12s",$temp4[6];
		printf Write4 "%8s",$temp4[7];
		printf Write4 "%8s",$temp4[8];
		printf Write4 "%6s",$temp4[9];
		printf Write4 "  3.00";
		printf Write4 "%12s",$temp4[11];
		printf Write4 "\n";
		}
	elsif(($chain_1 eq $pre) && ($count == 2) && ($temp4[10] eq '6.00'))
		{
		$pre=$chain_1;
		printf Write4 "$line4\n";
		}
	else
		{
		}
	}
close (Write4);

system('uniq 123.pdb > 456.pdb');
system('rm -rf 123.pdb');

open(Read5,"456.pdb");
open(Write5,">view_2.pdb");

@bclean=<Read5>;
close Read5;

%ochash;
%lihash;

foreach $line(@bclean)
{
  @temp = split(/\s+/,$line);
  $key = $temp[2].'s'.$temp[4].'s'.$temp[5];
  push(@{$ochash{$key}},$temp[10]);
  push(@{$lihash{$key}},$line);
}
$prekey = "";
foreach $line1(@bclean)
{
  $flag = 0;
  @tmp = split(/\s+/,$line1);
  $key = $tmp[2].'s'.$tmp[4].'s'.$tmp[5];
  if($key eq $prekey)
  {
    $flag = 1;
  }
  if($flag == 0)
  {
  $length = @{$ochash{$key}};
  $index = 0;
  $maxval = ${$ochash{$key}}[$index];
  for ($i= 0;$i<$length;$i++)
 {
    if ($maxval < ${$ochash{$key}}[$i])
    {
        $index = $i;
        $maxval = ${$ochash{$key}}[$i];
    }
 }
  print Write5"${$lihash{$key}}[$index]";
 }
 $prekey = $key;
}

undef @bclean;
undef %ochash;
undef %lihash;
close Write5;

system('rm -rf 456.pdb');
system('rm -rf view_1.pdb');


# 2nd level Annotation : Residues of chain 1 has B-factor=0, Residues in chain 2 has B-factor=3, all interface residues has B-factor=6 and all hospot residues has B-factor=9.

open(Write6,">123.pdb");

open(Read6,"view_2.pdb");
@data1=<Read6>;
close (Read6);

open(Read7, "hotspot_residues");
@data2=<Read7>;
close (Read7);

foreach $line6(@data1)
{
$line6 =~ s/\n//g;
@temp6= split(/\s+/,$line6);

foreach $line7(@data2)
 {
 $line7 =~ s/\n//g;
 @temp7= split(/\s+/,$line7);
 for($i=0;$i<=$#temp7;$i++)
  {
  $ansh1=substr($temp7[$i],0,1);
  $ansh2=substr($temp7[$i],-3);
  $ansh3=substr($temp7[$i],1,-3);
  if((($temp6[4]) eq ($ansh1)) && (($temp6[3]) eq ($ansh2)) && (($temp6[5]) eq ($ansh3)))
   {
   printf Write6 "%4s",${temp6[0]};
   printf Write6 "%7s",${temp6[1]};
   printf Write6 "%5s",${temp6[2]};
   printf Write6 "%4s",${temp6[3]};
   printf Write6 "%2s",${temp6[4]};
   printf Write6 "%4s",${temp6[5]};
   printf Write6 "%12s",${temp6[6]};
   printf Write6 "%8s",${temp6[7]};
   printf Write6 "%8s",${temp6[8]};
   printf Write6 "%6s",${temp6[9]};
   printf Write6 "%6.2f", 9.00;
   printf Write6 "%12s",${temp6[11]};
   printf Write6 "\n";
   }
    else
    {
    printf Write6 "$line6\n";
    }
 }
}
}

system('uniq 123.pdb > 456.pdb');
system('rm -rf 123.pdb');

open(Read3,"456.pdb");
open(Write7,">view.pdb");

@bclean=<Read3>;
close Read3;

%ochash;
%lihash;

foreach $line(@bclean)
{
  @temp = split(/\s+/,$line);
  $key = $temp[2].'s'.$temp[4].'s'.$temp[5];
  push(@{$ochash{$key}},$temp[10]);
  push(@{$lihash{$key}},$line);
}
$prekey = "";
foreach $line1(@bclean)
{
  $flag = 0;
  @tmp = split(/\s+/,$line1);
  $key = $tmp[2].'s'.$tmp[4].'s'.$tmp[5];
  if($key eq $prekey)
  {
    $flag = 1;
  }
  if($flag == 0)
  {
  $length = @{$ochash{$key}};
  $index = 0;
  $maxval = ${$ochash{$key}}[$index];
  for ($i= 0;$i<$length;$i++)
 {
    if ($maxval < ${$ochash{$key}}[$i])
    {
        $index = $i;
        $maxval = ${$ochash{$key}}[$i];
    }
 }
  print Write7"${$lihash{$key}}[$index]";
 }
 $prekey = $key;
}

undef @bclean;
undef %ochash;
undef %lihash;
close Write7;

system('rm -rf 456.pdb');
system('rm -rf view_2.pdb');
