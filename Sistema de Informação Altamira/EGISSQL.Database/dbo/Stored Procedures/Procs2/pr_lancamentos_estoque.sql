

CREATE PROCEDURE pr_lancamentos_estoque
----------------------------------------------------------------------------------------------------------------
--pr_lancamentos_estoque
----------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
----------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel Duela 
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de lançamentos no estoque
--Data			: 24/05/2002
--Alteração		: Johnny Mendes de Souza 24/02/2003
--Desc. Alteração	: 07/04/2003 - Inclusão de Parâmetro p/ Pesquisa p/ Lcto - ELIAS
--                        22/04/2003 - Utilizada Função para formatar a máscara do Produto - ELIAS
--                                     Modificada a chamada a função fn_produto_localizacao, que passa a 
--                                     receber também o código de fase - ELIAS
--                        23/04/2003 - Acréscimo dos campos de sigla do tipo de destinatário e documento - ELIAS
--                        23/06/2003 - Retirado o Cast p/ decimal do campo de vl_total_movimento que estava
--                                     gerando erro de arredondamento - ELIAS
--                        06/10/2003 - Tirado Cast do campo 'qt_movimento_estoque' (Desnecessário). 
--                                     Agora o mesmo campo utiliza 4 casas decimais - Daniel Duela
--                        07/01/2004 - Tirado Cast do campos referente a valores (Desnecessário). 
--                                     Agora o mesmo campo utiliza 2 casas decimais - Daniel Duela
--                        07/01/2004 - Alteração no cálculo do Saldo Atual - (qt_saldo_atual_produto+qt_consig_produto) - Daniel Duela
--                        09/02/2004 - Inclusão do campo 'cd_aplicacao_produto' - Daniel Duela
--                        05/03/2004 - Inclusão do campo 'qt_consig_produto' - Daniel Duela
-- 06.02.2005 - Conversão de Unidade de Medida - Carlos Fernandes
-- 07.05.2005 - Apresentação do Lote na Grid - Carlos Fernandes
-- 28.09.2005 - Apresentação do Tipo de Lançamento / Grupo de Produto - Carlos Fernandes
--
----------------------------------------------------------------------------------------------------------------------

