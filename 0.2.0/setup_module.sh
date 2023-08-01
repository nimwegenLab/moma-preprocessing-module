setup_docker_container() {
  ### TODO: Check if an image with this tag already exists; if it does do not pull new one; this will avoid having to run the lengthy hash calculation
  ### michaelmell/mmpreprocesspy:v0.2.0

  printf "Setting up module with Singularity container."

  docker pull "${CONTAINER_TAG}"
  id=$(docker create "${CONTAINER_TAG}")

  ### Copy support scripts from container to host
  HOST_SCRIPT_DIR="/host_scripts"
  if [[ ! -f "${MOMA_BIN_DIRECTORY}/mm_dispatch_preprocessing.sh" ]]; then
    docker cp "${id}":"${HOST_SCRIPT_DIR}/mm_dispatch_preprocessing.sh" "${MOMA_BIN_DIRECTORY}/mm_dispatch_preprocessing.sh"
  fi
  if [[ ! -f "${MOMA_BIN_DIRECTORY}/moma_preprocess.sh" ]]; then
    docker cp "${id}":"${HOST_SCRIPT_DIR}/moma_preprocess" "${MOMA_BIN_DIRECTORY}/moma_preprocess.sh"
  fi
}

function setup_singularity_container() {
    printf "Setting up module with Singularity container."
    SINGULARITY_CONTAINER_NAME="${CONTAINER_NAME//\//_}"
#    echo "SINGULARITY_CONTAINER_NAME: ${SINGULARITY_CONTAINER_NAME}"
    SINGULARITY_CONTAINER_FILENAME="${CONTAINER_NAME//\//_}_${VERSION}.sif"
#    echo "SINGULARITY_CONTAINER_FILENAME: ${SINGULARITY_CONTAINER_FILENAME}"
    SINGULARITY_CONTAINER_FILE_PATH="${SINGULARITY_CONTAINER_DIR}/${SINGULARITY_CONTAINER_FILENAME}"

    if [[ ! -f "${SINGULARITY_CONTAINER_FILE_PATH}" ]]; then
      singularity pull "${SINGULARITY_CONTAINER_FILE_PATH}" "docker://${CONTAINER_TAG}"
    fi

    if [[ ! -f "${MOMA_BIN_DIRECTORY}/mm_dispatch_preprocessing.sh" ]]; then
      singularity  exec "${SINGULARITY_CONTAINER_FILE_PATH}" cp "${HOST_SCRIPT_DIR}/mm_dispatch_preprocessing.sh" .
    fi
    if [[ ! -f "${MOMA_BIN_DIRECTORY}/moma_preprocess.sh" ]]; then
      singularity  exec "${SINGULARITY_CONTAINER_FILE_PATH}" cp "${HOST_SCRIPT_DIR}/moma_preprocess.sh" .
    fi
}

setup_module() {
  export VERSION="v0.2.0"
  export CONTAINER_NAME="michaelmell/mmpreprocesspy"
  export CONTAINER_TAG="${CONTAINER_NAME}:${VERSION}"

  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  MOMA_BIN_DIRECTORY="${DIR}/bin/"
  export SINGULARITY_CONTAINER_DIR="${MOMA_BIN_DIRECTORY}"

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
