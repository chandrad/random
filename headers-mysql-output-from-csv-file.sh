HEADER_FILE=​​/opt/software/scripts/${0##*/}.header
REPORT=/medhok/sql/history/finalcsv_$(date +%Y%m%d).csv
​SQL_FILE=​​/opt/software/scripts/​sqls/${0##*/}.sql​
 
​sql=$(cat $SQL_FILE)​ 
run_sql -h medhok "$sql" >$REPORT
r_code=$(($r_code + $?))

if [[ $(wc -l < $REPORT) -gt 0 ]]; then
   head -1 $REPORT > $HEADER_FILE
else
   cat $HEADER_FILE >$REPORT
fi


###LEGEND###
#e.g. if the script was named abc_report, the sql file would be abc_report.sql and the header file would be abc_report.header.


#​$0 = the script called
#${0##*/} removes the path
