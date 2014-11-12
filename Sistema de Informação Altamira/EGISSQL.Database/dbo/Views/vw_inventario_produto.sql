
-- vw_inventario_produto
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Alexandre Del Soldato
-- Banco de Dados: EgisSql
-- Objetivo: Lista Regitro de Invetário de Produto utilizado nos Arquivos Magnéticos
-- Data: 22/03/2004
-- Atualizado: 
-- ---------------------------------------------------------------------------------------
-- 
create view vw_inventario_produto
as
    -- SAÍDA
    select   
      distinct
      n.cd_nota_saida								as DOCUMENTO,
      nsi.cd_item_nota_saida							as ITEM,
      'S'									as ENTRADASAIDA,
      n.dt_nota_saida								as RECEBTOSAIDA,
      pf.dt_produto_fechamento 							as DATA,
      dbo.fn_limpa_mascara(p.cd_mascara_produto) 				as PRODUTO,
      isnull(ps.qt_saldo_atual_produto,isnull(pf.qt_atual_prod_fechamento,0)) 	as QUANTIDADE,
      (pf.vl_custo_prod_fechamento * isnull(ps.qt_saldo_atual_produto,
                                     isnull(pf.qt_atual_prod_fechamento,0)))  	as VALOR,
      1										as CODPOSSE,
      00000000000000                                                            as CNPJ,
      00000000000000                                                            as IE
    from
      Nota_Saida_Item_Registro r
    inner join
      Nota_Saida n
    on
      r.cd_nota_saida = n.cd_nota_saida  
    left outer join
      Operacao_Fiscal o
    on
      r.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = o.cd_grupo_operacao_fiscal
    left outer join
      Nota_Saida_Item nsi 
    on 
      nsi.cd_nota_saida = r.cd_nota_saida and
      nsi.cd_item_nota_saida = r.cd_item_nota_saida  
    left outer join
      Produto p
    on
      nsi.cd_produto = p.cd_produto
    left outer join 
      Produto_saldo ps 
    on
      ps.cd_produto = p.cd_produto and
      ps.cd_fase_produto = nsi.cd_fase_produto 
    left outer join 
      Produto_Fechamento pf 
    on
      pf.cd_produto = p.cd_produto and 
      pf.cd_fase_produto = nsi.cd_fase_produto and
      pf.dt_produto_fechamento = (dateadd( dd , -1, Cast(Str(year(n.dt_nota_saida))+'-'+Str(month(n.dt_nota_saida))+'-01' as DateTime) ))
    where
      gop.cd_tipo_operacao_fiscal = 2 and
      p.cd_produto = nsi.cd_produto
    union all
    select   
      distinct
      n.cd_nota_entrada								as DOCUMENTO,
      n.cd_item_nota_entrada							as ITEM,
      'E'									as ENTRADASAIDA,
      ni.dt_receb_nota_entrada							as RECEBTOSAIDA,
      pf.dt_produto_fechamento 							as DATA,
      dbo.fn_limpa_mascara(p.cd_mascara_produto) 				as PRODUTO,
      isnull(ps.qt_saldo_atual_produto,isnull(pf.qt_atual_prod_fechamento,0)) 	as QUANTIDADE,
      (pf.vl_custo_prod_fechamento * isnull(ps.qt_saldo_atual_produto,
                                     isnull(pf.qt_atual_prod_fechamento,0)))  	as VALOR,
      1										as CODPOSSE,
      00000000000000                                                            as CNPJ,
      00000000000000                                                            as IE
    from
      Nota_Entrada_Item_Registro ni
    left outer join
      Nota_Entrada_Item n
    on
      n.cd_nota_entrada = ni.cd_nota_entrada and
      n.cd_fornecedor = ni.cd_fornecedor and
      n.cd_operacao_fiscal = ni.cd_operacao_fiscal and
      n.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Nota_Entrada_Peps nep
    on
      nep.cd_documento_entrada_peps = cast(n.cd_nota_entrada as varchar(30)) and
      nep.cd_fornecedor = n.cd_fornecedor and
      nep.cd_item_documento_entrada = n.cd_item_nota_entrada 
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    left outer join
      Produto p
    on
      n.cd_produto = p.cd_produto
    left outer join 
      Produto_saldo ps 
    on
      ps.cd_produto = p.cd_produto and
      ps.cd_fase_produto = nep.cd_fase_produto 
    left outer join 
      Produto_Fechamento pf 
    on
      pf.cd_produto = p.cd_produto and 
      pf.cd_fase_produto = nep.cd_fase_produto and
      pf.dt_produto_fechamento = (dateadd( dd , -1, Cast(Str(year(ni.dt_receb_nota_entrada))+'-'+Str(month(ni.dt_receb_nota_entrada))+'-01' as DateTime) ))
    where
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      isnull(op.ic_servico_operacao,'N') = 'N'  and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
--     order by
--       produto 

-- select cd_fase_produto from nota_entrada_item    
-- 
-- select * from nota_entrada_peps


--select * from nota_entrada

--select * from vw_inventario_produto
