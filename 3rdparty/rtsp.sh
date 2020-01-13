#!/bin/bash
#/*
# * This file is part of the NextDom software (https://github.com/NextDom or http://nextdom.github.io).
# * Copyright (c) 2018 NextDom - Slobberbone.
# *
# * This program is free software: you can redistribute it and/or modify
# * it under the terms of the GNU General Public License as published by
# * the Free Software Foundation, version 2.
# *
# * This program is distributed in the hope that it will be useful, but
# * WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# * General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with this program. If not, see <http://www.gnu.org/licenses/>.
# */
apacheDirectory=/var/www/html/core
nginxDirectory=/usr/share/nginx/www/jeedom

touch $3/snapshot_$4.jpg
if [ -d "$apacheDirectory" ]; then
  ln -s $3/snapshot_$4.jpg /var/www/html/plugins/RTSP/captures/snapshot_$4.jpg
  chmod 666 /var/www/html/plugins/RTSP/captures/snapshot_$4.jpg
  chown www-data:www-data /var/www/html/plugins/RTSP/captures/snapshot_$4.jpg
fi

if [ -d "$nginxDirectory" ]; then
  ln -s $3/snapshot_$4.jpg /usr/share/nginx/www/jeedom/plugins/RTSP/captures/snapshot_$4.jpg
  chmod 666 /usr/share/nginx/www/jeedom/plugins/RTSP/captures/snapshot_$4.jpg
  chown www-data:www-data /usr/share/nginx/www/jeedom/plugins/RTSP/captures/snapshot_$4.jpg
fi

url=""
if [ ${10} != '' ]
then
  url="${10}:${11}@"
fi
complement=$(echo "$7" | sed 's/[\]//g')    # substitute to escape the ampersand
while sleep $6
do
if [ $9 -eq 1 ]
then
  datetime=$(echo $(date +%Y-%m-%dT%H\\:%M\\:%S))
  displayInfo="drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf: text='$datetime': fontcolor=black@0.8: x=50: y=60"
  /usr/bin/ffmpeg -i $1://$url$2:$5$complement -s $8 -frames:v 1  -an -vf "$displayInfo" -y $3/snapshot_$4.jpg > $3/$4.log 2>&1
else
  /usr/bin/ffmpeg -i $1://$url$2:$5$complement -s $8 -frames:v 1  -an -y $3/snapshot_$4.jpg > $3/$4.log 2>&1
fi
done
