
CREATE FUNCTION fn_empresa_admin()
RETURNS int


AS
BEGIN

  --select DB_NAME()

  declare @cd_empresa int

  select 
    top 1
      @cd_empresa = isnull(cd_empresa,1)
  from 
    EgisAdmin.dbo.Empresa with (nolock) 
  where
    nm_banco_empresa = DB_NAME()
  order by
    cd_empresa

  return(@cd_empresa)

end

------------------------------------------------------------------------
--Example to execute function
------------------------------------------------------------------------
--Select  dbo.fn_empresa_admin()_
------------------------------------------------------------------------
