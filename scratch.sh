#!/bin/bash
LITTLE_VERSION_NUMBER='beta 1' # little's version number
cd "$(dirname "$0")"           # Go to the script's directory
. ./lib/mo                     # This loads the "mo" function
source config.vars || exit 1   # Read config variables

source lib/db/2018/db.txt || exit 1

printf "\n\n"

echo ${POST_12_27_content2[0]}