
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_orcamento_produto_sem_custo
-------------------------------------------------------------------------------
--pr_consulta_orcamento_produto_sem_custo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Produtos digitados no Orçamento sem preço
--                   de Custo para geração automática de cotação de preço de
--                   custos
--Data             : 08.09.2007
--Alteração        : 21.01.2008 - Ajustes Diversos - Carlos Fernands
--12.02.2008 - Ajuste 
------------------------------------------------------------------------------
create procedure pr_consulta_orcamento_produto_sem_custo
@ic_parametro           int = 0,
@cd_consulta            int = 0,
@cd_grupo_orcamento     int = 0,
@cd_categoria_orcamento int = 0

as

--select * from consulta_item_componente

select
  identity(int,1,1)                  as cd_controle,
  go.nm_grupo_orcamento,
  co.nm_categoria_orcamento,
  cli.nm_fantasia_cliente,
  v.nm_fantasia_vendedor,
  c.cd_consulta,
  c.dt_consulta,
  i.cd_item_consulta,
  i.cd_item_comp_orcamento,
  i.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  p.cd_categoria_produto,
  isnull(um.sg_unidade_medida,ume.sg_unidade_medida) as sg_unidade_medida,
  i.qt_item_comp_orcamento,
  i.ic_esp_comp_orcamento,
  i.nm_produto_orcamento,
  i.nm_obs_componente,
  i.vl_custo_produto,
  i.dt_custo_produto,
  i.cd_unidade_medida,
  isnull(ume.sg_unidade_medida,'')       as nm_unidade_medida
into
  #ProdutoSemCusto
from
  consulta_item_componente i             with (nolock)
  inner join Consulta c                  with (nolock) on c.cd_consulta             = i.cd_consulta
  left outer join produto p              with (nolock) on p.cd_produto              = i.cd_produto
  left outer join unidade_medida um      with (nolock) on um.cd_unidade_medida      = p.cd_unidade_medida
  left outer join cliente cli            with (nolock) on cli.cd_cliente            = c.cd_cliente
  left outer join Vendedor v             with (nolock) on v.cd_vendedor             = c.cd_vendedor_interno
  left outer join Categoria_Orcamento co with (nolock) on co.cd_categoria_orcamento = i.cd_categoria_orcamento
  left outer join Grupo_Orcamento     go with (nolock) on go.cd_grupo_orcamento     = co.cd_grupo_orcamento
  left outer join Unidade_Medida ume     with (nolock) on ume.cd_unidade_medida     = i.cd_unidade_medida
 where
   i.cd_consulta                      = case when @cd_consulta            = 0 then i.cd_consulta                      else @cd_consulta            end and
   isnull(i.cd_grupo_orcamento,0)     = case when @cd_grupo_orcamento     = 0 then isnull(i.cd_grupo_orcamento,0)     else @cd_grupo_orcamento     end and
   isnull(i.cd_categoria_orcamento,0) = case when @cd_categoria_orcamento = 0 then isnull(i.cd_categoria_orcamento,0) else @cd_categoria_orcamento end and
--   --and isnull(ic_gera_cotacao,'N')='N' 
  isnull(i.vl_custo_produto,0)=0

order by
  c.dt_consulta desc,
  c.cd_consulta desc,
  p.nm_fantasia_produto   

select
  *
from
  #ProdutoSemCusto
order by
  dt_consulta,
  cd_consulta desc,
  nm_fantasia_produto   



--Atualização do Custo
--select * from consulta_item_componente
-- update
--   consulta_item_componente
-- set
--   vl_custo_produto = :vl_custo_produto
-- where
--   cd_consulta = :cd_consulta and
--   cd_item_consulta = :cd_item_consulta and
--   cd_item_comp_orcamento = :cd_item_comp_orcamento


