# /packages/download/www/admin/repository-ae.tcl
ad_page_contract {
     Repository add/edit page.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Mon Dec 11 18:49:53 2000
     @cvs-id $Id$
} {
    repository_id:integer,notnull
    {return_url "[ad_conn package_url]/admin/"}
}

set package_id      [ad_conn package_id]
set user_id [ad_conn user_id]
ad_require_permission $package_id "admin"

form create ae_repository
element create ae_repository return_url -label "ReturnUrl" -datatype text -widget hidden
element create ae_repository repository_id -label "RepositoryID" -datatype integer -widget hidden
element create ae_repository title -label "Title" -datatype text
element create ae_repository description -label "Description" -datatype text -widget textarea -html {rows 4 cols 40} -optional
element create ae_repository help_text -label "Help Text" -datatype text -widget textarea -html {rows 4 cols 40} -optional

#For now, just show link to admin page
if { ![db_0or1row repository_info {
    select title, description, help_text from download_repository_obj where repository_id = :repository_id
}] } {
    set title ""
    set description ""
    set help_text ""
}

if { [form is_request ae_repository] } {
    element set_properties ae_repository repository_id -value $repository_id
    element set_properties ae_repository title -value $title
    element set_properties ae_repository description -value $description
    element set_properties ae_repository help_text -value $help_text
    element set_properties ae_repository return_url -value $return_url
}

if { [form is_valid ae_repository] } {
    form get_values ae_repository
    set edit_p [db_string rep_count_get "select count(*) from download_repository_obj where repository_id = :repository_id"]
    if { $edit_p == "0" } {
        db_exec_plsql todo_insert {
         declare
          the_id integer;
         begin
          the_id := download_rep.new(repository_id  => :repository_id,
                             title => :title,
                             description => :description,
                             help_text => :help_text,
                             creation_user => :user_id,
                             parent_id => :package_id,
                             context_id => :package_id);
                    end;
        }
    } else {
        db_exec_plsql repository_edit {
             begin
                download_rep.edit(repository_id  => :repository_id,
                                         title => :title,
                                         description => :description,
                                         help_text => :help_text,
                                  modifying_user => :user_id
                );
             end;
        }
    }    
    ad_returnredirect "$return_url"
    ad_script_abort
}
        
ad_return_template