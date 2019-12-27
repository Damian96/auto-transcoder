#!/bin/bash

# Set Debugging
# set -x

URL=""
FILENAME=""

_trapCmd() {
  trap 'kill -TERM $PID; exit 130;' TERM
  eval "$1" &
  PID=$!
  wait $PID
}

_check() {
	if [[ ! -w "." ]]; then
		printf "%s\n" "Current folder is not writable."
		exit 2
	fi
}

transcodeVideo() {
	if [[ $? == 0 ]]; then
		TARGET="$FILENAME.ogg"

		_trapCmd "youtube-dl \"$URL\" -f bestaudio/best --output-template \"%(title)s\" --console-title --no-call-home --extract-audio --audio-format vorbis --audio-quality 0 --fixup warn --prefer-ffmpeg --abort-on-error"

		if [[ $? == 0 ]]; then
			printf "%s\n" "success"
		else
			printf "\n%s" "Something went wrong while downloading the video"
			exit 2
		fi
	else
		printf "\n%s" "The video you entered does not exist"
		exit 1
	fi
}

getURL() {
	while [[ true ]]; do
		read "\n%sInsert the video's URL: " -r URL

		if [[ -z $URL ]]; then
			printf "%s\n" "Invalid URL"
		else
			break
		fi
	done
}

getFileName() {
	read -p "Insert output filename: " -r FILENAME
}

totalargs=$#
if [[ totalargs -ge 1 ]]; then
	for (( i=1; i <= totalargs; i++ )) do
	printf "%s\n" "Downloading $i out of $# videos..."
		URL=$1
		getFileName
		transcodeVideo
	done
	exit
fi

while [ "$OPTION" != "q" ]; do
	getURL
	printf "\n%s" "1. View available formats"
	printf "\n%s" "2. Download"
	printf "\n%s" "3. Download & Transcode to highest quality audio (ogg/libvorbis)"
	printf "\n%s" "[Q]uit/[q]uit:"
	read -p "\n%s: " -r OPTION

	if [[ "$OPTION" == "q" ]]; then
		printf "\n%s\n" "Bye!"
		exit 0
	elif [[ "$OPTION" == "1" ]]; then	
		youtube-dl "$URL" --list-formats --abort-on-error
	elif [[ "$OPTION" == "2" ]]; then
		printf "\n%s" "Available video formats:"
		youtube-dl "$URL" --list-formats --abort-on-error
		read -p "\n%sInsert the media format: " -r FORMAT

		getFileName
		youtube-dl "$URL" -f "$FORMAT" -o "$FILENAME.ogg" --abort-on-error
	elif [[ "$OPTION" == "3" ]]; then
		getFileName
		transcodeVideo
	fi
done

unset URL
unset FILENAME
unset TERM
unset TARGET
unset FORMAT
unset OPTION
unset getFileName
unset getURL

exit 0
