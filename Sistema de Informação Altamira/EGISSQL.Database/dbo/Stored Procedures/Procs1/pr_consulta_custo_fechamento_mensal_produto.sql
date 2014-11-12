
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_custo_fechamento_mensal_produto
-------------------------------------------------------------------------------
--pr_consulta_custo_fechamento_mensal_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mostra o Custo de Fechamento Mensal 
--Data             : 01.02.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_custo_fechamento_mensal_produto
@dt_inicial      datetime,
@dt_final        datetime,
@cd_fase_produto int = 0

as

--declare @cd_fase_produto int
--select * from fase_produto

set @cd_fase_produto = 3

select
  month(pf.dt_produto_fechamento)  as Mes,
  year(pf.dt_produto_fechamento)   as Ano,
  p.cd_produto                     as Codigo_Interno,
  p.cd_mascara_produto             as Codigo,
  p.nm_fantasia_produto            as Fantasia,
  p.nm_produto                     as Produto,
  cast(round(isnull(vl_custo_medio_fechamento/qt_atual_prod_fechamento,0),4) as decimal(25,4)) as Custo 
into
  #CustoFechamento

from 
  Produto p
  inner join Produto_Fechamento pf on pf.cd_produto      = p.cd_produto and
                                      pf.cd_fase_produto = @cd_fase_produto
where
  pf.dt_produto_fechamento between @dt_inicial and @dt_final and
  pf.qt_atual_prod_fechamento>0

select
  *
from
  #CustoFechamento  
order by
  Fantasia,Ano,Mes

drop table #CustoFechamento  



