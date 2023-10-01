#!/bin/bash



if [ "${CONDA_DEFAULT_ENV}" != "base" ]; then
  echo "ERROR: This script must be run from within the Conda base environment"
  exit 1
fi


env_name='hyena'
echo "creating conda env ${env_name}"


source ${anaconda_path}/etc/profile.d/conda.sh

conda deactivate
conda activate 

echo "Updating conda itself"
conda update conda -y


#-------------------------------------------------------------------------------------------------------------
# setting up the packages to be installed
python_version='python=3.10'

conda_default_packages='pandas scikit-learn tqdm'

anaconda_packages='jupyter pillow h5py scikit-image scikit-learn'

conda_forge_packages='jupyter_contrib_nbextensions matplotlib gensim einops imageio scipy tqdm python-utils pygments'

hf_pip_packages='transformers accelerate bitsandbytes peft datasets'

pip_packages_req='tensorboard opencv_python wandb pynvml rich pytorch-lightning==1.8.6 hydra-core omegaconf opt-einsum cmake pykeops timm torchtext regex lightning'

# pip_packages_req_min='lightning regex wandb'

#-------------------------------------------------------------------------------------------------------------
# installing the packages
echo "Creating environment and installing Python + Pytorch"
conda create -y -n $env_name $python_version

echo "Installing pytorch version 2 with cuda 11.8 based on the command line from their site"
conda install -y -n $env_name pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia

echo "Installing default channel packages"
conda install -y  -n $env_name $conda_default_packages


echo "Installing anaconda packages"
conda install -y -n $env_name -c anaconda $anaconda_packages

echo "Installing conda-forge packages"
conda install -y -n $env_name -c conda-forge $conda_forge_packages

# echo "Installing pytorch packages"
# conda install -y -n $env_name -c pytorch $pytorch_packages


echo "Installing pip packages"
conda activate $env_name
cp create_conda_env.sh $CONDA_PREFIX/create_conda_env.txt


if [[ -n "$CONDA_DEFAULT_ENV" ]] && [[ "$CONDA_DEFAULT_ENV" == "$env_name" ]]; then
    echo "The script is running from within the specific Conda environment: $env_name. installing the pip packages...."
    pip install $pip_packages
    pip install $hf_pip_packages
    pip install $pip_packages_req
else
    echo "The script is not running from within the $env_name. skipping pip packages installation...."
fi

echo "\n\n\n\n=============================Finished=================================================="
echo "if skipped pip packeges installation, run the following commands:"
echo "1. conda activate $env_name"
echo "2. pip install $pip_packages"
echo "3. pip install $hf_pip_packages"
echo "4. pip install $pip_packages_req"
echo "========================================================================================="

