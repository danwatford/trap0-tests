#!/bin/bash
. ./simple_t0.lib
DIR=/tmp/foomoo
mkdir -p $DIR

# Mount proc, sys and dev in the target directory ready for a chroot.
launch_and_check mkdir $DIR/proc $DIR/sys $DIR/dev
in_t0 rmdir $DIR/proc $DIR/sys $DIR/dev

launch_and_check sudo mount --bind /proc $DIR/proc
in_t0 sudo umount $DIR/proc

# Simulate an error condition if $DIR/error_marker exists.
set -e
[ ! -e $DIR/error_marker ] || false

launch_and_check sudo mount --bind /sys $DIR/sys
in_t0 sudo umount $DIR/sys

launch_and_check sudo mount --bind /dev $DIR/dev
in_t0 sudo umount $DIR/dev

echo chroot would go here.