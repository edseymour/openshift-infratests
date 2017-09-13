#!/bin/bash

function remove_files()
{
  rm /var/tmp/perftest
  rm ${remote_file}
}

REMOTE_DIR=$1
[ "$REMOTE_DIR" == "" ] && echo "please pass remote dir, using /var/tmp as a default (so both local and remote are the same)" && REMOTE_DIR=/var/tmp

remote_file=/${REMOTE_DIR}/perftest-$(hostname)

echo "*** Test run $(date)"
echo "***
*** Write Speed Tests
*** Local file-system (/var/tmp)"
dd if=/dev/zero of=/var/tmp/perftest bs=1G count=1 oflag=direct
echo "*** Remote file-system"
dd if=/dev/zero of=${remote_file} bs=1G count=1 oflag=direct 
echo "*** Read Speed Tests
*** Local file-system"
dd if=/var/tmp/perftest of=/dev/null bs=8k
echo "*** Remote file-system"
dd if=${remote_file} of=/dev/null bs=8k
echo "*** Write latency test
*** Local file-system"

remove_files

dd if=/dev/zero of=/var/tmp/perftest bs=512 count=2048 oflag=dsync
echo "*** Remote file-system"
dd if=/dev/zero of=${remote_file} bs=512 count=2048 oflag=dsync

remove_files

echo "***
*** Test completed $(date)"

