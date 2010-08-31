ad_library {
    Procedures for initializing service contracts etc. for the
    messages portlet package. Should only be executed 
    once upon installation.
    
    @creation-date 2010-01-20
    @author Pedro Castellanos (pedro@viaro.net)
}

namespace eval apm::messages_portlet {}
namespace eval apm::messages_admin_portlet {}

ad_proc -public apm::messages_portlet::after_install {} {
    Create the datasources needed by the messages portlets.
} {
    db_transaction {
        messages_portlet::after_install
    }
}

ad_proc -public apm::messages_portlet::before_uninstall {} {
    messages Portlet package uninstall proc
} {
    db_transaction {
        messages_portlet::uninstall
    }
}


