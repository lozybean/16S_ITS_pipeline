#!/usr/bin/env perl
use strict;
use warnings;
use List::Util qw(shuffle);

die "$0 <otu_to_downsize><group_file><pick_number> <Y/N_keep_small_size_sample><out>" unless @ARGV == 5;

my ( $otu_to_downsize,$group_file,$pick_number,$if_keep_small_size,$out ) = @ARGV;

open IN,"$group_file" or die $!;
my %group_samples;
while(<IN>){
    chomp;
    next if /^#/;
    my @tabs = split /\t/;
    $group_samples{$tabs[0]} ++;
}
close IN;

open IN, "$otu_to_downsize" or die "$otu_to_downsize";
my %sample_number;
my %samples;
my @title = ();
while(<IN>){
	chomp;
    my @tab= split /\t/,$_;
    foreach(my $i=1;$i<@tab;$i++){
        $tab[$i] =~ /(\S+)_\d+/;
        my $sample_name = $1;
        next unless exists $group_samples{$sample_name};
		$samples{$tab[$i]}=$tab[0];
		push @title,$tab[$i];
        $sample_number{$sample_name}++;
	}
}
close IN;

my @min = sort { $sample_number{$a} <=> $sample_number{$b} } (keys %sample_number);
my %small_sample;
for my $small (@min){
	if( $sample_number{$small} < $pick_number){
		$small_sample{$small} = $sample_number{$small};
		delete $sample_number{$small};
	}else{
		last;
	}
}

if( (keys %small_sample) > 0){
	my @small_sample = keys %small_sample;
	if($if_keep_small_size eq "Y"){
		for my $key (keys %small_sample){
			$sample_number{$key} = $small_sample{$key};
		}
		print "warnings: some samples, @small_sample, have too fewer reads, but they are still kept\n";
	}elsif($if_keep_small_size eq "N"){
		print "some samples, @small_sample, have too fewer reads. These small samples will be removed\n";
	}else{
		die "\n*************argument 3 shold be 'Y' or 'N'*********\n";
	}
}
my $min = $pick_number;

@title = shuffle @title;

my %read_count;
map {$read_count{$_} = 0} keys %sample_number;

my @final_list;
for my $value ( @title ){
    $value=~/(\S+)\_\w+$/;
    my $sample = $1;
    if(exists $read_count{$sample}){
        if($read_count{$sample} < $min ){
            $read_count{$sample}++;
            push @final_list, $value;
        }
    }
}

my %otus;
foreach my $sample(@final_list){
	my $otu=$samples{$sample};
	$otus{$otu}.="$sample\t";
}
open OUT, ">$out" or die "$out";
foreach my $otuname(keys%otus){
	chop $otus{$otuname};
	print OUT "$otuname\t$otus{$otuname}\n";
}
close OUT;
