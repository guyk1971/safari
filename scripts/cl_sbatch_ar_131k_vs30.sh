#!/bin/bash
#SBATCH -p a100-pcie-80gb-preprod
#SBATCH -N 1 # number of nodes
#SBATCH -t 4:00:00              # wall time  (8 for batch, backfill, 2 for batch_short)
#SBATCH -J "hyena-safari-ar-131k-vs30"            # job name (<< CHANGE ! >>)
#SBATCH --ntasks-per-node=1    # n tasks per machine (one task per gpu) <required>
set -x

# CONTAINER="nvcr.io/ea-bignlp/ga-participants/nemofw-training:23.08.02"
CONTAINER="gitlab-master.nvidia.com:5005/gkoren/safari-hyena"
WANDB="656d898ceb43e7059b9ab57b2f85bb05d196b907" # replace with your own WandB API key


# Logging
PROJECT="Hyena_safari"
EXPNAME="Hyena_SAR_131K_vs30"

# Mounts
PROJECT_ROOT="/home/scratch.gkoren_gpu/code/github/guyk1971/safari"
# PREPROC_DATA="/lustre/fsw/swdl/swdl-langspeech/datasets/data/BigNLP/"

RESULTS="${PROJECT_ROOT}/results/${EXPNAME}"

CODE="${PROJECT_ROOT}"
# MODEL="${GPFS}/models"
#MODEL="/lustre/fsw/swdl/swdl-langspeech/sandeepsub/models"
mkdir -p ${RESULTS}

MOUNTS="--container-mounts=$CODE:/workspace/safari,$RESULTS:/workspace/safari/results/$EXPNAME"

#TRAIN="[/preproc_data/tool_generated_sft_datasets/rare-finch/rare-finch_commercial.jsonl]"

# TRAIN="[/preproc_data/tool_generated_sft_datasets/kickass-snake/kickass-snake_commercial.shuf.jsonl]"

# VALID="[/preproc_data/scale_ai_data/delivery_2023-04-07-val.jsonl]"

# Necessary Exports
# export HYDRA_FULL_ERROR=1

OUTFILE="${RESULTS}/slurm-%j-%n.out"
ERRFILE="${RESULTS}/error-%j-%n.out"

# && cd /code/ \
# && git rev-parse HEAD \
# && cd nemo/collections/nlp/data/language_modeling/megatron \
# && make \
# && export PYTHONPATH="/code/.:${PYTHONPATH}" \


read -r -d '' cmd <<EOF
echo "*******STARTING********" \
&& echo "---------------" \
&& export WANDB_API_KEY=${WANDB} \
&& echo "Starting training" \
&& python -m train experiment=synthetics/associative_recall/hyena-131k-30vs.yaml
EOF

srun -o $OUTFILE -e $ERRFILE --container-image="$CONTAINER" $MOUNTS bash -c "${cmd}"
set +x
