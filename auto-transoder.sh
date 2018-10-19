#!/bin/sh

# Set Debugging
# set -x;

echo "Please insert the video's URL: ";
read -r URL;

if [[ -z $URL ]]; then
	echo "Error: Empty URL provided";
else
	while [ true ]; do

		echo "What do you want to do?";
		echo "1. View available formats of media.";
		echo "2. Download media.";
		echo "3. Download & Transcode media to highest quality audio.";
		echo "['q': exit]";
		echo ": ";
		read -r OPTION;

		if [[ "$OPTION" == "q" ]]; then
			exit;
		elif [[ "$OPTION" == "1" ]]; then
			youtube-dl "$URL" -F;
		elif [[ "$OPTION" == "2" ]]; then
			echo "Please insert the media's format id: ";
			read -r FORMAT;
			youtube-dl "$URL" -f "$FORMAT";
		elif [[ "$OPTION" == "3" ]]; then
			ID=`youtube-dl "$URL" --get-id`;
			TITLE=`youtube-dl "$URL" --get-title`;
			FILE="./$ID.webm";
			TARGET="$TITLE-$ID.ogg";

			youtube-dl "$URL" -f 171 --id -q;
			ffmpeg -i "$FILE" -vn -b:a 128k -vol 270 -codec libvorbis "$TARGET";
			rm "$FILE";

			echo "Audio ready @:\"./$TARGET\"";
		fi;

	done
fi;