#!/bin/bash
cd "$(dirname "$0")" # Go to the script's directory
. ./lib/mo # This loads the "mo" function

source config.vars || exit 1 # Read config variables

${MARKDOWN} # Convert post content from markdown to html and store in a tmp file. This tmp file will get removed at the end

YEAR=$(date +'%Y')
MONTH=$(date +'%m')
DAY=$(date +'%d')

PUBLISHED_CONTENT_DIR=posts/published
DRAFTS_CONTENT_DIR=posts/drafts

mkdir -p ${PUBLISHED_CONTENT_DIR}/${YEAR}/${MONTH}/${DAY}

MOVE_TO=${PUBLISHED_CONTENT_DIR}/${YEAR}/${MONTH}/${DAY}

mv ${DRAFTS_CONTENT_DIR}/* ${MOVE_TO}/

POST_SLUG_WITH_EXTENSION=$(ls ${MOVE_TO})
POST_SLUG=${POST_SLUG_WITH_EXTENSION%%.*}

cat <<EOF | mo > tmp.html

{{> templates/post.mustache}}

EOF

mkdir -p dist/${YEAR}/${MONTH}/${DAY}/${POST_SLUG}

DIST_POST=dist/${YEAR}/${MONTH}/${DAY}/${POST_SLUG}

mv tmp.html ${DIST_POST}/index.html

rm -rf templates/tmp-content-template.html # Delete temporary post content