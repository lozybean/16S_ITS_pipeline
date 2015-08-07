#!/usr/bin/env perl
use strict;
foreach my $file (@ARGV){
    open IN,$file or die $!;
    while(<IN>){
        chomp;
        s/\s+//;
        my @tabs = split /\t/;
        next if @tabs == 1;
        print "$_\n";
    }
    close IN;
}
