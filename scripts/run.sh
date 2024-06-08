#!/bin/bash

if ! docker image inspect piorosen/mnist-weight > /dev/null 2>&1; then
    docker build -t piorosen/mnist-weight -f ./scripts/model_reproducibility.dockerfile ./scripts
    id=$(docker run --rm -it --detach piorosen/mnist-weight)
    echo $id
    docker cp $id:/sources/output/weights.hpp .
    docker cp $id:/sources/tests/ .
    docker kill $id
fi

if ! docker image inspect piorosen/mnist > /dev/null 2>&1; then
    docker build -t piorosen/mnist -f ./scripts/mnist.dockerfile .
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --all)
            all_option=true
            shift
            ;;
        --input)
            input_option=true
            shift 2
            ;;
        *)
            echo "Error: Unknown option '$1'" >&2
            exit 1
            ;;
    esac
done

if $all_option; then
    file_list=($(ls "./tests" | grep ".txt"))

    if [ ${#file_list[@]} -eq 0 ]; then
        id=$(docker run --rm -it --detach piorosen/mnist-weight)
        echo $id
        docker cp $id:/sources/output/weights.hpp .
        docker cp $id:/sources/tests/ .
        docker kill $id
    fi

    file_list=($(ls "./tests" | grep ".txt"))

    for file in "${file_list[@]}"; do
        echo $file
        docker run --rm -it -v $(pwd)/tests:/tests -t piorosen/mnist /mnist file $file
    done
fi

if $input_option; then
    docker run --rm -it -t piorosen/mnist /mnist input
fi
