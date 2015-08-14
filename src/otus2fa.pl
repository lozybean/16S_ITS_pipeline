#!/usr/bin/env perl
use strict;
die "perl $0 <otu.txt> <seqs.fna><out_seqs.fna>" unless(@ARGV==3);
my($otu,$seqs,$out)=@ARGV;
open IN,$otu || die "can not open $otu\n";
my %reads;
while(<IN>){
    chomp;
    my @tab=split/\t/,$_;
    foreach(my $i=1;$i<@tab;$i++){
        $reads{$tab[$i]} ++;
    }
}
close IN;

open IN,$seqs || die "can not open $seqs\n";
open OUT,">$out" || die "can not open $out\n";
$/=">";
<IN>;
while(<IN>){
    chomp;
	my @lines=split /\n/;
    my $id = shift @lines;
    my $seq = join('',@lines);
    next unless exists $reads{$id};
    print OUT ">$id\n$seq\n";
}	
close IN;
close OUT;

