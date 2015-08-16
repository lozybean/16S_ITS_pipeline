#!/usr/bin/env perl
die "perl $0 <otu_all.txt><group><out>" unless(@ARGV==3); 
my ($otu0,$group,$out)=@ARGV;

open IN,$group or die $!;
my %group;
while(<IN>){
	chomp;
	my @tab=split/\t/,$_;
	$group{$tab[0]}=$tab[1];

}
close IN;

$otu0 =~ /(\S+)\./;
my $base = $1;
chomp(my $head=`sort $otu0 | uniq -d `);
chomp(my $content = `sort $otu0 | uniq -u`);
open OUT,">$base.trans.txt" or die $!;
print OUT "$head\n";
print OUT "$content\n";
close OUT;

open IN,"$base.trans.txt" or die $!;
open OUT,">$out" or die $!;
my $header=<IN>;
my @headers=split/\t/,$header;
shift @headers;
chomp @headers;
my $otu;
my $samples;
foreach my $sample(@headers){
    $otu.="$group{$sample}\t";
    $samples.="$sample\t";
}
chop $otu;chop $samples;
print OUT "class\t$otu\n";
print OUT "Taxon\t$samples\n";
while(<IN>){
           chomp;
           my @tab=split/\t/,$_;
           #s/\w\_\_//g;
           #s/\[//g;s/\]//g;
           s/;/\|/g;
           next if(/\|\w\_\_\t/ or /Other\t/);
           print OUT "$_\n";
}
close IN;
close OUT;
