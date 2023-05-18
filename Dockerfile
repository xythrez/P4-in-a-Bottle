FROM debian:11

ARG MAX_THREADS=1
ADD scripts/p4iab_docker_entry.sh /usr/bin/p4iab_docker_entry.sh

RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y \
        # Build Tools
        automake \
        bison \
        cmake \
        flex \
        git \
        gcc \
        g++ \
        libtool \
        make \
        pkg-config \
        valgrind \
        # P4 Dependencies
        python3 \
        python3-cffi \
        python3-crcmod \
        python3-dev \
        python3-ipaddr \
        python3-pip \
        python3-psutil \
        python3-scapy \
        python3-thrift \
        python3-virtualenv \
        python3-wheel \
        python3-protobuf \
        python3-grpcio \
        libboost-filesystem-dev \
        libboost-graph-dev \
        libboost-iostreams-dev \
        libboost-program-options-dev \
        libboost-system-dev \
        libboost-test-dev \
        libboost-thread-dev \
        libboost-dev \
        libgc-dev \
        libgmp-dev \
        libbpf-dev \
        libevent-dev \
        libffi-dev \
        libgflags-dev \
        libpcap-dev \
        libnanomsg-dev \
        libssl-dev \
        libreadline-dev \
        libthrift-dev \
        thrift-compiler \
        libprotobuf-dev \
        protobuf-compiler \
        protobuf-compiler-grpc \
        libprotoc-dev \
        libgrpc-dev \
        libgrpc++-dev \
        # Mininet Dependencies
        python3-pep8 \
        python3-pexpect \
        python3-tk \
        pyflakes3 \
        pylint \
        cgroupfs-mount \
        cgroup-tools \
        psmisc \
        ethtool \
        help2man \
        iperf \
        iproute2 \
        socat \
        ssh \
        telnet \
        tshark \
        # User utilities
        sudo \
        htop \
        less \
        man \
        net-tools \
        tcpdump \
        termshark \
        tmux \
        vim \
        emacs-nox; \
    pip3 install pypcap; \
    ln -sf /usr/local/lib/python3.9/dist-packages \
        /usr/lib/python3.9/site-packages; \
    apt-get clean; \
# Setup user account
    useradd -m -G sudo -s /bin/bash p4; \
    echo "p4:p4" | chpasswd; \
    mkdir -p /home/p4/shared; \
    chmod +x /usr/bin/p4iab_docker_entry.sh; \
# Install P4 - PI
    mkdir -p /opt/build; \
    git clone --depth=1 --recurse-submodules --shallow-submodules -b v0.1.0 \
        https://github.com/p4lang/PI.git /opt/build/PI; \
    cd /opt/build/PI; \
    ./autogen.sh; \
    ./configure \
        --prefix=/usr \
        --with-proto \
        --with-internal-rpc \
        --with-cli; \
    make -j$MAX_THREADS; \
    make install; \
    ldconfig; \
# Install P4 - Behavioral Model
    mkdir -p /opt/build; \
    git clone --depth=1 --recurse-submodules --shallow-submodules -b 1.15.0 \
        https://github.com/p4lang/behavioral-model.git \
        /opt/build/behavioral-model; \
    cd /opt/build/behavioral-model; \
    ./autogen.sh; \
    ./configure \
        --prefix=/usr \
        --with-nanomsg \
        --with-pi \
        --with-thrift; \
    make -j$MAX_THREADS; \
    make install; \
    ldconfig; \
    cd targets/simple_switch_grpc; \
    ./autogen.sh; \
    ./configure \
        --prefix=/usr \
        --with-thrift; \
    make -j$MAX_THREADS; \
    make install; \
    ldconfig; \
# Install P4 - p4c
    mkdir -p /opt/build; \
    git clone --depth=1 --recurse-submodules --shallow-submodules -b v1.2.3.9 \
        https://github.com/p4lang/p4c.git /opt/build/p4c; \
    cd /opt/build/p4c; \
    mkdir build; \
    cd build; \
    cmake \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DENABLE_GTESTS=OFF \
        ..; \
    make -j$MAX_THREADS; \
    make install; \
    ldconfig; \
# Install P4 - mininet
    mkdir -p /opt/build; \
    git clone --depth=1 --recurse-submodules --shallow-submodules -b 2.3.1b4 \
        https://github.com/mininet/mininet.git /opt/build/mininet; \
    cd /opt/build/mininet; \
    PYTHON=python3 make install; \
# Install P4 - P4 runtime shell
    mkdir -p /opt/build; \
    git clone --depth=1 --recurse-submodules --shallow-submodules -b v0.0.3 \
        https://github.com/p4lang/p4runtime-shell.git \
        /opt/build/p4runtime-shell; \
    cd /opt/build/p4runtime-shell; \
    pip3 install .; \
# Install P4 - ptf
    pip3 install ptf; \
# Setup P4 tutorials
    sudo -u p4 git clone --depth=1  --recurse-submodules --shallow-submodules \
        https://github.com/p4lang/tutorials.git /home/p4/tutorials; \
# Cleanup
    rm -rf /opt/build; \
    unlink /usr/lib/python3.9/site-packages;

