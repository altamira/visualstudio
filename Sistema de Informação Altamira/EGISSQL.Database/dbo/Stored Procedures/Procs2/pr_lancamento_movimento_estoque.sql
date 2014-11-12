

/****** Object:  Stored Procedure dbo.pr_lancamento_movimento_estoque    Script Date: 13/12/2002 15:08:34 ******/

CREATE PROCEDURE pr_lancamento_movimento_estoque
@ic_parametro           int, 
@ic_mov_tipo_movimento  char(1),
@dt_inicial             datetime,
@dt_final               datetime

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Lançamento Estoque (Entrada)
-------------------------------------------------------------------------------
  begin
    select 
      me.cd_movimento_estoque,
      me.dt_movimento_estoque,
      tme.ic_mov_tipo_movimento,
      me.cd_tipo_movimento_estoque,
      tme.nm_tipo_movimento_estoque as 'Tipo_Lancamento',
      me.cd_produto,
      me.cd_fase_produto,
      me.cd_tipo_documento_estoque,
      me.cd_documento_movimento,
      me.dt_documento_movimento,
      me.cd_item_documento,
      me.cd_fornecedor,
      me.cd_centro_custo,
      me.qt_movimento_estoque,
      me.vl_unitario_movimento,
      me.vl_total_movimento,
      me.nm_historico_movimento,
      me.ic_peps_movimento_estoque,
      me.ic_terceiro_movimento,
      me.ic_fase_entrada_movimento,
      me.cd_fase_produto_entrada,
      me.cd_usuario,
      me.dt_usuario
    from Movimento_Estoque me
    left outer join Tipo_Movimento_Estoque tme on
      tme.cd_tipo_movimento_estoque=me.cd_tipo_movimento_estoque
    where  
      tme.ic_mov_tipo_movimento=@ic_mov_tipo_movimento and
      me.dt_movimento_estoque between @dt_inicial and @dt_final
  end


