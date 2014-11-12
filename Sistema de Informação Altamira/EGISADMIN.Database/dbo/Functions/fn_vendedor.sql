
---------------------------------------------------------------------------------------
--fn_documentacao_padrao
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Márcio
--Banco de Dados	: EGISSQL ou EGISADMIN
--Objetivo		: 
--
--Data			: 13/04/2004
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_vendedor
(@cd_usuario int)
RETURNS int
AS
Begin
     declare @cd_vendedor int
     if IsNull(@cd_usuario,0) <> 0  
     begin  
          set @cd_vendedor = isnull((select top 1 u.cd_vendedor  
                                     from EgisAdmin.dbo.Usuario_Internet u   
                                     where u.cd_usuario = @cd_usuario and   
                                           IsNull(u.ic_vpn_usuario,'N') = 'S'),0)  
     end
     return isnull(@cd_vendedor,0)
  
end
