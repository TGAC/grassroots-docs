#!/bin/bash

ROOT=..
OUTPUT_DIR=docs
OUTPUT_FILE=${OUTPUT_DIR}/index.md


BuildDocForContent () 
{
	i=${ROOT}/$1/readme.md; 
	n=$( basename $( dirname "$i" ) ); 
	n=${n/-/ }; 
	to="$1/$( basename $( dirname "$i")).md"; 
	echo "> $n"; 
	cp "$i" "${OUTPUT_DIR}/${to}"; 
	echo " * [$n](${to})" >> ${OUTPUT_FILE}; 
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
		do n=$( basename $( dirname "$i" ) ); n=${n/-/ }; to="$1/$( basename $( dirname "$i")).md"; echo "> $n"; cp "$i" "${OUTPUT_DIR}/${to}"; echo " * [$n](${to})" >> ${OUTPUT_FILE}; 
	done
	else
		i=${ROOT}/$1/readme.md; n=$( basename $( dirname "$i" ) ); n=${n/-/ }; to="$1/$( basename $( dirname "$i")).md"; echo "> $n"; cp "$i" "${OUTPUT_DIR}/${to}"; echo " * [$n](${to})" >> ${OUTPUT_FILE}; 
	fi

}



# Clear the output file
truncate -s 0 ${OUTPUT_FILE}


BuildDocsForContent services Services true
BuildDocsForContent libs Libraries true

# Lucene
#mkdir -p ${OUTPUT_DIR}/lucene
#cp ${ROOT}/lucene/readme.md ${OUTPUT_DIR}/lucene/lucene.md
#echo "> lucene"
#echo "" >> ${OUTPUT_FILE}
#echo "## lucene" >> ${OUTPUT_FILE}
#echo " * [lucene](lucene/lucene.md)" >> ${OUTPUT_FILE}

BuildDocsForContent lucene Lucene false

BuildDocsForContent servers Servers true
BuildDocsForContent clients Clients true




