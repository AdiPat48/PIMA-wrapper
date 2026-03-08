#!/usr/bin/perl

# Removing coordinates from multiple chains of same proteins (i.e. considering coordinates from only 1st model), in case of NMR method.

open(FX,">ansh.pdb"); 
$read = $ARGV[0];
open(Reads,$read);
@datas=<Reads>;
close(Reads);

foreach $lines(@datas)
 {
  $lines=~ s/\n//; #Removes newline character from the line
  @temps = split(/\s+/,$lines); #Splits the line into fields using whitespace as delimiter
   do
   {
   print FX "$lines\n"; 
    if(($temps[0] eq 'MODEL' && $temps[1] == '2') || ($temps[0] eq 'ENDMDL'))
    {
    last;
    }
   }
   while (($temps[0] eq 'MODEL' && $temps[1] == '2') || ($temps[0] eq 'ENDMDL'));
 }

close (FX);


open(fw,">input.pdb");
open(Read,"ansh.pdb");
@data=<Read>;
close(Read);

foreach $line(@data)
 {
  $line=~ s/\n//;
  @temp = split(/\s+/,$line);
  $count =0;
  $counter =0;
# Filters for ATOM lines that exclude: Hydrogens (H), Deuteriums (D), malformed atom names (starting with 1–3), and nucleotide residues
  if(($temp[0] eq 'ATOM') && ($temp[2] !~ /^H/) && ($temp[2] !~ /^D/) && ($temp[2] !~ /^1/) && ($temp[2] !~ /^2/) && ($temp[2] !~ /^3/) && ($temp[3] ne 'A') && ($temp[3] ne 'U') && ($temp[3] ne 'C') && ($temp[3] ne 'G') && ($temp[3] ne 'T') && ($temp[3] !~ /^D/))
   {
     while ($temp[2] =~ /[A-Z 0-9]/ig) { $count++ } #Counts alphanumeric characters in the atom name.
     if( $count > 3) #If atom name is long (>3), inserts a space to fix alignment.
     {
        $try = substr($temp[2],3,1);
        substr($temp[2],3,1) = " $try";
        $rline = join('  ',@temp);
        push(@bclean,$rline);
     }
      while ($temp[4] =~ /[A-Z 0-9]/ig) { $counter++ }
      if( $counter > 1)
      {
        $trial = substr($temp[4],1,4);
        substr($temp[4],1,4) = " $trial";
        $rline = join('  ',@temp);
        push(@bclean,$rline);
      }
      else
      {
        push(@bclean,$line);
      }
    }
 }

%ochash; #Hash to store occupancy values
%lihash; #Hash to store lines


foreach $line(@bclean)
{
  @temp = split(/\s+/,$line);
  $key = $temp[2].'s'.$temp[4].'s'.$temp[5];
  push(@{$ochash{$key}},$temp[9]); # occupancy (field 10)
  push(@{$lihash{$key}},$line);  # the complete line
}
$prekey = "";
foreach $line1(@bclean)
{
  $flag = 0;
  @tmp = split(/\s+/,$line1);
  $key = $tmp[2].'s'.$tmp[4].'s'.$tmp[5]; # Key is the atom name, chain identifier, and residue number
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
  print fw"${$lihash{$key}}[$index]\n";
 }
 $prekey = $key;
}

undef @bclean;
undef %ochash;
undef %lihash;
close fw;


# To obtain Chain IDs of all residues present in the file.

open(W,">all_chains");
open(W0,">chain_ids");

open(Read,"input.pdb");
@anshul=<Read>;
close(Read);

foreach $line(@anshul)
{
$line =~ s/\n//;
@data = split(/\s+/,$line);
@out = "$data[4] ";
print W "@out";
}
close W;

# To know about only the Chain Ids present in the PDB ID.

open(Read,"all_chains");
@ans=<Read>;
close(Read);

foreach $line(@ans)
{
@data = split(/\s+/,$line);
@outer = grep{$_ =~ /\w+/ and ++$counts{$_} < 2;} @data;
}
print W0 "@outer";
close W0;
# To get atoms of same chain identifiers (Amino acids and water molecules) together.


# print STDERR "DEBUG: Line read: [@data]\n";

open(WW,">atoms");

open(Read,"input.pdb");
@atoms=<Read>;
close(Read);

# -------------------
#Start of code added by Aditi 
# -------------------
@data = ();
for (my $i = 0; $i < $chains; $i++) 
{
    $data[$i] = "";
}

# -------------------
# End of code added by Aditi
# -------------------

foreach $line(@atoms)
{
@temp = split(/\s+/,$line);

$chains=@outer;

for($i=0;$i<$chains;$i++)
 {

  if($temp[4] eq $outer[$i])
  {

	$data[$i].="$line";

  }
 }
}


