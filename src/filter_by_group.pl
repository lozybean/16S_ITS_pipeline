#!/usr/bin/env perl
use strict;
my ($group_file,$fna_in,$fna_out) = @ARGV;
my %samples;
open IN,$group_file or die $!;
while(<IN>){
    chomp;
    my  @tabs = split /\t/;
    $samples{$tabs[0]} ++;
}
close IN;
open IN,$fna_in or die $!;
open OUT,">$fna_out" or die $!;
$/='>';
<IN>;
while(<IN>){
    chomp;
    my @lines = split /\n/;
    my $id = shift @lines;
    my $seq = join('',@lines);
    $id =~ /(\S+)_/;
    next unless exists $samples{$1};
    print OUT ">$id\n$seq\n";
}
close IN;
close OUT;
