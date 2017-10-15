#!/usr/bin/env bash
if [ -z "$1" ]; then
   echo "Usage apply.sh <jobname>"
   exit -1
fi
export SIGIL_DELIMS='#{,}#'
sigil -f $1 | nomad run -
