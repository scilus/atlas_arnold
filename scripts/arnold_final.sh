#################################################################################################################
# This script takes an input folder of tractograms in MNI space and perfoms the virtual dissection to extract
# the left and right Arnold tracks and write them to output folder provided:
#    1) L_Arnold_proper, R_Arnold_proper
#    2) L_Arnold_lateral, R_Arnold_lateral
#    3) L_Arnold_AR_like, R_Arnold_AR_like
#    4) L_Arnold_OR_like, R_Arnold_OR_like
#
#   AR := Accoustic Radiations, OR := Optic Radiations
#
#
# Key points about this script:
#   - the tractogram needs to be in trk or tck format in MNI space
#   - the tractogram quality will not be checked. Arnold tracks are "hard-to-track" anatomical pulvino-temporal
#     connections. See Mandonnet et al BRAIN 2024 for tractography details. In this work, an aggressive seeding
#     TractoFlow pipeline was used in conjunction with a Bundle-Specitifc Tractography (BST) approach. 
#   - this script does not perform any registration or warping (see scilpy for documentation on this)
#              
#
#
# The script is called as so:
#
# ./arnold_final.sh  input_arnold/ MNI_binary_ROIs/   o_dir
#
#  root=/path/to/[root]                      Root folder containing multiple subjects trk in MNI space
#
#                                              [root]
#                                                ├── S1
#                                                │   └── *.trk
#                                                └── S2
#                                                    └── *
#
#  MNI_ROIs=/path/to/atlas_arnold/MNI_ROIs  Path to MNI_binary_ROIs provided in the atlas_arnold_project
#
#  o_dir=/path/to/[o_dir]                   Output directory
#################################################################################################################

#### TODO: "parallelize" this with parallel or nextoflow

dir=$1
MNI_ROIs=$2
o_dir=$3

echo "Input folder: $dir"
echo "MNI_ROIs found: $MNI_ROIs"
echo "Output folder: $o_dir"
    

