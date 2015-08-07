#!/usr/bin/env perl
use File::Basename;
die "perl $0 <otu_all.xls><group.txt>" unless(@ARGV==2);
my ($otu0,$group)=@ARGV;
my @otu=split/\./,$otu0;
my $otuname=shift @otu;
my $otubase=basename($otuname);

open R, ">$otuname.pcoa.R";
print R<<RTXT;
library(WGCNA)
library("ade4")
library(RColorBrewer)
X=read.table("$otu0",header=TRUE,row.names=1,sep="\\t")
group=read.table("$group",header=F,row.names=1)
group=group[colnames(X),1]
group=as.data.frame(group)
rownames(group)=colnames(X)
colors=labels2colors(group)
colors = as.character(colors)
g=unique(group)
g_order=g[order(g),1]
g_order=as.character(g_order)
gcols=unique(colors)
gcols_order=gcols[order(g)]
A=factor(group[,1])

d=dist(t(X))
X.dudi = dudi.pco(d,nf=2,scannf=F)
con = X.dudi\$eig/sum(X.dudi\$eig)*100
con = round(con,2)

pdf(file="$otuname.pcoaplot.pdf",11,8.5)
par(mar=c(4.1,5.1,3.1,2.1))

plot(X.dudi\$li,col=colors,pch=15,cex=1.2,xlab=paste("PCOA1(",con[1],"%)",sep=""),ylab=paste("PCOA2(",con[2],"%)",sep=""),cex.axis=1.5,cex.lab=1.7)
#plot(X.dudi\$li,xlim=c(0,0.2),ylim=c(-0.2,0.1),col=colors,pch=15,cex=1.2,xlab=paste("PCOA1(",con[1],"%)",sep=""),ylab=paste("PCOA2(",con[2],"%)",sep=""),cex.axis=1.5,cex.lab=1.7)
legend("topleft",g_order,col=gcols_order,pch=15,cex=1,bty="n",,horiz=T)

RTXT
system("/data_center_01/home/NEOLINE/wuleyun/wuly/R-3.1.2/bin/R CMD BATCH $otuname.pcoa.R $otuname.pcoa.Rout");
system("/usr/bin/convert $otuname.pcoaplot.pdf $otuname.pcoaplot.png");

