CREATE  FUNCTION fn_vendedor_internet(@cd_usuario int)  
RETURNS integer  
AS  
BEGIN  
   RETURN(isnull((select   
    top 1 u.cd_vendedor  
        from   
    EgisAdmin.dbo.Usuario_Internet u   
        where   
    u.cd_usuario_internet = @cd_usuario and   
             IsNull(u.ic_vpn_usuario,'N') = 'S'),0))  
END  