$data="";
foreach $data(@data)
{
$data=~s/AATOM/ATOM/;

 if($data=~/\d+/)
 {
 print WW "$data";
 }
}
close WW;

# To get every line in a neat & clean PDB format.

open(WWW,">atoms.pdb");

open(Read,"atoms");
@read=<Read>;
close(Read);

foreach $lines(@read)
{
 @ansh=split('\s+',$lines);
if($ansh[0] eq 'ATOM')
{
 printf WWW "%4s",${ansh[0]};
 printf WWW "%7s",${ansh[1]};
 printf WWW "%5s",${ansh[2]};
 printf WWW "%4s",${ansh[3]};
 printf WWW "%2s",${ansh[4]};
 printf WWW "%4s",${ansh[5]};
 $ansh1=length${ansh[6]};
 $ansh2=length${ansh[7]};
 $ansh3=length${ansh[8]};
 $ansh4=length${ansh[9]};
# For correct format of 1st+2nd+3rd+Occupancy+B-factor coordinate column.
  if($ansh1>16)
  {
  printf WWW "%28s",${ansh[6]};
  }
  elsif(($ansh1>8) && ($ansh1<=16))
  {
  printf WWW "%20s",${ansh[6]};
  }
  else
  {
  printf WWW "%12s",${ansh[6]};
  }
# For correct format of 2nd+3rd+Occupancy+B-factor coordinate column.
  if(($ansh1>16) && ($ansh2<=5))
  {
  printf WWW "%6s",${ansh[7]};
  }
  elsif(($ansh1>16) && ($ansh2>5))
  {
  printf WWW "%12s",${ansh[7]};
  }
  elsif(($ansh1<=8) && ($ansh2>8))
  {
  printf WWW "%16s",${ansh[7]};
  }
  elsif($ansh2<=8)
  {
  printf WWW "%8s",${ansh[7]};
  }
  else
  {
  }
# For correct format of 3rd coordinate + Occupancy+B-factor+Atom identifier (last) column.
  if(($ansh1>16) && ($ansh2<=5))
  {
  printf WWW "%6s",${ansh[8]};
  }
  elsif(($ansh1>16) && ($ansh2>5))
  {
  printf WWW "%12s",${ansh[8]};
  }
  elsif(($ansh1<=8) && ($ansh2<8) && ($ansh3<8))
  {
  printf WWW "%8s",${ansh[8]};
  }
  elsif((($ansh1>8) || ($ansh2>8)) && ($ansh3<=5))
  {
  printf WWW "%6s",${ansh[8]};
  }
  elsif((($ansh1>8) || ($ansh2>8)) && ($ansh3>5))
  {
  printf WWW "%12s",${ansh[8]};
  }
  else
  {
  }
# For correct format of 3rd coordinate + Occupancy+B-factor+Atom identifier (last) column.
  if(($ansh1>16) && ($ansh2<=5))
  {
  printf WWW "%12s",${ansh[9]};
  }
  elsif((($ansh1>8) || ($ansh2>8)) && ($ansh3>5))
  {
  printf WWW "%12s",${ansh[9]};
  }
  elsif((($ansh1>8) || ($ansh2>8)) && ($ansh3<=5))
  {
  printf WWW "%6s",${ansh[9]};
  }
  elsif(($ansh1<=8) && ($ansh2<8) && ($ansh3<8) && ($ansh4<=5))
  {
  printf WWW "%6s",${ansh[9]};
  }
  elsif(($ansh1<=8) && ($ansh2<8) && ($ansh3<8) && ($ansh4>5))
  {
  printf WWW "%12s",${ansh[9]};
  }
  else
  {
  }
# For correct format of Occupancy+B-factor+Atom identifier (last) column.
  if(($ansh1<=8) && ($ansh2<8) && ($ansh3<8) && ($ansh4<=5))
  {
  printf WWW "%6s",${ansh[10]};
  }
  elsif(($ansh1<=8) && ($ansh2<8) && ($ansh3<8) && ($ansh4>5))
  {
  printf WWW "%12s",${ansh[10]};
  }
  elsif((($ansh1>8) || ($ansh2>8)) && ($ansh3<=5))
  {
  printf WWW "%12s",${ansh[10]};
  }
# For correct format of Atom identifier (last) column.
  if(($ansh1<=8) && ($ansh2<8) && ($ansh3<8) && ($ansh4<=5))
  {
  printf WWW "%12s",${ansh[11]};
  }
 printf WWW  "\n";
}
}
system ("rm ansh.pdb");
system ("rm input.pdb");
system ("rm all_chains");
system ("rm atoms");
