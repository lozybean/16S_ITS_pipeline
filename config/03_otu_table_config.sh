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

pick_otu_dir=$work_dir/01_pick_otu
otu_all=$pick_otu_dir/otus_all.txt
seqs_all=$pick_otu_dir/seqs_all.fa
pick_otu_summary=$pick_otu_dir/sumOTUPerSample.txt

rep_set_tax_ass_file=$work_dir/03_otu_table/$ass_tax_method\_assigned_taxonomy/rep_set_tax_assignments_filt.txt

if [ -f $pick_otu_summary ];then
	minimum=$( (awk '{print $7}' $pick_otu_summary) | (sort -n) | (head -n 2) | (tail -n 1) )
else
	echo "please set \$pick_otu_summary and \$minimum !"
fi
