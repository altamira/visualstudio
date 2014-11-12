
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_cliente_atraso
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Clientes em Atraso
--Data             : 26.10.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_cliente_atraso
@dt_inicial datetime = ''
as


select
  cli.nm_fantasia_cliente                                                as 'cliente', 
  cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2)) as 'Total_Atraso',
  min(dr.dt_vencimento_documento)                                        as 'Vencimento',
  max(cli.cd_vendedor)                                                   as 'CodVendedor',
  (select top 1 v.nm_fantasia_vendedor 
   from Vendedor v where v.cd_vendedor = max(cli.cd_vendedor))           as 'Vendedor',
   cg.nm_cliente_grupo
into #tabela_aux
from
   Documento_Receber dr  with (nolock)
   left outer join Cliente cli           on dr.cd_cliente        = cli.cd_cliente
   left outer join cliente_grupo cg on cli.cd_cliente_grupo = cg.cd_cliente_grupo
where
   --dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-1,'N','U') and
   dr.dt_vencimento_documento < @dt_inicial             and
   CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND 
   dr.dt_cancelamento_documento is null and 
   dr.dt_devolucao_documento    is null

Group by
   cli.nm_fantasia_cliente,
   cg.nm_cliente_grupo

order by Total_Atraso desc

select 
    identity(int,1,1) as 'posicao',*
into #tabela
from 
   #Tabela_aux
order by
   total_atraso desc

select * from #tabela
  
drop table #tabela
drop table #tabela_aux


--Antes na query Intera
-- select
--   cli.nm_fantasia_cliente                                                as 'cliente', 
--   cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2)) as 'Total_Atraso',
--   min(dr.dt_vencimento_documento)                                        as 'Vencimento',
--   max(cli.cd_vendedor)                                                   as 'CodVendedor',
--   (select top 1 v.nm_fantasia_vendedor 
--    from Vendedor v where v.cd_vendedor = max(cli.cd_vendedor))           as 'Vendedor',
--    cg.nm_cliente_grupo
-- into #tabela_aux
-- from
--    Cliente cli left outer join
--    Documento_Receber dr on dr.cd_cliente = cli.cd_cliente  left outer join
--    cliente_grupo cg on cli.cd_cliente_grupo = cg.cd_cliente_grupo
-- where
--    dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-1,'N','U') and
--    CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND  dr.dt_cancelamento_documento is null and dr.dt_devolucao_documento is null
-- 
--    
-- 
-- Group by cli.nm_fantasia_cliente,
--                 cg.nm_cliente_grupo
-- 
-- order by Total_Atraso desc
-- 
-- select 
--     identity(int,1,1) as 'posicao',*
-- into #tabela
-- from 
--    #Tabela_aux
-- order by
--    total_atraso desc
-- 
-- select * from #tabela
--   
-- drop table #tabela
-- drop table #tabela_aux
-- 

