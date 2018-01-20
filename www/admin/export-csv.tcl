ad_page_contract {
    returns a comma-separated values file where each row is one
    user in a class (designated by the args); this CSV file is 
    suitable for importation into any standard spreadsheet program

    @param 
    @author Joseph Bank (based on view-csv.tcl by philg@mit.edu)
    @creation-date 
    @cvs-id $Id$
} {
    sql_query:verify
} 

set admin_user_id [ad_conn user_id]

# Header for CSV file
set csv_rows "\"User Name\",\"Version\",\"Download Date\",\"From IP\",\"From Hostname\",\"Download Reason\"\n"

set count 0
db_foreach download_info_select $sql_query {
    append csv_rows "\"$user_name\",\"$version_name\",\"$download_date\",\"$download_ip\",\"$download_hostname\",\"$reason\"\n"
    incr count
}

if { $count == 0 } {
    doc_return 200 text/plain "No users meet your criteria"
} else {
    doc_return 200 text/plain $csv_rows
}
ad_script_abort

#
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

