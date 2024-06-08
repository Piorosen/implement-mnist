#!/bin/bash

docker build -t piorosen/mnist-weight -f ./scripts/model_reproducibility.dockerfile ./scripts
id=$(docker run --rm -it --detach piorosen/mnist-weight)
echo $id
docker cp $id:/sources/output/weights.hpp .
docker cp $id:/sources/tests/ .
sudo docker kill $id

docker build -t piorosen/mnist -f ./scripts/mnist.dockerfile .
