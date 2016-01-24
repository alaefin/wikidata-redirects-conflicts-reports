#! /bin/sh
/usr/bin/php sqlbuilder.php $1 | /usr/bin/mysql --defaults-file=~/replica.my.cnf -h wikidatawiki.labsdb > report.tsv ; mv report.tsv public_html/$1-$(date +"%Y-%m-%d").tsv
