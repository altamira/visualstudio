
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_faturamento_custo_fechamento_mensal_produto
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
create procedure pr_consulta_faturamento_custo_fechamento_mensal_produto
@dt_inicial      datetime,
@dt_final        datetime,
@cd_fase_produto int = 0,
@cd_produto      int = 0

as

--declare @cd_fase_produto int

set @cd_fase_produto = 3
set @cd_produto      = 0

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

-- select
--   *
-- from
--   #CustoFechamento  
-- order by
--   Fantasia,Ano,Mes

--select * from vw_faturamento

select
  month(vw.dt_nota_saida)           as Mes,
  year(vw.dt_nota_saida)            as Ano,
  vw.cd_produto                     as Codigo_Interno,
  max(p.cd_mascara_produto)         as Codigo,
  max(p.nm_fantasia_produto)        as Fantasia,
  max(p.nm_produto)                 as Produto,
  sum( vw.qt_item_nota_saida )      as Quantidade,
  sum( vw.vl_unitario_item_total)   as Total

  --cast(round(isnull(vl_custo_medio_fechamento/qt_atual_prod_fechamento,0),4) as decimal(25,4)) as Custo 
into
  #Faturamento

from 
  vw_faturamento vw
  left outer join Produto p        on p.cd_produto       = vw.cd_produto 
  
where
  vw.dt_nota_saida between @dt_inicial and @dt_final and
  vw.cd_produto    = case when @cd_produto = 0 then vw.cd_produto else @cd_produto end
  and isnull(vw.ic_comercial_operacao,'N')='S' 
  and vw.cd_status_nota = 5 
  and vw.ic_analise_op_fiscal = 'S'
group by
  month(vw.dt_nota_saida),
  year(vw.dt_nota_saida),
  vw.cd_produto
  
select
  f.*,
  cf.Custo,
  CustoTotal    = cf.Custo * f.Quantidade,
  Margem        = 0.00,
  Rentabilidade = 0.00,
  RentAcumulada = 0.00,
  PrecoMedio    = 0.00,
  PrecoMax      = 0.00,
  PrecoMin      = 0.00
  
  
from
  #Faturamento f
  left outer join #CustoFechamento cf on cf.codigo_interno = f.codigo_interno and
                                         cf.ano            = f.ano            and
                                         cf.mes            = f.mes
order by
   f.Fantasia,f.Ano,f.Mes



drop table #Faturamento
drop table #CustoFechamento  



