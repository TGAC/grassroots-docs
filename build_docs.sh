#!/bin/bash

# A tool to build the admin help pages for Grassroots

# Where we are reading the files from 
ROOT=..

# The directory in which we will build the pages
OUTPUT_DIR=docs

# The name of the initil page that we are writing to
OUTPUT_FILE=${OUTPUT_DIR}/components.md

# $1 is the directory name that we're copying and building the docs for
# $2 is the markdown filename
BuildDocForContent () 
{
	i=$2; 
	n=$( basename $( dirname "$i" ) ); 
	n=${n/-/ }; 
	to="$1/$( basename $( dirname "$i")).md"; 
	echo "> $n"; 
	cp "$i" "${OUTPUT_DIR}/${to}"; 
	echo " * [${n^}](${to})" >> ${OUTPUT_FILE}; 
}



#
# $1 is the directory name that we're copying and building the docs for
# $2 is the heading used for the list of entries
BuildDocsForContent () 
{
	mkdir -p ${OUTPUT_DIR}/$1
	echo "" >> ${OUTPUT_FILE}
	echo "## $2" >> ${OUTPUT_FILE}

	if [[ $3 = "true" ]]
	then
	for i in ${ROOT}/$1/*/readme.md; 
	do
		BuildDocForContent $1 $i
	done
	else
		BuildDocForContent $1 ${ROOT}/$1/readme.md
	fi


#	 find . -maxdepth 1 -mindepth 1 -name \*.md -a -not -name readme.md -exec cp -t ${OUTPUT_DIR} {} +

}



# Clear the output file
mkdir -p ${OUTPUT_DIR}
truncate -s 0 ${OUTPUT_FILE}

cat components_intro.md > ${OUTPUT_FILE}

BuildDocsForContent services Services true

BuildDocsForContent libs Libraries true

BuildDocsForContent lucene Lucene false

BuildDocsForContent servers Servers true

BuildDocsForContent clients Clients true


cp readme.md ${OUTPUT_DIR}/index.md

cp configuration.md ${OUTPUT_DIR}

cp examples.md ${OUTPUT_DIR}

cp schema.md ${OUTPUT_DIR}

cp service_configuration.md ${OUTPUT_DIR}

cp wizard.md ${OUTPUT_DIR}


