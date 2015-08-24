## notice
# please copy this config to your current path 
# fill the work_dir
# run work.sh first
# run ' nohup sh pipeline.qsub & ' in your work path with be running over steps using default settings
# if you want to run step-by-step, just run ' sh  xx_xxx.qsub ' 
# if you just want to run some steps, you have to confirm the settings

#Dependency Config [must be setted!]
work_dir=$PWD
source $work_dir/00_all_config.sh
[ -z $subgroup_files ] && subgroup_files=
[ -z $subgroup_names ] && subgroup_names=
[ -z $subgroup_num ] && subgroup_num=${#subgroup_names[@]}

if [ ! -f $work_dir/01_pick_otu/sumOTUPerSample.txt ];then
	echo 'you must run work.sh and finish the first step first!'
	exit
fi

for i in $(seq $subgroup_num)
do

subgroup_file=${subgroup_files[$i-1]}
subgroup_name=${subgroup_names[$i-1]}
subwork_dir=$work_dir/$subgroup_name
mkdir -p $subwork_dir
cd $subwork_dir
cp $subgroup_file $subwork_dir/
pick_otu_summary=$work_dir/01_pick_otu/sumOTUPerSample.txt

supersample_num=$( (wc -l $group_file)|awk '{print $1}' )
subsample_num=$( (wc -l $subgroup_file)|awk '{print $1}' )

echo "$filter_sum_txt_by_group_script $subgroup_file $pick_otu_summary $subwork_dir/sumOTUPerSample.txt  ">$subwork_dir/filt.sh


group_file=$subgroup_file
group_num=$((sort -u -k2 $group_file) | (wc -l))

echo "\
job_name=$job_name\_$subgroup_name
work_dir=$subwork_dir
group_num=$group_num
ITS_or_16S=$ITS_or_16S
fna_file=$fna_file
group_file=$group_file
if_remain_small_size=$if_remain_small_size
super_work_dir=$work_dir
subgroup_name=$subgroup_name

# importing pipeline default settings ...
pipeline_path=/data_center_01/home/NEOLINE/liangzebin/pipeline/16S/pipeline_ver_1.0
source \$pipeline_path/all_config.sh
# if you want to change something, copy the configurations you want to change and change it after this line ">$subwork_dir/00_all_config.sh
	
echo "\
source \$config_path/03_otu_table_config.sh
pick_otu_dir=\$super_work_dir/01_pick_otu
otu_all=\$pick_otu_dir/otus_all.txt
seqs_all=\$pick_otu_dir/seqs_all.fa
pick_otu_summary=\$work_dir/sumOTUPerSample.txt
rep_set_tax_ass_file=\$work_dir/03_otu_table/\$ass_tax_method\_assigned_taxonomy/rep_set_tax_assignments_filt.txt
minimum=\$( (awk '{print \$7}' \$pick_otu_summary) | (sort -n) | (head -n 2) | (tail -n 1) )
# if you want to change something, copy the configurations you want to change and change it after this line
source \$pipeline_path/03_otu_table.sh
sh3=\$work_dir/03_otu_table/work                            ">$subwork_dir/03_otu_table_config.sh

echo "\
source \$config_path/04_diversity_analysis_config.sh
pick_otu_dir=\$super_work_dir
pick_otu_summary=\$work_dir/sumOTUPerSample.txt
minimum=\$( (awk '{print \$7}' \$pick_otu_summary) | (sort -n) | (head -n 2) | (tail -n 1) )
# if you want to change something, copy the configurations you want to change and change it after this line
source \$pipeline_path/04_diversity_analysis.sh
sh4_1=\$work_dir/04_diversity_analysis/work
sh4_2=\$work_dir/04_diversity_analysis/alpha_diff/work
sh4_3=\$work_dir/04_diversity_analysis/beta_diff/work           " >$subwork_dir/04_diversity_analysis_config.sh

echo "\
source \$config_path/05_diff_taxa_analysis_config.sh
# if you want to change something, copy the configurations you want to change and change it after this line
source \$pipeline_path/05_diff_taxa_analysis.sh
sh5=\$work_dir/05_diff_taxa_analysis/work  " >$subwork_dir/05_diff_taxa_analysis_config.sh

if [ $supersample_num = $subsample_num ];then

echo "\
source $subwork_dir/00_all_config.sh
[ -f $subwork_dir/filt.o ] && rm $subwork_dir/filt.o $subwork_dir/filt.e
cp $pick_otu_summary $subwork_dir/sumOTUPerSample.txt
source $subwork_dir/03_otu_table_config.sh
ln -s $work_dir/03_otu_table $subwork_dir/03_otu_table
source $subwork_dir/04_diversity_analysis_config.sh
cp $work_dir/04_diversity_analysis_config/rep_phylo.tre $subwork_dir/
qsub4_2=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_04 -e \$sh4_2.e -o \$sh4_2.o -terse \$sh4_2.sh\`
qsub4_3=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_04 -e \$sh4_3.e -o \$sh4_3.o -terse \$sh4_3.sh\`
source $subwork_dir/05_diff_taxa_analysis_config.sh
qsub5=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_05 -e \$sh5.e -o \$sh5.o -terse \$sh5.sh\`
log='there still have some jobs to do'
while [ -n \"\$log\" ];
do
    sleep 1m
    echo 'waiting for all jobs done ...'
    log=\$(qstat -j \$qsub4_2,\$qsub4_3,\$qsub5);
done
source  \$pipeline_path/subgroup_upload.sh	">$subwork_dir/pipeline.qsub

else

echo "\
source $subwork_dir/00_all_config.sh
[ -f $subwork_dir/filt.o ] && rm $subwork_dir/filt.o $subwork_dir/filt.e
qsub0=\`qsub -cwd -l vf=1G -q all.q -N \$job_name\_00 -e $subwork_dir/filt.e -o $subwork_dir/filt.o -terse $subwork_dir/filt.sh\`
while [ ! -f $subwork_dir/sumOTUPerSample.txt ];
do
    sleep 1m;
done
source $subwork_dir/03_otu_table_config.sh
qsub3=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_03 -e \$sh3.e -o \$sh3.o -terse -hold_jid \$qsub0 \$sh3.sh\`
source $subwork_dir/04_diversity_analysis_config.sh
qsub4_1=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_04 -e \$sh4_1.e -o \$sh4_1.o -terse -hold_jid \$qsub3 \$sh4_1.sh\`
qsub4_2=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_04 -e \$sh4_2.e -o \$sh4_2.o -terse -hold_jid \$qsub4_1 \$sh4_2.sh\`
qsub4_3=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_04 -e \$sh4_3.e -o \$sh4_3.o -terse -hold_jid \$qsub4_1 \$sh4_3.sh\`
source $subwork_dir/05_diff_taxa_analysis_config.sh
qsub5=\`qsub -cwd -l vf=10G -q all.q -N \$job_name\_05 -e \$sh5.e -o \$sh5.o -terse -hold_jid \$qsub3 \$sh5.sh\`
log='there still have some jobs to do'
while [ -n \"\$log\" ];
do
    sleep 1m
    echo 'waiting for all jobs done ...'
    log=\$(qstat -j \$qsub2,\$qsub3,\$qsub4_1,\$qsub4_2,\$qsub4_3,\$qsub5);
done
source  \$pipeline_path/subgroup_upload.sh  ">$subwork_dir/pipeline.qsub

fi

[ -f nohup.out ] && rm nohup.out
cd $subwork_dir
nohup sh $subwork_dir/pipeline.qsub &
cd $work_dir

done


