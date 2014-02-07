#!/bin/sh
. ./simple_t0.lib
DIR=/tmp/foomoo
FILE=$DIR/file1
mkdir -p $DIR
in_t0 rmdir $DIR

in_t0 ls -l $FILE
in_t0 rm $FILE
launch_and_check touch $FILE
