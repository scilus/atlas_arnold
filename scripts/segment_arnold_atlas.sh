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
# ./segment_arnold_atlas.sh -i INPUT -r MNI_binary_ROIs -o OUT_DIR
#
#  INPUT=/path/to/[INPUT] INPUT folder containing multiple subjects trk in MNI space
#
#                 [INPUT]
#                 ├── S1
#                 │   └── *.trk
#                 ├── S2
#                 │   └── *.trk
#                 └── *
#
#  MNI_ROI_PATH=/path/to/atlas_arnold/MNI_ROIs  Path to MNI_binary_ROIs provided in the atlas_arnold_project
#
#  OUT_DIR=/path/to/[OUT_DIR] Output directory
#################################################################################################################

#### TODO: "parallelize" this with parallel or nextflow

#!/usr/bin/env bash
usage() { echo "#
# The script is called as so:
#
# ./segment_arnold_atlas.sh -i input_arnold -r MNI_binary_ROIs -o o_dir
#
# input=/path/to/[INPUT]                        Input folder containing multiple subjects trk in MNI space
#
#                        [INPUT]
#                        ├── S1
#                        │   └── *.trk
#                        ├── S2
#                        │   └── *.trk
#                        └── *
#
#  MNI_ROI_PATH=/path/to/atlas_arnold/MNI_ROIs  Path to MNI_binary_ROIs provided in the atlas_arnold_project
#
#  OUT_DIR=/path/to/[OUT_DIR]                   Output directory
#"
echo ""
echo "-> $(basename $0) [-i INPUT] [-r MNI_ROI_PATH] [-o OUT_DIR]" 1>&2; exit 1; }

while getopts "i:o:r:" args; do
    case "${args}" in
        i) i=${OPTARG};;
        r) r=${OPTARG};;
		o) o=${OPTARG};;
        *) usage;;
    esac
done
shift $((OPTIND-1))

if [ -z "${i}" ] || [ -z "${r}" ] || [ -z "${o}" ]; then
    usage
fi

i_dir=${i%%/}
MNI_ROIs=${r%%/}
o_dir=${o%%/}

echo "#"
echo "# Input folder: ${i_dir}"
echo "# MNI_ROIs found: ${MNI_ROIs}"
echo "# Output folder: ${o_dir}"
echo "#"
echo ""



for i in ${i_dir}/*;
do
    # tractogram to virtually dissect
    t="${i}/*.trk"

    # subject ID directory
    f=${t/${i_dir}\//}
    s_id=${f/\/*/}
	
	echo ""
	echo "#"
    echo "# Running subject ${s_id}"

	scil_verify_space_attributes_compatibility.py $t ${MNI_ROIs}/../mni152_1mm_bet.nii.gz > ${o_dir}/${s_id}_log_validate.txt
	if [[ $(< ${o_dir}/${s_id}_log_validate.txt) != "All input files have compatible headers." ]]; then
		echo "# ERROR - $t is not in the MNI space. Please check https://scilpy.readthedocs.io/en/latest/documentation/tractogram_registration.html"
		echo "#"
	else 
		mkdir -p ${o_dir}/${s_id}
	 	for nside in L R
		do
		echo "#"
		echo "# Filter ${nside} side"
	    # Arnold proper
		echo "# Filtering Arnold proper: ${s_id}_${nside}_Arnold_proper_mni.trk"
	    scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_proper_mni.trk \
		    --drawn_roi ${MNI_ROIs}/${nside}_pulvinar_mni_mean_bin.nii.gz either_end include \
			--drawn_roi ${MNI_ROIs}/${nside}_TL_mni_mean_bin.nii.gz either_end include \
		    --drawn_roi ${MNI_ROIs}/${nside}_Arnold_trunk_mni_mean_bin.nii.gz any include \
		    --drawn_roi ${MNI_ROIs}/${nside}_LGN_cut_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_FG_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f
	
		# Arnold lateral
		echo "# Filtering Arnold lateral: ${s_id}_${nside}_Arnold_lateral_mni.trk"
    	scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_lateral_mni.trk \
			--drawn_roi ${MNI_ROIs}/${nside}_pulvinar_mni_mean_bin.nii.gz either_end include \
			--drawn_roi ${MNI_ROIs}/${nside}_TL_mni_mean_bin.nii.gz either_end include \
			--drawn_roi ${MNI_ROIs}/${nside}_STG_mni_mean_bin.nii.gz either_end exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_LGN_cut_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Clean_Cingulum_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_03_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/SelectionCube04.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/SelectionCuber05.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_hippo_temporal_mask.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/Mid_sagittal_mask.nii.gz any exclude -f		

		# Arnold OR like
		echo "# Filtering Arnold OR like: ${s_id}_${nside}_Arnold_OR_like_mni.trk"
    	scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_OR_like_mni.trk \
		    --drawn_roi ${MNI_ROIs}/${nside}_pulvinar_mni_mean_bin.nii.gz either_end include \
		    --drawn_roi ${MNI_ROIs}/${nside}_TL_mni_mean_bin.nii.gz either_end include \
		    --drawn_roi ${MNI_ROIs}/${nside}_FG_mni_mean_bin.nii.gz either_end include \
		    --drawn_roi ${MNI_ROIs}/${nside}_Arnold_trunk_mni_mean_bin.nii.gz any include \
		    --drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_03_mni_mean_bin_corrected_to_exclude_thalamus.nii.gz any include -f

		# Arnold AR like
		echo "# Filtering Arnold AR like: ${s_id}_${nside}_Arnold_AR_like_mni.trk"
		scil_filter_tractogram.py $t ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_AR_like_mni.trk \
			--drawn_roi ${MNI_ROIs}/${nside}_pulvinar_mni_mean_bin.nii.gz either_end include \
			--drawn_roi ${MNI_ROIs}/${nside}_STG_mni_mean_bin.nii.gz either_end include \
			--drawn_roi ${MNI_ROIs}/${nside}_TL_mni_mean_bin.nii.gz either_end include \
			--drawn_roi ${MNI_ROIs}/${nside}_Arnold_trunk_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_LGN_cut_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_01_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_02_mni_mean_bin.nii.gz any exclude \
			--drawn_roi ${MNI_ROIs}/${nside}_Selection_Cube_03_mni_mean_bin.nii.gz any exclude -f


    	# Small length pruning to remove spurious streamlines
		scil_filter_streamlines_by_length.py ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_proper_mni.trk \
	   		${o_dir}/${s_id}/${s_id}_${nside}_Arnold_proper_mni.trk --maxL 90 -f
	    scil_filter_streamlines_by_length.py ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_OR_like_mni.trk \
		    ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_OR_like_mni.trk --maxL 130 -f
    	scil_filter_streamlines_by_length.py ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_AR_like_mni.trk \
			${o_dir}/${s_id}/${s_id}_${nside}_Arnold_AR_like_mni.trk --maxL 63 -f
	    scil_filter_streamlines_by_length.py ${o_dir}/${s_id}/${s_id}_${nside}_Arnold_lateral_mni.trk \
			${o_dir}/${s_id}/${s_id}_${nside}_Arnold_lateral_mni.trk --maxL 55 -f
		done
		echo "# Subject ${s_id} done"
	fi
done





