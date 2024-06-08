#!/bin/bash

docker run --rm -it -v $(pwd)/tests:/tests -t piorosen/mnist /mnist file $@
