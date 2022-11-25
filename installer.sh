# CentOS 9 Stream with Snort3

## Ready to run
sudo ldconfig
mkdir -p ~/sources && cd ~/sources

## Basic Dependencies
sudo dnf install -y curl git vim flex bison gcc gcc-c++ make cmake automake autoconf libtool
sudo dnf install -y libpcap-devel pcre-devel libdnet-devel hwloc-devel openssl-devel zlib-devel luajit-devel pkgconf libmnl-devel libunwind-devel
sudo dnf install -y libnfnetlink-devel libnetfilter_queue-devel
cd ~/sources && git clone https://github.com/snort3/libdaq.git && cd ~/sources/libdaq && sudo ./bootstrap && sudo ./configure
sudo make && sudo make install && sudo ldconfig

## Optional Dependencies
sudo dnf install -y xz-devel libuuid-devel
sudo dnf install -y hyperscan hyperscan-devel
cd ~/sources && curl -Lo flatbuffers-22.11.23.tar.gz https://github.com/google/flatbuffers/archive/v22.11.23.tar.gz && tar xf flatbuffers-22.11.23.tar.gz
mkdir -p ~/sources/fb-build && cd ~/sources/fb-build && sudo cmake ~/sources/flatbuffers-22.11.23 && sudo make -j$(nproc) && sudo make -j$(nproc) install && sudo ldconfig && flatc --version
cd ~/sources && curl -Lo cert-forensics-tools-release-el9.rpm https://forensics.cert.org/cert-forensics-tools-release-el9.rpm && sudo rpm -Uvh cert-forensics-tools-release*rpm && sudo dnf --enablerepo=forensics install -y libsafec libsafec-devel && sudo ln -s /usr/lib64/pkgconfig/safec-3.3.pc /usr/lib64/pkgconfig/libsafec.pc
sudo dnf install -y gperftools-devel

## Install Snort3
cd ~/sources && git clone https://github.com/snort3/snort3.git
cd ~/sources/snort3 && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH && export CFLAGS="-O3" && export CXXFLAGS="-O3 -fno-rtti" && ./configure_cmake.sh --prefix=/usr/local/snort --enable-tcmalloc && cd ~/sources/snort3/build && sudo make -j$(nproc) && sudo make -j$(nproc) install

## Install Snort3 Extra
cd ~/sources && git clone https://github.com/snort3/snort3_extra.git
cd ~/sources/snort3_extra && export PKG_CONFIG_PATH=/usr/local/snort/lib64/pkgconfig:$PKG_CONFIG_PATH && ./configure_cmake.sh --prefix=/usr/local/snort/extra && cd ~/sources/snort3_extra/build && sudo make -j$(nproc) && sudo make -j$(nproc) install

## Check Snort3 version
/usr/local/snort/bin/snort -V
