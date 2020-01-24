

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
#Install script for Ubuntu & Debian
UID_CHECK=$(whoami)
SUDO=$(command -v sudo)
DistrID=$( lsb_release -i | awk '{print $3}')
install_pvtbox () {
    echo "start install"
    if [ -z "$(dpkg -l | grep apt-transport-https)" ] ; then $1 apt-get install -y apt-transport-https ; fi
    $1 wget -O - https://mirror.pvtbox.net/pvtbox.net.gpg |$1 apt-key add -
    if [ "$DistrID" = "Ubuntu" ];
    then
        $1 add-apt-repository "deb http://mirror.pvtbox.net/ stretch main"
    else
        $1 echo "deb http://mirror.pvtbox.net/ stretch main" >> /etc/apt/sources.list
    fi
    $1 apt-get update
    echo "success"
}


if [ $(whoami) == "root" ]
then
    install_pvtbox
elif [ -n $(command -v sudo) ]
then
    install_pvtbox sudo
else
    echo "you must be root or installed sudo"
fi