for i in ${dir}/*;
do
    # tractogram to virtually dissect
    t="${i}/*.trk"
    
    # subject ID directory
    f=${t/${dir}\//}
    s_id=${f/\/*/}
    
    mkdir -p ${o_dir}/${s_id}

    echo "$t  ${o_dir}/${s_id}/${s_id}_L_Arnold_proper_mni.trk"
    # Arnold proper
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_L_Arnold_proper_mni.trk \
			      --drawn_roi ${MNI_ROIs}/L_pulvinar_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/L_TL_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/L_Arnold_trunk_mni_mean_bin.nii.gz any include \
			      --drawn_roi ${MNI_ROIs}/L_LGN_cut_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_FG_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_R_Arnold_proper_mni.trk \
			      --drawn_roi ${MNI_ROIs}/R_pulvinar_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/R_TL_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/R_Arnold_trunk_mni_mean_bin.nii.gz any include \
			      --drawn_roi ${MNI_ROIs}/R_LGN_cut_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_FG_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f

    # Arnold lateral
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_L_Arnold_lateral_mni.trk \
			      --drawn_roi ${MNI_ROIs}/L_pulvinar_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/L_TL_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/L_STG_mni_mean_bin.nii.gz either_end exclude \
			      --drawn_roi ${MNI_ROIs}/L_LGN_cut_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Clean_Cingulum_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_03_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/SelectionCube04.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/SelectionCuber05.nii any exclude \
			      --drawn_roi ${MNI_ROIs}/L_hippo_temporal_mask.nii any exclude \
			      --drawn_roi ${MNI_ROIs}/Mid_sagittal_mask.nii any exclude -f
		
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_R_Arnold_lateral_mni.trk \
			      --drawn_roi ${MNI_ROIs}/R_pulvinar_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/R_TL_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/R_STG_mni_mean_bin.nii.gz either_end exclude \
			      --drawn_roi ${MNI_ROIs}/R_LGN_cut_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Clean_Cingulum_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_03_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/SelectionCube04.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/SelectionCuber05.nii any exclude \
			      --drawn_roi ${MNI_ROIs}/R_hippo_temporal_mask.nii any exclude \
			      --drawn_roi ${MNI_ROIs}/Mid_sagittal_mask.nii any exclude -f

    # Arnold AR like
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_L_Arnold_AR_like_mni.trk \
			      --drawn_roi ${MNI_ROIs}/L_pulvinar_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/L_STG_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/L_TL_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/L_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_LGN_cut_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/L_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f
    
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_R_Arnold_AR_like_mni.trk \
			      --drawn_roi ${MNI_ROIs}/R_pulvinar_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/R_STG_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/R_TL_mni_mean_bin.nii.gz either_end include \
			      --drawn_roi ${MNI_ROIs}/R_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_LGN_cut_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f

    # Arnold OR like
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_L_Arnold_OR_like_mni.trk \
		     --drawn_roi ${MNI_ROIs}/L_pulvinar_mni_mean_bin.nii.gz either_end include \
		     --drawn_roi ${MNI_ROIs}/L_TL_mni_mean_bin.nii.gz either_end include \
		     --drawn_roi ${MNI_ROIs}/L_FG_mni_mean_bin.nii.gz either_end include \
		     --drawn_roi ${MNI_ROIs}/L_Arnold_trunk_mni_mean_bin.nii.gz any include \
		     --drawn_roi ${MNI_ROIs}/L_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		     --drawn_roi ${MNI_ROIs}/L_Selection_Cube_03_mni_mean_bin_corrected_to_exclude_thalamus.nii any include -f
    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_R_Arnold_OR_like_mni.trk \
		      --drawn_roi ${MNI_ROIs}/R_pulvinar_mni_mean_bin.nii.gz either_end include \
		      --drawn_roi ${MNI_ROIs}/R_TL_mni_mean_bin.nii.gz either_end include \
		      --drawn_roi ${MNI_ROIs}/R_FG_mni_mean_bin.nii.gz either_end include \
		      --drawn_roi ${MNI_ROIs}/R_Arnold_trunk_mni_mean_bin.nii.gz any include \
		      --drawn_roi ${MNI_ROIs}/R_FG_mni_mean_bin.nii.gz any include \
		      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
		      --drawn_roi ${MNI_ROIs}/R_Selection_Cube_03_mni_mean_bin_corrected_to_exclude_thalamus.nii any include -f
    
    # Small length pruning to remove spurious streamlines
    prune_streamlines ${o_dir}/${s_id}/${s_id}_L_Arnold_proper_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_L_Arnold_proper_mni2.trk --max_prune 90 -f
    prune_streamlines ${o_dir}/${s_id}/${s_id}_L_Arnold_OR_like_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_L_Arnold_OR_like_mni2.trk --max_prune 130 -f
    prune_streamlines ${o_dir}/${s_id}/${s_id}_L_Arnold_AR_like_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_L_Arnold_AR_like_mni2.trk --max_prune 63 -f
    prune_streamlines ${o_dir}/${s_id}/${s_id}_L_Arnold_lateral_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_L_Arnold_lateral_mni2.trk --max_prune 55 -f    
    		
    prune_streamlines ${o_dir}/${s_id}/${s_id}_R_Arnold_proper_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_R_Arnold_proper_mni2.trk --max_prune 90 -f
    prune_streamlines ${o_dir}/${s_id}/${s_id}_R_Arnold_OR_like_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_R_Arnold_OR_like_mni2.trk --max_prune 130 -f
    prune_streamlines ${o_dir}/${s_id}/${s_id}_R_Arnold_AR_like_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_R_Arnold_AR_like_mni2.trk --max_prune 63 -f
    prune_streamlines ${o_dir}/${s_id}/${s_id}_R_Arnold_lateral_mni.trk \
		      ${o_dir}/${s_id}/${s_id}_R_Arnold_lateral_mni2.trk --max_prune 55 -f

    mv ${o_dir}/${s_id}/${s_id}_R_Arnold_proper_mni2.trk ${o_dir}/${s_id}/${s_id}_R_Arnold_proper_mni.trk
    mv ${o_dir}/${s_id}/${s_id}_R_Arnold_lateral_mni2.trk ${o_dir}/${s_id}/${s_id}_R_Arnold_lateral_mni.trk
    mv ${o_dir}/${s_id}/${s_id}_R_Arnold_OR_like_mni2.trk ${o_dir}/${s_id}/${s_id}_R_Arnold_OR_like_mni.trk
    mv ${o_dir}/${s_id}/${s_id}_R_Arnold_AR_like_mni2.trk ${o_dir}/${s_id}/${s_id}_R_Arnold_AR_like_mni.trk
    mv ${o_dir}/${s_id}/${s_id}_L_Arnold_proper_mni2.trk ${o_dir}/${s_id}/${s_id}_L_Arnold_proper_mni.trk
    mv ${o_dir}/${s_id}/${s_id}_L_Arnold_lateral_mni2.trk ${o_dir}/${s_id}/${s_id}_L_Arnold_lateral_mni.trk
    mv ${o_dir}/${s_id}/${s_id}_L_Arnold_OR_like_mni2.trk ${o_dir}/${s_id}/${s_id}_L_Arnold_OR_like_mni.trk
    mv ${o_dir}/${s_id}/${s_id}_L_Arnold_AR_like_mni2.trk ${o_dir}/${s_id}/${s_id}_L_Arnold_AR_like_mni.trk 
done





