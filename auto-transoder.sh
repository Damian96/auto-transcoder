#!/bin/sh

# Set Debugging
# set -x;

URL="";

getURL() {
	echo "Please insert the video's URL: ";
	read -r URL;

	if [[ -z $URL ]]; then
		echo "Error: Empty URL provided";
		exit 1;
	else
		echo "$URL";
	fi;
}

while [ true ]; do

	echo "                ###########							 ";
	echo "What do you want to do?";
	echo "1. View available formats of media.";
	echo "2. Download media.";
	echo "3. Download & Transcode media to highest quality audio.";
	echo "['q': exit]";
	echo ": ";
	read -r OPTION;

	if [[ "$OPTION" == "q" ]]; then
		echo "Bye!";
		exit 0;
	elif [[ "$OPTION" == "1" ]]; then
		getURL;
		youtube-dl "$URL" -F;
	elif [[ "$OPTION" == "2" ]]; then
		getURL;
		echo "Please insert the media's format id: ";
		read -r FORMAT;
		youtube-dl "$URL" -f "$FORMAT";
	elif [[ "$OPTION" == "3" ]]; then
		getURL;
		ID=`youtube-dl "$URL" --get-id`;
		TITLE=`youtube-dl "$URL" --get-title`;
		FILE="./$ID.webm";
		TARGET="$TITLE-$ID.ogg";

		youtube-dl "$URL" -f 171 --id -q;
		ffmpeg -i "$FILE" -vn -b:a 128k -vol 270 -codec libvorbis "$TARGET";
		rm "$FILE";

		echo "      ############		 ";
		echo "Audio ready @:\"./$TARGET\"";
		echo "      ############		 ";
	fi;
done
