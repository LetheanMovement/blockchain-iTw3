#!/bin/bash -x

# Environment prerequisites:
# 1) QT_PREFIX_PATH should be set to Qt libs folder
# 2) BOOST_ROOT should be set to the root of Boost
# 3) OPENSSL_ROOT_DIR should be set to the root of OpenSSL
#
# for example, place these lines to the end of your ~/.bashrc :
#
# export BOOST_ROOT=/home/user/boost_1_66_0
# export QT_PREFIX_PATH=/home/user/Qt5.10.1/5.10.1/gcc_64
# export OPENSSL_ROOT_DIR=/home/user/openssl

ARCHIVE_NAME_PREFIX=lethean-linux-cli-x64-testnet-

prj_root=$(pwd)

echo "---------------- BUILDING PROJECT ----------------"
echo "--------------------------------------------------"

echo "Building...."

rm -rf build; mkdir -p build/release;
cmake -H. -Bbuild/release -DCMAKE_BUILD_TYPE=Release -DHUNTER_CONFIGURATION_TYPES=Release -DTESTNET=true -DSTATIC=true

if [ $? -ne 0 ]; then
    echo "Failed to run cmake"
    exit 1
fi
cmake --build build/release -- -j2
if [ $? -ne 0 ]; then
    echo "Failed to make!"
    exit 1
fi

read version_str <<< $(./build/release/src/letheand --version | awk '/^Lethean/ { print $2 }')
version_str=${version_str}
echo $version_str

rm -rf build/Lethean;
mkdir -p build/Lethean;


cp -Rv LICENCE build/release/src/letheand build/release/src/simplewallet  build/release/src/connectivity_tool build/Lethean
chmod 0777 build/Lethean/letheand build/Lethean/simplewallet  build/Lethean/connectivity_tool

package_filename=${ARCHIVE_NAME_PREFIX}${version_str}.tar.bz2

rm -f ./$package_filename
cd build/Lethean || exit
tar -cjvf ../../$package_filename *
if [ $? -ne 0 ]; then
    echo "Failed to pack"
    exit 1
fi

echo "Build success"

exit 0
