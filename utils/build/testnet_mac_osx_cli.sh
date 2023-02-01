set -x # echo on
set +e # switch off exit on error
curr_path=$(pwd)

ARCHIVE_NAME_PREFIX=lethean-macos-cli-$(arch)-testnet-

rm -rf build; mkdir -p build/release;
cmake -H. -Bbuild/release -DHUNTER_STATUS_DEBUG=ON -DCMAKE_BUILD_TYPE=Release -DHUNTER_CONFIGURATION_TYPES=Release -DTESTNET=true -DSTATIC=true

if [ $? -ne 0 ]; then
    echo "Failed to cmake"
    exit 1
fi

cmake --build build/release -- -j2
if [ $? -ne 0 ]; then
    echo "Failed to make binaries!"
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
