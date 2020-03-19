#!/bin/bash
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
# Shell script for build debian package of pvtboxd.
#
# dependences:
# sudo apt-get install dpkg debconf debhelper lintian md5deep

VERSION=$(grep -Po "^__version__ = u'\K(\d+.\d+.\d+.\d+)" dist/__version.py) || exit 1
echo version is ${VERSION} || exit 1

mkdir -p dist/pvtboxd/DEBIAN
mkdir -p dist/pvtboxd/opt/pvtbox
mkdir -p dist/pvtboxd/usr/bin
mkdir -p dist/pvtboxd/usr/share/doc/pvtbox

eval "echo \"$(cat control.template.d)\"" > dist/pvtboxd/DEBIAN/control || exit 1
cp copyright dist/pvtboxd/usr/share/doc/pvtbox/copyright || exit 1
cp license.rtf dist/pvtboxd/usr/share/doc/pvtbox/LICENSE.rtf || exit 1
cp third_party.rtf dist/pvtboxd/usr/share/doc/pvtbox/THIRD_PARTY_LICENSES.rtf || exit 1

unzip -o dist/launcher.zip -d dist/tmp || exit 1
cp -rf dist/tmp/launcher/* dist/pvtboxd/opt/pvtbox || exit 1
unzip -o dist/service.zip -d dist/tmp || exit 1
cp -rf dist/tmp/service/* dist/pvtboxd/opt/pvtbox || exit 1
rm -rf dist/tmp

# Remove unused files
rm_list=(
    PySide2/translations
    PySide2/qml
    libQt53DAnimation.so.5
    libQt53DCore.so.5
    libQt53DExtras.so.5
    libQt53DInput.so.5
    libQt53DLogic.so.5
    libQt53DQuickAnimation.so.5
    libQt53DQuickExtras.so.5
    libQt53DQuickInput.so.5
    libQt53DQuickRender.so.5
    libQt53DQuickScene2D.so.5
    libQt53DQuick.so.5
    libQt53DRender.so.5
    libQt5Bluetooth.so.5
    libQt5Bodymovin.so.5
    libQt5Concurrent.so.5
    libQt5DataVisualization.so.5
    libQt5DBus.so.5
    libQt5EglFSDeviceIntegration.so.5
    libQt5Gamepad.so.5
    libQt5Location.so.5
    libQt5MultimediaQuick.so.5
    libQt5Multimedia.so.5
    libQt5Nfc.so.5
    libQt5PositioningQuick.so.5
    libQt5Positioning.so.5
    libQt5Purchasing.so.5
    libQt5QuickControls2.so.5
    libQt5QuickParticles.so.5
    libQt5QuickShapes.so.5
    libQt5Quick.so.5
    libQt5QuickTemplates2.so.5
    libQt5QuickTest.so.5
    libQt5RemoteObjects.so.5
    libQt5Scxml.so.5
    libQt5Sensors.so.5
    libQt5Sql.so.5
    libQt5Test.so.5
    libQt5VirtualKeyboard.so.5
    libQt5WebChannel.so.5
    libQt5WebEngineCore.so.5
    libQt5WebEngine.so.5
    libQt5WebSockets.so.5
    libQt5WebView.so.5
    libQt5XcbQpa.so.5
    libQt5XmlPatterns.so.5
)
for f in ${rm_list[*]}
do
    rm -vfr dist/pvtboxd/opt/pvtbox/$f
done

ln -sf /opt/pvtbox/pvtboxd dist/pvtboxd/usr/bin/pvtboxd
ln -sf /opt/pvtbox/pvtbox-service dist/pvtboxd/usr/bin/pvtbox-service

fakeroot dpkg-deb --build dist/pvtboxd dist/pvtboxd_amd64.deb || exit 1
