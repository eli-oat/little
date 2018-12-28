#!/bin/bash
LITTLE_VERSION_NUMBER='beta 1' # little's version number
cd "$(dirname "$0")"           # Go to the script's directory
. ./lib/mo                     # This loads the "mo" function
source config.vars || exit 1   # Read config variables

DATA_BASE=lib/db/2018/db.txt

IFS=$'\n' read -d '' -r -a POSTS < ${DATA_BASE}

# INDEX_POSTS=$(head -25 $DATA_BASE)

i=0
for POST in "${POSTS[@]:0:26}"
do
    i=$((i + 1))
    IFS=', ' read -r -a p <<< "$POST"

    # echo "${p[0]}"
    # echo "${p[1]}"

    mkdir -p templates/tmp
    pandoc ./${p[1]} -o templates/tmp/${i}.html
    printf "<br>\n<br>\n<a href=${p[0]}>Permalink</a>" >> templates/tmp/${i}.html
done

iter=0
while read line
do
    INDEX_CONTENT[ $iter ]="$line"        
    (( $iter+1 ))
done < <(ls templates/tmp)

for CONTENT in "${INDEX_CONTENT[@]}"
do
    echo $CONTENT # TODO: this represents a single post template to insert into a blog index
done