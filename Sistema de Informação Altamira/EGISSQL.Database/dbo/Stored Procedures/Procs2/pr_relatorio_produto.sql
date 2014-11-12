
CREATE PROCEDURE pr_relatorio_produto
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias Pereira da Silva
--Banco de Dados: SQL 
--Objetivo      : Consultas para emissão do Relatório de Produtos
--Data          : 25/02/2004
--Atualizado    : 15/03/2004 - Acrescentado Código do Produto - ELIAS
--           
----------------------------------------------------------------------
@ic_parametro int,
@ic_pesquisa char(1),  -- POR (C)ÓDIGO, (F)ANTASIA
@nm_pesquisa varchar(50), -- CÓDIGO OU FANTASIA
@ic_inconsistente char(1)  -- SOMENTE OS INCONSISTENTES

as


-----------------------------------------------------
if @ic_parametro = 1   -- Busca dados para Relatório de Produtos p/ Contabilidade
-------------------------------------------------------------------------------
begin

  select 
    p.cd_produto as 'CodProduto',
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,p.cd_mascara_produto) as 'Mascara',
    p.nm_fantasia_produto as 'Fantasia',
    p.nm_produto as 'Nome',
    u.sg_unidade_medida as 'UN',
    c.sg_categoria_produto as 'Categoria',
    s.sg_serie_produto as 'Serie',
    gc.sg_grupo_categoria as 'GrupoCategoria',
    m.sg_tipo_mercado as 'Mercado',
    pc.cd_lancamento_padrao as 'CodLanctoPadrao',
    lp.nm_lancamento_padrao as 'LancamentoPadrao',
    pcd.cd_conta_reduzido as 'Debito',
    pcd.cd_mascara_conta as 'MascaraDebito',
    pcc.cd_conta_reduzido as 'Credito',
    pcc.cd_mascara_conta as 'MascaraCredito',
    h.nm_historico_contabil as 'Historico',
    tc.sg_tipo_contabilizacao as 'Contabilizacao',
    lp.ic_tipo_operacao as 'Operacao',
    p.vl_produto as 'ValorVenda',
    pcu.ic_peps_produto as 'PEPS',
    pcu.vl_custo_produto as 'Custo',
    p.dt_cadastro_produto as 'Cadastro'  
  from
    Produto p
  left outer join 
    Grupo_Produto gp
  on 
    p.cd_grupo_produto = gp.cd_grupo_produto
  left outer join 
    Unidade_Medida u
  on 
    p.cd_unidade_medida = u.cd_unidade_medida 
  left outer join 
    Categoria_Produto c
  on 
    p.cd_categoria_produto = c.cd_categoria_produto 
  left outer join 
    Serie_Produto s
  on 
    p.cd_serie_produto = s.cd_serie_produto
  left outer join 
    Grupo_Categoria gc
  on 
    p.cd_grupo_categoria = gc.cd_grupo_categoria 
  left outer join 
    Produto_Contabilizacao pc
  on 
    p.cd_produto = pc.cd_produto
  left outer join 
    Tipo_Mercado m
  on 
    pc.cd_tipo_mercado = m.cd_tipo_mercado
  left outer join 
    Lancamento_Padrao lp
  on 
    pc.cd_lancamento_padrao = lp.cd_lancamento_padrao
 left outer join 
   Plano_Conta pcd
 on 
   pcd.cd_conta = lp.cd_conta_debito_padrao
 left outer join 
   Plano_Conta pcc
 on 
   pcc.cd_conta = lp.cd_conta_credito_padrao
 left outer join 
   Historico_Contabil h
 on 
   lp.cd_historico_contabil = h.cd_historico_contabil
 left outer join 
   Tipo_Contabilizacao tc
 on 
    lp.cd_tipo_contabilizacao = tc.cd_tipo_contabilizacao
 left outer join 
   Produto_Custo pcu
 on 
   p.cd_produto = pcu.cd_produto
 where 
    -- Busca por Fantasia
   (((p.nm_fantasia_produto like @nm_pesquisa+'%') and (@ic_pesquisa = 'F')) or
    -- Busca por Código
    (replace(replace(replace(p.cd_mascara_produto,'/',''),'.',''),'-','') like
     replace(replace(replace(        @nm_pesquisa,'/',''),'.',''),'-','')+'%') and
   (@ic_pesquisa = 'C')) --and
--   (pc.cd_produto = case when (@ic_inconsistente = 'S') then NULL else p.cd_produto end)


end

