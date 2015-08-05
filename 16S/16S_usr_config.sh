## notice
# please copy this config to your current path and change it, but do not change the filename!


#Dependency Config [must be setted!]
job_name=
work_dir=
group_num=
fna_file=$work_dir/16S_together.fna
group_file=$work_dir/group.txt

# importing pipeline default settings ...
pipeline_path=/data_center_01/home/NEOLINE/liangzebin/pipeline/16S/pipeline_ver_1.0/16S
source $pipeline_path/16S_all_config.sh

## file changes is needed [default is the comment lines,if you want to change something, uncomment it and change it]
# 01_pick_otu

# 02_alpha_rare_curve
#pick_otu_dir=$work_dir/01_pick_otu  [ not in used ]
#otu_all=$pick_otu_dir/otus_all.txt
#seqs_all=$pick_otu_dir/seqs_all.fa
#alpha_metrics="chao1,observed_species,PD_whole_tree,shannon,simpson,goods_coverage"
#multiple_rarefactions_argv=" -m 10 -x 127999 -s 4000 "
#maximum will be setted by the biggest num of tags in $pick_otu_dir/sumOTUPerSample.txt as default
#gg_ref=/data_center_01/soft/greengenes/gg_12_10_otus/rep_set/97_otus.fasta
#gg_tax=/data_center_01/soft/greengenes/gg_12_10_otus/taxonomy/97_otu_taxonomy.txt
#gg_imputed=/data_center_01/soft/greengenes/core_set_aligned.fasta.imputed
#gg_lanemask=/data_center_01/soft/greengenes/lanemask_in_1s_and_0s


# 
