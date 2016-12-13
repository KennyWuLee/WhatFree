#!/bin/bash

username=""
password=""
downloadDir="/path/to/downloadfolder/"
url="passtheheadphones.me"

free=$(curl -L -s -b "cookie.txt" -c "cookie.txt"\
 "https://$url/torrents.php?freetorrent=1")
if echo "$free" | grep "<title>Login ::" > /dev/null
then
	curl -L -s -b "cookie.txt" -c "cookie.txt"\
	 -d "username=$username&password=$password&keeplogged=1" \
	 "https://$url/login.php" > /dev/null
	free=$(curl -L -s -b "cookie.txt" -c "cookie.txt"\
	 "https://$url/torrents.php?freetorrent=1")
fi
echo "$free" |\
 sed -n '/action=download/ s/.*href..\(.*\)..class.*/\1/p' |\
 sed 's/\&amp;/\&/g' |\
 while read link
 do
 	wget -O "$downloadDir$(echo $link | sed 's/.*download.id=\([0-9]*\).*/\1/').torrent"\
 	 -nc "https://$url/$link"
 done 
