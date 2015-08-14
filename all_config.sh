#pipeline settings
script_path=$pipeline_path/src
config_path=$pipeline_path/config

## some settings
multiple_rarefactions_argv=" -m 10 -s 4000 "
pick_rep_method=most_abundant
ass_tax_method=rdp
[ $ITS_or_16S = '16S' ] && align_seq_method=pynast || align_seq_method=muscle

#ref
# 16S 
gg_ref=/data_center_01/soft/greengenes/gg_12_10_otus/rep_set/97_otus.fasta
gg_tax=/data_center_01/soft/greengenes/gg_12_10_otus/taxonomy/97_otu_taxonomy.txt
gg_imputed=/data_center_01/soft/greengenes/core_set_aligned.fasta.imputed
gg_lanemask=/data_center_01/soft/greengenes/lanemask_in_1s_and_0s

#software

#set python environment
PYTHONPATH=''
PATH=/data_center_01/home/liangzb/.pyenv/versions/2.7.10/bin:$PATH

usearch=/home/snowflake/local/bin/usearch7.0.1090_i86linux32
java=/home/snowflake/softwares/jdk1.8.0_25/bin/java
RDPtools=/home/snowflake/softwares/RDP-classifier/RDPTools/classifier/dist/classifier.jar
transform_rdp_result2qiimeform_script=$script_path/transform_rdp_result2qiimeform.pl
## LEfSe config
PATH=/data_center_01/home/NEOLINE/liangzebin/soft/LEfSe/nsegata-lefse-094f447691f0:$PATH

#script
alpha_rare_curve_script=$script_path/alpha_rare_curve.pl
get_single_read_script=$script_path/single_read.pl
fasta_number_script=$script_path/fasta_number.py
uc2otutab_script=$script_path/uc2otutab.pl
otus2fa_script=$script_path/otus2fa.pl
sumOTUPerSample_script=$script_path/sumOTUPerSample.pl
sample_downsize_script=$script_path/sample_downsize.pl
filt_rep_set_tax_ass_script=$script_path/filt_rep_set_tax_ass.pl
filter_by_group_script=$script_path/filter_by_group.pl
filter_sum_txt_by_group_script=$script_path/filter_sum_txt_by_group.pl

# otu table script
script_03_core_otu=$script_path/03_core_otu.pl
script_03_get_otu_uniform=$script_path/03_get_otu_uniform.pl
script_03_otu_pca=$script_path/03_otu_pca.pl
script_03_otu_statistics=$script_path/03_otu_statistics.pl
script_03_tax_heatmap=$script_path/03_tax_heatmap.pl
script_03_tax_stars=$script_path/03_tax_stars.pl
script_03_venn=$script_path/03_venn.pl
script_03_otu_tax_sample_bar=$script_path/03_otu_tax_sample_bar.pl
script_03_otu_tax_group_bar=$script_path/03_otu_tax_group_bar.pl
script_03_otu_specaccum=$script_path/03_otu_specaccum.pl

# alpha/beta diff script
script_04_alpha_diff=$script_path/04_alpha_diff.pl
script_04_group2mapfile=$script_path/04_group2mapfile.pl
script_04_Draw_beta_heatmap=$script_path/04_Draw_beta_heatmap.pl
script_04_beta_boxplot=$script_path/04_beta_boxplot.pl
script_04_beta_pca=$script_path/04_beta_pca.pl
script_04_beta_pcoa=$script_path/04_beta_pcoa.pl

# tax diff script
script_05_otu_table_cat=$script_path/05_otu_table_cat.pl
script_05_otu_transL=$script_path/05_otu_transL.pl
script_05_otu_alllevel=$script_path/05_otu_alllevel.pl
script_05_tax_diff=$script_path/05_tax_diff.pl
script_05_tax_marker_boxplot=$script_path/05_tax_marker_boxplot.pl
script_05_marker_tax=$script_path/05_marker.tax.pl
script_05_pca_diff=$script_path/05_pca_diff.pl
script_05_diff_tax_heatmap=$script_path/05_diff_tax_heatmap.pl
script_05_otu_diff_statistics=$script_path/05_otu_diff_statistics.pl
