
CREATE PROCEDURE pr_rel_manutencao_nota_entrada
@ic_comercial char(1),
@dt_inicial datetime,
@dt_final   datetime

as

select
  Notas.*,

  dbo.fn_get_reduzido_conta_credito( cd_lancamento_padrao, 1 ) as 'cd_reduzido_cred_nf',
  dbo.fn_get_reduzido_conta_credito( cd_lancamento_padrao, 2 ) as 'cd_reduzido_cred_icms',
  dbo.fn_get_reduzido_conta_credito( cd_lancamento_padrao, 3 ) as 'cd_reduzido_cred_ipi',

  dbo.fn_get_reduzido_conta_debito( cd_lancamento_padrao, 1 ) as 'cd_reduzido_deb_nf',
  dbo.fn_get_reduzido_conta_debito( cd_lancamento_padrao, 2 ) as 'cd_reduzido_deb_icms',
  dbo.fn_get_reduzido_conta_debito( cd_lancamento_padrao, 3 ) as 'cd_reduzido_deb_ipi'

from
  (SELECT
     vw.nm_fantasia as nm_fantasia_fornecedor,
     vw.cd_destinatario as cd_fornecedor,
     ne.cd_nota_entrada,
     opf.cd_mascara_operacao,
     nei.cd_tributacao,   
     ne.dt_receb_nota_entrada,
     sum(nei.vl_contabil_nota_entrada) as vl_total_nota_entrada,
     sum(nei.vl_icms_nota_entrada) as vl_icms_nota_entrada,
     sum(nei.vl_ipi_nota_entrada) as vl_ipi_nota_entrada, 
     nr.cd_rem,
     isnull(nei.cd_mascara_classificacao, cf.cd_mascara_classificacao) as cd_mascara_classificacao,
     pl.cd_mascara_plano_compra, 
     dp.nm_destinacao_produto, 
     pc.cd_destinacao_produto, 
     pc.cd_plano_compra, 
     ne.cd_operacao_fiscal, -- usado para descobrir o lançamento padrão
     pent.cd_lancamento_padrao, -- usado para puxar as contas reduzidas
     isnull(sum(neir.vl_bicms_reg_nota_entrada), 0) as 'BaseCalculoICM',
     isnull(sum(neir.vl_bipi_reg_nota_entrada), 0) as 'BaseCalculoIPI',
     isnull(sum(neir.pc_icms_reg_nota_entrada), 0) as 'AliquotaICM',
     isnull(sum(neir.pc_ipi_reg_nota_entrada), 0) as 'AliquotaIPI',
     isnull(sum(neir.vl_icms_reg_nota_entrada), 0) as 'ImpostoDevidoICM',
     isnull(sum(neir.vl_ipi_reg_nota_entrada), 0) as 'ImpostoDevidoIPI',
     isnull(sum(neir.vl_icmsisen_reg_nota_entr), 0) as 'IsentasICM',
     isnull(sum(neir.vl_ipiisen_reg_nota_entr), 0) as 'IsentasIPI',
     isnull(sum(neir.vl_icmsoutr_reg_nota_entr), 0) as 'OutrasICM',
     isnull(sum(neir.vl_ipioutr_reg_nota_entr), 0) as 'OutrasIPI',
     isnull(sum(neir.vl_icmsobs_reg_nota_entr), 0) as 'ObservacaoICM',
     isnull(sum(neir.vl_ipiobs_reg_nota_entr), 0) as 'ObservacaoIPI' 
   FROM
     Nota_Entrada ne   
   LEFT OUTER JOIN
     vw_Destinatario vw
   ON
     ne.cd_fornecedor = vw.cd_destinatario and
     ne.cd_tipo_destinatario = vw.cd_tipo_destinatario   
   left outer join 
     Nota_Entrada_Registro nr 
   on 
     ne.cd_nota_entrada      = nr.cd_nota_entrada and
     ne.cd_fornecedor        = nr.cd_fornecedor   and
     ne.cd_operacao_fiscal   = nr.cd_operacao_fiscal and
     ne.cd_serie_nota_fiscal = nr.cd_serie_nota_fiscal    
   LEFT OUTER JOIN
     Operacao_Fiscal opf
   ON
     ne.cd_operacao_fiscal = opf.cd_operacao_fiscal   
   LEFT OUTER JOIN
     Nota_Entrada_Item nei
   on 
     ne.cd_nota_entrada      = nei.cd_nota_entrada and
     ne.cd_fornecedor        = nei.cd_fornecedor   and
     ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal and
     ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal   
   LEFT OUTER JOIN
     Nota_Entrada_Item_Registro neir
   on 
     nei.cd_nota_entrada      = neir.cd_nota_entrada and
     nei.cd_fornecedor        = neir.cd_fornecedor   and
     nei.cd_operacao_fiscal   = neir.cd_operacao_fiscal and
     nei.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal and
     nei.cd_item_nota_entrada = neir.cd_item_nota_entrada        
   left outer join
     Pedido_Compra pc
   on 
     pc.cd_pedido_compra = nei.cd_pedido_compra
   LEFT OUTER JOIN
     Destinacao_Produto dp
   ON
     pc.cd_destinacao_produto = dp.cd_destinacao_produto      
   left outer join
     Plano_Compra pl
   on 
     pl.cd_plano_compra = pc.cd_plano_compra   
   left outer join
     Parametro_Entrada pent
   on 
     pent.cd_destinacao_produto = pc.cd_destinacao_produto and
     pent.cd_plano_compra = pc.cd_plano_compra and
     pent.cd_operacao_fiscal = ne.cd_operacao_fiscal     
   left outer join
     Classificacao_Fiscal cf
   on
     cf.cd_classificacao_fiscal = neir.cd_classificacao_fiscal
   WHERE
     ne.dt_receb_nota_entrada BETWEEN @dt_inicial AND @dt_final and
     ((@ic_comercial = 'A') or (opf.ic_comercial_operacao = @ic_comercial))   
   GROUP BY
     vw.nm_fantasia,
     vw.cd_destinatario,
     ne.cd_nota_entrada,
     opf.cd_mascara_operacao,
     nei.cd_tributacao,   
     ne.dt_receb_nota_entrada,
     ne.vl_total_nota_entrada,
     ne.vl_icms_nota_entrada,
     ne.vl_ipi_nota_entrada,
     nr.cd_rem,
     isnull(nei.cd_mascara_classificacao, cf.cd_mascara_classificacao),
     pl.cd_mascara_plano_compra,
     dp.nm_destinacao_produto,   
     pc.cd_destinacao_produto, 
     pc.cd_plano_compra, 
     ne.cd_operacao_fiscal,
     pent.cd_lancamento_padrao ) Notas
  ORDER BY
    nm_fantasia_fornecedor,
    cd_fornecedor,
    cd_nota_entrada,
    cd_mascara_operacao,
    cd_tributacao,
    cd_mascara_classificacao

