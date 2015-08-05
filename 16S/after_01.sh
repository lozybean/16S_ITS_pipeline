source $pipeline_path/02_alpha_rare_curve.sh
sh2=$work_dir/02_alpha_rare_curve/work

source $pipeline_path/03_otu_table.sh
sh3=$work_dir/03_otu_table/work

source $pipeline_path/04_diversity_analysis.sh
sh4_1=$work_dir/04_diversity_analysis/work
sh4_2=$work_dir/04_diversity_analysis/alpha_diff/work
sh4_3=$work_dir/04_diversity_analysis/beta_diff/work

source $pipeline_path/05_diff_taxa_analysis.sh
sh5=$work_dir/05_diff_taxa_analysis/work


