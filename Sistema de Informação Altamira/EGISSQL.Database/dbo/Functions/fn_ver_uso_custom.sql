
---------------------------------------------------------------------------------------
--fn_ver_uso_custom
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)	        : Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Função base para verificação se uso de customizações.
--Data			: 31/10/2006
--Atualização           : 24/11/2006 - Incluído customização de lote - Daniel C. Neto.
--14.08.2010 - Lote - Bariloche
---------------------------------------------------------------------------------------
CREATE  FUNCTION fn_ver_uso_custom
 (@nm_customizacao varchar(10))  
  
RETURNS int
  
AS  
begin  
  declare @retorno int

  set @retorno =  0

  if @nm_customizacao = 'RATEIO'
    if exists ( select 'x' from EGISADMIN.dbo.Empresa
		where cd_empresa = dbo.fn_empresa() and
		      nm_fantasia_empresa like '%CYDAK%')
      set @retorno =  1

  if @nm_customizacao = 'LOTE'
    if exists ( select 'x' from EGISADMIN.dbo.Empresa
		where cd_empresa = dbo.fn_empresa() and
		      nm_fantasia_empresa like '%TRM%' or nm_fantasia_empresa like '%GBS%' or
                      nm_fantasia_empresa like '%BARILOCHE%' )  
      set @retorno =  1

  return @retorno

end  
  
  
  
