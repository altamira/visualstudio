
-------------------------------------------------------------------------------
--pr_grupo_cliente_atraso
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Atraso de Documentos a Receber por Grupo de Cliente
--
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_grupo_cliente_atraso
@ic_parametro     int = 0,
@cd_cliente_grupo int = 0
as

--Grupo de cliente

if @ic_parametro = 1

begin
  select
    isnull(cg.cd_cliente_grupo,0)                                          as cd_cliente_grupo, 
    IsNull(cg.nm_cliente_grupo,'Sem Grupo')                                as 'Grupo',
    cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2)) as 'Total_Atraso',
    min(dr.dt_vencimento_documento)                                        as 'Vencimento'
  into #tabela_aux
  from
    Cliente cli 
    left outer join Documento_Receber dr on dr.cd_cliente = cli.cd_cliente 
    left outer join cliente_grupo cg     on cli.cd_cliente_grupo = cg.cd_cliente_grupo
  where
     dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-1,'N','U') and
     CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND  dr.dt_cancelamento_documento is null and dr.dt_devolucao_documento is null
     and cli.cd_cliente_grupo = case when @cd_cliente_grupo = 0 then cli.cd_cliente_grupo else @cd_cliente_grupo end
  Group by 
    cg.cd_cliente_grupo,cg.nm_cliente_grupo
  order by Total_Atraso desc

   select 
    identity(int,1,1) as 'posicao',*
   into #tabela
   from 
     #Tabela_aux
   order by
     total_atraso desc

   select * from #tabela

end

--Analítico por Cliente

if @ic_parametro=2
begin
  select
    cg.nm_cliente_grupo                                                    as 'Grupo',
    cli.nm_fantasia_cliente                                                as 'cliente', 
    cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2)) as 'Total_Atraso',
    min(dr.dt_vencimento_documento)                                        as 'Vencimento',
    max(cli.cd_vendedor)                                                   as 'CodVendedor',
   (select top 1 v.nm_fantasia_vendedor 
    from Vendedor v where v.cd_vendedor = max(cli.cd_vendedor))           as 'Vendedor'
  into #tabela_cli
  from
   Cliente cli 
   left outer join Documento_Receber dr on dr.cd_cliente = cli.cd_cliente 
   left outer join cliente_grupo cg     on cli.cd_cliente_grupo = cg.cd_cliente_grupo
  where
     cli.cd_cliente_grupo = case when @cd_cliente_grupo = 0 then cli.cd_cliente_grupo else @cd_cliente_grupo end and
     dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-1,'N','U') and
     CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND  dr.dt_cancelamento_documento is null and dr.dt_devolucao_documento is null
  Group by 
    cg.nm_cliente_grupo,
    cli.nm_fantasia_cliente
  order by Total_Atraso desc

  select 
    identity(int,1,1) as 'posicao',*
  into #tabelafinal
  from 
    #Tabela_cli
  order by
    total_atraso desc

  select * from #tabelafinal

end

