@ECHO OFF
call extras\win\configure_local_paths.cmd

SET LOCAL_BOOST_LIB_PATH=%LOCAL_BOOST_PATH%\lib64-msvc-14.2
SET QT_MSVC_PATH=%QT_PREFIX_PATH%\msvc2019_64

SET ACHIVE_NAME_PREFIX=lethean-win-cli-x64-
SET MY_PATH=%~dp0
SET SOURCES_PATH=%MY_PATH:~0,-13%

IF NOT [%build_prefix%] == [] (
  SET ACHIVE_NAME_PREFIX=%ACHIVE_NAME_PREFIX%%build_prefix%-
)

SET TESTNET_DEF=-D TESTNET=TRUE
SET TESTNET_LABEL=testnet
SET ACHIVE_NAME_PREFIX=%ACHIVE_NAME_PREFIX%testnet-


@echo on

set BOOST_ROOT=%LOCAL_BOOST_PATH%
set BOOST_LIBRARYDIR=%LOCAL_BOOST_LIB_PATH%



@echo "---------------- PREPARING BINARIES ---------------------------"
@echo "---------------------------------------------------------------"

cd %SOURCES_PATH%
rmdir build /s /q
mkdir build

@echo "---------------- BUILDING APPLICATIONS ------------------------"
@echo "---------------------------------------------------------------"

cd %SOURCES_PATH%\build
cmake -H. -Bbuild/release -D CMAKE_BUILD_TYPE=Release -D STATIC=ON -D TESTNET=ON -G "Visual Studio 17 2022"
IF %ERRORLEVEL% NEQ 0 (
  goto error
)

cmake --build build/release -- -j10

IF %ERRORLEVEL% NEQ 0 (
  goto error
)

@echo on
echo "sources are built successfully"

:skip_build
cd %SOURCES_PATH%/build

set cmd=src\release\simplewallet.exe --version
FOR /F "tokens=3" %%a IN ('%cmd%') DO set version=%%a
echo '%version%'
set version=%version:~0,-2%
echo '%version%'

set build_zip_filename=%ACHIVE_NAME_PREFIX%%version%.zip
set build_zip_path=%SOURCES_PATH%\%build_zip_filename%

del /F /Q %build_zip_path%

cd src\release

@echo on

mkdir bunch

copy /Y letheand.exe bunch
copy /Y simplewallet.exe bunch
copy /Y *.pdb bunch

cd bunch

zip -r %build_zip_path% *.*
IF %ERRORLEVEL% NEQ 0 (
  goto error
)

goto success

:error
echo "BUILD FAILED"
exit /B %ERRORLEVEL%

:success
echo "BUILD SUCCESS"

cd ..

EXIT /B %ERRORLEVEL%


:: functions
:sha256
@setlocal enabledelayedexpansion
@set /a count=1
@for /f "skip=1 delims=:" %%a in ('CertUtil -hashfile %1 SHA256') do @(
  @if !count! equ 1 set "hash=%%a"
  @set /a count+=1
)
@(
 @endlocal
 @set "%2=%hash: =%
)
@exit /B 0
