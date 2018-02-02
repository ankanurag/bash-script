
#!/bin/bash -xv
DATE="$(date +%F_%H%M%S)"
DB="$(mysql -u<username> -p<password> -h<hostip> -e 'show databases'|egrep -v -e information_schema -e Database -e mysql -e sys -e test -e tmp -e performance_schema -e innodb)"
#create dirctory for dump store
mkdir -p <path where dump file store for some time>/${DATE}
#find command for delete before 1 days file
find <path where dump file store for some time>/ -type d -ctime +0 -exec rm -rf {} \;

for i in ${DB}
do
#Dump command that take dump and gzip it.
/usr/bin/mysqldump  --single-transaction -u<username> -p<password> -h<hostip> ${i} | gzip > <path where dump file store for some time>/${DATE}/${i}_${DATE}.sql.gz
#Command for copy gzip dump file on s3.
/usr/bin/aws s3 cp <path where dump file store for some time>/${DATE}/${i}_${DATE}.sql.gz s3://<s3 bucket name>/${DATE}/
done
