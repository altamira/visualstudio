CREATE FUNCTION fn_empresa ()  
RETURNS int  
  
  
AS  
BEGIN  
  
  declare @cd_empresa int  
  
  select   
    @cd_empresa = cd_empresa  
  from   
    EgisAdmin.dbo.Empresa  
  where  
    nm_banco_empresa = DB_NAME()  
  
  return(@cd_empresa)  
  
end  

