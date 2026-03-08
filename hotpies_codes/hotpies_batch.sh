#!/bin/sh
BASEDIR=$(dirname "$0")
unzip $1
cp */*.pdb .
cp */redo_list .
if [ -f "redo_list" ]
then
	perl $BASEDIR/automate-hotpies.pl $2
else
	echo "redo_list file not found in the uploaded zip"
	exit 1
fi

