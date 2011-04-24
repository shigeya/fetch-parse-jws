#!/bin/sh
URL='https://spreadsheets.google.com/spreadsheet/pub?hl=en&key=0AuLjy4AyvEigdFlzejRGcGtEcldaZGw1MG9xOXdwb3c&hl=en&chrome=false&gid=0'
wget --no-check-certificate -O t.html $URL


if [ -x /sbin/md5 ]; then
	MD5=/sbin/md5
else
	MD5=md5
fi

T_MD5=`$MD5 t.html |sed -e 's/.* = //'`
FILE="archive/jws-${T_MD5}.html"
if [ ! -e $FILE ]; then
	echo New File: $FILE
	mv t.html $FILE
	touch fetch.log
	echo `date`: $FILE >> fetch.log
	ruby jws-gs2csv.rb $FILE
else
	echo $FILE already exists.
fi
