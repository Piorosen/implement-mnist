#!/bin/bash

if ! docker image inspect piorosen/mnist-weight > /dev/null 2>&1; then
    docker build -t piorosen/mnist-weight -f ./scripts/model_reproducibility.dockerfile ./scripts
    id=$(docker run --rm -it --detach piorosen/mnist-weight)
    echo $id
    docker cp $id:/sources/output/weights.hpp .
    docker cp $id:/sources/tests/ .
    sudo docker kill $id
fi

if ! docker image inspect piorosen/mnist > /dev/null 2>&1; then
    docker build -t piorosen/mnist -f ./scripts/mnist.dockerfile .
fi

# if [ -z "$1" ]; then
#     docker run --rm -it -t piorosen/mnist /mnist input
# fi

file_list=($(ls "./tests" | grep ".txt"))
for file in "${file_list[@]}"; do
    echo $file
    docker run --rm -it -v $(pwd)/tests:/tests -t piorosen/mnist /mnist file /tests/$file
done
