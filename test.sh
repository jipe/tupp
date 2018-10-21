#!/bin/bash
set -e

function at_exit {
  if [ -n "$pop_dir" ]
  then
    popd > /dev/null
  fi
}

components=harvester

trap at_exit EXIT

for component in $components
do
  echo "Testing $component"
  pushd $component > /dev/null
  pop_dir=true
  ./test.sh
  popd > /dev/null
  unset pop_dir
done
