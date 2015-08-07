#!/usr/bin/env perl

die "usage: perl $0 <infile> <outfile>" unless @ARGV==2;

my ($infile,$outfile) = @ARGV;

open IN,$infile or die $!;
open OUT,">$outfile" or die $!;
while(<IN>){
    if(/^#/){
        print OUT;
    }
    chomp;
    my @tabs = split /\t/;
    my $tax=$tabs[1];
    while( ( $tax=~/__$/ ) || ( $tax =~ /Other$/ ) || ( $tax =~ /unidentified$/ ) ){
        $tax =~ s/(\S+);\S+$/$1/;
    }
    $tabs[1] = $tax;
    $" = "\t";
    print OUT "@tabs\n";
}
close IN;
close OUT;

