#!/usr/bin/env perl
use strict;
use File::Basename;

die "perl $0 <otu_L6.txt><group.txt>" unless(@ARGV==2);

my ($otu,$group)=@ARGV;
my $otupath = dirname($otu);
my $otubase=basename($otu);
my $main;
$otu =~ /(\S+)\.\S+/;
my $otuname = $1;

if($otubase eq "otu_table_L2.txt"){$main="Phylum";}
elsif($otubase eq "otu_table_L3.txt"){$main="Class";}
elsif($otubase eq "otu_table_L4.txt"){$main="Order";}
elsif($otubase eq "otu_table_L5.txt"){$main="Family";}
elsif($otubase eq "otu_table_L6.txt"){$main="Genus";}

open IN,$otu or die $!;
open OUT,">$otuname.for_star_plot.txt" or die $!;
<IN>;
$_=<IN>;
s/^#//;
print OUT;
while(<IN>){
    chomp;
    my @tabs = split /\t/;
    unless ($tabs[0]=~/g__(\S+)$/){
        next;
    }
#    while( ($tabs[0] =~ /__$/) or ($tabs[0] =~ /Other$/) or ($tabs[0]=~/unidentified$/) ){
#        $tabs[0] =~ s/;\S+?$//;
#    }
    $" = "\t";
    print OUT "@tabs\n";
}
close IN;
close OUT;

open R, ">$otuname.stars.R";
print R<<RTXT;

library(grid)
X=read.table("$otuname.for_star_plot.txt",sep="\\t",row.name=1,header=T)
group=read.table("$group",sep="\\t",row.name=1,header=F)
a=apply(X,1,mean)
b=order(a,decreasing = T)[1:10]
X1=X[b,]
name1=rownames(X[b,])
m=strsplit(name1,";")
name2=c()
for(i in 1:length(m)){
	x1=m[[i]][length(m[[i]])]
    name2=c(name2,x1)
}
name2
X2=X1[,rownames(group)]
colnames(X2)=rownames(group)
rownames(X2)=name2
palette(rainbow(12, s = 0.6, v = 0.75))
sample_num=nrow(group)
pdf("$otuname.stars.pdf",18,26)
par(mar=c(2.1,0,4.1,10.1))
stars(t(X2), labels=colnames(X2),len = 1,ncol=6,key.loc = c(8, -1),main = "$main", draw.segments = TRUE,frame.plot=TRUE)
palette("default")
dev.off()
RTXT

system("R CMD BATCH $otuname.stars.R $otuname.stars.Rout");
system("convert $otuname.stars.pdf $otuname.stars.png");

