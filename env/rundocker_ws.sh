#!/bin/bash
# Define variables
# IMAGE_NAME="gitlab-master.nvidia.com:5005/gkoren/safari-hyena:pyt23.09"
# IMAGE_NAME="nvcr.io/nvidia/pytorch:23.09-py3"

IMAGE_NAME="safari:23.09-vsc"
# docker pull $(IMAGE_NAME)

# Run the container
docker run --gpus all -it --rm --privileged -v $(pwd -P):/workspace/safari --shm-size=8g -p 8888:8888 -p 6006:6006 --ulimit memlock=-1 --ulimit stack=67108864 --device=/dev/snd "$IMAGE_NAME"

# docker run --gpus all --user $(id -u):$(id -g) -it --rm --privileged -v $(pwd -P):/workspace/safari --shm-size=8g -p 8888:8888 -p 6006:6006 --ulimit memlock=-1 --ulimit stack=67108864 --device=/dev/snd "$IMAGE_NAME"
