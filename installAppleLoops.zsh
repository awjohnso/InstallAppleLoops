#!/bin/zsh

# Authtor: Andrew W. Johnson
# Date: 2022.01.10
# Version 1.00
# DoIT/Stony Brook University

# What this script does:
# This script will download zipped DMG files from a web server. It will then
# unzip the files, mount the DMG and install all the Apple audio loop PKG files 
# located within the DMG. It will then unmount the DMG, remove the zipped file, 
# and the DMG file.
#
# Requirements:
# In oder for this to work use appleloops (https://github.com/carlashley/appleloops)
# by Carl Carlashley to create the DMG files for the mandatory and optional loops.
# Compress the DMG files into a zip file and store them on a web server. Also the DMG 
# volume must be called appleloops.
#
# Reasoning:
# 1. JamfPro Cloud does not seem to have the ability to import files larger 
#    than twenty something gigs. The optional loops are close to fourty gigs.
# 2. In order to run appleloops on the clients, they really need Python 3, and
#    we prefer not to install it.
# 3. As of the creation date of this script, appleloops misses thirty or more 
#    audio units for GarageBand 10.4.5, which I was able to snag and throw into
#    the mandatory DMG.

	# Filename to curl down from the web server. Use $1 if standalone.
myLoops="${1}"
	# Filename to curl down from the web server. Use if running from JamfPro.
# myLoops="${4}"
	# Enter the URL (full path) to the zipped DMG file: http(https)://my.university.edu/path/to/dmg
# myURL=""

	# If using JamfPro enter the URL (full path) to the zipped DMG file: http(https)://my.university.edu/path/to/dmg as paramater 5.
myURL="${5}"

	# Curl down the zipped DMG file and save it to /private/tmp/
/bin/echo "Curling down ${myLoops} from ${myURL}."
/usr/bin/curl ${myURL}/${myLoops}.zip -o /private/tmp/${myLoops}.zip

	# Check to see if it got downloaded.
if [ ! -e "/private/tmp/${myLoops}.zip" ]; then
	/bin/echo "ERROR: ${myLoops}.zip was not found in /private/tmp."
	exit 1
fi
	# Unzip the file.
/bin/echo "Unzipping ${myLoops}.zip."
/usr/bin/unzip /private/tmp/${myLoops}.zip -d /private/tmp

if [ ! -e "/private/tmp/${myLoops}" ]; then
	/bin/echo "ERROR: ${myLoops} was not found in /private/tmp."
	exit 1
fi

	# Mount the DMG.
/bin/echo "Mounting ${myLoops}."
/usr/bin/hdiutil attach -nobrowse /private/tmp/${myLoops} -quiet

isMounted=$(/bin/df | /usr/bin/egrep -ic appleloops)
if [ ${isMounted} -ge 1 ]; then

		# Looking for the pkgs to install.
	/bin/echo "Searching for the packages to install..."
	myPKGs=($(/usr/bin/find /Volumes/appleloops -name "*pkg"))

		# Loop through the array and install all the packages.
	for i in "${myPKGs[@]}"; do
		/bin/echo "Installing: ${i}"
		/usr/sbin/installer -pkg "${i}" -target /
	done

	/bin/echo "Done installing."
	
		# Unmount the DMG
	/bin/echo "Unmounting ${myLoops}"
	/sbin/umount /Volumes/appleloops
	
		# Removing the zipped file.
	/bin/echo "Removing ${myLoops}.zip"
	/bin/rm -Rf ${myLoops}.zip
	
	# removing the dmg file.
	/bin/echo "Removing ${myLoops}"
	/bin/rm -Rf ${myLoops}
else
	/bin/echo "ERROR: the DMG did not mount."
	exit 1
fi

exit 0
