#!/bin/bash
set -e

cd /tmp/

# TODO: clean up this python stuff
apt-get install -y python3 python3-pip python3-setuptools python3-wheel ninja-build
pip3 install --user meson
export PATH=$PATH:/root/.local/bin

# build libqmi
apt install -y libgudev-1.0-dev gobject-introspection libgirepository1.0-dev help2man bash-completion

git clone https://gitlab.freedesktop.org/mobile-broadband/libqmi.git
cd libqmi
meson setup build --prefix=/usr -Dmbim_qmux=false -Dqrtr=false
ninja -C build

# build ModemManager
apt install -y libpolkit-gobject-1-dev

git clone https://gitlab.freedesktop.org/mobile-broadband/ModemManager.git
cd ModemManager
meson setup build --prefix=/usr --sysconfdir=/etc -Dqmi=true -Dmbim=false
ninja -C build
