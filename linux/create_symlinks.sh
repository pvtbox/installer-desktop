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
# Replace files with symlinks on Ubuntu since version 18.04


for FILE in *.so*
do
  if [[ "$FILE" =~ ^libQt5.* ]]
  then
    continue
  fi

  if [ -f "/lib/x86_64-linux-gnu/$FILE" ]
  then
    ln -sfv "/lib/x86_64-linux-gnu/$FILE" "$FILE"
  fi

  if [ -f "/usr/lib/x86_64-linux-gnu/$FILE" ]
  then
    ln -sfv "/usr/lib/x86_64-linux-gnu/$FILE" "$FILE"
  fi

  if [ -f "/usr/lib/python3.7/lib-dynload/$FILE" ]
  then
    ln -sfv "/usr/lib/python3.7/lib-dynload/$FILE" "$FILE"
  fi
done

