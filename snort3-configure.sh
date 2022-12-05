#!/usr/bin/env bash
# CentOS 9 Stream with Snort3 Configurer

# Get Oinkcode
ORGNPATH=$(pwd)
read -p "Enter Oinkcode: " OINKCODE

# Snort Global Rules, Open AppID and IP Reputation
mkdir -p ~/rules
#curl -Lo ~/snortrules-snapshot-30000.tar.gz https://www.snort.org/rules/snortrules-snapshot-31470.tar.gz?oinkcode=<YOUR OINKCODE HERE>
cd ~/rules && curl -Lo snortrules-snapshot-31470.tar.gz https://www.snort.org/rules/snortrules-snapshot-31470.tar.gz?oinkcode="$OINKCODE" && tar xf snortrules-snapshot-*.tar.gz
sudo cp ~/rules/rules/*.rules /usr/local/snort/etc/rules
sudo cp ~/rules/builtins/builtins.rules /usr/local/snort/etc/builtin_rules
sudo cp ~/rules/etc/snort_defaults.lua /usr/local/snort/etc/snort
sudo cp ~/rules/etc/snort.lua /usr/local/snort/etc/snort
sudo cp ~/rules/etc/file_magic.lua /usr/local/snort/etc/snort
cd ~/sources && curl -Lo snort-openappid.tar.gz https://snort.org/downloads/openappid/26425 && tar xf snort-openappid.tar.gz && sudo cp -r odp /usr/local/snort/appid
cd ~/sources && curl -Lo ip-blocklist https://www.talosintelligence.com/documents/ip-blacklist && sudo cp ip-blocklist /usr/local/snort/intel
ls /usr/local/snort/etc/rules; ls /usr/local/snort/etc/appid/odp

# Confiure default setup
sudo cp "$ORGNPATH"/cfg/snort_defaults.lua /usr/local/snort/etc/snort/snort_defaults.lua
sudo cp "$ORGNPATH"/cfg/snort.lua /usr/local/snort/etc/snort/snort.lua
