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

mkdir -p artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS
mkdir -p artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks
mkdir -p artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Resources

mv -f artifacts/service.app/Contents/MacOS/*.dylib artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/service.app/Contents/MacOS/*.so artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/service.app/Contents/MacOS/Qt* artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks/

mv -f artifacts/app.app/Contents/MacOS/*.dylib artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/app.app/Contents/MacOS/*.so artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/app.app/Contents/MacOS/Qt* artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks/
mv -f artifacts/app.app/Contents/MacOS/PySide2 artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Frameworks/

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
rm -rf artifacts/service.app/Contents/MacOS/PySide2

cp -rf artifacts/app.app/Contents/MacOS/. artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS/
cp -rf artifacts/service.app/Contents/MacOS/. artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS/

cp -rf artifacts/service.app/Contents/Resources/. artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Resources/

cp artifacts/Info.plist.internal artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Info.plist

pushd artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS
ln -s ../Frameworks/* ./
popd

echo version is ${VERSION}
echo ${VERSION} > version

mv artifacts/pvtbox-service artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS/Pvtbox-Service
mv artifacts/pvtbox artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/MacOS/Pvtbox
cp artifacts/license-en.rtf artifacts/Pvtbox.app/Contents/LICENSE.rtf
cp artifacts/third_party.rtf artifacts/Pvtbox.app/Contents/THIRD_PARTY_LICENSES.rtf
cp artifacts/Pvtbox.app/Contents/Resources/default.icns artifacts/Pvtbox.app/Contents/Pvtbox.app/Contents/Resources/

pushd artifacts/Pvtbox.app/Contents/PlugIns/PvtboxFinderSync.appex/Contents/Frameworks/SocketRocket.framework/
rm -rf Versions/Current
pushd Versions
ln -s A Current
popd
rm -rf Resources
ln -s Versions/Current/Resources Resources
rm -rf SocketRocket
ln -s Versions/Current/SocketRocket SocketRocket
popd
        
pushd artifacts/Pvtbox.app/Contents/PlugIns/PvtboxShareExtension.appex/Contents/Frameworks/SocketRocket.framework/
rm -rf Versions/Current
pushd Versions
ln -s A Current
popd
rm -rf Resources
ln -s Versions/Current/Resources Resources
rm -rf SocketRocket
ln -s Versions/Current/SocketRocket SocketRocket
popd

ditto -c -k --sequesterRsrc artifacts/Pvtbox.app Pvtbox.app.zip

       

# portable

cp -RP artifacts/Pvtbox.app Pvtbox.app

rm -rf Pvtbox.app/Contents/PlugIns
rm -rf Pvtbox.app/Contents/uninstall.app
rm -rf PvtBox.app/Contents/Resources/*.workflow
cp main.scpt Pvtbox.app/Contents/Resources/Scripts/main.scpt
patch --forward Pvtbox.app/Contents/Info.plist < portable.patch
rm Pvtbox.app/Contents/Info.plist.*
        
ditto -c -k --sequesterRsrc --keepParent Pvtbox.app Pvtbox-portable.app.zip

