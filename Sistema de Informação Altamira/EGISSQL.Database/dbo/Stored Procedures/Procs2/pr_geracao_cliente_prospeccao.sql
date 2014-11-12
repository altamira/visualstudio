
-------------------------------------------------------------------------------
--pr_geracao_cliente_prospeccao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 29/10/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_cliente_prospeccao
  @cd_empresa int = 0,
  @cd_param   int = 0
AS

--select * from cliente
--select * from estado
--select * from cidade
--select * from cep
--select * from Fornecedor
--select * from egisSQL.dbo.cliente_prospeccao

Declare @sql varchar(8000)
Set
  @sql = ( select top 1 nm_banco_empresa from egisadmin.dbo.empresa where cd_empresa = @cd_empresa )

if @cd_param = 0
begin
  exec ('
    select distinct
      *
    from
      (
        select
          isnull(c.nm_fantasia_cliente, '''') as nm_fantasia_cliente,
          e.sg_estado,
          isnull(cd.cd_ddd_cidade, '''') cd_ddd_cidade,
          cd.sg_cidade,
          c.cd_telefone,
          c.nm_razao_social_cliente
        from 
          '+ @sql + '.dbo.cliente c
        left join '+ @sql + '.dbo.Estado e On e.cd_estado = c.cd_estado
        left join '+ @sql + '.dbo.Cidade cd On cd.cd_cidade = c.cd_cidade
  
        Union
 
        select
          isnull(c.nm_fantasia_fornecedor, '''') as nm_fantasia_cliente,
          e.sg_estado,
          isnull(cd.cd_ddd_cidade, '''') cd_ddd_cidade,
          cd.sg_cidade,
          c.cd_telefone,
          c.nm_razao_social as nm_razao_social_cliente
        from 
          '+ @sql + '.dbo.fornecedor c
        left join '+ @sql + '.dbo.Estado e On e.cd_estado = c.cd_estado
        left join '+ @sql + '.dbo.Cidade cd On cd.cd_cidade = c.cd_cidade
      ) as t
    Where
      nm_fantasia_cliente not in (
			  select nm_fantasia_cliente from cliente_prospeccao where not nm_fantasia_cliente is null
      )
    Order by
      nm_fantasia_cliente
  ')
end

--if @cd_param = 1
--begin
--end

