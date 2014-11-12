
CREATE PROCEDURE pr_lancamentos_estoque_terceiro_2
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
    ps.qt_consig_produto,
    cast(0 as integer)                  as 'cd_aplicacao_produto',
    isnull(ps.qt_saldo_atual_produto,0) as 'qt_saldo_atual_produto',
    cast(0 as integer)                  as 'cd_tipo_movimento_estoque',
    cast(0 as integer)                  as 'cd_historico_estoque',
    cast('N' as varchar(1))             as 'ic_consig_movimento',
    cast('N' as varchar(1))             as 'ic_terceiro_movimento',
    cast('N' as varchar(1))             as 'ic_peps_movimento_estoque',
    cast(0   as float)                  as 'vl_fob_convertido',
    cast(0   as float)                  as 'vl_custo_contabil_produto',
    cast(0   as float)                  as 'vl_fob_produto',
    cast(0   as float)                  as 'vl_unitario_movimento',
    cast(0   as float)                  as 'vl_total_movimento',
    cast(0   as float)                  as 'cd_tipo_documento_estoque',
    cast(0   as float)                  as 'cd_centro_custo',
    p.nm_fantasia_produto               as 'Produto_Origem_Fantasia',
    p.nm_produto                        as 'Produto_Origem_Nome',
    mpt.dt_movimento_terceiro           as 'dt_movimento_estoque',
    mpt.cd_movimento_produto_terceiro   as 'cd_movimento_estoque',
    mpt.cd_item_nota_fiscal             as 'cd_item_documento',
    cast(0 as datetime)                 as 'dt_documento_movimento',
    cast(0 as integer)                  as 'cd_serie_nota_fiscal', 
    mpt.cd_nota_entrada                 as 'cd_documento_movimento',
    mpt.qt_movimento_terceiro           as 'qt_movimento_estoque',
    cast(0 as integer)                  as 'cd_origem_baixa_produto',
    mpt.cd_destinatario                 as 'cd_fornecedor' ,
    cast(''as varchar(18))              as 'Centro_Custo',
    cast(0 as integer)                  as 'qt_origem_movimento',
    cast(0 as integer)                  as 'qt_fator_produto_unidade',
    cast(0 as varchar(5))               as 'cd_lote_produto',
    isnull(pc.ic_peps_produto,'N')      as 'ic_peps_produto',
    cast('E' as varchar(1))             as 'ic_mov_movimento',
    mpt.cd_produto,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto) as 'Mascara_Produto',
    p.nm_produto                               as 'Produto_Nome',
    p.nm_fantasia_produto                      as 'Produto_Fantasia',
    gp.cd_mascara_grupo_produto,
    dbo.fn_produto_localizacao(p.cd_produto,mpt.cd_fase_produto_terceiro) as 'LOCALIZACAO',
    u.sg_unidade_medida                        as 'Unidade_Produto',
    u.cd_unidade_medida, 
    mpt.cd_fase_produto_terceiro               as 'cd_fase_produto',         
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
    cast('N'as varchar(1))              as'ic_tipo_lancto_movimento',
    cast(0 as integer)                  as 'cd_unidade_origem', 
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
    
    ps.qt_consig_produto,
    cast(0 as integer)                  as 'cd_aplicacao_produto',
    isnull(ps.qt_saldo_atual_produto,0) as 'qt_saldo_atual_produto',
    cast(0 as integer)                  as 'cd_tipo_movimento_estoque',
    cast(0 as integer)                  as 'cd_historico_estoque',
    cast('N' as varchar(1))             as 'ic_consig_movimento',
    cast('N' as varchar(1))             as 'ic_terceiro_movimento',
    cast('N' as varchar(1))             as 'ic_peps_movimento_estoque',
    cast(0   as float)                  as 'vl_fob_convertido',
    cast(0   as float)                  as 'vl_custo_contabil_produto',
    cast(0   as float)                  as 'vl_fob_produto',
    cast(0   as float)                  as 'vl_unitario_movimento',
    cast(0   as float)                  as 'vl_total_movimento',
    cast(0   as float)                  as 'cd_tipo_documento_estoque',
    cast(0   as float)                  as 'cd_centro_custo',
    p.nm_fantasia_produto               as 'Produto_Origem_Fantasia',
    p.nm_produto                        as 'Produto_Origem_Nome',
    mpt.dt_movimento_terceiro           as 'dt_movimento_estoque' ,
    mpt.cd_movimento_produto_terceiro   as 'cd_movimento_estoque' ,
    mpt.cd_item_nota_fiscal             as 'cd_item_documento',
    cast(0 as datetime)                 as 'dt_documento_movimento',
    mpt.cd_nota_entrada                 as 'cd_documento_movimento',
    mpt.qt_movimento_terceiro           as 'qt_movimento_estoque',
    cast(0 as integer)                  as 'qt_fator_produto_unidade',
    cast(0 as integer)                  as 'cd_serie_nota_fiscal',
    mpt.cd_produto,
    mpt.cd_destinatario                 as 'cd_fornecedor',
    cast(0 as integer)                  as 'cd_origem_baixa_produto',
    cast(''as varchar(18))              as 'Centro_Custo',
    cast('N'as varchar(1))              as'ic_tipo_lancto_movimento', 
    cast(0 as integer)                  as 'cd_unidade_origem', 
    cast(0 as integer)                  as 'qt_origem_movimento',
    cast(0 as varchar(5))                as 'cd_lote_produto',
    cast('E' as varchar(1))             as 'ic_mov_movimento',
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto) as 'Mascara_Produto',
    p.nm_produto                               as 'Produto_Nome',
    p.nm_fantasia_produto                      as 'Produto_Fantasia',
    gp.cd_mascara_grupo_produto,
    dbo.fn_produto_localizacao(p.cd_produto,mpt.cd_fase_produto_terceiro)   as 'LOCALIZACAO',
    u.cd_unidade_medida,
    u.sg_unidade_medida                        as 'Unidade_Produto',
    mpt.cd_fase_produto_terceiro               as 'cd_fase_produto',         
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
  
