FROM ubuntu:18.04
ENV COMPILE_PROC_NUM 2
ENV WORKSPACE /usr/app/ORB_SLAM2
SHELL ["/bin/bash", "-c"]
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends \
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
RUN mkdir -p ${WORKSPACE}
ADD src ${WORKSPACE}/src
RUN cd ${WORKSPACE}/src/Pangolin && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j${COMPILATION_PROC_NUM}
RUN cd ${WORKSPACE}/src/ORB_SLAM2 && \
    sed -i '1iCOMPILE_PROC_NUM='"${COMPILE_PROC_NUM}" build.sh && \
    sed -i '31s/$/\ -DCMAKE\_EXPORT\_COMPILE\_COMMANDS=1/' build.sh && \
    # https://github.com/ducha-aiki/pymagsac/issues/4#issuecomment-603853616 
    sed -i '39i list(APPEND CMAKE_INCLUDE_PATH "/usr/local/include")' CMakeLists.txt && \
    sed -i '40i find_package (Eigen3 3.3 REQUIRED NO_MODULE)' CMakeLists.txt && \
    sed -i '41d' CMakeLists.txt && \
    ./build.sh
