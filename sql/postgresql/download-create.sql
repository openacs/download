--
-- packages/sdm/sql/download/download-create.sql
--
-- 
-- @author Vinod Kurup (vinod@kurup.com)
-- 
-- @cvs-id $Id$
--

-- Note cr_items has available:
--    parent_id
--    name
--    publish_status
-- Note cr_revisions has available:
--    title
--    description
--    publish_date
--    content

-- QUESTION:  How do we store information about vendors like their
--   URL, or a description

--
-- Download Repository Instances:
--   Each has a description and some help text.
--   parent_id is the package_id
--
create table download_repository (
       repository_id integer
                     constraint download_repository_id_fk
                     references cr_items (item_id) on delete cascade
                     constraint download_repository_id_pk primary key
);

select content_type__create_type (
	'cr_download_rep',
	'content_revision',
	'Download Repository',
	'Download Repositories',
	'download_repository',
	'repository_id',
	null
);

comment on table download_repository is '
This table stores the actual download repositories.  Each repository has a title
and description of the repository.  Meta information about what can be stored in
the repository is keyed to this table';

-- DESIGN QUESTION: We could make the archive type part of the metadata,
-- but then we couldn't very well conditionalize other metadata based on it.

-- Each download module will support certain archive types, we need to indicate
-- what those types are.
create sequence download_archive_type_seq;
create view download_archive_type_sequence as 
	   select nextval('download_archive_type_seq') as nextval;
create table download_archive_types (
    archive_type_id integer
                    constraint download_archive_types_pk 
					primary key,
    repository_id   integer
					constraint download_archive_rep_id_fk 
					references download_repository (repository_id),
    pretty_name     varchar(100) not null,
    description     varchar(500) not null
);

comment on table download_archive_types is '
 This table stores the types of archives that can be stored in a given download repository.
';

create sequence download_reasons_seq;
create view download_reasons_sequence as 
	   select nextval('download_reasons_seq') as nextval;
create table download_reasons (
    download_reason_id integer
                       constraint download_archive_reasons_pk 
					   primary key,
    repository_id	   integer
					   constraint download_reason_id_fk 
					   references download_repository (repository_id) ,
    reason			   varchar(500) not null
);

comment on table download_archive_types is '
 This table stores the types of archives that can be stored in a given download repository.
';


--
-- Meta Information for Each Archive in a Particular Repository
-- We must be able to support meta info per archive for things like:
--   owners (email addresses)
--   vendors
--   dependencies
-- This is basically survey simple.
--
create table download_archive_metadata (
    metadata_id      integer
                     constraint download_ma_pk 
					 primary key,
    repository_id    integer
					 constraint download_ma_rep_id_fk
                     references download_repository (repository_id),
    --if archive_type_id is null, applies to all archive types
    archive_type_id  integer 
                     constraint download_ma_type_fk 
					 references download_archive_types,
    sort_key         integer
                     constraint download_ma_sort_key_nn
                     not null,
    pretty_name      varchar(100) 
					 constraint download_ma_pretty_name_nn
					 not null,
    data_type        varchar(30)
                     constraint download_data_type_ck
                     check (data_type in ('text', 'shorttext', 'boolean', 'number', 'integer', 'date', 'choice')),
    required_p       boolean,
    --linked_p indicates whether we should have links to show all
    --archives with a particular link
    linked_p         boolean,
    --is this field shown on the main page?                 
    mainpage_p       boolean,
    --is this field computed, or should we ask the user to enter it?
    computed_p       boolean
);

--When a piece of metadata has a fixed set of responses
create sequence download_md_choice_id_seq start 1;
create view download_md_choice_id_sequence as 
	   select nextval('download_md_choice_id_seq') as nextval;

create table download_metadata_choices (
	choice_id	integer 
				constraint download_mc_choice_id_nn 
				not null 
				constraint download_mc_choice_id_pk
				primary key,
	metadata_id	integer
				constraint download_mc_met_id_nn 
				not null 
				constraint download_mc_met_id_fk
				references download_archive_metadata,
	-- human readable 
	label		varchar(500) 
				constraint download_mc_label_nn
				not null,
	-- might be useful for averaging or whatever, generally null
	numeric_value	numeric,
	-- lower is earlier 
	sort_order	integer
);

comment on table download_archive_metadata is '
 This table stores information about all metadata stored for each archive in a given
 repository.';

--
-- The Archives Themselves
-- We need at least the following pieces of info:
--   archive_name (via cr_item.name)
--   repository_id (via cr_item.parent_id)
--   summary (via archive_desc_id.title)
--   description (via archive_desc_id.text)
--   description_type (i.e. archive_desc_id.mime_type for description)
--
create table download_archives (
    archive_id          integer
						constraint download_archives_a_id_fk 
                        references cr_items (item_id) on delete cascade 
                        constraint download_archives_a_id_pk 
						primary key,
    archive_type_id     integer 
                        constraint download_archives_at_id_fk 
						references download_archive_types,
-- we use another content_type to hold the content of the archive description, 
-- which we need in addition to version descriptions
    archive_desc_id     integer
                        constraint download_archives_ad_id_fk 
						references cr_revisions
);

