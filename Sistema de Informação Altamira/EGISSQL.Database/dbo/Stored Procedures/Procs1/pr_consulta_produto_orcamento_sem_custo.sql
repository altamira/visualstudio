
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_produto_orcamento_sem_custo
-------------------------------------------------------------------------------
--pr_consulta_produto_orcamento_sem_custo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Produto sem Preço de Custo 
--Data             : 18.04.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_produto_orcamento_sem_custo
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_consulta      int      = 0
as

select 
  cli.nm_fantasia_cliente   as Cliente,
  v.nm_fantasia_vendedor    as Vendedor,
  p.cd_mascara_produto      as CodigoProduto,
  p.nm_fantasia_produto     as Fantasia,
  p.nm_produto              as Descricao,
  go.nm_grupo_orcamento     as GrupoOrcamento,
  co.nm_categoria_orcamento as CategoriaOrcamento,
  cic.*   
from
  consulta_item_componente cic           with (nolock) 
  inner join consulta c                  with (nolock) on c.cd_consulta             = cic.cd_consulta
  left outer join cliente cli            with (nolock) on cli.cd_cliente            = c.cd_cliente
  left outer join vendedor v             with (nolock) on v.cd_vendedor             = c.cd_vendedor
  left outer join produto  p             with (nolock) on p.cd_produto              = cic.cd_produto
  left outer join unidade_medida um      with (nolock) on um.cd_unidade_medida      = p.cd_unidade_medida
  left outer join grupo_orcamento go     with (nolock) on go.cd_grupo_orcamento     = cic.cd_grupo_orcamento
  left outer join categoria_orcamento co with (nolock) on co.cd_categoria_orcamento = cic.cd_categoria_orcamento
where
  c.cd_consulta = case when @cd_consulta = 0 then c.cd_consulta else @cd_consulta end and
  c.dt_consulta between @dt_inicial and @dt_final and
  isnull(cic.vl_custo_produto,0)=0
order by
  c.dt_consulta
