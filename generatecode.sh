#!/bin/bash

FIN="./list-active.txt";
FOUT="./list-active.tmp";

if [ ! -f $FIN ]; then
    echo "${FIN} not exist";
    exit 1;
fi

# 4 spaces
TAB="    ";

while read line; do
    echo "${TAB}${TAB}\"${line}\",";
done < $FIN > $FOUT;

LASTLINE="$(tail -n1 $FOUT |tr -d ',')";
sed -i -e "s/${LASTLINE},/${LASTLINE}/g" $FOUT;

mkdir -p ./code/php/NawawiExt;
cat <<_EOF_ >./code/php/NawawiExt/Disposeable.php;
<?php
namespace NawawiExt;

final class Disposeable {
    public static \$list = array(
$(cat $FOUT)
    );

    public static function Domain(\$domain) {
        return in_array(\$domain, self::\$list);
    }

    public static function Email(\$email) {
        list(\$user, \$domain) = explode("@", \$email);
        return self::Domain(\$domain);
    }
}
_EOF_

mkdir -p ./code/zephir/NawawiExt;
cat <<_EOF_ >./code/zephir/NawawiExt/Disposeable.zep;
namespace NawawiExt;

final class Disposeable {
    public static list = [
$(cat $FOUT)
    ];

    public static function Domain(string domain)->boolean {
        return in_array(domain, self::list);
    }

    public static function Email(string email)->boolean {
        var arr;
        let arr = explode("@", email);
        if ( count(arr) === 2 ) {
            return self::Domain(arr[1]);
        }
        return false;
    }
}
_EOF_

mkdir -p ./code/json;
cat <<_EOF_ >./code/json/Disposeable.json;
[
$(cat $FOUT |sed -e 's/^    //g')
]
_EOF_

mkdir -p ./code/xml;
cat <<_EOF_ >./code/xml/Disposeable.xml;
<?xml version="1.0" encoding="UTF-8"?>
$(cat $FOUT|sed -e 's/,//g' -e 's/"//g'|while read p; do echo "<domain>$p</domain>";done)
_EOF_

rm -f $FOUT;

exit 0;


