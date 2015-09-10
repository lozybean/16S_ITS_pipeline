## notice
# please copy this config to your current path 
# fill the dependency config of your project [ fill and check for the 6 configurations ]
# run ' nohup sh pipeline.qsub & ' in your work path with be running over steps using default settings
# if you want to run step-by-step, just run ' sh  xx_xxx.qsub ' 
# if you just want to run some steps, you have to confirm the settings

#Dependency Config [must be setted!]
job_name=
ITS_or_16S=16S
[ -z $work_dir ] && work_dir=$PWD
[ -z $fna_file ] && fna_file=$work_dir/$ITS_or_16S\_together.fna
[ -z $group_file ] && group_file=$work_dir/group.txt
[ -z $group_num ] && group_num=$((sort -u -k2 $group_file) | (wc -l))
if_remain_small_size=Y

# if you have some subgroup, set $if_have_subgroup=Y  and  list the subgroup_files and subgroup_names as arrays,  
if_have_subgroup=Y
subgroup_files=( $work_dir/prop1.txt $work_dir/prop2.txt $work_dir/prop3.txt $work_dir/prop4.txt $work_dir/prop5.txt $work_dir/prop6.txt $work_dir/prop7.txt )
subgroup_names=( prop1 prop2 prop3 prop4 prop5 prop6 prop7 )
subgroup_num=${#subgroup_names[@]}

if [ -z $ITS_or_16S ] && [ $ITS_or_16S != '16S' ] && [ $ITS_or_16S != 'ITS' ]  ;then
    echo 'you have to confirm the data type [ 16S or ITS ]'
    exit
fi

#{{{
echo "\
job_name=$job_name
work_dir=$work_dir
group_num=$group_num
ITS_or_16S=$ITS_or_16S
fna_file=$fna_file
group_file=$group_file
if_remain_small_size=$if_remain_small_size

# if you have some subgroup, set $if_have_subgroup=Y  and  list the subgroup_files and subgroup_names as arrays,
if_have_subgroup=$if_have_subgroup
subgroup_files=(${subgroup_files[@]})
subgroup_names=(${subgroup_names[@]})
subgroup_num=$subgroup_num

# importing pipeline default settings ... 
pipeline_path=/data_center_01/home/NEOLINE/liangzebin/pipeline/16S/pipeline_ver_1.0
source \$pipeline_path/all_config.sh
# if you want to change something, copy the configurations you want to change and change it after this line ">$work_dir/00_all_config.sh

echo "\
# +++++++++++++++                01_pick_otu                 +++++++++++++++++++++ #

source \$config_path/01_pick_otu_config.sh
# if you want to change something, copy the configurations you want to change and change it after this line 
source \$pipeline_path/01_pick_otu.sh
sh1=\$work_dir/01_pick_otu/work
pick_otu_summary=\$work_dir/01_pick_otu/sumOTUPerSample.txt " >$work_dir/01_pick_otu_config.sh 

echo "\
# +++++++++++++++            02_alpha_rare_curve             +++++++++++++++++++++ #
source \$config_path/02_alpha_rare_curve_config.sh                              
# if you want to change something, copy the configurations you want to change and change it after this line 
source \$pipeline_path/02_alpha_rare_curve.sh                                   
sh2=\$work_dir/02_alpha_rare_curve/work                                        ">$work_dir/02_alpha_rare_curve_config.sh 

echo "\
# ++++++++++++++++             03_otu_table                  +++++++++++++++++++++ #
source \$config_path/03_otu_table_config.sh                                 
# if you want to change something, copy the configurations you want to change and change it after this line 
source \$pipeline_path/03_otu_table.sh
sh3=\$work_dir/03_otu_table/work							">$work_dir/03_otu_table_config.sh

echo "\
# ++++++++++++++++        04_diversity_analysis              +++++++++++++++++++ #
source \$config_path/04_diversity_analysis_config.sh
# if you want to change something, copy the configurations you want to change and change it after this line 
source \$pipeline_path/04_diversity_analysis.sh
sh4_1=\$work_dir/04_diversity_analysis/work
sh4_2=\$work_dir/04_diversity_analysis/alpha_diff/work
sh4_3=\$work_dir/04_diversity_analysis/beta_diff/work			" >$work_dir/04_diversity_analysis_config.sh

echo "\
# +++++++++++++++         05_diff_taxa_analysis              +++++++++++++++++++ #
source \$config_path/05_diff_taxa_analysis_config.sh
# if you want to change something, copy the configurations you want to change and change it after this line 
source \$pipeline_path/05_diff_taxa_analysis.sh
sh5=\$work_dir/05_diff_taxa_analysis/work  " >$work_dir/05_diff_taxa_analysis_config.sh


echo "\
source $work_dir/00_all_config.sh
source $work_dir/01_pick_otu_config.sh
qsub1=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_01 -e \$sh1.e -o \$sh1.o -terse \$sh1.sh\`
while [ ! -s \$pick_otu_summary ];
do
        sleep 1m
        echo 'waiting for picking otu  ...'
done
source $work_dir/02_alpha_rare_curve_config.sh
qsub2=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_02 -e \$sh2.e -o \$sh2.o -terse \$sh2.sh\`
source $work_dir/03_otu_table_config.sh
qsub3=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_03 -e \$sh3.e -o \$sh3.o -terse \$sh3.sh\`
[ "$if_have_subgroup" = 'Y' ]  && sh \$pipeline_path/work_subgroups.sh 
source $work_dir/04_diversity_analysis_config.sh
qsub4_1=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_04 -e \$sh4_1.e -o \$sh4_1.o -terse -hold_jid \$qsub3 \$sh4_1.sh\`
qsub4_2=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_04 -e \$sh4_2.e -o \$sh4_2.o -terse -hold_jid \$qsub4_1 \$sh4_2.sh\`
qsub4_3=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_04 -e \$sh4_3.e -o \$sh4_3.o -terse -hold_jid \$qsub4_1 \$sh4_3.sh\`
source $work_dir/05_diff_taxa_analysis_config.sh
qsub5=\`qsub -cwd -l vf=10G -q all.q -N $job_name\_05 -e \$sh5.e -o \$sh5.o -terse -hold_jid \$qsub3 \$sh5.sh\`
log='there still have some jobs to do'
while [ -n \"\$log\" ];
do
    sleep 1m
    echo 'waiting for all jobs done ...'
    log=\$(qstat -j \$qsub2,\$qsub3,\$qsub4_1,\$qsub4_2,\$qsub4_3,\$qsub5);
done
source \$pipeline_path/upload.sh
">$work_dir/pipeline.qsub

#}}}
