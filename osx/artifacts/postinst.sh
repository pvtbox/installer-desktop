#!/usr/bin/env bash

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
sudo -u $USER pluginkit -a ~/Applications/Pvtbox.app/Contents/PlugIns/PvtboxFinderSync.appex || true
sudo -u $USER pluginkit -a ~/Applications/Pvtbox.app/Contents/PlugIns/PvtboxShareExtension.appex || true
sudo -u $USER pluginkit -e use -i net.pvtbox.Pvtbox.PvtboxFinderSync || true
sudo -u $USER pluginkit -e use -i net.pvtbox.Pvtbox.PvtboxShareExtension || true
sudo -u $USER pluginkit -e use -i net.pvtbox.Pvtbox || true

sudo -u $USER bash -c "sleep 5; open ~/Applications/Pvtbox.app" > /dev/null 2>&1 & disown $!

exit 0

