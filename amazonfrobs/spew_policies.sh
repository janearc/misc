#!/bin/bash
# set -x
GN=""
PN=""
export GN PN
aws iam list-groups | \
	grep GroupName | \
	awk '{ print $2 }' | cut -d\" -f 2 | \
		while read gn ; do 
			# scoping
			GN="`echo $gn | tr -d ',:\"'`" ; export GN ;
			echo "group $GN captured" >> /dev/stderr
			aws iam list-group-policies --group-name $GN ; 
		done | \
	grep -E '^        ' | \
		while read pn ; do 
			# scoping
			PN="`echo $pn | tr -d ',:\"'`" ; export PN ;
			echo "group $GN"
			echo "policy $PN"
			# echo "${GN}:${PN}" ;
		done
