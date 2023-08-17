# moma-preprocessing

This repository contains module files for using moma preprocessing with the [Environment Modules](https://modules.readthedocs.io/en/latest/index.html).

## Requirements

- You will need a Linux host system to run the Linux containers that are used by the modules.
- You must install [Docker](https://www.docker.com/) or [Singularity/Apptainer](https://apptainer.org/) to use the provided modules.

## Setup instructions

- Install Docker or Apptainer/Singularity as explained here:
  - Docker: https://docs.docker.com/engine/install
  - Singularity/Apptainer: https://apptainer.org/docs/admin/main/installation.html
- Clone this Git repository or download the ZIP file.
- Modify your `~/.bashrc`:
  - If you are using [Environment Modules](https://modules.readthedocs.io/en/latest/index.html), add this to use version `0.4.0`:
    ```sh
    module use <PATH_TO_GIT_REPOSITORY>
    module load moma-preprocessing/0.4.0
    ```
  - Otherwise use this to add version `0.4.0` to your `PATH`:
    ```sh
    PATH=<PATH_TO_GIT_REPOSITORY>/0.4.0/:$PATH
    ```
