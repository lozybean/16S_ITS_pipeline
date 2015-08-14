#!/usr/bin/env perl
use strict;

die "usage : perl $0 <group_file> <sumOTUPerSample_in> <sumOTUPerSample_out>" unless @ARGV==3;

my ($group_file,$sum_in,$sum_out) = @ARGV;

my %samples;
open IN,$group_file or die $!;
while(<IN>){
    chomp;
    my @tabs = split /\t/;
    $samples{$tabs[0]} ++;
}
close IN;

open IN,$sum_in or die $!;
open OUT,">$sum_out" or die $!;
$_=<IN>;
print OUT;
while(<IN>){
    my @tabs = split /\t/;
    next unless exists $samples{$tabs[0]};
    print OUT;
}
close IN;
close OUT;
