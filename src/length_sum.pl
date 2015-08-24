#!/usr/bin/env perl
use strict;
my $fa_file = shift @ARGV;
$fa_file =~ /(\S+)\//;
my $path = $1;

my @length=(1,220);
for (my $i=240;$i<=500;$i+=20){
    push(@length,$i);
}
my %length;
open IN,$fa_file or die $!;
$/='>';
<IN>;
while(<IN>){
    chomp;
    my @lines = split /\n/;
    my $id = shift @lines;
    my $seq = join('',@lines);
    my $length = length($seq);
    for(my $i=0;$i<@length-1;$i++){
        if (($length > $length[$i]) && ($length < $length[$i+1]) ){
            my $b = $length[$i];
            my $e = $length[$i+1];
            $length{"$b-$e"}++;
        }
    }
}
close IN;
open OUT,">$path/length_sum.txt" or die $!;
for my $key(sort keys %length){
    print OUT "$key\t$length{$key}\n";
}
close OUT;
open R,">$path/length_sum.R" or die $!;
print R <<RTXT;
X=read.table("length_sum.txt",row.names=1)
pdf('length_sum.pdf')
barplot(t(X),col='blue',xlab='Sequence length',ylab='Sequence number')
dev.off()
RTXT
close R;
`Rscript $path/length_sum.R`;
`convert $path/length_sum.pdf $path/length_sum.png`;
#`rm length_sum.R*`;

