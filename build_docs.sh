#!/bin/bash

#
# $1 is the directory name that we're copying and building teh docs for
# $2 is the heading used for the list of entries
BuildDocsForContent () 
{
	mkdir -p $1
	echo "" >> ${OUTPUT_FILE}
	echo "## $2" >> ${OUTPUT_FILE}
	for i in ${ROOT}/$1/*/readme.md; 
		do n=$( basename $( dirname "$i" ) ); n=${n/-/ }; to="$1/$( basename $( dirname "$i")).md"; echo "> $n"; cp "$i" "${to}"; echo " * [$n](${to})" >> ${OUTPUT_FILE}; 
	done
}

OUTPUT_FILE=contents2.md
ROOT=..


# Clear the output file
truncate -s 0 ${OUTPUT_FILE}


BuildDocsForContent services Services
BuildDocsForContent libs Libraries
BuildDocsForContent servers Servers
BuildDocsForContent clients Clients




