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
# Shell script for build debian package of pvtbox.
#
# dependences:
# sudo apt-get install dpkg debconf debhelper lintian md5deep

echo `amd64/opt/pvtbox/pvtbox -v 2>&1`
VERSION=$(grep -Po "^__version__ = u'\K(\d+.\d+.\d+.\d+)" amd64/opt/pvtbox/__version.py)

#for ARCHITECTURE in amd64 i386; do
for ARCHITECTURE in amd64; do

    echo architecture is ${ARCHITECTURE}
    echo version is ${VERSION}

    eval "echo \"$(cat control.template)\"" > ${ARCHITECTURE}/DEBIAN/control
    cp changelog ${ARCHITECTURE}/DEBIAN/changelog
    cp copyright ${ARCHITECTURE}/DEBIAN/copyright
    mkdir -p ${ARCHITECTURE}/usr/share/doc/pvtbox
    cp copyright ${ARCHITECTURE}/usr/share/doc/pvtbox/copyright
    cp license.rtf ${ARCHITECTURE}/usr/share/doc/pvtbox/LICENSE.rtf
    cp third_party.rtf ${ARCHITECTURE}/usr/share/doc/pvtbox/THIRD_PARTY_LICENSES.rtf

    fakeroot dpkg-deb --build ${ARCHITECTURE}
    mv ${ARCHITECTURE}.deb pvtbox_${VERSION}_${ARCHITECTURE}.deb
done

