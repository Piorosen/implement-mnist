#!/bin/bash

python3 -m pip install -r requirements.txt

# train
python3 ./train_with_save.py --save_weight ./model_weights.h5 --epoch 1000

# deploy to cpp
python3 ./gen_param_for_cpp.py --h5_file ./model_weights.h5 \
                                --template_file ./template.hpp \
                                --output ../template.hpp

# generate dataset for test
python3 ./gen_image_from_dataset.py --output ../tests --take 100
