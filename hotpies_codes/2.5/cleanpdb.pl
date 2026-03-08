#! usr/bin/perl

open(fr,$ARGV[0]);
@data = <fr>;

foreach $line(@data)
{
  if($line=~ /^ATOM/)
  {
     @temp = split(/\s+/,$line);
     if($temp[2] =~ /^H/)
     {
     #  print "$line";
     }
     else
     {
        print "$line";
     }
  }
}
