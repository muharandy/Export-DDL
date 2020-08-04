#!/bin/bash
IMPALA_HOST=PUT_HOST_HERE
SSL_CERT=PUT_PATH_TO_CERT_HERE

rm -f $1_table_list.txt
rm -f $1_table_ddl.txt
impala-shell -i $IMPALA_HOST -d $1 -k --ssl --ca_cert=$SSL_CERT -d default -q "SHOW TABLES" | sed -e '1,3d;$ d;s/^.//;s/.$//' > $1_table_list.txt
wait
cat $1_table_list.txt | while read LINE
   do
   	echo -e "--------------------\n" >> $1_table_ddl.txt
    echo -e "-- $1.$LINE\n" >> $1_table_ddl.txt
    echo -e "--------------------\n" >> $1_table_ddl.txt
    echo  -e "\n" >> $1_table_ddl.txt
    impala-shell -i $IMPALA_HOST -d $1 -k --ssl --ca_cert=$SSL_CERT -d default -q "SHOW CREATE TABLE $LINE;" | sed -e '1,3d;$ d;s/^.//;s/.$//' >> $1_table_ddl.txt
    echo  -e "\n" >> $1_table_ddl.txt

  done
rm -f $1_table_list.txt
echo "DDL Generated for $1 Database"
