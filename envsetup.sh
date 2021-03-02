#!/bin/bash
#setup enviroment for building project NOTE: script must be launched as root.
cd env
if [[ ! -f raspi-toolchain.tar.gz ]]
then
    wget https://github.com/Pro/raspi-toolchain/releases/latest/download/raspi-toolchain.tar.gz
fi
# NOTE: The toolchain has to be in /opt/cross-pi-gcc since it's not location independent.
if [[ ! -d /opt/cross-pi-gcc/ ]]
then
    tar xfz raspi-toolchain.tar.gz --strip-components=1 -C /opt
fi

if [[ ! -d rootfs ]]
then
    mkdir rootfs/
fi
rsync -vR --progress -rl --safe-links pi@raspberrypi.local:/{lib,usr,opt/vc/lib} ${PWD}/rootfs

if [[ ! -f Toolchain-rpi.cmake ]]
then
    wget https://raw.githubusercontent.com/Pro/raspi-toolchain/master/Toolchain-rpi.cmake
fi