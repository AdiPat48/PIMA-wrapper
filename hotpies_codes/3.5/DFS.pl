#!/usr/bin/perl 

#The input adjacency matrix should be given in command line like perl DFS.pl<adjmatr
#use strict;

my %map;
my @matrix;
my @cluster;

my $i = 0;
open INP,"<replace_tmp2";
while(<INP>){
  chomp($_);
  $map{$i} = $_;
  $i++;
}
close INP;
# Input matrix specified on command line. No blank spaces allowed.

push @matrix, [split] while (<>);
my @nodes= (0..$#matrix);

unlink "dfssubmatr" if ( -f "dfssubmatr");
unlink "dfsOutput" if ( -f "dfsOutput");
unlink "orphans" if ( -f "orphans");

open OUT, ">dfsOutput";
open OUT2, ">dfssubmatr"; 
open OUT3, ">orphans"; 
open OUT5, ">dfsmapping"; 
my $clno = 1;

# Finding clusters and printing them to file dfsOutput

while (@nodes) {
  my @stack=();
  print OUT "Cluster no: $clno\n";
  print OUT5 "Cluster no: $clno\n";
  print OUT5 "*****************\n";
  unshift @stack, shift @nodes;
  while (@stack) {
    my @tmp;
    my @newnodes;
    my $i = $stack[0];
    foreach my $j (@nodes) {
      if (0 + $matrix[$i][$j]) {
	push @tmp, $j;
      } else {
	push @newnodes, $j;
      }
    }
    if (@nodes == @newnodes) {
      my $p = shift @stack;
      push @{$cluster[$clno]}, $p;
      print OUT $p+1, "\n";
      #my $y = $p+1;
      print OUT5 $map{$p},"\n";
      @newnodes = ();
    } else {
      if (@tmp) {
	unshift @stack, shift @tmp;
	push @newnodes, @tmp;
	@tmp = ();
      }
      @nodes = @newnodes;
      @newnodes = ();   
    }
  }

  print OUT2 "\nSubmatrix for cluster no:$clno\n";          # Printing submatrices to file dfssubmatr.
  foreach my $i (sort { $a <=> $b } @{$cluster[$clno]}) {
    foreach my $j (sort { $a <=> $b} @{$cluster[$clno]}) {
      printf OUT2 "%3d", $matrix[$i][$j];
    }   
    print OUT2  "\n";  
  }  


  if (@{$cluster[$clno]} == 1) {               # printing orphan nodes to file orphans
    my $i = $cluster[$clno][0] + 1;
    print OUT3 "$i\n";
  }
  $clno++;
}

close OUT;  
close OUT2;
close OUT3;
close OUT4;

#   To find corresponding nodes between Mtu and Submatrix1
open OUT4, ">mtusubnodes";
@{$cluster[1]} = sort { $a <=> $b } @{$cluster[1]};
my $tot = @{$cluster[1]};
print OUT4 "Mtu       Submatrix1\n";
foreach my $a (0..$tot-1) {
  printf OUT4 "   %3d      %3d\n", $cluster[1][$a]+1, $a+1;
}
close OUT4;    
exit 0;



