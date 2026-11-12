@echo off
REM ===========================================================================
REM  OrcaSlicer Nonplanar - Windows build helper
REM
REM  Applies the nonplanar patches to an OrcaSlicer 2.4.2 checkout and builds it.
REM  Run this from the folder that contains your OrcaSlicer checkout, with the
REM  patch repository next to it, or set the two paths below.
REM
REM  Usage:  build-windows.cmd deps     build the dependencies (first time only)
REM          build-windows.cmd slicer   build OrcaSlicer
REM          build-windows.cmd installer  build the NSIS installer (cpack)
REM ===========================================================================
setlocal

REM ---- paths (edit if needed) -----------------------------------------------
if "%ORCA_SRC%"=="" set "ORCA_SRC=%~dp0..\..\orca-np"
if "%PATCH_DIR%"=="" set "PATCH_DIR=%~dp0.."
if "%CMAKE_BIN%"=="" set "CMAKE_BIN=C:\Program Files\CMake\bin"
if "%PERL_BIN%"=="" set "PERL_BIN=C:\Strawberry\c\bin"

REM ---- environment ----------------------------------------------------------
set "PATH=%CMAKE_BIN%;%PERL_BIN%;%PATH%"
set "CMAKE_POLICY_VERSION_MINIMUM=3.5"
set "git_commit_hash=8500fcdccaa10b5099ac20d252af3a7c560046f1"

if not exist "%ORCA_SRC%\version.inc" (
    echo OrcaSlicer source not found at "%ORCA_SRC%".
    echo Set ORCA_SRC to your OrcaSlicer 2.4.2 checkout.
    exit /b 1
)

cd /d "%ORCA_SRC%" || exit /b 1

REM ---- apply the patches if they are not applied yet -------------------------
findstr /C:"ORCA_NONPLANAR_VERSION" version.inc >nul 2>nul
if errorlevel 1 (
    echo Applying orca-nonplanar.patch ...
    git apply "%PATCH_DIR%\orca-nonplanar.patch" || exit /b 1
)
findstr /C:"OrcaSlicerNonplanar" CMakeLists.txt >nul 2>nul
if errorlevel 1 (
    echo Applying windows\orca-nonplanar-windows.patch ...
    git apply "%PATCH_DIR%\windows\orca-nonplanar-windows.patch" || exit /b 1
)

REM ---- build ----------------------------------------------------------------
if /I "%1"=="installer" (
    if not exist build (
        echo Build the slicer first: build-windows.cmd slicer
        exit /b 1
    )
    cd build
    cpack -G NSIS -C Release
    exit /b %errorlevel%
)

build_release_vs2022.bat %*
exit /b %errorlevel%
