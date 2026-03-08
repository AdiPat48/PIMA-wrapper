#!/bin/sh
BASEDIR=$(dirname "$0")
echo $1 $2 $3 > redo_list
perl $BASEDIR/automate-hotpies.pl $4