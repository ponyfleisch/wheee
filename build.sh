#!/usr/bin/env bash
set -e -u

version=$(git describe --tags --always --abbrev=7 --dirty)

function build() {

	local browser=${1:-firefox}
	local product=""
	case $browser in
		firefox)
			product=wheee.xpi
			;;
		chrome)
			product=wheee.zip
			;;
		*)
			echo >&2 "bad browser: ${browser}"
	esac

	echo "building wheee v${version}@${browser}"

	mkdir -vp build/${browser}
	cp -v wheee.js scratch.mp3 *.png build/${browser}/
	manifest ${browser} >build/${browser}/manifest.json

	zip -j build/${product} build/${browser}/*

}

function manifest() {

	local browser=${1:-firefox}

	if [[ ${browser} = chrome ]]; then
		local version=$(echo ${version} | grep -oE '^[0-9.]+')
	fi

	cat <<-EOF
	{
		"name": "Wheee",
		"version": "${version}",
		"description": "Lets you know when an audible tab is closed",
		"icons": {
			"16": "icon-16.png",
			"48": "icon-48.png",
			"128": "icon-128.png"
		},
		"background": {
			"persistent": true,
			"scripts": [
				"wheee.js"
			]
		},
	EOF

	[[ ${browser} = firefox ]] && cat <<-EOF
		"applications": {
			"gecko": {
				"id": "wheee@ponyfleisch.ch"
			}
		},
	EOF

	cat <<-EOF
		"manifest_version": 2
	}
	EOF

}

case ${1:-all} in
	firefox)
		build firefox
		;;
	chrome)
		build chrome
		;;
	all)
		build firefox
		build chrome
		;;
esac
