#source $config_path/04_diversity_analysis_config.sh
beta_sub_dir=$work_dir/04_diversity_analysis/beta_diff
mkdir -p $beta_sub_dir

wf_bdiv_outdir=$beta_sub_dir/wf_bdiv_even_$minimum
map_file=$work_dir/mapfile.txt
heatmap_outdir=$beta_sub_dir/wf_bdiv_even_$minimum\_heatmap
cluster_tree_out_dir=$beta_sub_dir/cluster_tree

echo \
"$script_04_group2mapfile $group_file $map_file
cp $work_dir/04_diversity_analysis/rep_phylo.tre $beta_sub_dir/rep_phylo.tre
beta_diversity.py -i $otu_biom -o $wf_bdiv_outdir -t $beta_sub_dir/rep_phylo.tre
$script_04_Draw_beta_heatmap -m $map_file -w $wf_bdiv_outdir/weighted_unifrac_otu_table.txt -u $wf_bdiv_outdir/unweighted_unifrac_otu_table.txt -g D -d $heatmap_outdir
$script_04_beta_boxplot $wf_bdiv_outdir/weighted_unifrac_otu_table.txt $group_file
$script_04_beta_boxplot $wf_bdiv_outdir/unweighted_unifrac_otu_table.txt $group_file
$script_04_beta_pcoa $wf_bdiv_outdir/weighted_unifrac_otu_table.txt $group_file
$script_04_beta_pcoa $wf_bdiv_outdir/unweighted_unifrac_otu_table.txt $group_file
mkdir -p $cluster_tree_out_dir
jackknifed_beta_diversity.py -i $otu_biom -m $map_file -e $minimum -t $beta_sub_dir/rep_phylo.tre -o $cluster_tree_out_dir -f
make_bootstrapped_tree.py -m $cluster_tree_out_dir/unweighted_unifrac/upgma_cmp/master_tree.tre -s $cluster_tree_out_dir/unweighted_unifrac/upgma_cmp/jackknife_support.txt -o $cluster_tree_out_dir/unweighted_unifrac_cluster.pdf
make_bootstrapped_tree.py -m $cluster_tree_out_dir/weighted_unifrac/upgma_cmp/master_tree.tre -s $cluster_tree_out_dir/weighted_unifrac/upgma_cmp/jackknife_support.txt -o $cluster_tree_out_dir/weighted_unifrac_cluster.pdf
convert $cluster_tree_out_dir/unweighted_unifrac_cluster.pdf $cluster_tree_out_dir/unweighted_unifrac_cluster.png
convert $cluster_tree_out_dir/weighted_unifrac_cluster.pdf $cluster_tree_out_dir/weighted_unifrac_cluster.png" >$beta_sub_dir/work.sh



[ -f $beta_sub_dir/work.e ] && rm $beta_sub_dir/work.e
[ -f $beta_sub_dir/work.o ] && rm $beta_sub_dir/work.o

if [ -z $job_name ];then
	echo -e "qsub -cwd -l vf=10G -q all.q -e $beta_sub_dir/work.e -o $beta_sub_dir/work.o $beta_sub_dir/work.sh" >$work_dir/04_diversity_analysis/04_beta_diversity_analysis.qsub
else
	echo -e "qsub -cwd -l vf=10G -q all.q -N $job_name\_04 -e $beta_sub_dir/work.e -o $beta_sub_dir/work.o $beta_sub_dir/work.sh" >$work_dir/04_diversity_analysis/04_beta_diversity_analysis.qsub
fi
