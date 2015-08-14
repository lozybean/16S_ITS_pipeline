#!/usr/bin/env perl

die "usage :perl $0 <otu_table> <outdir>" unless @ARGV==2;

my ($otu,$outdir) = @ARGV;
open IN,$otu or die $!;
open OUT,">$outdir/specaccum.temp" or die $!;
while(<IN>){
    chomp;
    s/\s+$//;
    my @tabs = split /\t/;
    next if @tabs == 1;
    s/^#//;
    print OUT "$_\n";
}
close IN;
close OUT;

open R,">$outdir/specaccum.R" or die $!;
print R<<RTXT;
library('vegan')
X=read.table('$outdir/specaccum.temp',head=T,row.names=1,sep="\\t")
X=t(X)

pdf("$outdir/specaccum.pdf",20,12)

#sp1 <- specaccum(X)
sp2 <- specaccum(X, "random")
#plot(sp1, ci.type="poly", col="blue", lwd=2, ci.lty=0, ci.col="lightblue")
#boxplot(sp2, col="yellow", add=TRUE, pch="+")

## Fit Lomolino model to the exact accumulation
#mod1 <- fitspecaccum(sp1, "lomolino")
#coef(mod1)
#fitted(mod1)
#plot(sp1)
## Add Lomolino model using argument 'add'
#plot(mod1, add = TRUE, col=2, lwd=2)

## Fit Arrhenius models to all random accumulations
mods <- fitspecaccum(sp2, "arrh")
plot(mods, col="lightblue",xlab='Number of samples sequenced',ylab='OTUs detected')
boxplot(sp2, col = "yellow", border = "blue", lty=1, cex=0.3, add= TRUE)
RTXT

`Rscript $outdir/specaccum.R`;
`convert $outdir/specaccum.pdf $outdir/specaccum.png`;