@ic_parametro           int, 
@ic_mov_tipo_movimento  char(1),
@dt_inicial             datetime,
@dt_final               datetime,
@cd_movimento_estoque   int = 0  -- ELIAS 07/04/2003

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Movimentações no Estoque
-------------------------------------------------------------------------------
  begin

  select

    me.cd_movimento_estoque,
    me.dt_movimento_estoque,
    me.cd_produto,
    me.cd_origem_baixa_produto,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto)
			                       as 'Mascara_Produto',  -- 22/04/2003
    p.nm_produto                               as 'Produto_Nome',
    p.nm_fantasia_produto                      as 'Produto_Fantasia',
    gp.cd_mascara_grupo_produto,
    dbo.fn_produto_localizacao(p.cd_produto,me.cd_fase_produto) 
					       as 'LOCALIZACAO',      -- 22/04/2003
    u.sg_unidade_medida                        as 'Unidade_Produto',
    p2.nm_produto                              as 'Produto_Origem_Nome',
    p2.nm_fantasia_produto                     as 'Produto_Origem_Fantasia',
    me.cd_fase_produto,         
    fp.nm_fase_produto                         as 'Fase_Produto',
    me.cd_tipo_movimento_estoque,
    tme.nm_tipo_movimento_estoque              as 'Tipo_Movimento',
    tme.sg_tipo_movimento_estoque,  -- 23/04/2003
    tme.ic_mov_tipo_movimento,   
    me.cd_documento_movimento,                        
    me.dt_documento_movimento,                      
    me.cd_item_documento,                             
    me.cd_tipo_documento_estoque,
    tde.nm_tipo_documento_estoque              as 'Tipo_Documento',
    tde.sg_tipo_documento_estoque, -- 23/04/2003
    me.cd_tipo_destinatario,
    td.nm_tipo_destinatario                    as 'Tipo_Destinatario',
    td.sg_tipo_destinatario,  -- 23/04/2003
    me.cd_fornecedor,
    me.nm_destinatario,
    me.cd_centro_custo,          
    cc.nm_centro_custo                         as 'Centro_Custo', 
    me.qt_movimento_estoque, 
    me.vl_unitario_movimento,
    me.vl_total_movimento,   
    me.vl_fob_produto,
    me.vl_fob_convertido,
    me.vl_custo_contabil_produto,
    isnull(me.ic_peps_movimento_estoque,'N')        as 'ic_peps_movimento_estoque',
    isnull(me.ic_terceiro_movimento,    'N')        as 'ic_terceiro_movimento',   
    isnull(me.ic_consig_movimento,      'N')        as 'ic_consig_movimento',     
    me.nm_historico_movimento,                                                 
    isnull(ps.qt_saldo_atual_produto,0) as 'qt_saldo_atual_produto',
    isnull(ps.qt_consig_produto,0) as 'qt_consig_produto',
    ps.qt_minimo_produto,
    ps.qt_maximo_produto,
    ps.qt_padrao_compra,
    ps.qt_padrao_lote_compra,
    me.cd_usuario,
    me.dt_usuario,
    me.cd_historico_estoque,
    me.cd_lote_produto,
    me.ic_mov_movimento,
    me.cd_unidade_medida,
    me.ic_tipo_lancto_movimento,
    us.nm_fantasia_usuario,
    isnull(pc.ic_peps_produto,'N')         as 'ic_peps_produto',
    me.cd_aplicacao_produto,
    me.cd_unidade_origem,
    me.qt_fator_produto_unidade,
    me.qt_origem_movimento,
    me.ic_tipo_lancto_movimento as 'Tipo_Lancamento',
    gp.nm_grupo_produto         

  from 
    Movimento_Estoque me
      left outer join 
    tipo_movimento_estoque tme 
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
      left outer join 
    Produto p
      on p.cd_produto = me.cd_produto
      left outer join 
    grupo_produto gp
      on p.cd_grupo_produto = gp.cd_grupo_produto
      Left Outer Join
    Produto p2
      on p2.cd_produto = me.cd_origem_baixa_produto
      left outer join
    unidade_medida u
      on u.cd_unidade_medida = p.cd_unidade_medida
      left outer join
    fase_produto fp
      on fp.cd_fase_produto = me.cd_fase_produto
      left outer join
    tipo_documento_estoque tde
      on tde.cd_tipo_documento_estoque = me.cd_tipo_documento_estoque
      left outer join
    Tipo_Destinatario td
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario
      Left Outer Join
    centro_custo cc
      on cc.cd_centro_custo = me.cd_centro_custo
      left outer join
    Produto_Saldo ps
      on me.cd_produto = ps.cd_produto and
         me.cd_fase_produto = ps.cd_fase_produto
      Left Outer join
    Produto_Custo pc
      on pc.cd_produto = p.cd_produto
      Left Outer join    
    EgisAdmin.dbo.Usuario us
      on me.cd_usuario = us.cd_usuario

  where  
    tme.ic_mov_tipo_movimento = @ic_mov_tipo_movimento and
    me.dt_movimento_estoque between @dt_inicial and @dt_final

  order by
    me.dt_movimento_estoque desc, 
    me.cd_movimento_estoque desc, 
    me.cd_produto

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- Pesquisa p/ Número de Lançamento - ELIAS 07/04/2003
-------------------------------------------------------------------------------
  begin

  select 
    me.cd_movimento_estoque,
    me.dt_movimento_estoque,
    me.cd_produto,
    me.cd_origem_baixa_produto,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto)
			                       as 'Mascara_Produto',  -- 22/04/2003
    p.nm_produto                               as 'Produto_Nome',
    p.nm_fantasia_produto                      as 'Produto_Fantasia',
    gp.cd_mascara_grupo_produto,
    dbo.fn_produto_localizacao(p.cd_produto,me.cd_fase_produto) 
					       as 'LOCALIZACAO',      -- 22/04/2003
    u.sg_unidade_medida                        as 'Unidade_Produto',
    p2.nm_produto                              as 'Produto_Origem_Nome',
    p2.nm_fantasia_produto                     as 'Produto_Origem_Fantasia',
    me.cd_fase_produto,         
    fp.nm_fase_produto                         as 'Fase_Produto',
    me.cd_tipo_movimento_estoque,
    tme.nm_tipo_movimento_estoque              as 'Tipo_Movimento',
    tme.sg_tipo_movimento_estoque,  -- 23/04/2003
    tme.ic_mov_tipo_movimento,   
    me.cd_documento_movimento,                        
    me.dt_documento_movimento,                      
    me.cd_item_documento,                             
    me.cd_tipo_documento_estoque,
    tde.nm_tipo_documento_estoque              as 'Tipo_Documento',
    tde.sg_tipo_documento_estoque, -- 23/04/2003
    me.cd_tipo_destinatario,
    td.nm_tipo_destinatario                    as 'Tipo_Destinatario',
    td.sg_tipo_destinatario,  -- 23/04/2003
    me.cd_fornecedor,
    me.nm_destinatario,
    me.cd_centro_custo,          
    cc.nm_centro_custo                         as 'Centro_Custo', 
    qt_movimento_estoque, 
    me.vl_unitario_movimento,
    me.vl_total_movimento,   
    me.vl_fob_produto,
    me.vl_fob_convertido,
    me.vl_custo_contabil_produto,
    isnull(me.ic_peps_movimento_estoque,'N')        as 'ic_peps_movimento_estoque',
    isnull(me.ic_terceiro_movimento,    'N')        as 'ic_terceiro_movimento',   
    isnull(me.ic_consig_movimento,      'N')        as 'ic_consig_movimento',     
    me.nm_historico_movimento,                                                 
    isnull(ps.qt_saldo_atual_produto,0) as 'qt_saldo_atual_produto',
    isnull(ps.qt_consig_produto,0) as 'qt_consig_produto',
    ps.qt_minimo_produto,
    ps.qt_maximo_produto,
    ps.qt_padrao_compra,
    ps.qt_padrao_lote_compra,
    me.cd_usuario,
    me.dt_usuario,
    me.cd_historico_estoque,
    me.cd_lote_produto,
    me.ic_mov_movimento,
    me.cd_unidade_medida,
    me.ic_tipo_lancto_movimento,
    us.nm_fantasia_usuario,
    isnull(pc.ic_peps_produto,'N')         as 'ic_peps_produto',
    me.cd_aplicacao_produto,
    me.cd_unidade_origem,
    me.qt_fator_produto_unidade,
    me.qt_origem_movimento,
    me.ic_tipo_lancto_movimento as 'Tipo_Lancamento',
    gp.nm_grupo_produto         

  from 
    Movimento_Estoque me
      left outer join 
    tipo_movimento_estoque tme 
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
      left outer join 
    Produto p
      on p.cd_produto = me.cd_produto
      left outer join 
    grupo_produto gp
      on p.cd_grupo_produto = gp.cd_grupo_produto
      Left Outer Join
    Produto p2
      on p2.cd_produto = me.cd_origem_baixa_produto
      left outer join
    unidade_medida u
      on u.cd_unidade_medida = p.cd_unidade_medida
      left outer join
    fase_produto fp
      on fp.cd_fase_produto = me.cd_fase_produto
      left outer join
    tipo_documento_estoque tde
      on tde.cd_tipo_documento_estoque = me.cd_tipo_documento_estoque
      left outer join
    Tipo_Destinatario td
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario
      Left Outer Join
    centro_custo cc
      on cc.cd_centro_custo = me.cd_centro_custo
      left outer join
    Produto_Saldo ps
      on me.cd_produto = ps.cd_produto and
         me.cd_fase_produto = ps.cd_fase_produto
      Left Outer join       
    Produto_Custo pc
       on pc.cd_produto = p.cd_produto 
       Left Outer Join
    EgisAdmin.DBO.Usuario us
      on me.cd_usuario = us.cd_usuario

  where  
    tme.ic_mov_tipo_movimento = @ic_mov_tipo_movimento and
    me.cd_movimento_estoque = @cd_movimento_estoque

  order by
    me.dt_movimento_estoque desc, 
    me.cd_movimento_estoque desc, 
    me.cd_produto

  end
  
