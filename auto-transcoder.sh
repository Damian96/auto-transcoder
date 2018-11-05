#!/bin/sh

# Set Debugging
# set -x;

URL="";
FILENAME="";

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

getFileName() {
	while [ true ]; do
		echo "Please insert the media's filename: ";
		read -r FILENAME;

		if [[ -f "$FILENAME" ]]; then
			echo "A file already exists, with that name. Please insert a different one.";
		else
			break;
		fi;
	done
}

while [ "$OPTION" != "q" ]; do

	echo "                ###########							 ";
	echo "What do you want to do?";
	echo "1. View available formats of media.";
	echo "2. Download media.";
	echo "3. Download & Transcode media to highest quality audio (.ogg).";
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

		getFileName;
		youtube-dl "$URL" -f "$FORMAT" -o "$FILENAME";
	elif [[ "$OPTION" == "3" ]]; then
		getURL;
		ID=`youtube-dl "$URL" --get-id`;
		TEMP="./$ID.webm";

		getFileName;
		TARGET="$FILENAME";

		youtube-dl "$URL" -f 171 --id -q;
		ffmpeg -loglevel panic -i "$TEMP" -vn -b:a 128k -vol 270 -codec libvorbis "$TARGET";
		rm "$TEMP";

		echo "      ############		 ";
		echo "Audio ready @:\"./$TARGET\"";
		echo "      ############		 ";
	fi;
done
