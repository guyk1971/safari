# make sure to init and update the flash attention submodule
# git submodule init
# git submodule update
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd $DIR/../flash-attention/
pip install .

cd csrc/layer_norm
pip install .

cd ../fused_dense_lib
pip install .

