
CREATE PROCEDURE pr_consulta_total_geral_estoque_caixa
@dt_inicial datetime,
@dt_final   datetime
AS

declare @cd_fase_produto int

select
  @cd_fase_produto = cd_fase_produto
from
  Parametro_Comercial
where
  cd_empresa = dbo.fn_empresa()


select
  gp.nm_grupo_produto                 as Grupo,
  p.cd_mascara_produto                as Codigo,
  p.nm_fantasia_produto               as Fantasia,
  p.nm_produto                        as Descricao,
  um.sg_unidade_medida                as Unidade,
  isnull(ps.qt_saldo_atual_produto,0) as Saldo,
  isnull(pc.vl_custo_produto,0)       as PrecoCusto,
  isnull(pc.vl_custo_produto,0) *
  isnull(ps.qt_saldo_atual_produto,0) as TotalCusto,
  isnull(p.vl_produto,0)              as PrecoVenda,
  isnull(p.vl_produto,0) *
  isnull(ps.qt_saldo_atual_produto,0) as TotalVenda
into
  #AuxTotal
from
  Produto p
  left outer join Grupo_Produto gp  on gp.cd_grupo_produto  = p.cd_grupo_produto
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join Produto_Saldo ps  on ps.cd_produto        = p.cd_produto         and
                                       ps.cd_fase_produto   = @cd_fase_produto
  left outer join Produto_Custo pc  on pc.cd_produto        = p.cd_produto

where
  isnull(p.cd_status_produto,1) = 1  and
isnull(ps.qt_saldo_atual_produto,0)>0
order by
  gp.nm_grupo_produto,
  p.nm_fantasia_produto


select
  *,
  Margem = (TotalCusto/case when TotalVenda>0 then TotalVenda else 1 end)*100
from
  #AuxTotal
order by 
  Grupo,
  Fantasia


