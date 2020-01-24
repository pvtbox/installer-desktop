#!/bin/sh
###############################################################################
#   
#   Pvtbox. Fast and secure file transfer & sync directly across your devices. 
#   Copyright © 2020  Pb Private Cloud Solutions Ltd. 
#   
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#   
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.
#   
###############################################################################
# Shell script for build os x package of pvtbox.
#

set -xe

pushd artifacts
VERSION=`python -c "import __version; print __version.__version__"`
popd

sed -i.bak "s/{VERSION}/${VERSION}/" Pvtbox.pkgproj

mkdir -p artifacts/Pvtbox.app/Contents/Frameworks

mkdir -p artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS
mkdir -p artifacts/Pvtbox.app/Contents/PvtboxService.app/Contents/MacOS

pushd artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents
ln -s ../../Frameworks Frameworks
ln -s ../../Resources Resources
popd

pushd artifacts/Pvtbox.app/Contents/PvtboxService.app/Contents
ln -s ../../Frameworks Frameworks
ln -s ../../Resources Resources
popd

cp -f artifacts/pvtbox-service artifacts/service.app/Contents/MacOS/Pvtbox-Service
cp -f artifacts/pvtbox artifacts/app.app/Contents/MacOS/Pvtbox

mv -f artifacts/service.app/Contents/MacOS/*.dylib artifacts/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/service.app/Contents/MacOS/*.so artifacts/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/service.app/Contents/MacOS/Qt* artifacts/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/service.app/Contents/MacOS/PySide2 artifacts/Pvtbox.app/Contents/Frameworks/

mv -f artifacts/app.app/Contents/MacOS/*.dylib artifacts/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/app.app/Contents/MacOS/*.so artifacts/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/app.app/Contents/MacOS/Qt* artifacts/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/app.app/Contents/MacOS/PySide2/*.so artifacts/Pvtbox.app/Contents/Frameworks/PySide2/

pushd artifacts/Pvtbox.app/Contents/Frameworks
ln -s ../Resources/* .
popd

rm -rf artifacts/app.app/Contents/MacOS/*.dylib
rm -rf artifacts/app.app/Contents/MacOS/*.so
rm -rf artifacts/app.app/Contents/MacOS/Qt*
rm -rf artifacts/app.app/Contents/MacOS/PySide2
rm -rf artifacts/app.app/Contents/MacOS/*.egg-info

rm -rf artifacts/app.app/Contents/MacOS/include
rm -rf artifacts/app.app/Contents/MacOS/lib
rm -rf artifacts/service.app/Contents/MacOS/include
rm -rf artifacts/service.app/Contents/MacOS/lib
rm -rf artifacts/service.app/Contents/MacOS/*.egg-info

cp -rf artifacts/app.app/Contents/MacOS/. artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS/
cp -rf artifacts/service.app/Contents/MacOS/. artifacts/Pvtbox.app/Contents/PvtboxService.app/Contents/MacOS/

cp -rf artifacts/service.app/Contents/Resources/. artifacts/Pvtbox.app/Contents/Resources/


cp artifacts/Info.plist.internal artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Info.plist
cp artifacts/Info.plist.service artifacts/Pvtbox.app/Contents/PvtboxService.app/Contents/Info.plist

cat artifacts/app.patch | patch -p1 || true

rm -f artifacts/Pvtbox.app/Contents/Info.plist.orig
chmod a+x artifacts/postinst.sh

pushd artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS
#ln -s ../Resources/db_migration ./
#ln -s ../Resources/language ./
#ln -s ../Resources/certifi ./
ln -s ../../../Frameworks/* .
popd

pushd artifacts/Pvtbox.app/Contents/PvtboxService.app/Contents/MacOS
#ln -s ../Resources/db_migration ./
#ln -s ../Resources/language ./
#ln -s ../Resources/certifi ./
ln -s ../../../Frameworks/* .
popd

echo version is ${VERSION}

echo ${VERSION} > version

codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/postinst.sh
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS/Pvtbox
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Pvtbox.app
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/PvtboxService.app/Contents/MacOS/Pvtbox-Service
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/PvtboxService.app
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/uninstall.app
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force 'artifacts/Pvtbox.app/Contents/Resources/Copy to Pvtbox sync folder.workflow'
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Frameworks/*.so
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Frameworks/**/*.so
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Frameworks/*.dylib
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Frameworks/**/**/**/*.dylib
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Frameworks/Qt*
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/Resources/Scripts/*
#codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/MacOS/applet
#codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/PlugIns/PvtboxFinderSync.appex/Contents/MacOS/PvtboxFinderSync
#codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --deep --force artifacts/Pvtbox.app/Contents/PlugIns/PvtboxFinderSync.appex
codesign -s 587E5882AD3DD26EED5B4F31EB4B3C2A272E70E1 --force artifacts/Pvtbox.app

cp artifacts/license-en.rtf artifacts/Pvtbox.app/Contents/LICENSE.rtf
cp artifacts/third_party.rtf artifacts/Pvtbox.app/Contents/THIRD_PARTY_LICENSES.rtf

packagesbuild Pvtbox.pkgproj

mv build/Pvtbox.pkg Pvtbox_${VERSION}.pkg

