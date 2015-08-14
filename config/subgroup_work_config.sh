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
$pick_otu_dir/sumOTUPerSample.txt
