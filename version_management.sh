#!/usr/bin/env bash

get_versions() {
  name="$(grep -Po '#*Name: \K.*' "$1")"
  vers="($(grep -Po '#*Versions: \K.*' "$1"))"
  printf "%sVer=%s\n" "$name" "$vers" >> $path_config/reference.conf
  #echo "" >> $path_config/reference.conf
}

generate_software_version_catalogue() {
  rm $path_config/reference.conf
  for f in $path_auto/*.sh; do
  	get_versions $f
  done

  for f in $path_manu/*.sh; do
  	get_versions $f
  done
}

check_conf() {
  success=0
  name=$(echo "$1"|grep -Po '.*(?==)')
  versions=$(echo "$1"|grep -Po '(?<==\().*(?=\))')
  if !(grep -q "^$name=" "$path_config/reference.conf"); then
    echo "Script for ${name%"Ver"} is not contained within this suite!"
    success=1
  else
    available_versions=$(grep -Po "(?<=$name=\().*(?=\))" "$path_config/reference.conf")
    for version in $versions; do
      matched=1
      for available in $available_versions; do
        if [[ "$available" == "$version" ]]; then
          matched=0
        fi
      done
      if [[ $matched -eq 1 ]]; then
        echo "Version $version for ${name%"Ver"} is not provided by this suite!"
        success=1
      fi
    done
  fi
  return $success
}

### reads config file and checks wether it is valid if so it returns 0
read_conf() {
  success=0
  #echo $lines
  #cat $1
  while IFS="\n" read line; do
    check_conf "$line"
    if [[ $? -ne 0 ]]; then
      success=1
    fi
  done<$1
  return $success

    #echo $(check_conf "$line")
    #if [ $(check_conf $line -ne 0) ]; then
    #  echo "error"
    #fi
}
