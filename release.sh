#!/bin/bash

## Define functions
usage() {
  echo "$0 -h [version jump] [tag message]"
  echo "   -h show this help message"
  echo "   [version jump] M major, m minor, p patch can be specified"
  echo "   [tag message] message for the release tag"
  echo " "
  echo "This script should be run in the root directory of the project."
}

get_version() {
  echo "Get version from $1"
  VERSION=$(sed -n 's/version = "\([0-9]\+\)/\1/p' $1 | sed 's/"//' | sed 's/[^[:print:]]//g')
  echo "Version is $VERSION"
}

set_version() {
  echo "Change version from $1 to $2 in $3"
  sed -i "s/version = \"$1\"/version = \"$2\"/g" $3
}

change_version() {
  a=( ${VERSION//./ } )
  case $1 in
      M)
          ((a[0]++))
          a[1]=0
          a[2]=0
          ;;
      m)
          ((a[1]++))
          a[2]=0
          ;;
      p)
          ((a[2]++))
          ;;
      *)
          echo "Abort unknown option for version switch"
          exit 1
          ;;
  esac
}

workflow() {
  get_version $1
  change_version $2
  NEW_VERSION="${a[0]}.${a[1]}.${a[2]}"
  set_version "$VERSION" "$NEW_VERSION" "$1"
  TAG=$(echo $1 | cut -d / -f 1)
}

while getopts "h" arg; do
  case ${arg} in
    h)
      usage
      exit 0
      ;;
    *)
      echo_error "Unknown optional argument $*"
      usage
      exit 1
      ;;
  esac
done

echo "Checking if your local directory is clean."
if [[ $(git status --porcelain --untracked-files=no) ]]
  then
    echo "You have uncommited changes and should not do a release."
    exit 1
fi

workflow pyproject.toml $1
DATE=$(date '+%Y-%m-%d')
pdm run yq --arg date "$DATE" '.publication_date = $date' .zenodo.json > .zenodo.json_
mv .zenodo.json_ .zenodo.json
sed -i "s/^date-released: .*$/date-released: \'$DATE\'/g" CITATION.cff
sed -i "s/^version: .*$/version: v$NEW_VERSION/g" CITATION.cff
git add .zenodo.json CITATION.cff pyproject.toml
git commit -m "release: new version -> $NEW_VERSION $2"
git tag -a v$NEW_VERSION -m "$2"

read -rp $'\033[34;5mDo you want to push the release and run ci/cd [y]?: \033[0m' proceed
if [ "$proceed" != "y" ]
  then
    exit 0
fi
git push --follow-tags