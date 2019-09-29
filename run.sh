#!/bin/bash
set -e

verb=${VERB:-Running}
script=${SCRIPT:-run.sh}

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
  echo "$verb $component"
  pushd $component > /dev/null
  pop_dir=true
  ./$script
  popd > /dev/null
  unset pop_dir
done
