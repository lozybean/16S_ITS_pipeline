upload_dir=$work_dir/Upload
mkdir -p $upload_dir

dir_01=$upload_dir/01_Reads
mkdir -p $dir_01
cp $work_dir/01_pick_otu/seqs_all.fa $dir_01/seqs_all.fna
cp $work_dir/01_pick_otu/sumOTUPerSample.txt $dir_01/sumOTUPerSample.xls
cp $work_dir/03_otu_table/seqs_downsize_60786.fa $dir_01/seqs_downsize_60786.fa


dir_02=$upload_dir/02_OTU
otu_table_dir=$work_dir/03_otu_table
mkdir -p $dir_02
cp $otu_table_dir/$ass_tax_method\_assigned_taxonomy/sample_otu_statatistics.txt $dir_02/sample_otu_statatistics.xls
cp $otu_table_dir/otu_table.txt $dir_02/otu_table.xls
cp $otu_table_dir/$ass_tax_method\_assigned_taxonomy/rep_set_tax_assignments.txt $dir_02/rep_set_tax_assignments.xls
cp $otu_table_dir/otu_table.venn.tiff $dir_02/
cp $otu_table_dir/otu_table.core.p* $dir_02/
cp $otu_table_dir/otu_table.core.txt $dir_02/otu_table.core.xls

wf_indir=$otu_table_dir/wf_taxa_summary
wf_outdir=$dir_02/wf_taxa_summary
mkdir -p $wf_outdir
cp $wf_indir/otu_table_L6.heatmap.pdf $wf_outdir/
cp $wf_indir/otu_table_L6.heatmap.png $wf_outdir/
cp $wf_indir/otu_table_L6.stars.pdf $wf_outdir/
cp $wf_indir/otu_table_L6.stars.png $wf_outdir/
for i in {2..6}
do
    cp $wf_indir/otu_table_L$i.txt $wf_outdir/otu_table_L$i.xls
    cp $wf_indir/bar_plot/otu_table_L$i.png $wf_outdir/
    cp $wf_indir/bar_plot/otu_table_L$i.pdf $wf_outdir/
    cp $wf_indir/bar_plot_group/otu_table_L$i.png $wf_outdir/
    cp $wf_indir/bar_plot_group/otu_table_L$i.pdf $wf_outdir/
done

summary_file=$work_dir/01_pick_otu/sumOTUPerSample.txt
minimum=$( (awk '{print $7}' $summary_file) | (sort -n) | (head -n 2) | (tail -n 1) )

alpha_rare_indir=$work_dir/02_alpha_rare_curve/multiple_rarefactions/alpha_div_collated
alpha_rare_outdir=$upload_dir/03_Alpha_diversity/alpha_rare
mkdir -p $alpha_rare_outdir
cp $alpha_rare_indir/*.pdf $alpha_rare_outdir/
cp $alpha_rare_indir/*.png $alpha_rare_outdir/

dir_03=$upload_dir/03_Alpha_diversity/alpha_diff
mkdir -p $dir_03
alpha_dir=$work_dir/04_diversity_analysis/alpha_diff/wf_arare_$minimum/alpha_div_collated
cp $alpha_dir/*.pdf $dir_03/
cp $alpha_dir/*.png $dir_03/
cp $alpha_dir/alpha_statistics.txt $dir_03/alpha_statistics.xls
cp $alpha_dir/alpha.markers.txt $dir_03/alpha.markers.xls

dir_04=$upload_dir/04_Beta_diversity/
mkdir -p $dir_04
beta_dir=$work_dir/04_diversity_analysis/beta_diff/wf_bdiv_even_$minimum
cp $beta_dir/unweighted_unifrac_otu_table.boxplot.pdf   $dir_04/unweighted_unifrac.boxplot.pdf
cp $beta_dir/unweighted_unifrac_otu_table.boxplot.png   $dir_04/unweighted_unifrac.boxplot.png
cp $beta_dir/weighted_unifrac_otu_table.boxplot.pdf     $dir_04/weighted_unifrac.boxplot.pdf
cp $beta_dir/weighted_unifrac_otu_table.boxplot.png     $dir_04/weighted_unifrac.boxplot.png
cp $beta_dir/unweighted_unifrac_otu_table.txt           $dir_04/unweighted_unifrac.xls
cp $beta_dir/weighted_unifrac_otu_table.txt             $dir_04/weighted_unifrac.xls
cp $beta_dir/unweighted_unifrac_otu_table.pcoaplot.pdf  $dir_04/unweighted_unifrac.pcoaplot.pdf
cp $beta_dir/unweighted_unifrac_otu_table.pcoaplot.png  $dir_04/unweighted_unifrac.pcoaplot.png
cp $beta_dir/weighted_unifrac_otu_table.pcoaplot.pdf    $dir_04/weighted_unifrac.pcoaplot.pdf
cp $beta_dir/weighted_unifrac_otu_table.pcoaplot.png    $dir_04/weighted_unifrac.pcoaplot.png

cp $beta_dir\_heatmap/Beta_diversity_heatmap.pdf            $dir_04/Beta_diversity_heatmap.pdf
cp $beta_dir\_heatmap/Beta_unweighted_diversity_heatmap.png $dir_04/unweighted_unifrac.heatmap.png
cp $beta_dir\_heatmap/Beta_weighted_diversity_heatmap.png   $dir_04/weighted_unifrac.heatmap.png

dir_05=$upload_dir/05_Diff_marker/
mkdir -p $dir_05
diff_dir=$work_dir/05_diff_taxa_analysis

otu_diff_indir=$diff_dir/otu_diff
otu_diff_outdir=$dir_05/otu_diff
mkdir -p $otu_diff_outdir
cp $otu_diff_indir/*.pdf $otu_diff_outdir/
cp $otu_diff_indir/*.png $otu_diff_outdir/
cp $otu_diff_indir/otu_table_otu.diff.marker.statistics.txt   $otu_diff_outdir/otu_table_otu.diff.marker.statistics.xls



