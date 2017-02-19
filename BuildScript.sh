#!/bin/sh

#  BuildScript.sh
#  PSIReader
#
#  Created by Hai Hw on 19/2/17.
#  Copyright © 2017 Hai Hw. All rights reserved.

pod install
#Clean target
xcodebuild clean -workspace PSIReader.xcworkspace -configuration Release -alltargets

#Archive
xcodebuild archive -workspace PSIReader.xcworkspace -scheme PSIReader -archivePath PSIReader.xcarchive
#Get version from command parameter or plist file
if [ -n "$1" ]
then
VERSION=$1
#Write version to plist file
plutil -replace CFBundleShortVersionString -string $1 PSIReader/Info.plist
else
VERSION=$(/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" PSIReader/Info.plist)
fi

FILENAME="Deliverables/PSIReader_v."$VERSION

if [[ -e $FILENAME.ipa ]] ; then
   i=0
   while [[ -e $FILENAME-$i.ipa ]] ; do
      let i++
   done
   FILENAME=$FILENAME-$i
fi

#Export Archive
xcodebuild -exportArchive -archivePath PSIReader.xcarchive -exportPath $FILENAME -exportFormat ipa -exportSigningIdentity "iPhone Distribution: Hai Nguyen Huu Hiep (47NZJ66X5R)"

#Delete the archive file
rm -rf PSIReader.xcarchive
