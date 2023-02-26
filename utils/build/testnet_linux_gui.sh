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

ARCHIVE_NAME_PREFIX=lethean-gui-bundle-linux-testnet-$(arch)

: "${BOOST_ROOT:?BOOST_ROOT should be set to the root of Boost, ex.: /home/user/boost_1_66_0}"
: "${QT_PREFIX_PATH:?QT_PREFIX_PATH should be set to Qt libs folder, ex.: /home/user/Qt5.10.1/5.10.1/gcc_64}"
: "${OPENSSL_ROOT_DIR:?OPENSSL_ROOT_DIR should be set to OpenSSL root folder, ex.: /home/user/openssl}"


prj_root=$(pwd)

echo "---------------- BUILDING PROJECT ----------------"
echo "--------------------------------------------------"

echo "Building...."

rm -rf build; mkdir -p build/release; cd build/release;
cmake -D TESTNET=TRUE -D STATIC=true -D ARCH=x86-64 -D BUILD_GUI=TRUE -D OPENSSL_ROOT_DIR="$OPENSSL_ROOT_DIR" -D CMAKE_PREFIX_PATH="$QT_PREFIX_PATH" -D CMAKE_BUILD_TYPE=Release ../..
if [ $? -ne 0 ]; then
    echo "Failed to run cmake"
    exit 1
fi

make -j2 Lethean
if [ $? -ne 0 ]; then
    echo "Failed to make!"
    exit 1
fi

rm -rf Lethean;
mkdir -p Lethean;

mkdir ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libicudata.so.56 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libicui18n.so.56 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libicuuc.so.56 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Core.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5DBus.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Gui.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Network.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5OpenGL.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Positioning.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5PrintSupport.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Qml.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Quick.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Sensors.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Sql.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5Widgets.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5WebEngine.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5WebEngineCore.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5WebEngineWidgets.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5WebChannel.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5XcbQpa.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/lib/libQt5QuickWidgets.so.5 ./Lethean/lib
cp $QT_PREFIX_PATH/libexec/QtWebEngineProcess ./Lethean
cp $QT_PREFIX_PATH/resources/qtwebengine_resources.pak ./Lethean
cp $QT_PREFIX_PATH/resources/qtwebengine_resources_100p.pak ./Lethean
cp $QT_PREFIX_PATH/resources/qtwebengine_resources_200p.pak ./Lethean
cp $QT_PREFIX_PATH/resources/icudtl.dat ./Lethean


mkdir ./Lethean/lib/platforms
cp $QT_PREFIX_PATH/plugins/platforms/libqxcb.so ./Lethean/lib/platforms
mkdir ./Lethean/xcbglintegrations
cp $QT_PREFIX_PATH/plugins/xcbglintegrations/libqxcb-glx-integration.so ./Lethean/xcbglintegrations

package_filename=${ARCHIVE_NAME_PREFIX}.tar.bz2

rm -f ./$package_filename
tar -cjvf ../../$package_filename Lethean
if [ $? -ne 0 ]; then
    echo "Failed to pack"
    exit 1
fi

echo "Build success"

exit 0
