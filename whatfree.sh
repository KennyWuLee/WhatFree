#!/bin/bash

username=""
password=""
downloadDir="/path/to/downloadfolder/"


free=$(curl -L -s -b "cookie.txt" -c "cookie.txt"\
 "https://what.cd/torrents.php?freetorrent=1")
if echo "$free" | grep "<title>Login :: What.CD</title>" > /dev/null
then
	curl -L -s -b "cookie.txt" -c "cookie.txt"\
	 -d "username=$username&password=$password&keeplogged=1" \
	 "https://what.cd/login.php" > /dev/null
	free=$(curl -L -s -b "cookie.txt" -c "cookie.txt"\
	 "https://what.cd/torrents.php?freetorrent=1")
fi
echo "$free" |\
 sed -n '/action=download/ s/.*href..\(.*\)..class.*/\1/p' |\
 sed 's/\&amp;/\&/g' |\
 while read link
 do
 	wget -O "$downloadDir$(echo $link | sed 's/.*download.id=\([0-9]*\).*/\1/').torrent"\
 	 -nc "https://what.cd/$link"
 done 
