FROM python:3.10.14-bookworm

WORKDIR /sources
RUN mkdir ./output
RUN mkdir ./tests

COPY ./requirements.txt .
RUN pip install -r requirements.txt

COPY *.py .

RUN python3 ./train_with_save.py --save_weight ./model_weights.h5 --epoch 10 --seed 142

COPY template.hpp .

RUN python3 ./gen_param_for_cpp.py --h5_file ./model_weights.h5 \
                                    --template_file ./template.hpp \
                                    --output ./output/weights.hpp

RUN python3 ./gen_image_from_dataset.py --output ./tests --take 100
