#!/bin/sh

# Set Debugging
# set -x;

URL="";
FILENAME="";

getURL() {
	printf "\n%s" "Please insert the video's URL: ";
	read -r URL;

	if [[ -z $URL ]]; then
		printf "\n%s" "Error: Empty URL provided";
		exit 1;
	else
		printf "\n%s" "$URL";
	fi;
}

getFileName() {
	while [ true ]; do
		printf "\n%s" "Please insert the media's filename (without extension): ";
		read -r FILENAME;

		if [[ -f "$FILENAME.ogg" ]]; then
			printf "\n%s" "A file already exists, with that name. Please insert a different one.";
		else
			break;
		fi;
	done
}

while [ "$OPTION" != "q" ]; do

	printf "\n%s" "                ###########";
	printf "\n%s" "What do you want to do?";
	printf "\n%s" "1. View available formats of media.";
	printf "\n%s" "2. Download media.";
	printf "\n%s" "3. Download & Transcode media to highest quality audio (.ogg).";
	printf "\n%s" "['q': exit]";
	printf "\n%s" ": ";
	read -r OPTION;

	if [[ "$OPTION" == "q" ]]; then
		printf "\n%s" "Bye!";
		exit 0;
	elif [[ "$OPTION" == "1" ]]; then
		getURL;
		youtube-dl "$URL" -F;
	elif [[ "$OPTION" == "2" ]]; then
		getURL;
		printf "\n%s" "Please insert the media's format id: ";
		read -r FORMAT;

		getFileName;
		youtube-dl "$URL" -f "$FORMAT" -o "$FILENAME.ogg";
	elif [[ "$OPTION" == "3" ]]; then
		getURL;
		ID=`youtube-dl "$URL" --get-id`;

		if [[ $? == 0 ]]; then
			TEMP="./$ID.webm";

			getFileName;
			TARGET="$FILENAME.ogg";

			youtube-dl "$URL" -f 171 --id -q;

			if [[ $? == 0 ]]; then
				ffmpeg -loglevel panic -i "$TEMP" -vn -b:a 128k -vol 270 -codec libvorbis "$TARGET";
				printf "\n%s" "      ############		 ";
				printf "\n%s" "Audio ready @:\"./$TARGET\"";
				printf "\n%s" "      ############		 ";
			else
				printf "\n%s" "Something went wrong while downloding the video.";
			fi

			rm "$TEMP";
		else
			printf "\n%s" "The video you entered does not exist.";
		fi
	fi
done

unset URL;
unset FILENAME;
unset TARGET;
unset ID;
unset TEMP;
unset FORMAT;
unset OPTION;

unset getFileName;
unset getUrl;

exit 0;