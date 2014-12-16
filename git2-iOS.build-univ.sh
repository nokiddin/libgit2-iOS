#!/bin/sh

set -e;

# CONFIGURATION is Debug or Release
# PLATFORM_NAME is iphoneos or iphonesimulator
# so BUILD_DIR will usually embed ${CONFIGURATION}-${PLATFORM_NAME}

# define output folder environment variable
mytarget=git2-iOS;
myiosdevarchs="armv7 armv7s arm64";
myiossimarchs="x86_64 i386";


#### from here on is stereotypical iosetaclient configuration - do not change without deliberation.
SHWCLPUBDIR=${SRCROOT}/.build.pub.dir;
UNIV_BASEOUTDIR=${BUILD_DIR};
UNIVERSAL_OUTPUTFOLDER=${UNIV_BASEOUTDIR}/${CONFIGURATION}-universal
myoutdir=${SHWCLPUBDIR}/${PROJECT_NAME};


# myoutdir /lib   --> symlinks to $UNIV_BASEOUTDIR
# myoutdir /include   directory which copies all the contents from pub/ folder


# Step 1. Build Device and Simulator versions
xcodebuild -target "$mytarget" ARCHS="$myiosdevarchs" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos  BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}";
xcodebuild -target "$mytarget" ARCHS="$myiossimarchs" VALID_ARCHS="$myiossimarchs" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}";

# make sure the output directory exists
mkdir -p "${UNIV_BASEOUTDIR}";
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}";


# Step 2. Create universal binary file using lipo
libname=lib${PROJECT_NAME#lib}.a;
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/$libname" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/$libname" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/$libname"
echo "Built fat library at ${UNIVERSAL_OUTPUTFOLDER}/$libname";

makelink(){
    :
    local src="$1";
    local tgt="$2";
    
    [ -h "$tgt" ] && rm  "$tgt";
    ln -s "$src" "$tgt";
}

[ -d "$SHWCLPUBDIR" ] || mkdir -p $SHWCLPUBDIR;
[ -d "$myoutdir" ] || mkdir -p $myoutdir;
makelink "${UNIV_BASEOUTDIR}" "$myoutdir/lib";

# here, for include, we don't symlink as we need the build to complete.
# This behavior is by design.
# symlinking will directly expose source level errors in this project into projects dependent on this project. copy will provide the necessary isolation as it won't occur
#   until this project has been completely built.
mkdir -p "$myoutdir/include";
if [ -d "$SRCROOT"/pub ] ; then 
cp -R "${SRCROOT}"/pub/* "$myoutdir/include";
fi
if [ -f "$SRCROOT"/pubincdirs.list ]; then 
rsync -av --files-from="${SRCROOT}"/pubincdirs.list ${SRCROOT} "$myoutdir/include";
fi


echo "OK    | ${PROJECT_NAME} | build-univ" 1>&2 ; 

