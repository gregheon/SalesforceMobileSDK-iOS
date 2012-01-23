#!/bin/bash
# Running this script will install all dependencies needed for all of the projects, 
# as well as generating the latest .h and template files.

# Xcode 4 is a requirement to build.
xcodebuild_version=`xcodebuild -version`
xcode4_installed=`echo "$xcodebuild_version" | grep -E 'Xcode 4(\.\d+)?'`
if [ "$xcode4_installed" = "" ]
then
    echo "Xcode 4 is a prerequisite to build the iOS SDK."
    echo "Current installed version: $xcodebuild_version"
    exit 1
fi

# ensure that we have the correct version of all submodules
git submodule init
git submodule sync
git submodule update

CURRENT_DIR=`pwd`


# keep anything existing in /dist

# clean our xcode templates for reinstallation
cd $CURRENT_DIR/hybrid/sfdc_build
ant clean
cd $CURRENT_DIR/native/sfdc_build
ant clean

# clean sample apps
cd $CURRENT_DIR/native/SampleApps/RestAPIExplorer/sfdc_build
ant clean
cd $CURRENT_DIR/hybrid/SampleApps/ContactExplorer/sfdc_build
ant clean
cd $CURRENT_DIR/hybrid/SampleApps/VFConnector/sfdc_build
ant clean


# build salesforce libraries and install templates
cd $CURRENT_DIR/hybrid/sfdc_build
ant install

cd $CURRENT_DIR/native/sfdc_build
ant install

# build sample apps with dependencies
cd $CURRENT_DIR/native/SampleApps/RestAPIExplorer/sfdc_build
ant
cd $CURRENT_DIR/hybrid/SampleApps/ContactExplorer/sfdc_build
ant
cd $CURRENT_DIR/hybrid/SampleApps/VFConnector/sfdc_build
ant

