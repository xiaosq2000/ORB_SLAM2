FROM ubuntu:18.04
ENV COMPILE_PROC_NUM 2
ENV WORKSPACE /usr/app/ORB_SLAM2
SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    apt-get install -qy --no-install-recommends DEBIAN_FRONTEND=noninteractive \
    build-essential \
    cmake \
    git \
    vim \
    python-dev \
    libeigen3-dev \
    libopencv-dev \
    dbus-x11 \
    libegl1 \
    libegl1-mesa-dev \
    libglew-dev && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p ${WORKSPACE}/src
ADD src ${WORKSPACE}
RUN cd ${WORKSPACE}/src/Pangolin && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j${COMPILATION_PROC_NUM} && \
    cd ${WORKSPACE}/src/ORB_SLAM2 && \
    sed -i '1iCOMPILE_PROC_NUM='"${COMPILE_PROC_NUM}" build.sh && \
    sed -i '31s/$/\ -DCMAKE\_EXPORT\_COMPILE\_COMMANDS=1/' build.sh && \
    ./build.sh