
set -u

setup_docker_container() {
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

  ### TODO: Check if an image with this tag already exists; if it does do not pull new one; this will avoid having to run the lengthy hash calculation
  ### michaelmell/mmpreprocesspy:v0.2.0

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
