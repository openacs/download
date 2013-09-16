
UPDATE pg_attribute a SET atttypmod = 504 from pg_class c 
       where attname = 'user_agent' and c.oid = attrelid and 
       relname in ('download_downloads', 'download_downloads_repository');

UPDATE pg_attribute a SET atttypmod = 44 from pg_class c
       where attname = 'download_ip'  c.oid = attrelid and 
       relname in ('download_downloads', 'download_downloads_repository');