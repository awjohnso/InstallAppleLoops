# Install Apple Loops
## Jamf Pro Script to help install the massive GarageBand Loops.
- Authtor: Andrew W. Johnson
- Date: 2022.01.10
- Version: 1.00
- Organizations: Stony Brook University/DoIT
---
What this script does:

This script will download zipped DMG files from a web server. It will then unzip the files, mount the DMG and install all the Apple audio loop PKG files  located within the DMG. It will then unmount the DMG, remove the zipped file, and the DMG file.

Requirements:

In oder for this to work use appleloops (https://github.com/carlashley/appleloops)
by Carl Carlashley to create the DMG files for the mandatory and optional loops.
Compress the DMG files into a zip file and store them on a web server. Also the DMG 
volume must be called appleloops.

Reasoning:

1. JamfPro Cloud does not seem to have the ability to import files larger than twenty something gigs. The optional loops are close to fourty gigs.
2. In order to run appleloops on the clients, they really need Python 3, and we prefer not to install it.
3. As of the creation date of this script, appleloops misses thirty or more audio units for GarageBand 10.4.5, which I was able to snag and throw into the mandatory DMG.

