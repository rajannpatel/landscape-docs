#!/bin/sh
# This script computes a rough size estimate for mirroring the archive.
# The generated table is located in en/repositories.md
#
# BUG: multi-arch debs are counted twice in the combined total.

ALL_SERIES="focal bionic xenial"
ARCHS="amd64 i386"
COMPS="main restricted universe multiverse"

ruler="|-----------"
ruler2="|           "
printf "|           "
for series in $ALL_SERIES
do
  printf "|        |% 8s|        | " "$series"
  ruler="$ruler|--------|--------|--------|-"
  ruler2="$ruler2|$(printf "% 8s|%8s" $ARCHS)|   total|-"
done
echo
echo "$ruler"
echo "$ruler2"


for pocket in "" "-updates" "-security"
do
  case $pocket in
    "-updates") printf "|Updates    ";;
    "-security") printf "|Security   ";;
    "") printf "|Release    ";;
  esac

  for series in $ALL_SERIES
  do
    total=0
    for arch in $ARCHS
    do
      size=$(
      for comp in $COMPS
      do
        curl --silent "http://archive.ubuntu.com/ubuntu/dists/$series$pocket/$comp/binary-$arch/Packages.gz"
      done | zcat | awk '/^Size/ {total += $2} END {printf "%.1f\n", total/1024/1024/1024}'
      )
      total="$(echo "$total + $size" | bc)"
      printf "|% 8s" "$(printf "%.0fGB" $size)"
    done

    printf "|% 8s|-" "$(printf "%.0fGB" "$total")"
  done

  echo
done
