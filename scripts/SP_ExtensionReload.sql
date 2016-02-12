CREATE OR REPLACE FUNCTION SP_ExtensionReload() RETURNS void
AS $$
DECLARE
  ver TEXT;
  sql TEXT;
BEGIN
  ver := split_part(systemapic.sp_version(), ' ', 1);
  sql := 'ALTER EXTENSION systemapic UPDATE TO ''' || ver || 'next''';
  EXECUTE sql;
  sql := 'ALTER EXTENSION systemapic UPDATE TO ''' || ver || '''';
  EXECUTE sql;
END;
$$ language 'plpgsql' VOLATILE;
