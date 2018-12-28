#!/bin/bash
LITTLE_VERSION_NUMBER='beta 1' # little's version number
cd "$(dirname "$0")"           # Go to the script's directory
. ./lib/mo                     # This loads the "mo" function
source config.vars || exit 1   # Read config variables

USER_INPUT="$@"

# Check that user input isn't blank
if [ -n "$USER_INPUT" ]; then

	# Display help text
	if [ $USER_INPUT == "help" ]; then
		cat <<EOF | mo
{{> lib/help.txt}}
EOF
	fi

	# Display version number
	if [ $USER_INPUT == "version" ]; then
		printf "\nlittle version: ${LITTLE_VERSION_NUMBER}\n\n"
	fi

	# Build the site
	if [ $USER_INPUT == "build" ]; then

		${MARKDOWN} # Convert post content from markdown to html and store in a tmp file. This tmp file will getremoved at the end

		YEAR=$(date +'%Y')
		MONTH=$(date +'%m')
		DAY=$(date +'%d')

		DATABASE=lib/db/${YEAR}
		mkdir -p ${DATABASE}

		PUBLISHED_CONTENT_DIR=posts/published
		DRAFTS_CONTENT_DIR=posts/drafts

		mkdir -p ${PUBLISHED_CONTENT_DIR}/${YEAR}/${MONTH}/${DAY}
		MOVE_TO=${PUBLISHED_CONTENT_DIR}/${YEAR}/${MONTH}/${DAY}
		mv ${DRAFTS_CONTENT_DIR}/* ${MOVE_TO}/

		POST_SLUG_WITH_EXTENSION=$(ls ${MOVE_TO})
		POST_SLUG=${POST_SLUG_WITH_EXTENSION%%.*}

		cat <<EOF | mo >tmp.html
{{> templates/post.mustache}}
EOF

		mkdir -p dist/${YEAR}/${MONTH}/${DAY}/${POST_SLUG}
		DIST_POST=dist/${YEAR}/${MONTH}/${DAY}/${POST_SLUG}
		mv tmp.html ${DIST_POST}/index.html
		cp -r assets/ dist/                        # Copy the contents of the assets folder to dist
		rm -rf templates/tmp-content-template.html # Delete temporary post content

		# Write basic info about the new post to post cache db
		POST_CACHE_INFO="POST_${MONTH}_${DAY}_${POST_SLUG}=(\"${YEAR}/${MONTH}/${DAY}/${POST_SLUG}/index.html\" \"${MOVE_TO}/${POST_SLUG_WITH_EXTENSION}\")"
		cat <(echo "${POST_CACHE_INFO}") ${DATABASE}/db.txt >${DATABASE}/tmp-db.txt
		rm -rf ${DATABASE}/db.txt
		mv ${DATABASE}/tmp-db.txt ${DATABASE}/db.txt

	fi

else

	# If no user input, display help text
	cat <<EOF | mo
{{> lib/help.txt}}
EOF
fi
