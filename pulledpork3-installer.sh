#!/usr/bin/env bash
# CentOS 9 Stream with Snort3 Auto update through PulledPork3
ORGNPATH=$(pwd)

## Dependencies
sudo dnf install -y python3 python3-pip python3-devel
mkdir -p ~/sources
git clone https://github.com/shirkdog/pulledpork3.git ~/sources/pulledpork3
pip3 install -r ~/sources/pulledpork3/requirements.txt
sudo pip3 install -r ~/sources/pulledpork3/requirements.txt

## Install PulledPork3
sudo mkdir -p /usr/local/pulledpork/etc
sudo cp ~/sources/pulledpork3/pulledpork.py /usr/local/pulledpork
sudo cp -r ~/sources/pulledpork3/lib /usr/local/pulledpork
sudo cp -r ~/sources/pulledpork3/etc /usr/local/pulledpork
sudo cln -s /usr/local/pulledpork/pulledpork.py /usr/bin/pulledpork
pulledpork -V

## Configure PulledPork3
read -p "Enter Oinkcode: " OINKCODE
sudo cp "$ORGNPATH"/cfg/pulledpork3.conf "$ORGNPATH"/cfg/pulledpork.conf
echo 'oinkcode = "$OINKCODE"\n' >> "$ORGNPATH"/cfg/pulledpork.conf
sudo mv /usr/local/pulledpork/etc/pulledpork.conf /usr/local/pulledpork/etc/pulledpork.conf.default
sudo mv "$ORGNPATH"/cfg/pulledpork.conf /usr/local/pulledpork/etc/pulledpork.conf
sudo cp "$ORGNPATH"/cfg/pulledpork.service /etc/systemd/system
sudo cp "$ORGNPATH"/cfg/pulledpork.timer /etc/systemd/system
sudo touch /usr/local/pulledpork/etc/enablesid.conf
sudo touch /usr/local/pulledpork/etc/dropsid.conf
sudo touch /usr/local/pulledpork/etc/disablesid.conf
sudo touch /usr/local/pulledpork/etc/modifysid.conf
sudo systemctl daemon-reload
sudo systemctl enable pulledpork.timer

sudo pulledpork -c /usr/local/pulledpork/etc/pulledpork.conf
