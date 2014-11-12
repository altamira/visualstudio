
-------------------------------------------------------------------------------
--sp_helptext pr_calculo_custo_reposicao_produto
-------------------------------------------------------------------------------
--pr_calculo_custo_reposicao_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : 
--Data             : 27.05.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_calculo_custo_reposicao_produto
@cd_produto      int     = 0,
@ic_custo_zerado char(1) = 'N'

as

--select vl_custo_produto,* from produto_custo

select
  p.cd_produto,
  isnull(pc.vl_custo_produto,0) as vl_custo_produto
into
  #CustoProduto
from
  produto p
  inner join produto_custo pc on pc.cd_produto = p.cd_produto

if @ic_custo_zerado = 'S'
   delete from #CustoProduto where isnull(vl_custo_produto,0)<>0

--select * from #CustoProduto

--select * from nota_entrada_item
  
select
  i.cd_produto,
  i.cd_nota_entrada,
  i.dt_item_receb_nota_entrad as dt_entrada,

  i.vl_total_nota_entr_item,
  i.vl_ipi_nota_entrada,
  i.vl_icms_nota_entrada,
 ( i.vl_total_nota_entr_item * (1.65/100) ) as vl_pis,
 ( i.vl_total_nota_entr_item * (7.60/100) ) as vl_cofins,

  custoproduto =

  isnull(vl_total_nota_entr_item,0) 
  +
  --IPI
  i.vl_ipi_nota_entrada

  -
  --PIS/COFINS
  case when o.ic_piscofins_op_fiscal = 'S' THEN
     ( i.vl_total_nota_entr_item * (1.65/100) )
     +
     ( i.vl_total_nota_entr_item * (7.60/100) )
  else
     0.00
  end
  --Verifica se Deduz o ICMS do Preço de Custo do Produto

  - 

  case when pc.ic_icms_custo_produto = 'S' then
    0.00
  else
    i.vl_icms_nota_entrada
  end

  /

  isnull(qt_item_nota_entrada,0)

into
  #CustoAux
 
from
  nota_entrada_item i
  inner join #CustoProduto p         on p.cd_produto         = i.cd_produto
  left outer join Operacao_Fiscal o  on o.cd_operacao_fiscal = i.cd_operacao_fiscal
  left outer join parametro_custo pc on pc.cd_empresa        = dbo.fn_empresa()

where
  i.qt_item_nota_entrada>0 AND
  ISNULL(o.ic_comercial_operacao,'N') = 'S'
order by
  3 desc

select * from #CustoAux order by 3 desc

--select top 1 custoproduto from #CustoAux x WHERE x.cd_produto = 263 order by dt_entrada desc 

update
  produto_custo
set
  vl_custo_produto = ( select top 1 custoproduto from #CustoAux x WHERE x.cd_produto = pc.cd_produto order by dt_entrada desc )
from
  produto_custo pc
  inner join #CustoProduto cp on cp.cd_produto = pc.cd_produto

--select vl_custo_produto from produto_custo where cd_produto = 263
-- select
--   cd_produto,
-- --  max(dt_item_receb_nota_entrada)    as dt_entrada,
--   custoproduto                       as custoproduto
-- into
--   #CustoFinal
-- from
--   #Custoaux
-- group by
--   cd_produto
-- --  custoproduto
-- 
-- select * from #CustoFinal 
-- group by
--   i.cd_produto

--select * from nota_entrada_item

-- update
--   produto_custo
-- set
--   vl_custo_produto = 0
-- where
--   cd_produto = 263

