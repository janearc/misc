#!/bin/bash

# ufattr.sh - un-frob attribs.
#
# in theory this will behave like cp -r and tar c - | tar x - only 
# it won't keep all those shit attrs that apple puts on files.


for f in $*; do
	[[ -d "${f}" ]] && make_dir( "${f}" )
	[[ -f "${f}" ]] && make_file( "${f}" )
done

exit 0;

function make_file {
	SRC=$1
	DST=make_relative($SRC)
	dd if="${SRC}" of="${DST}" bs=512k
}

function make_dir {
	SRC=$1
	DST=make_relative($SRC)
	mkdir -p "${DST}"
}

function make_relative {
	SRC=$1
	DST="`echo ${SRC} | sed 's;^/;;'`"
	return $DST
}
