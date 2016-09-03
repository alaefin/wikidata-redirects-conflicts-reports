#! /bin/sh
for i in $( /usr/bin/mysql --defaults-file=/data/project/wikidata-redirects-conflicts-reports/replica.my.cnf -N -h labsdb1003.eqiad.wmnet -e 'SELECT dbname FROM wiki WHERE family = "wikipedia" ORDER BY dbname' meta_p )
do
    /usr/bin/mysql --defaults-file=/data/project/wikidata-redirects-conflicts-reports/replica.my.cnf -h $i.labsdb $i'_p' < /data/project/wikidata-redirects-conflicts-reports/wikidata-redirects-conflicts-reports.sql > /data/project/wikidata-redirects-conflicts-reports/report.tsv ;
    mkdir -p -m 0755 /data/project/wikidata-redirects-conflicts-reports/public_html/reports/$(date +"%G-%V") ;
    echo $(date +"%G-%V")'\t'$(/usr/bin/wc -l /data/project/wikidata-redirects-conflicts-reports/report.tsv | /usr/bin/awk '{print $1-1}') >> /data/project/wikidata-redirects-conflicts-reports/public_html/visualization/$i.txt ;
    mv /data/project/wikidata-redirects-conflicts-reports/report.tsv /data/project/wikidata-redirects-conflicts-reports/public_html/reports/$(date +"%G-%V")/$i-$(date +"%G-%V").tsv ;
done
