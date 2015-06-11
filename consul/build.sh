#!/bin/bash

cd ${0%/*}

VERSION="0.5.2"
RELEASE="1"
EPOCH="1"
URL="http://consul.io/"
DESCRIPTION="Consul makes it simple for services to register themselves and to discover other services via a DNS or HTTP interface."

destdir="build"
prefix="usr/bin"

echo "Building package version: $VERSION release: $RELEASE epoch: $EPOCH"

if [ "$destdir/$prefix" != "/"  ] ; then
  echo "Cleaning build dir $destdir/"
  rm -rf $destdir/*
fi

mkdir -p $destdir/$prefix

zip="${VERSION}_linux_amd64.zip"

if [ ! -f "$zip" ] ; then
  echo "No zip file named $zip locally, downloading"
  curl -#qLO https://dl.bintray.com/mitchellh/consul/$zip
fi

if [ ! -f "$zip" ] ; then
  echo "Missing zip and looks like the download failed. Can't continue"
  exit 1
fi


echo "Extracting $zip"
unzip $zip -d build/usr/bin/

echo "Running fpm"
fpm -s dir -t rpm -n consul -v "$VERSION" \
  -a x86_64 --iteration "1_${RELEASE}" \
  -x "/.gitinclude" \
  --epoch $EPOCH \
  --url "$URL" \
  --description "$DESCRIPTION" \
  --vendor "Hashicorp" \
  --license "Mozilla Public License, version 2.0" \
  --rpm-use-file-permissions \
  --rpm-user root --rpm-group root \
  -x .gitinclude \
  -f -C $destdir .
