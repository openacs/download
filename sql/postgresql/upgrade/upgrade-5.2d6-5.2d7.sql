create or replace function inline_0 ()
returns integer as $$
DECLARE
   v_dummy integer;
BEGIN
   select setting from pg_settings where name='server_version_num' and setting::int >= 90200 into v_dummy;
   IF found THEN

      	drop view IF EXISTS download_reasons_sequence;
   	ALTER SEQUENCE IF EXISTS download_reasons_seq RENAME TO download_reasons_sequence;

	-- remove unused sequence
      	drop view IF EXISTS download_archive_type_seqence;
	DROP SEQUENCE IF EXISTS download_archive_type_seq;

   ELSE
	-- version earlier than 9.2, no "IF EXISTS" on ALTER SEQUENCE
	drop view download_reasons_sequence;
   	ALTER SEQUENCE download_reasons_seq RENAME TO download_reasons_sequence;

	-- remove unused sequence
      	drop view download_archive_type_seqence;
	DROP SEQUENCE download_archive_type_seq;

   END IF;
   return 1;
END;
$$ language 'plpgsql';

select inline_0();
drop function inline_0();