-- We need at least the following
--
--  approved_p
--  approved_date
--  approved_user
--  approved_comment 
--  archive_id (via cr_revision.cr_item)
--  version_name (via cr_revision.description)
--  file_name (via cr_revision.title)
--  file_type (via cr_revision.mime_type)
--  file_content (via cr_revision.content)
--  version_url (via metadata)
--  release_notes (via metadata)
--  release_date (via metadata)
--  vendor (via metadata)
--  owner (via metadata)

--  I added file_size, cuz the oracle version
--  keeps content in blobs and thus can easily
--  get file_size from the database
--     vinodk 2001-05-16
create table download_archive_revisions (
    revision_id         integer
						constraint download_ar_id_fk
                        references cr_revisions (revision_id) on delete cascade
                        constraint download_ar_id_pk 
						primary key,
    approved_p          boolean,
    approved_date       timestamptz,
    approved_user       integer 
                        constraint download_ar_usr_fk 
						references users,
    approved_comment    text,
	file_size			integer
						constraint download_ar_file_size_nn
						not null
);

-- Storage of the metadata per archive
-- Long skinny table.
create table download_revision_data (
    revision_id       integer
					  constraint download_revision_data_fk
                      references download_archive_revisions(revision_id),
    metadata_id       integer
					  constraint download_revision_metadata_fk
                      references download_archive_metadata(metadata_id),
    --The possible responses.
    choice_id		  integer
					  constraint download_revision_choice_fk
					  references download_metadata_choices (choice_id),
    boolean_answer	  boolean,
    clob_answer		  text,
    number_answer	  numeric,
    varchar_answer	  text,
    date_answer		  timestamptz
);


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Information about who has downloaded stuff
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- We want to collect statistics on downloads.
create sequence download_downloads_seq;
create view download_downloads_sequence as 
	   select nextval('download_downloads_seq') as nextval;
create table download_downloads (
    download_id   integer 
                  constraint download_downloads_id_pk 
				  primary key,
    user_id       integer
				  constraint download_downloads_user_fk 
				  references users 
                  on delete set null,
    revision_id   integer
				  constraint download_downloads_rev_fk 
				  references download_archive_revisions
                  on delete cascade,
    download_date timestamptz not null,
    download_hostname varchar(400),
    download_ip   varchar(20),
    user_agent    varchar(200),
    reason_id     integer
				  constraint download_downloads_reason_fl
				  references download_reasons(download_reason_id) 
				  on delete set null,
    reason        text
);

select content_type__create_type (
	  'cr_download_archive',
	  'content_revision',
	  'Download Archive',
	  'Download Archives',
	  'download_archives',
	  'archive_id',
	  null
);

select content_type__register_child_type(
      'cr_download_rep',
      'cr_download_archive',
	  'generic',
	  0,
	  null
);

select content_type__create_type (
	  'cr_download_archive_desc',
	  'content_revision',
	  'Download Archive Description',
	  'Download Archive Descriptions',
	  'download_archive_descs',
	  'archive_desc_id',
	  null
);

select content_type__register_child_type(
      'cr_download_rep',
      'cr_download_archive_desc',
	  'generic',
	  0,
	  null
);

create view download_repository_obj as
       select repository_id, 
	          o.*, 
	          i.parent_id, 
			  r.title, 
			  r.description, 
			  r.content as help_text
       from download_repository dr, acs_objects o, cr_items i, cr_revisions r
	   where dr.repository_id = o.object_id and 
			 i.item_id = o.object_id and
             r.revision_id = i.live_revision;

create view download_archives_obj as
       select cri.parent_id as repository_id, 
			  cri.name as archive_name, 
			  cri.latest_revision, 
			  cri.live_revision,
              da.archive_id, 
			  da.archive_type_id, 
			  da.archive_desc_id,
              desc_item.title as summary, 
			  desc_item.description as description, 
			  desc_item.mime_type as description_type,
              desc_item.creation_user, 
			  desc_item.creation_date, 
			  desc_item.creation_ip 
       from download_archives da, cr_items cri, download_archive_descsi desc_item
	   where da.archive_desc_id = desc_item.revision_id and 
			 da.archive_id = cri.item_id;

create view download_arch_revisions_obj as
       select dar.*, 
			  o.*, 
			  r.item_id as archive_id, 
			  r.title as file_name, 
			  r.description as version_name, 
			  r.publish_date, 
			  r.mime_type, 
			  r.content
       from download_archive_revisions dar, acs_objects o, cr_revisions r
	   where dar.revision_id = o.object_id and 
			 dar.revision_id = r.revision_id;

create view download_downloads_repository as
       select dd.*,
			  (select repository_id 
			   from download_archives_obj da, cr_revisions r 
			   where dd.revision_id = r.revision_id and 
					 r.item_id = da.archive_id) as repository_id
       from download_downloads dd;

\i download-packages.sql
