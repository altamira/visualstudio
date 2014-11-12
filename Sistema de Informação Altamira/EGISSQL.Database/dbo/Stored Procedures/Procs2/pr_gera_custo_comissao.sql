
-------------------------------------------------------------------------------
--sp_helptext pr_gera_custo_comissao
-------------------------------------------------------------------------------
--pr_gera_custo_comissao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração do Valor de Custo sem Impostos para o Cálculo 
--                   da comissão
--Data             : 21.08.2007
--Alteração        : 23.08.2007 - Ajuste do IPI
------------------------------------------------------------------------------
create procedure pr_gera_custo_comissao

as

--select * from nota_entrada_item

select
  ine.cd_produto,
  ine.dt_item_receb_nota_entrad,
  max(ine.vl_item_nota_entrada + ( vl_item_nota_entrada * (isnull(pc_ipi_nota_entrada,0)/100))) as vl_custo_comissao
into
  #Produto_Custo
from
  nota_entrada_item ine
where
  isnull(ine.cd_produto,0)>0 and isnull(ine.vl_item_nota_entrada,0)>0
group by
  ine.cd_produto,
  ine.dt_item_receb_nota_entrad
order by
  ine.dt_item_receb_nota_entrad

select
  p.cd_produto,
--  isnull(pc.vl_custo_comissao,0) as vl_custo_comissao,
  ( select top 1 dt_item_receb_nota_entrad 
    from #Produto_Custo 
    where cd_produto = p.cd_produto order by dt_item_receb_nota_entrad desc )
     as DataCusto,

  isnull(( select top 1 isnull(vl_custo_comissao,0)
    from #Produto_Custo 
    where cd_produto = p.cd_produto order by dt_item_receb_nota_entrad desc ),0)
     as vl_custo_comissao

into
  #Tabela_Atualizacao
from
  Produto p
  left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto
order by
  p.cd_produto

-- select
--   *
-- from
--   #Tabela_Atualizacao

update
  produto_custo
set
  vl_custo_comissao = ta.vl_custo_comissao
from
  produto_custo pc 
  inner join #Tabela_Atualizacao ta on ta.cd_produto = pc.cd_produto

  
--select vl_custo_comissao,* from produto_custo

