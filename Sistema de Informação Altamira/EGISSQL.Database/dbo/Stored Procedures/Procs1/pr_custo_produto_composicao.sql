
-----------------------------------------------------------------
-- pr_custo_produto_composicao
-----------------------------------------------------------------
--GBS - Global Business Solution Ltda                        20045
-----------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Daniel C. Neto
--Banco de Dados          : EgisSQL
--Objetivo                : Listar o Custo de Reposição da Composição de um Produto.
--Data                    : 10/02/2005
-----------------------------------------------------------------------------
create procedure pr_custo_produto_composicao
@ic_parametro char(1),   -- (1) - Por Fantasia, por Código
@nm_filtro varchar(80),
@cd_grupo_produto int


as

SELECT distinct
  gp.nm_fantasia_grupo_produto, 
  pc.vl_custo_produto, 
  pc.vl_custo_contabil_produto, 
  dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
  p.nm_produto, 
  p.nm_fantasia_produto, 
  prodc.nm_fantasia_produto as nm_fantasia_composicao,
  pcomp.qt_item_produto, 
  pcomp.cd_item_produto, 
  pcomp.qt_peso_liquido_produto, 
  pcomp.qt_peso_bruto_produto, 
  mp.nm_fantasia_mat_prima, 
  p.vl_produto, 
  fp.nm_fase_produto

FROM         
  Produto_Custo pc inner join
  Produto p ON pc.cd_produto = p.cd_produto inner join
  Produto_Composicao pcomp ON p.cd_produto = pcomp.cd_produto_pai and
                              p.cd_versao_produto = pcomp.cd_versao_produto_comp left outer join
  Grupo_Produto gp ON p.cd_grupo_produto = gp.cd_grupo_produto left outer join
  Materia_Prima mp ON pcomp.cd_materia_prima = mp.cd_mat_prima left outer join
  Fase_Produto fp ON pcomp.cd_fase_produto = fp.cd_fase_produto left outer join
  Produto prodc on prodc.cd_produto = pcomp.cd_produto
where
  ( case when @ic_parametro = 'F' then
      p.nm_fantasia_produto else
      dbo.fn_mascara_produto(p.cd_produto) 
    end ) like @nm_filtro + '%' and
  ( case when @cd_grupo_produto = 0 then
      @cd_grupo_produto else
      p.cd_grupo_produto end ) = @cd_grupo_produto
order by
  gp.nm_fantasia_grupo_produto,
  p.nm_fantasia_produto,
  pcomp.cd_item_produto

