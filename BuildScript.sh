#!/bin/sh

#  BuildScript.sh
#  PSIReader
#
#  Created by Hai Hw on 19/2/17.
#  Copyright © 2017 Hai Hw. All rights reserved.


#Clean target
xcodebuild clean -project PSIReader.xcodeproj -configuration Release -alltargets

#Archive
xcodebuild archive -project PSIReader.xcodeproj -scheme PSIReader -archivePath PSIReader.xcarchive
#Get version from command parameter or plist file
if [ -n "$1" ]
then
VERSION=$1
#Write version to plist file
plutil -replace CFBundleShortVersionString -string $1 PSIReader/Info.plist
else
VERSION=$(/usr/libexec/PlistBuddy -c "print :CFBundleShortVersionString" PSIReader/Info.plist)
fi

FILENAME="PSIReader_v."$VERSION

#Export Archive
xcodebuild -exportArchive -archivePath PSIReader.xcarchive -exportPath $FILENAME -exportFormat ipa -exportSigningIdentity "iPhone Distribution: Hai Nguyen Huu Hiep (47NZJ66X5R)"

#Delete the archive file
rm -rf PSIReader.xcarchive