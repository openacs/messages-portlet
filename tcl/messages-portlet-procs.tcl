ad_library {

    Procedures to support the messages portlets

    @creation-date 2010-06-01
    @author Pedro Castellanos (pedro@viaro.net)
    
}

namespace eval messages_portlet {}
namespace eval messages_admin_portlet {}


#
# messages namespace
#

ad_proc -private messages_portlet::get_my_name {
} {
    return "messages_portlet"
}



ad_proc -private messages_portlet::my_package_key {
} {
    return "messages-portlet"
}



ad_proc -public messages_portlet::get_pretty_name {
} {
    return "#messages.messages#"
}



ad_proc -public messages_portlet::link {
} {
    return ""
}



ad_proc -public messages_portlet::add_self_to_page {
    {-portal_id:required}
    {-package_id:required}
    {-param_action:required}
    {-force_region ""}
    {-page_name "" }
} {
    Adds a messages PE to the given portal.
    
    @param portal_id The page to add self to
    @param package_id The community with the folder
    
    @return element_id The new element's id
} {

    ns_log Notice "portal_id:: $portal_id;; $page_name"
    return [portal::add_element_parameters \
        -portal_id $portal_id \
        -portlet_name [get_my_name] \
        -value $package_id \
        -force_region $force_region \
        -page_name $page_name \
        -pretty_name [get_pretty_name] \
        -param_action $param_action
       ]
}



ad_proc -public messages_portlet::remove_self_from_page {
    {-portal_id:required}
    {-package_id:required}
} {
    Removes a messages PE from the given page or the package_id of the
    messages package from the portlet if there are others remaining
    
    @param portal_id The page to remove self from
    @param package_id
} {
    portal::remove_element_parameters \
        -portal_id $portal_id \
        -portlet_name [get_my_name] \
        -value $package_id
}



ad_proc -public messages_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "messages-portlet"
}

#
# messages admin namespace
#

ad_proc -private messages_admin_portlet::get_my_name {} {
    return "messages_admin_portlet"
}


ad_proc -public messages_admin_portlet::get_pretty_name {} {
    return "#messages.messages_Administration#"
}



ad_proc -private messages_admin_portlet::my_package_key {} {
    return "messages-portlet"
}



ad_proc -public messages_admin_portlet::link {} {
    return ""
}



ad_proc -public messages_admin_portlet::add_self_to_page {
    {-portal_id:required}
    {-page_name ""}
    {-package_id:required}
} {
    Adds a messages admin PE to the given portal

    @param portal_id The page to add self to
    @param package_id The package_id of the messages package

    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -key package_id \
                -value $package_id
           ]
}

ad_proc -public messages_admin_portlet::remove_self_from_page {
    {-portal_id:required}
} {
    Removes a messages admin PE from the given page
} {
    portal::remove_element \
        -portal_id $portal_id \
        -portlet_name [get_my_name]
}


ad_proc -public messages_admin_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "messages-admin-portlet"
}

ad_proc -private messages_portlet::after_install {} {
    Create the datasources needed by the messages portlet.
} {
    
    db_transaction {
    set ds_id [portal::datasource::new \
               -name "messages_portlet" \
               -description "Messages Portlet"]

    portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value t

    portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

    register_portal_datasource_impl

    }
}

ad_proc -private messages_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the messages portlet.
} {
    set spec {
        name "messages_portlet"
    contract_name "portal_datasource"
    owner "messages-portlet"
        aliases {
        GetMyName messages_portlet::get_my_name
        GetPrettyName  messages_portlet::get_pretty_name
        Link messages_portlet::link
        AddSelfToPage messages_portlet::add_self_to_page
        Show messages_portlet::show
        Edit messages_portlet::edit
        RemoveSelfFromPage messages_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private messages_admin_portlet::after_install {} {
    Create the datasources needed by the messages portlet.
} {

    db_transaction {
    set ds_id [portal::datasource::new \
               -name "messages_admin_portlet" \
               -description "Messages Admin Portlet"]

    portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value f

    portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

    register_portal_datasource_impl
    }

}



ad_proc -private messages_admin_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the messages admin portlet.
} {
    set spec {
        name "messages_admin_portlet"
    contract_name "portal_datasource"
    owner "messages-portlet"
        aliases {
        GetMyName messages_admin_portlet::get_my_name
        GetPrettyName  messages_admin_portlet::get_pretty_name
        Link messages_admin_portlet::link
        AddSelfToPage messages_admin_portlet::add_self_to_page
        Show messages_admin_portlet::show
        Edit messages_admin_portlet::edit
        RemoveSelfFromPage messages_admin_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private messages_portlet::uninstall {} {
    messages Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id messages_portlet]
    db_exec_plsql delete_messages_ds { *SQL* }
}

ad_proc -private messages_admin_portlet::uninstall {} {
    messages Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id messages_admin_portlet]
    db_exec_plsql delete_admin_ds { *SQL* }
}

ad_proc -private messages_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "messages_portlet"
}

ad_proc -private messages_admin_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "messages_admin_portlet"
}
