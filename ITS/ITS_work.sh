usr_config=ITS_usr_config.sh
source $usr_config


#01_pick otu
source $pipeline_path/01_pick_otu.sh

#02_alpha_rare_curve
source $pipeline_path/02_alpha_rare_curve.sh

#03_otu_table (downsize)
source $pipeline_path/03_otu_table.sh

#04_diversity_analysis
source $pipeline_path/04_diversity_analysis.sh

#05_tax_diff_analysis
source $pipeline_path/05_diff_taxa_analysis.sh

