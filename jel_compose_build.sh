#!/bin/bash
GitDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CacheDir=/srv/jelatomic-cache
BuildDir=/srv/jelatomic-build
TreeFile=$GitDir/jel-atomic-host.json

if [ -d "$CacheDir" ]; then
  echo '' > /dev/null # do nothing // better way to do nothing?
else
  mkdir -p ${CacheDir}
fi

if [ -d "$BuildDir" ]; then
  echo '' > /dev/null # do nothing // better way to do nothing?
else
  mkdir -p ${BuildDir}
  ostree init --repo=${BuildDir} --mode=archive
fi

rpm-ostree compose tree --cachedir=${CacheDir} --repo=${BuildDir} ${TreeFile}