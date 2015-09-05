#!/bin/bash

set -e

BUNDLER_DIR=$(pwd)

COVERAGE_DIR="$BUNDLER_DIR/../sublime-coverage"

TAG_NAME=$1

if [[ $TAG_NAME == "" ]]; then
    echo "Usage: ./update.sh {tag_name}"
    exit 1
fi

BASE_URL="https://github.com/codexns/coverage-build/releases/download"

TMP_DIR="$BUNDLER_DIR/tmp"

download_extract() {
    PLAT_ARCH="$1"
    ST_DIR="$2"
    COPY_PY_FILES="$3"

    if [[ -e $TMP_DIR/$PLAT_ARCH ]]; then
        rm -R $TMP_DIR/$PLAT_ARCH
    fi
    mkdir -p $TMP_DIR/$PLAT_ARCH

    cd $TMP_DIR/$PLAT_ARCH

    if [[ $PLAT_ARCH =~ linux ]]; then
        SUFFIX=".tar.gz"
        EXTRACT_COMMAND="tar xvfz"
        if [[ $PLAT_ARCH =~ 33 ]]; then
            SO_EXT=".cpython-33m.so"
        else
            SO_EXT=".so"
        fi
    elif [[ $PLAT_ARCH =~ osx ]]; then
        SUFFIX=".zip"
        EXTRACT_COMMAND="unzip"
        SO_EXT=".so"
    else
        SUFFIX=".zip"
        EXTRACT_COMMAND="unzip"
        SO_EXT=".pyd"
    fi

    ARCHIVE_NAME="${TAG_NAME}_${PLAT_ARCH}${SUFFIX}"

    curl -O --location $BASE_URL/$TAG_NAME/$ARCHIVE_NAME
    $EXTRACT_COMMAND $ARCHIVE_NAME
    rm $ARCHIVE_NAME

    if [[ -e $COVERAGE_DIR/$ST_DIR ]]; then
        rm -R $COVERAGE_DIR/$ST_DIR
    fi
    mkdir -p $COVERAGE_DIR/$ST_DIR/coverage/

    mv coverage/tracer$SO_EXT $COVERAGE_DIR/$ST_DIR/coverage/
    
    if [[ $COPY_PY_FILES != "" ]]; then
        if [[ -e $COVERAGE_DIR/all ]]; then
            rm -R $COVERAGE_DIR/all/
        fi
        mkdir -p $COVERAGE_DIR/all/coverage/

        find coverage -type d -not -name 'coverage' -exec mkdir -p '{}' \;
        find coverage -type f -iname '*.py' -exec cp '{}' $COVERAGE_DIR/all/'{}' \;
    fi
    cd $BUNDLER_DIR
}

download_extract py26_linux-x32   st2_linux_x32    all
download_extract py26_linux-x64   st2_linux_x64
download_extract py26_osx-x64     st2_osx_x64
download_extract py26_windows-x32 st2_windows_x32
download_extract py26_windows-x64 st2_windows_x64
download_extract py33_linux-x32   st3_linux_x32
download_extract py33_linux-x64   st3_linux_x64
download_extract py33_osx-x64     st3_osx_x64
download_extract py33_windows-x32 st3_windows_x32
download_extract py33_windows-x64 st3_windows_x64

