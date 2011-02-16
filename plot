#!/bin/bash

name="$1"
if [ -z "$name" -o ! -x ./$name ]; then
	echo "specify binary name"
	exit 1
fi

./analyze.pl $name.data > $name.stats
 tail +5 < $name.stats | sort -n -k2 > $name.tmp
cnt=`wc -l < $name.data`
addrs=`wc -l < $name.tmp`
sed -e "s/@NAME@/$name/;s/@TITLE@/$cnt samples\\\n$addrs addresses/" < plot.gpl > $name.gpl
gnuplot -p $name.gpl
