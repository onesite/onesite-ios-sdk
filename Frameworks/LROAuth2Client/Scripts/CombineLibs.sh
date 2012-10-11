#!/bin/sh

set -e

FLAVOR=""
NAME=libLROAuth2Client
OUTPUT_DIR=${BUILD_DIR}/Combined${BUILD_STYLE}${FLAVOR}
OUTPUT_FILE=${NAME}${FLAVOR}.a
ZIP_DIR=${BUILD_DIR}/Zip

if [ ! -d ${OUTPUT_DIR} ]; then
	mkdir ${OUTPUT_DIR}
fi

# Combine lib files
lipo -create "${BUILD_DIR}/${BUILD_STYLE}-iphoneos/${NAME}-Device${FLAVOR}.a" "${BUILD_DIR}/${BUILD_STYLE}-iphonesimulator/${NAME}-Simulator${FLAVOR}.a" -output ${OUTPUT_DIR}/${OUTPUT_FILE}

# Copy to direcory for zipping 
if [ ! -d ${ZIP_DIR} ]; then
  mkdir ${ZIP_DIR}
fi
cp ${OUTPUT_DIR}/${OUTPUT_FILE} ${ZIP_DIR}
cp ${BUILD_DIR}/${BUILD_STYLE}-iphonesimulator/usr/local/include/*.h ${ZIP_DIR}

cd ${ZIP_DIR}
zip -m ${NAME}${FLAVOR}.zip *
mv ${NAME}${FLAVOR}.zip ..
rm -rf ${ZIP_DIR}
