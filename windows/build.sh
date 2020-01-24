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
#### Get version from pvtbox binary ####

cd artifacts
VERSION=`python -c "import __version; print(__version.__version__)"`
cd -

echo version is ${VERSION}

mkdir build
echo ${VERSION} > build/version

#### Offline x64 installer ####

sed "s/\${VERSION}/${VERSION}/" installer.iss.template | sed "s/\${UPDATE_BRANCH}/${UPDATE_BRANCH}/" | sed "s/\${IS_OFFLINE}/True/" | sed "s/\${SETUP_NAME}/PvtboxSetup-offline_x64/" > installer-offline_x64.iss

rm -f artifacts/x64.zip && touch artifacts/x64.zip
rm -f artifacts/x86.zip && touch artifacts/x86.zip

rm -f artifacts/PvtboxIntegration.exe
cp PvtboxExplorerIntegration.exe artifacts/PvtboxIntegration.exe

cd artifacts/x64 && cmake -E tar cf ../x64.zip * --format=zip  && cd -

"C:/Program Files (x86)/Inno Setup 5/iscc.exe" installer-offline_x64.iss


#### Offline x86 installer ####

sed "s/\${VERSION}/${VERSION}/" installer.iss.template | sed "s/\${UPDATE_BRANCH}/${UPDATE_BRANCH}/" | sed "s/\${IS_OFFLINE}/True/" | sed "s/\${SETUP_NAME}/PvtboxSetup-offline_x86/" > installer-offline_x86.iss

rm -f artifacts/x64.zip && touch artifacts/x64.zip
rm -f artifacts/x86.zip && touch artifacts/x86.zip

rm -f artifacts/PvtboxIntegration.exe
cp PvtboxExplorerIntegration.exe artifacts/PvtboxIntegration.exe

cd artifacts/x86 && cmake -E tar cf ../x86.zip * --format=zip && cd -

"C:/Program Files (x86)/Inno Setup 5/iscc.exe" installer-offline_x86.iss


#### Online installer ####

sed "s/\${VERSION}/${VERSION}/" installer.iss.template | sed "s/\${UPDATE_BRANCH}/${UPDATE_BRANCH}/" | sed "s/\${IS_OFFLINE}/False/" | sed "s/\${SETUP_NAME}/PvtboxSetup/" > installer.iss

rm -f artifacts/x64.zip && touch artifacts/x64.zip
rm -f artifacts/x86.zip && touch artifacts/x86.zip

rm -f artifacts/PvtboxIntegration.exe
cp PvtboxSystemIntegration.exe artifacts/PvtboxIntegration.exe

"C:/Program Files (x86)/Inno Setup 5/iscc.exe" installer.iss

cd artifacts/x64 && cmake -E tar cf ../x64.zip * --format=zip  && cd -
cd artifacts/x86 && cmake -E tar cf ../x86.zip * --format=zip && cd -

