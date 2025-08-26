ALTER ROLE master SET statement_timeout = 60000;
do $$ begin if not exists (select * from pg_group where groname = 'group_superuser') then CREATE ROLE group_superuser; end if; end $$;
GRANT rds_superuser TO group_superuser;
do $$ begin if not exists (select * from pg_user where usename = 'db_superuser') then CREATE USER db_superuser; end if; end $$;
GRANT rds_iam, group_superuser TO db_superuser;
do $$ begin if not exists (select * from pg_group where groname = 'group_readwrite') then CREATE ROLE group_readwrite NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION; end if; end $$;
GRANT USAGE, CREATE ON SCHEMA public TO group_readwrite;
DO $$ 
DECLARE 
    schema_name TEXT;
BEGIN
    FOR schema_name IN 
        SELECT s.schema_name
        FROM information_schema.schemata s
        WHERE s.schema_name NOT IN ('pg_catalog', 'information_schema')
    LOOP
        EXECUTE format('GRANT USAGE, CREATE ON SCHEMA %I TO group_readwrite;', schema_name);
        EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA %I TO group_readwrite;', schema_name);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO group_readwrite;', schema_name);
        EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA %I TO group_readwrite;', schema_name);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT USAGE, SELECT ON SEQUENCES TO group_readwrite;', schema_name);
    END LOOP;
END $$;
do $$ begin if not exists (select * from pg_user where usename = 'db_readwrite') then CREATE USER db_readwrite NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION; end if; end $$;
GRANT rds_iam, group_readwrite, pg_read_all_stats TO db_readwrite;
do $$ begin if not exists (select * from pg_group where groname = 'group_readonly') then CREATE ROLE group_readonly NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION; end if; end $$;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO group_readonly;
DO $$ 
DECLARE 
    schema_name TEXT;
BEGIN
    FOR schema_name IN 
        SELECT s.schema_name
        FROM information_schema.schemata s
        WHERE s.schema_name NOT IN ('pg_catalog', 'information_schema')
    LOOP
        EXECUTE format('GRANT USAGE ON SCHEMA %I TO group_readonly;', schema_name);
        EXECUTE format('GRANT SELECT ON ALL TABLES IN SCHEMA %I TO group_readonly;', schema_name);
        EXECUTE format('GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA %I TO group_readonly', schema_name);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT USAGE, SELECT ON SEQUENCES TO group_readonly;', schema_name);
        EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT ON TABLES TO group_readonly;', schema_name);
    END LOOP;
END $$;
do $$ begin if not exists (select * from pg_user where usename = 'db_readonly') then CREATE USER db_readonly NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION; end if; end $$;
GRANT rds_iam, group_readonly, pg_read_all_stats TO db_readonly;