
CREATE PROCEDURE pr_lancamentos_estoque_terceiro
@ic_parametro         int, 
@ic_tipo_movimento    char(1),
@dt_inicial           datetime,
@dt_final             datetime,
@cd_movimento_estoque int = 0
AS

-------------------------------------------------------------------------------
if @ic_parametro = 2   -- Consulta de Movimentações no Estoque
-------------------------------------------------------------------------------
  begin
  select
    cast(0 as integer) as cd_lote_produto,
    mpt.cd_movimento_produto_terceiro,
    mpt.dt_movimento_terceiro,
    mpt.cd_destinatario,
    mpt.cd_nota_entrada,
    mpt.cd_item_nota_fiscal,
    mpt.cd_produto,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto) as 'Mascara_Produto',
    p.nm_produto                               as 'Produto_Nome',
    p.nm_fantasia_produto                      as 'Produto_Fantasia',
    gp.cd_mascara_grupo_produto,
    dbo.fn_produto_localizacao(p.cd_produto,mpt.cd_fase_produto_terceiro) as 'LOCALIZACAO',
    u.sg_unidade_medida                        as 'Unidade_Produto',
    u.cd_unidade_medida, 
    mpt.cd_fase_produto_terceiro,         
    fp.nm_fase_produto                         as 'Fase_Produto',
    mpt.ic_tipo_movimento                      as 'Tipo_Movimento',
    mpt.cd_documento_terceiro,                        
    mpt.cd_tipo_documento_terceiro,
    tde.nm_tipo_documento_estoque              as 'Tipo_Documento',
    tde.sg_tipo_documento_estoque,
    mpt.cd_tipo_destinatario,
    td.nm_tipo_destinatario                    as 'Tipo_Destinatario',
    td.sg_tipo_destinatario,
    mpt.nm_destinatario,
    mpt.qt_movimento_terceiro, 
    isnull(mpt.ic_tipo_movimento,    'N')      as 'ic_tipo_movimento',   
    mpt.nm_historico_movimento,                                                 
    mpt.cd_usuario,
    mpt.dt_usuario,
    us.nm_fantasia_usuario,
    gp.nm_grupo_produto         
  from 
    Movimento_Produto_Terceiro mpt
      left outer join 
    Produto p
      on p.cd_produto = mpt.cd_produto
      left outer join 
    grupo_produto gp
      on p.cd_grupo_produto = gp.cd_grupo_produto
      left outer join
    unidade_medida u
      on u.cd_unidade_medida = p.cd_unidade_medida
      left outer join
    fase_produto fp
      on fp.cd_fase_produto = mpt.cd_fase_produto_terceiro
      left outer join
    tipo_documento_estoque tde
      on tde.cd_tipo_documento_estoque = mpt.cd_tipo_documento_terceiro
      left outer join
    Tipo_Destinatario td
      on mpt.cd_tipo_destinatario = td.cd_tipo_destinatario
      left outer join
    Produto_Saldo ps
      on mpt.cd_produto = ps.cd_produto and
         mpt.cd_fase_produto_terceiro = ps.cd_fase_produto
      Left Outer join
    Produto_Custo pc
      on pc.cd_produto = p.cd_produto
      Left Outer join    
    EgisAdmin.dbo.Usuario us
      on mpt.cd_usuario = us.cd_usuario
  where  
    mpt.ic_tipo_movimento = @ic_tipo_movimento and
    mpt.dt_movimento_terceiro between @dt_inicial and @dt_final
  order by
    mpt.dt_movimento_terceiro desc, 
    mpt.cd_movimento_produto_terceiro desc, 
    mpt.cd_produto
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 1   -- Pesquisa p/ Número de Lançamento - ELIAS 07/04/2003
-------------------------------------------------------------------------------
  begin

  select 
    cast(0 as integer) as cd_lote_produto,
    mpt.cd_movimento_produto_terceiro,
    mpt.dt_movimento_terceiro,
    mpt.cd_produto,
    mpt.cd_destinatario,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto) as 'Mascara_Produto',
    p.nm_produto                               as 'Produto_Nome',
    p.nm_fantasia_produto                      as 'Produto_Fantasia',
    gp.cd_mascara_grupo_produto,
    dbo.fn_produto_localizacao(p.cd_produto,mpt.cd_fase_produto_terceiro)   as 'LOCALIZACAO',
    u.cd_unidade_medida,
    u.sg_unidade_medida                        as 'Unidade_Produto',
    mpt.cd_fase_produto_terceiro,         
    fp.nm_fase_produto                         as 'Fase_Produto',
    mpt.Ic_tipo_movimento                      as 'Tipo_Movimento',
    mpt.cd_documento_terceiro,                        
    mpt.cd_tipo_documento_terceiro,
    tde.nm_tipo_documento_estoque              as 'Tipo_Documento',
    tde.sg_tipo_documento_estoque,
    mpt.cd_tipo_destinatario,
    td.nm_tipo_destinatario                    as 'Tipo_Destinatario',
    td.sg_tipo_destinatario,
    mpt.nm_destinatario,
    isnull(mpt.ic_tipo_movimento,    'N')      as 'ic_tipo_movimento',   
    mpt.nm_historico_movimento,                                                 
    mpt.cd_usuario,
    mpt.dt_usuario,
    us.nm_fantasia_usuario,
    isnull(pc.ic_peps_produto,'N')             as 'ic_peps_produto',
    gp.nm_grupo_produto         
  from 
    Movimento_Produto_Terceiro mpt
      left outer join 
    Produto p
      on p.cd_produto = mpt.cd_produto
      left outer join 
    grupo_produto gp
      on p.cd_grupo_produto = gp.cd_grupo_produto
      left outer join
    unidade_medida u
      on u.cd_unidade_medida = p.cd_unidade_medida
      left outer join
    fase_produto fp
      on fp.cd_fase_produto = mpt.cd_fase_produto_terceiro
      left outer join
    tipo_documento_estoque tde
      on tde.cd_tipo_documento_estoque = mpt.cd_tipo_documento_terceiro
      left outer join
    Tipo_Destinatario td
      on mpt.cd_tipo_destinatario = td.cd_tipo_destinatario
      left outer join
    Produto_Saldo ps
      on mpt.cd_produto = ps.cd_produto and
         mpt.cd_fase_produto_terceiro = ps.cd_fase_produto
      Left Outer join       
    Produto_Custo pc
       on pc.cd_produto = p.cd_produto 
       Left Outer Join
    EgisAdmin.DBO.Usuario us
      on mpt.cd_usuario = us.cd_usuario
  where  
    mpt.ic_tipo_movimento = @ic_tipo_movimento and
    mpt.cd_movimento_produto_terceiro = @cd_movimento_estoque
  order by
    mpt.dt_movimento_terceiro desc, 
    mpt.cd_movimento_produto_terceiro desc, 
    mpt.cd_produto
  end
  
