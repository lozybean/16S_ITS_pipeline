#source $config_path/03_otu_table_config.sh
sub_dir=$work_dir/03_otu_table
mkdir -p $sub_dir
[ -z $super_work_dir ] && super_work_dir=$work_dir/..

suffix=downsize_$minimum
otu_downsize=$sub_dir/otus_$suffix.txt
seq_downsize=$sub_dir/seqs_$suffix.fa
ass_tax_outdir=$sub_dir/$ass_tax_method\_assigned_taxonomy
otu_biom=$sub_dir/otu_table.biom
otu_txt=$sub_dir/otu_table.txt
otu_uniform=$sub_dir/otu_table_profile.txt
wf_taxa_outdir=$sub_dir/wf_taxa_summary
sample_bar_outdir=$wf_taxa_outdir/bar_plot
group_bar_outdir=$wf_taxa_outdir/bar_plot_group
rank_abundance_outdir=$sub_dir/Rank_Abundance
specaccum_outdir=$sub_dir/specaccum

mkdir -p $sample_bar_outdir
mkdir -p $group_bar_outdir

echo "\
cp $super_work_dir/03_otu_table/otus_downsize_$minimum.txt $sub_dir/
cp $super_work_dir/03_otu_table/otu_table.biom $sub_dir/
cp $super_work_dir/03_otu_table/otu_table.txt $sub_dir/
cp $super_work_dir/03_otu_table/seqs_downsize_$minimum.fa $sub_dir/
cp $super_work_dir/03_otu_table/rep_set.fna $sub_dir/
cp -Rf $super_work_dir/03_otu_table/$ass_tax_method\_assigned_taxonomy $sub_dir/
cp -Rf $super_work_dir/03_otu_table/wf_taxa_summary $sub_dir/
$script_03_core_otu $otu_txt $rep_set_tax_ass_file 1
$script_03_get_otu_uniform $otu_txt
$script_03_otu_pca $otu_uniform $group_file
$script_03_otu_statistics $rep_set_tax_ass_file $otu_downsize
$script_03_tax_heatmap $wf_taxa_outdir/otu_table_L6.txt $group_file
$script_03_venn -otu $otu_txt -group $group_file -gnum $group_num
$script_03_tax_stars $wf_taxa_outdir/otu_table_L6.txt $group_file
cp $wf_taxa_outdir/*.txt $sample_bar_outdir
cp $wf_taxa_outdir/*.txt $group_bar_outdir
for i in 2 3 4 5 6
do
	$script_03_otu_tax_sample_bar -input $wf_taxa_outdir/otu_table_L\$i.txt -sample $group_file -prefix $sample_bar_outdir/otu_table_L\$i -level \$i
	$script_03_otu_tax_group_bar -input $wf_taxa_outdir/otu_table_L\$i.txt -group $group_file -prefix $group_bar_outdir/otu_table_group_L\$i -level \$i
done 
### rank_abundance
mkdir -p $rank_abundance_outdir
plot_rank_abundance_graph.py -i $otu_biom -s '*' -o $rank_abundance_outdir/all_plot.pdf --no_legend
convert $rank_abundance_outdir/all_plot.pdf $rank_abundance_outdir/all_plot.png    
### specaccum
mkdir -p $specaccum_outdir
$script_03_otu_specaccum $otu_txt $specaccum_outdir  " >$sub_dir/work.sh

[ -f $sub_dir/work.e ] && rm $sub_dir/work.e
[ -f $sub_dir/work.o ] && rm $sub_dir/work.o

if [ -z $job_name ];then
	echo "qsub -cwd -l vf=10G -q all.q -e $sub_dir/work.e -o $sub_dir/work.o $sub_dir/work.sh" >$work_dir/03_otu_table.qsub
else
	echo "qsub -cwd -l vf=10G -q all.q -N $job_name\_03 -e $sub_dir/work.e -o $sub_dir/work.o $sub_dir/work.sh" >$work_dir/03_otu_table.qsub
fi
