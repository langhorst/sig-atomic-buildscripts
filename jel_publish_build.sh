#!/bin/bash
BuildRepo="/srv/jelatomic-build"
BuildBranch="jelatomic/build/master"

MasterRepo="/srv/jelatomic-master"
MasterBranch="jelatomic/master"

Help="jel_publish_build.sh\n\n
  -s Subject [required]\n
  -m Message Body [required]\n
  -r Release Version [required]\n"

while getopts s:m:r: option
do
  case "${option}"
    in
    s) Subject=${OPTARG};;
    m) Message=${OPTARG};;
    r) Release=${OPTARG};;
  esac
done

if [ -z "$Subject" ]
then
  echo -e ${Help}
  echo 'ERROR: -s Subject is required, ex: "VIM Support"'
  exit
fi

if [ -z "$Message" ]
then
  echo -e ${Help}
  echo 'ERROR: -m Message Body is required, ex: "Adds VIM support"'
  exit
fi

if [ -z "$Release" ]
then
  echo -e ${Help}
  echo 'ERROR: -r Release Version is required, ex: "1.0"'
  exit
fi

checksum=$(ostree --repo=${BuildRepo} rev-parse ${BuildBranch})

echo "Subject: ${Subject}"
echo "Message: ${Message}"
echo "Release: ${Release}"
echo ''
echo -e "Promoting reference ${checksum}"
echo -e "\tBuild Repo: ${BuildRepo} | Branch: ${BuildBranch}"
echo -e "\tMaster Repo: ${MasterRepo} | Branch: ${MasterBranch}"
echo ''
echo -e "Are you sure you want to promote this reference? [y/N] "
read choice
case $choice in
  y) echo;;
  *) exit;;
esac

ostree --repo=${MasterRepo} pull-local ${BuildRepo} ${checksum}
ostree --repo=${MasterRepo} commit -b ${MasterBranch} \
  -s "$Subject" -m "$Message" --add-metadata-string=version=${Release} \
  --tree=ref=${checksum}
  