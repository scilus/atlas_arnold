##############################################
# Example call to this script:
#  ./arnold_final.sh arnold_clinical_cases
#  ./arnold_final.sh human_connectome_project/test_retest
#  ./arnold_final.sh human_connectome_project/hcp_3t
#  ./arnold_final.sh human_connectome_project/hcp_7t
##############################################

#### TODO, it would be nice to "parallelize" this with parallel 

# key = {human_connectome_project/test_retest, human_connectome_project/hcp_3t, human_connectome_project/hcp_7t, arnold_clinical_cases}
key=$1

# Directory
dir=/data/datasets/${key}/derivatives/register_flow/output/results_registration/
#dir=/data/datasets/human_connectome_project/test_retest/derivatives/register_flow_on_legacy_tractoflow_qc/output/results_registration/

# requirement: /data/Atlases/filtrage_arnold/MNI_binary_ROIs directory
for i in ${dir}/*;
do
    t="${i}/Trks_into_template_space/*ensemble*trk"
    a="${i/*registration\/\//}"
    echo $a
    
    # arnold proper
    rm -rf o_${key}/${a}
    mkdir -p o_${key}/${a}
    
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_L_Arnold_proper_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Arnold_trunk_mni_mean_bin.nii.gz any include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_LGN_cut_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_FG_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f
    # arnold AR like
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_L_Arnold_AR_like_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_STG_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_LGN_cut_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f
    # arnold OR like
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_L_Arnold_OR_like_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_FG_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Arnold_trunk_mni_mean_bin.nii.gz any include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_03_mni_mean_bin_corrected_to_exclude_thalamus.nii any include -f
    
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_L_Arnold_lateral_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_STG_mni_mean_bin.nii.gz either_end exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_LGN_cut_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Clean_Cingulum_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_Selection_Cube_03_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/SelectionCube04.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/SelectionCuber05.nii any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_hippo_temporal_mask.nii any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/Mid_sagittal_mask.nii any exclude -f
		

    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_L_Arnold_proper_mni.trk o_${key}/${a}/${a}_L_Arnold_proper_mni2.trk --max_prune 90 -f #80
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_L_Arnold_OR_like_mni.trk o_${key}/${a}/${a}_L_Arnold_OR_like_mni2.trk --max_prune 130 -f #112
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_L_Arnold_AR_like_mni.trk o_${key}/${a}/${a}_L_Arnold_AR_like_mni2.trk --max_prune 63 -f
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_L_Arnold_lateral_mni.trk o_${key}/${a}/${a}_L_Arnold_lateral_mni2.trk --max_prune 55 -f    

    # OR
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_L_OR_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_calc_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_LGN_mni_mean_bin.nii.gz either_end include -f
    # ILS
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_L_ILS_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_FL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_OL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/L_ILS_trunk_mni_mean_bin.nii.gz any include -f
    
    # arnold proper
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_R_Arnold_proper_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Arnold_trunk_mni_mean_bin.nii.gz any include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_LGN_cut_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_FG_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f
    # arnold AR like
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_R_Arnold_AR_like_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_STG_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_LGN_cut_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f
    # arnold OR like
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_R_Arnold_OR_like_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_FG_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Arnold_trunk_mni_mean_bin.nii.gz any include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_FG_mni_mean_bin.nii.gz any include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_03_mni_mean_bin_corrected_to_exclude_thalamus.nii any include -f

    # arnold lateral
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_R_Arnold_lateral_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_pulvinar_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_TL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_STG_mni_mean_bin.nii.gz either_end exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_LGN_cut_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Clean_Cingulum_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_Selection_Cube_03_mni_mean_bin.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/SelectionCube04.nii.gz any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/SelectionCuber05.nii any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_hippo_temporal_mask.nii any exclude \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/Mid_sagittal_mask.nii any exclude -f
		
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_R_Arnold_proper_mni.trk o_${key}/${a}/${a}_R_Arnold_proper_mni2.trk --max_prune 90 -f
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_R_Arnold_OR_like_mni.trk o_${key}/${a}/${a}_R_Arnold_OR_like_mni2.trk --max_prune 130 -f
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_R_Arnold_AR_like_mni.trk o_${key}/${a}/${a}_R_Arnold_AR_like_mni2.trk --max_prune 63 -f
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img prune_streamlines o_${key}/${a}/${a}_R_Arnold_lateral_mni.trk o_${key}/${a}/${a}_R_Arnold_lateral_mni2.trk --max_prune 55 -f

    # OR
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_R_OR_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_calc_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_LGN_mni_mean_bin.nii.gz either_end include -f
    # ILS
    singularity exec -B /data-2/,/data/ /data/Containers/.imeka_flows/dmri_human_20220314_master_205a85.img filter_tractogram $t o_${key}/${a}/${a}_R_ILS_mni.trk \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_FL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_OL_mni_mean_bin.nii.gz either_end include \
		--drawn_roi /data/Atlases/filtrage_arnold/MNI_binary_ROIs/R_ILS_trunk_mni_mean_bin.nii.gz any include -f

    mv o_${key}/${a}/${a}_R_Arnold_proper_mni2.trk o_${key}/${a}/${a}_R_Arnold_proper_mni.trk
    mv o_${key}/${a}/${a}_R_Arnold_lateral_mni2.trk o_${key}/${a}/${a}_R_Arnold_lateral_mni.trk
    mv o_${key}/${a}/${a}_R_Arnold_OR_like_mni2.trk o_${key}/${a}/${a}_R_Arnold_OR_like_mni.trk
    mv o_${key}/${a}/${a}_R_Arnold_AR_like_mni2.trk o_${key}/${a}/${a}_R_Arnold_AR_like_mni.trk
    mv o_${key}/${a}/${a}_L_Arnold_proper_mni2.trk o_${key}/${a}/${a}_L_Arnold_proper_mni.trk
    mv o_${key}/${a}/${a}_L_Arnold_lateral_mni2.trk o_${key}/${a}/${a}_L_Arnold_lateral_mni.trk
    mv o_${key}/${a}/${a}_L_Arnold_OR_like_mni2.trk o_${key}/${a}/${a}_L_Arnold_OR_like_mni.trk
    mv o_${key}/${a}/${a}_L_Arnold_AR_like_mni2.trk o_${key}/${a}/${a}_L_Arnold_AR_like_mni.trk 
done





