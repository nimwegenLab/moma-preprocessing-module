setup_docker_container() {
  if [[ "$(docker images -q "${CONTAINER_TAG}" 2> /dev/null)" == "" ]]; then
    printf "Setting up module with Docker container.\n"
    docker pull "${CONTAINER_TAG}"
  fi
  id=$(docker create "${CONTAINER_TAG}")

  ### Copy support scripts from container to host
  HOST_SCRIPT_DIR="/host_scripts"
  if [[ ! -f "${MOMA_BIN_DIRECTORY}/mm_dispatch_preprocessing.sh" ]]; then
    docker cp "${id}":"${HOST_SCRIPT_DIR}/mm_dispatch_preprocessing.sh" "${MOMA_BIN_DIRECTORY}/mm_dispatch_preprocessing.sh"
  fi
  if [[ ! -f "${MOMA_BIN_DIRECTORY}/moma_preprocess" ]]; then
    docker cp "${id}":"${HOST_SCRIPT_DIR}/moma_preprocess" "${MOMA_BIN_DIRECTORY}/moma_preprocess"
  fi
}

function setup_singularity_container() {
    if [[ ! -f "${SINGULARITY_CONTAINER_FILE_PATH}" ]]; then
      printf "Setting up module with Singularity container.\n"
      singularity pull "${SINGULARITY_CONTAINER_FILE_PATH}" "docker://${CONTAINER_TAG}"
    fi

    ### Copy support scripts from container to host
    HOST_SCRIPT_DIR="/host_scripts"
    if [[ ! -f "${MOMA_BIN_DIRECTORY}/mm_dispatch_preprocessing.sh" ]]; then
      singularity  exec --bind "${SINGULARITY_CONTAINER_DIR}":"${SINGULARITY_CONTAINER_DIR}" "${SINGULARITY_CONTAINER_FILE_PATH}" cp "${HOST_SCRIPT_DIR}/mm_dispatch_preprocessing.sh" "${SINGULARITY_CONTAINER_DIR}/mm_dispatch_preprocessing.sh"
    fi
    if [[ ! -f "${MOMA_BIN_DIRECTORY}/moma_preprocess" ]]; then
      singularity  exec --bind "${SINGULARITY_CONTAINER_DIR}":"${SINGULARITY_CONTAINER_DIR}" "${SINGULARITY_CONTAINER_FILE_PATH}" cp "${HOST_SCRIPT_DIR}/moma_preprocess" "${SINGULARITY_CONTAINER_DIR}/moma_preprocess"
    fi
}

setup_module() {
  export VERSION="v0.2.0"
  export CONTAINER_NAME="mmpreprocesspy"
  CONTAINER_NAMESPACE="nimwegenlab"
  export CONTAINER_TAG="${CONTAINER_NAMESPACE}/${CONTAINER_NAME}:${VERSION}"

  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  MOMA_BIN_DIRECTORY="${DIR}/bin/"
  export SINGULARITY_CONTAINER_DIR="${MOMA_BIN_DIRECTORY}"
  SINGULARITY_CONTAINER_FILENAME="${CONTAINER_NAME//\//_}_${VERSION}.sif"
  export SINGULARITY_CONTAINER_FILE_PATH="${SINGULARITY_CONTAINER_DIR}/${SINGULARITY_CONTAINER_FILENAME}"

  if [[ ! -d "${MOMA_BIN_DIRECTORY}" ]]
  then
    mkdir -p "${MOMA_BIN_DIRECTORY}"
  fi

  if command -v docker &> /dev/null
  then
    setup_docker_container
  elif command -v singularity &> /dev/null
  then
    setup_singularity_container
  else
      printf "ERROR: No container engine was found. Check that Singularity or Docker are correctly configured."
      exit 1
  fi
}
