----------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE  pr_consulta_saldo_reserva_maior_real
----------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Duela
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Produto cujos Saldo de Reserva sejam maiores que o saldo Real
--Data          : 20/05/2003
--Atualizado    : 27/08/2003
--                Ordenado por Máscara - Daniel C. Neto.
--              : 19.10.2007 - Carlos Fernandes                
-- 29.02.2008 - Acerto da Procedure e novo campo de Grupo de Produto - Carlos Fernandes
-- 28.10.2008 - Ajustes Diversos - Carlos Fernandes
-- 16.03.2010 - Ajustes Diversos/Fase - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------
@ic_parametro         int = 0

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Produto cujos Saldo de Reserva sejam maiores que o saldo Real
-------------------------------------------------------------------------------
begin
  select   
    p.cd_produto,
    p.cd_mascara_produto,
    --dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto ) as cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    f.nm_fase_produto,
    um.sg_unidade_medida,
    isnull(ps.qt_minimo_produto,0)        as qt_minimo_produto,
    isnull(ps.qt_consumo_produto,0)       as qt_consumo_produto,
    isnull(ps.qt_saldo_atual_produto,0)   as qt_saldo_atual_produto,
    isnull(ps.qt_saldo_reserva_produto,0) as qt_saldo_reserva_produto,
    isnull(ps.qt_terceiro_produto,0)      as qt_terceiro_produto,
    gp.nm_grupo_produto,
    sp.nm_status_produto,
    cp.nm_categoria_produto,
    p.nm_marca_produto
  from
    Produto p                            with (nolock) 
    left outer join Produto_saldo ps     with (nolock) on ps.cd_produto=p.cd_produto
    left outer join Unidade_medida um    with (nolock) on  p.cd_unidade_medida=um.cd_unidade_medida
    left outer join Grupo_Produto gp     with (nolock) on  p.cd_grupo_produto=gp.cd_grupo_produto
    left outer join Fase_produto f       with (nolock) on  f.cd_fase_produto=ps.cd_fase_produto
    left outer join Status_Produto sp    with (nolock) on sp.cd_status_produto = p.cd_status_produto
    left outer join Categoria_produto cp with (nolock) on cp.cd_categoria_produto = p.cd_categoria_produto
  where 
    isnull(ps.qt_saldo_reserva_produto,0)>isnull(ps.qt_saldo_atual_produto,0) and
    isnull(ps.cd_fase_produto,0)>0  and
    isnull(f.cd_fase_produto,0)>0
  order by 
    cd_mascara_produto, f.nm_fase_produto, p.nm_fantasia_produto

end

