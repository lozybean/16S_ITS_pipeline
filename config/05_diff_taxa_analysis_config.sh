if [ -z $work_dir ];then
    echo 'you must set the work_dir'
    exit
fi
if [ -z $fna_file ];then
    echo 'you must set the fna file'
    exit
fi
if [ -z $group_file ];then
    echo 'you must set the group file'
    exit
fi
if [ -z $group_num ];then
    echo 'you must set the group num'
    exit
fi

otu_table_dir=$work_dir/03_otu_table
wf_taxa_outdir=$otu_table_dir/wf_taxa_summary
otu_table_profile=$otu_table_dir/otu_table_profile.txt 
#rep_set_tax_assignments=$otu_table_dir/rep_set_tax_assignments.txt
rep_set_tax_assignments=$otu_table_dir/$ass_tax_method\_assigned_taxonomy/rep_set_tax_assignments_filt.txt
p_cutoff=0.05
if_paired=FALSE
