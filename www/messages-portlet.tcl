ad_page_contract {
    The display logic for the messages portlet

    @author Pedro Castellanos (pedro@viaro.net)
    @creation-date 2010-06-01

} {

}

append folder_ids [messages::get_folder_id -folder_name "inbox"]
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set folders_info [lindex [db_list_of_lists count_new_messages {}] 0]

if { [llength $folders_info] } {
    set data_info "([lindex $folders_info 0]/[lindex $folders_info 1])"
} else {
    set data_info ""
}
