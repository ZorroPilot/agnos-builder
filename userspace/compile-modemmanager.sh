#!/bin/bash
set -e

LIBQMI_VERSION="1.30.6"
MM_VERSION="1.18.8"

cd /tmp/

# TODO: clean up this python stuff
apt-get install -y python3 python3-pip python3-setuptools python3-wheel ninja-build
pip3 install --user meson
export PATH=$PATH:/root/.local/bin

# mobile-broadband-provider-info
apt install -y xsltproc
git clone https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info.git
cd mobile-broadband-provider-info
./autogen.sh
./configure
make install

# build libqmi
cd /tmp
apt install -y libgudev-1.0-dev gobject-introspection libgirepository1.0-dev help2man bash-completion

git clone https://gitlab.freedesktop.org/mobile-broadband/libqmi.git
cd libqmi
meson setup build --prefix=/usr --libdir=/usr/lib/aarch64-linux-gnu -Dmbim_qmux=false -Dqrtr=false
ninja -C build
ninja -C build install

# build ModemManager
cd /tmp
apt install -y gettext libpolkit-gobject-1-dev

git clone -b $MM_VERSION https://gitlab.freedesktop.org/mobile-broadband/ModemManager.git

cd ModemManager
meson setup build --prefix=/usr --libdir=/usr/lib/aarch64-linux-gnu --sysconfdir=/etc --buildtype=release \
      -Dqmi=true -Dmbim=false -Dqrtr=false -Dplugin_foxconn=disabled -Dplugin_dell=disabled \
      -Dplugin_altair_lte=disabled -Dplugin_fibocom=disabled

ninja -C build
