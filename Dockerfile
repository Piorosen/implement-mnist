FROM python:3.10.14-bookworm AS CodeGen
ARG TEST_TASK=100
ARG TRAIN_EPOCHS=100
ARG TRAIN_SEED=142

WORKDIR /sources
RUN mkdir ./output && mkdir ./tests
COPY ./scripts/requirements.txt ./scripts/template.hpp ./
RUN pip install -r requirements.txt
COPY ./scripts/*.py ./
RUN python3 ./train_with_save.py --save_weight ./model_weights.h5 --epoch ${TRAIN_EPOCHS} --seed ${TRAIN_SEED}
RUN python3 ./gen_param_for_cpp.py --h5_file ./model_weights.h5 \
                                    --template_file ./template.hpp \
                                    --output ./output/weights.hpp
RUN python3 ./gen_image_from_dataset.py --output ./tests --take ${TEST_TASK}

FROM ubuntu:24.04 AS Builder
WORKDIR /work
RUN apt update && \
    apt install -y clang-17 git cmake ninja-build \
    curl zip unzip tar build-essential pkg-config && \
    rm -rf /var/lib/apt/lists/*
    
COPY CMakeLists.txt CMakeLists.txt
COPY main.cpp .
ENV CXX clang++-17
ENV CC clang-17
COPY --from=CodeGen /sources/output/weights.hpp .
RUN mkdir build && \ 
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_EXE_LINKER_FLAGS="-std=c++17 -O2 -static" \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DSTATIC=ON \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_CXX_COMPILER=${CXX} \
    -G Ninja .. && \
    ninja

# For deployment., so To be determine.
FROM alpine
WORKDIR /
COPY --from=CodeGen /sources/tests/ /tests
COPY --from=Builder /work/build/mnist /mnist

LABEL org.opencontainers.image.source=https://github.com/Piorosen/implement-mnist
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.authors="JooHyoung Cha"

CMD [ "/mnist", "file", "/tests/4-0075.txt" ]

# FROM ubuntu:24.04 as bash
# RUN apt update && \
#     apt install -y tar g++ gcc make cmake \
#     wget curl zip unzip tar build-essential pkg-config && \
#     rm -rf /var/lib/apt/lists/*
# WORKDIR /work
# RUN wget https://ftp.gnu.org/gnu/bash/bash-5.2.21.tar.gz && \
#         tar -xzf bash-5.2.21.tar.gz && \
#         cd bash-5.2.21 && \
#         ./configure LDFLAGS=-static --enable-static-link && \
#         cd /work/bash-5.2.21 && make
