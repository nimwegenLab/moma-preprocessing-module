#!/usr/bin/env bash

###
# This script parses the command options for the preprocessing and calls the docker container for running the
# containerized preprocessing instance.
###

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#source "${DIR}/helpers.sh"
source "${DIR}/functions.sh"

docker_image_name=$(get_image_tag)

SHORT=i:,o:,p:,r:
LONG=tmax:,roi_boundary_offset_at_mother_cell:,gl_detection_template_path:,normalization_config_path:,normalization_region_offset:,frames_to_ignore:,image_registration_method:,forced_intensity_normalization_range:,log:

OPTS=$(getopt --alternative --name moma_preprocess --options $SHORT --longoptions $LONG -- "$@")

eval set -- "$OPTS"

CMD_ARGUMENTS=""

function get_directory_path {
    # This function takes the path of a file or directory. If file-path is passed it returns the path to the parent
    # directory. If a directory is passed, it returns the path to the directory itself.
    local TARGET_PATH=$1
    if [[ -d "$TARGET_PATH" ]]; then
      echo "$TARGET_PATH"
      return 0
    elif [[ -f "$TARGET_PATH" ]]; then
      RET=$(dirname "$TARGET_PATH")
      echo "$RET"
      return 0
    else
      # an invalid value was passed
      echo "ERROR: Path does not exist: ${TARGET_PATH}"
      exit 1
    fi
}

# This while loop captures paths that will be mount directories to the container.
# Other arguments are appended to the variable CMD_ARGUMENTS, which is passed as command line argument to the container.
while :
do
  case "$1" in
    -i )
      input_path=$(get_directory_path "$2")
      CMD_ARGUMENTS="${CMD_ARGUMENTS} $1 $2"
      shift 2
      ;;
    -o )
      output_path=$(get_directory_path "$2")
      CMD_ARGUMENTS="${CMD_ARGUMENTS} $1 $2"
      shift 2
      ;;
    --log )
      log_path=$(get_directory_path "$2")
      CMD_ARGUMENTS="${CMD_ARGUMENTS} $1 $2"
      shift 2
      ;;
    --gl_detection_template_path )
      gl_detection_template_path=$(get_directory_path "$2")
      CMD_ARGUMENTS="${CMD_ARGUMENTS} $1 $2"
      shift 2
      ;;
    -- )
      shift;
      break
      ;;
    * )
      CMD_ARGUMENTS="${CMD_ARGUMENTS} $1 $2"
      shift 2;
      ;;
  esac
done

echo "running container"
#echo "SINGULARITY_CONTAINER_DIR: ${SINGULARITY_CONTAINER_DIR}"
#SINGULARITY_CONTAINER_NAME="${CONTAINER_NAME//\//_}"
#echo "SINGULARITY_CONTAINER_NAME: ${SINGULARITY_CONTAINER_NAME}"
#SINGULARITY_CONTAINER_FILENAME="${CONTAINER_NAME//\//_}_${VERSION}.sif"
#echo "SINGULARITY_CONTAINER_FILENAME: ${SINGULARITY_CONTAINER_FILENAME}"
#SINGULARITY_CONTAINER_PATH="${SINGULARITY_CONTAINER_DIR}/${SINGULARITY_CONTAINER_FILENAME}"
#echo "SINGULARITY_CONTAINER_PATH: ${SINGULARITY_CONTAINER_PATH}"
#
#echo "EXITING"; exit 1

# Use docker if it available
if command -v docker &> /dev/null
then
    docker pull "${docker_image_name}"
    docker run --rm --mount type=bind,src="${input_path}",target="${input_path}" --mount type=bind,src="${gl_detection_template_path}",target="${gl_detection_template_path}" --mount type=bind,src="${output_path}",target="${output_path}" --mount type=bind,src="${log_path}",target="${log_path}" "${docker_image_name}" "${CMD_ARGUMENTS}"
elif command -v singularity &> /dev/null
then
#    echo "Running preprocessing using Singularity container."
#    SINGULARITY_CONTAINER_DIR="$HOME/singularity_images"
#    echo "${SINGULARITY_CONTAINER_DIR}"
#    echo "$(get_singularity_container_name)"
##    SINGULARITY_CONTAINER_PATH="${SINGULARITY_CONTAINER_DIR}/$(get_singularity_container_name)"
#    SINGULARITY_CONTAINER_FILENAME="${CONTAINER_NAME}_${VERSION}.sif"
#    SINGULARITY_CONTAINER_PATH="${SINGULARITY_CONTAINER_DIR}/${SINGULARITY_CONTAINER_FILENAME}"

#    echo "SINGULARITY_CONTAINER_DIR: ${SINGULARITY_CONTAINER_DIR}"
    SINGULARITY_CONTAINER_NAME="${CONTAINER_NAME//\//_}"
#    echo "SINGULARITY_CONTAINER_NAME: ${SINGULARITY_CONTAINER_NAME}"
    SINGULARITY_CONTAINER_FILENAME="${CONTAINER_NAME//\//_}_${VERSION}.sif"
#    echo "SINGULARITY_CONTAINER_FILENAME: ${SINGULARITY_CONTAINER_FILENAME}"
    SINGULARITY_CONTAINER_FILE_PATH="${SINGULARITY_CONTAINER_DIR}/${SINGULARITY_CONTAINER_FILENAME}"
#    echo "SINGULARITY_CONTAINER_PATH: ${SINGULARITY_CONTAINER_PATH}"

#    echo "${SINGULARITY_CONTAINER_PATH}"
    mkdir "${SINGULARITY_CONTAINER_DIR}"

    singularity pull "${SINGULARITY_CONTAINER_FILE_PATH}" "docker://${docker_image_name}"
    singularity run --bind "${input_path}":"${input_path}" --bind "${gl_detection_template_path}":"${gl_detection_template_path}" --bind "${output_path}":"${output_path}" --bind "${log_path}":"${log_path}" "${SINGULARITY_CONTAINER_FILE_PATH}" "${CMD_ARGUMENTS}"
#docker run --rm --mount type=bind,src="${input_path}",target="${input_path}" --mount type=bind,src="${gl_detection_template_path}",target="${gl_detection_template_path}" --mount type=bind,src="${output_path}",target="${output_path}" --mount type=bind,src="${log_path}",target="${log_path}" "${docker_image_name}" "${CMD_ARGUMENTS}"
fi
