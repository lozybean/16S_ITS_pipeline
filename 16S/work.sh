## notice
# please copy this config to your current path and change it


#Dependency Config [must be setted!]
job_name=
work_dir=
group_num=
fna_file=$work_dir/16S_together.fna
group_file=$work_dir/group.txt

#{{{
# importing pipeline default settings ...
pipeline_path=/data_center_01/home/NEOLINE/liangzebin/pipeline/16S/pipeline_ver_1.0/16S
source $pipeline_path/16S_all_config.sh

## file changes is needed [default is the comment lines,if you want to change something, uncomment it and change it]
# 01_pick_otu

source $pipeline_path/01_pick_otu.sh
sh1=$work_dir/01_pick_otu/work
pick_otu_summary=$work_dir/01_pick_otu/sumOTUPerSample.txt

# 02_alpha_rare_curve
#pick_otu_dir=$work_dir/01_pick_otu  [ not in used ]
#otu_all=$pick_otu_dir/otus_all.txt
#seqs_all=$pick_otu_dir/seqs_all.fa
#alpha_metrics="chao1,observed_species,PD_whole_tree,shannon,simpson,goods_coverage"
#multiple_rarefactions_argv=" -m 10 -s 4000 "

#awk '{print $2}' $pick_otu_dir/sumOTUPerSample.txt | sort -n | tail -n 1 > /tmp/file
#while read out
#do
#    maximum=$out
#done < /tmp/file


#gg_ref=/data_center_01/soft/greengenes/gg_12_10_otus/rep_set/97_otus.fasta
#gg_tax=/data_center_01/soft/greengenes/gg_12_10_otus/taxonomy/97_otu_taxonomy.txt
#gg_imputed=/data_center_01/soft/greengenes/core_set_aligned.fasta.imputed
#gg_lanemask=/data_center_01/soft/greengenes/lanemask_in_1s_and_0s

#source $pipeline_path/02_alpha_rare_curve.sh
#sh2=$work_dir/02_alpha_rare_curve/work

# 03_otu_table 

#pick_otu_dir=$work_dir/01_pick_otu [ not in used ]
#otu_all=$pick_otu_dir/otus_all.txt
#seqs_all=$pick_otu_dir/seqs_all.fa

#awk '{print $7}' $pick_otu_dir/sumOTUPerSample.txt | sort -n | head -n 2 |tail -n 1 > /tmp/file
#while read out
#do
#    minimum=$out
#done < /tmp/file

#source $pipeline_path/03_otu_table.sh
#sh3=$work_dir/03_otu_table/work

# 04_diversity_analysis

#otu_table_dir=$work_dir/03_otu_table [ not in used ] 
#rep_set=$otu_table_dir/rep_set.fna
#otu_biom=$otu_table_dir/otu_table.biom
#alpha_metrics="chao1,observed_species,PD_whole_tree,shannon,simpson,goods_coverage"
#alphas=${alpha_metrics//,/ }
#multiple_rarefactions_argv=" -m 45 -s 1500 "

#awk '{print $7}' $pick_otu_dir/sumOTUPerSample.txt | sort -n | head -n 2 |tail -n 1 > /tmp/file
#while read out
#do
#   minimum=$out
#done < /tmp/file

#source $pipeline_path/04_diversity_analysis.sh
#sh4_1=$work_dir/04_diversity_analysis/work
#sh4_2=$work_dir/04_diversity_analysis/alpha_diff/work
#sh4_3=$work_dir/04_diversity_analysis/beta_diff/work

# 05_diff_taxa_analysis
#otu_table_dir=$work_dir/03_otu_table [ not in used ] 
#wf_taxa_outdir=$otu_table_dir/wf_taxa_summary
#otu_table_profile=$otu_table_dir/otu_table_profile.txt
#rep_set_tax_assignments=$otu_table_dir/rep_set_tax_assignments.txt

#source $pipeline_path/05_diff_taxa_analysis.sh
#sh5=$work_dir/05_diff_taxa_analysis/work

echo "\
qsub1=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_01 -e $sh1.e -o $sh1.o -terse $sh.sh\`
while [ ! -s $pick_otu_summary ];
do
        sleep 1m
        echo 'sleeping ...'
done
source $pipeline_path/after_01.sh
qsub2=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_02 -e $sh2.e -o $sh2.o -terse -hold_jid \$qsub1 $sh2.sh\`
qsub3=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_03 -e $sh3.e -o $sh3.o -terse -hold_jid \$qsub1 $sh3.sh\`
qsub4_1=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_04 -e $sh4_1.e -o $sh4_1.o -terse -hold_jid \$qsub3 $sh4_1.sh\`
qsub4_2=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_04 -e $sh4_2.e -o $sh4_2.o -terse -hold_jid \$qsub4_1 $sh4_2.sh\`
qsub4_3=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_04 -e $sh4_3.e -o $sh4_3.o -terse -hold_jid \$qsub4_1 $sh4_3.sh\`
qsub5=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_05 -e $sh5.e -o $sh5.o -terse -hold_jid \$qsub3 $sh5.sh\`">$work_dir/pipeline.qsub
#}}}
