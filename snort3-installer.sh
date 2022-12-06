#!/usr/bin/env bash
# CentOS 9 Stream with Snort3 Installer

## Ready to run
sudo -Sv
sudo ldconfig
mkdir -p ~/sources


## Basic Dependencies
sudo dnf install -y curl git vim flex bison gcc gcc-c++ make cmake automake autoconf libtool libpcap-devel pcre-devel libdnet-devel hwloc-devel openssl-devel zlib-devel luajit-devel pkgconf libmnl-devel libunwind-devel libnfnetlink-devel libnetfilter_queue-devel xz-devel libuuid-devel hyperscan hyperscan-devel gperftools-devel

git clone https://github.com/snort3/libdaq.git ~/sources/libdaq
cd ~/sources/libdaq
sudo ./bootstrap
sudo ./configure --disable-netmap-module --disable-divert-module
sudo make
sudo make install
sudo ln -s /usr/local/lib/libdaq.so.3 /lib
sudo ldconfig

cd ~/sources
curl -Lo flatbuffers-22.11.23.tar.gz https://github.com/google/flatbuffers/archive/v22.11.23.tar.gz
tar xf flatbuffers-22.11.23.tar.gz
mkdir -p ~/sources/fb-build
cd ~/sources/fb-build
sudo cmake ~/sources/flatbuffers-22.11.23
sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo ldconfig
flatc --version

cd ~/sources
curl -Lo cert-forensics-tools-release-el9.rpm https://forensics.cert.org/cert-forensics-tools-release-el9.rpm
sudo rpm -Uvh cert-forensics-tools-release*rpm
sudo dnf --enablerepo=forensics install -y libsafec libsafec-devel
sudo ln -s /usr/lib64/pkgconfig/safec-3.3.pc /usr/lib64/pkgconfig/libsafec.pc
sudo ln -s /usr/lib64/libtcmalloc.so.4 /lib
sudo ldconfig


## Install Snort3
git clone https://github.com/snort3/snort3.git ~/sources/snort3
cd ~/sources/snort3
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:$PKG_CONFIG_PATH
export CFLAGS="-O3"
export CXXFLAGS="-O3 -fno-rtti"
./configure_cmake.sh --prefix=/usr/local/snort --enable-tcmalloc
cd ~/sources/snort3/build
sudo make -j$(nproc)
sudo make -j$(nproc) install
sudo ln -s /usr/local/snort/bin/snort /usr/bin


## Install Snort3 Extra
cd ~/sources
git clone https://github.com/snort3/snort3_extra.git
cd ~/sources/snort3_extra
export PKG_CONFIG_PATH=/usr/local/snort/lib64/pkgconfig:$PKG_CONFIG_PATH
./configure_cmake.sh --prefix=/usr/local/snort/extra
cd ~/sources/snort3_extra/build
sudo make -j$(nproc)
sudo make -j$(nproc) install


## Cnfigoure Snort3 Basic
sudo cp /usr/local/snort/etc/snort/snort_defaults.lua /usr/local/snort/etc/snort/snort_defaults.lua.default
sudo cp /usr/local/snort/etc/snort/snort.lua /usr/local/snort/etc/snort/snort.lua.default
sudo mkdir -p /usr/local/snort/etc/{rules,builtin_rules,so_rules,intel,appid,lightspd}
sudo mkdir -p /var/log/snort
sudo touch /usr/local/snort/etc/rules/local.rules
sudo touch /usr/local/snort/etc/intel/ip-allowlist
sudo systemctl stop firewalld
sudo systemctl disable firewalld

## Check Snort3 version
/usr/local/snort/bin/snort -V
echo "DONE!"
