#!/bin/sh

srcdir=`dirname $0`
stamp=${1}
for scss in $srcdir/*.scss
do
  sassc -a $scss ${scss%%.scss}.css || exit 1
done

[ "$stamp" ] && touch $stamp
