

--------------------------------------------------------------------------------------
--GBS - GLobal Business Solution - 200@cd_fase_produto
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor: ?
--Retorna o código do vendedor em função do usuário
--Data         : 05.15.2005
--------------------------------------------------------------------------------------  
CREATE FUNCTION fn_vendedor  
(@cd_usuario int)  
RETURNS int  
AS  
Begin  
     declare @cd_vendedor int  
     if IsNull(@cd_usuario,0) <> 0    
     begin    
          set @cd_vendedor = isnull((select top 1 u.cd_vendedor    
                                     from EgisAdmin.dbo.Usuario_Internet u     
                                     where u.cd_usuario_internet = @cd_usuario and     
                                           IsNull(u.ic_vpn_usuario,'N') = 'S'),0)    
     end  
     return isnull(@cd_vendedor,0)  
    
end  


