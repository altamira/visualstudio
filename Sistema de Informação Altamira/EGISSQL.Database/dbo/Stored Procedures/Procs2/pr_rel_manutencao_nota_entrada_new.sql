
CREATE PROCEDURE pr_rel_manutencao_nota_entrada_new
@ic_parametro int,
@ic_comercial char(1),
@dt_inicial datetime,
@dt_final   datetime

as

-------------------------------------------------------------------------------
if @ic_parametro = 1 --- LISTA SOMENTE OS VALORES FISCAIS
-------------------------------------------------------------------------------
begin

select 
  neir.cd_nota_entrada,
  neir.cd_fornecedor,
  neir.cd_operacao_fiscal,
  neir.cd_serie_nota_fiscal,
  cast(null as int) as cd_classificacao_fiscal,
  cast(null as int) as cd_item_nota_entrada,
  cast(null as int) as cd_tributacao,
  cast(null as char(10)) as cd_mascara_classificacao,
  isnull(sum(neir.vl_cont_reg_nota_entrada), 0) as 'ValorContabil',
  isnull(sum(neir.vl_bicms_reg_nota_entrada), 0) as 'BaseCalculoICM',
  isnull(sum(neir.vl_bipi_reg_nota_entrada), 0) as 'BaseCalculoIPI',
  isnull(neir.pc_icms_reg_nota_entrada, 0) as 'AliquotaICM',
  isnull(neir.pc_ipi_reg_nota_entrada, 0) as 'AliquotaIPI',
  isnull(sum(neir.vl_icms_reg_nota_entrada), 0) as 'ImpostoDevidoICM',
  isnull(sum(neir.vl_ipi_reg_nota_entrada), 0) as 'ImpostoDevidoIPI',
  isnull(sum(neir.vl_icmsisen_reg_nota_entr), 0) as 'IsentasICM',
  isnull(sum(neir.vl_ipiisen_reg_nota_entr), 0) as 'IsentasIPI',
  isnull(sum(neir.vl_icmsoutr_reg_nota_entr), 0) as 'OutrasICM',
  isnull(sum(neir.vl_ipioutr_reg_nota_entr), 0) as 'OutrasIPI',
  isnull(sum(neir.vl_icmsobs_reg_nota_entr), 0) as 'ObservacaoICM',
  isnull(sum(neir.vl_ipiobs_reg_nota_entr), 0) as 'ObservacaoIPI',
  max(isnull(neir.nm_obsicms_reg_nota_entr,op.nm_obs_livro_operacao)) as 'MsgObsICMS',
  max(neir.nm_obsipi_reg_nota_entr) as 'MsgObsIPI'
from
  nota_entrada_item_registro neir
left outer join
  nota_entrada n
on
  n.cd_nota_entrada      = neir.cd_nota_entrada and
  n.cd_fornecedor        = neir.cd_fornecedor   and
  n.cd_operacao_fiscal   = neir.cd_operacao_fiscal and
  n.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal  
left outer join
  Operacao_Fiscal op
on
  op.cd_operacao_fiscal = neir.cd_operacao_fiscal
where
  n.dt_receb_nota_entrada between @dt_inicial and @dt_final
group by
  neir.cd_nota_entrada,
  neir.cd_fornecedor,
  neir.cd_operacao_fiscal,
  neir.cd_serie_nota_fiscal,
  neir.pc_icms_reg_nota_entrada,
  neir.pc_ipi_reg_nota_entrada

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2 -- LISTA SOMENTE OS VALORES CONTÁBEIS
-------------------------------------------------------------------------------
begin

select 
  vw.nm_fantasia as nm_fantasia_fornecedor,
  nec.cd_fornecedor,  
  nec.cd_nota_entrada,
  nec.cd_serie_nota_fiscal,
  snf.sg_serie_nota_fiscal,
  op.cd_mascara_operacao,
  n.dt_receb_nota_entrada,
  pc.cd_mascara_plano_compra,
  dp.nm_destinacao_produto,
  nec.cd_destinacao_produto,
  nec.cd_operacao_fiscal,
  nec.cd_plano_compra,
  n.cd_tributacao,
  n.cd_rem,
  (select top 1 nei.cd_pedido_compra from nota_entrada_item nei
   where nei.cd_nota_entrada = nec.cd_nota_entrada and
         nei.cd_fornecedor = nec.cd_fornecedor and
         nei.cd_operacao_fiscal = nec.cd_operacao_fiscal and
         nei.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal) as 'cd_pedido_compra',
  -- Conta Reduzido Débito do Valor Contábil
  cast(isnull((select top 1 r.cd_conta_reduzido from Lancamento_Padrao l
   left outer join Plano_Conta r on r.cd_conta = l.cd_conta_debito and
                                    r.cd_empresa = dbo.fn_empresa() 
   where l.cd_conta_plano = lp.cd_conta_plano and
         l.cd_tipo_contabilizacao = 1 and
         l.ic_tipo_operacao = 'E'),0) as varchar) +'/'+
  -- Conta Reduzido Débito do IPI
  cast(isnull((select top 1 r.cd_conta_reduzido from Lancamento_Padrao l
   left outer join Plano_Conta r on r.cd_conta = l.cd_conta_debito and
                                    r.cd_empresa = dbo.fn_empresa() 
   where l.cd_conta_plano = lp.cd_conta_plano and
         l.cd_tipo_contabilizacao = 3 and
         l.ic_tipo_operacao = 'E'),0) as varchar) +'/'+
  -- Conta Reduzido Débito do ICMS
  cast(isnull((select top 1 r.cd_conta_reduzido from Lancamento_Padrao l
   left outer join Plano_Conta r on r.cd_conta = l.cd_conta_debito and
                                    r.cd_empresa = dbo.fn_empresa() 
   where l.cd_conta_plano = lp.cd_conta_plano and
         l.cd_tipo_contabilizacao = 2 and
         l.ic_tipo_operacao = 'E'),0) as varchar) as 'nm_classificacao_debito',
  -- Conta Reduzido Crédito do Valor Contabil
  cast(isnull((select top 1 r.cd_conta_reduzido from Lancamento_Padrao l
   left outer join Plano_Conta r on r.cd_conta = l.cd_conta_credito and
                                    r.cd_empresa = dbo.fn_empresa() 
   where l.cd_conta_plano = lp.cd_conta_plano and
         l.cd_tipo_contabilizacao = 1 and
         l.ic_tipo_operacao = 'E'),0) as varchar) +'/'+
  -- Conta Reduzido Crédito do IPI
  cast(isnull((select top 1 r.cd_conta_reduzido from Lancamento_Padrao l
   left outer join Plano_Conta r on r.cd_conta = l.cd_conta_credito and
                                    r.cd_empresa = dbo.fn_empresa() 
   where l.cd_conta_plano = lp.cd_conta_plano and
         l.cd_tipo_contabilizacao = 3 and
         l.ic_tipo_operacao = 'E'),0) as varchar) +'/'+
  -- Conta Reduzido Crédito do ICMS
  cast(isnull((select top 1 r.cd_conta_reduzido from Lancamento_Padrao l
   left outer join Plano_Conta r on r.cd_conta = l.cd_conta_credito and
                                    r.cd_empresa = dbo.fn_empresa() 
   where l.cd_conta_plano = lp.cd_conta_plano and
         l.cd_tipo_contabilizacao = 2 and
         l.ic_tipo_operacao = 'E'),0) as varchar) as 'nm_classificacao_credito',
  sum(isnull(nec.vl_contab_nota_entrada,0)) as vl_total_nota_entrada,
  sum(isnull(nec.vl_ipi_nota_entrada,0)) as vl_ipi_nota_entrada,
  sum(isnull(nec.vl_icms_nota_entrada,0)) as vl_icms_nota_entrada,
  sum(isnull(nec.vl_csll_nota_entrada,0)) as vl_csll_nota_entrada,
  sum(isnull(nec.vl_cofins_nota_entrada,0)) as vl_cofins_nota_entrada,
  sum(isnull(nec.vl_pis_nota_entrada,0)) as vl_pis_nota_entrada,
  sum(isnull(nec.vl_inss_nota_entrada,0)) as vl_inss_nota_entrada,
  sum(isnull(nec.vl_iss_nota_entrada,0)) as vl_iss_nota_entrada,
  sum(isnull(nec.vl_irrf_nota_entrada,0)) as vl_irrf_nota_entrada,
  IsNull(op.ic_servico_operacao,'N') as ic_servico_operacao
from 
  nota_entrada_contabil nec
left outer join
  nota_entrada n
on
  n.cd_nota_entrada = nec.cd_nota_entrada and
  n.cd_fornecedor = nec.cd_fornecedor and
  n.cd_operacao_fiscal = nec.cd_operacao_fiscal and
  n.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
left outer join 
  lancamento_padrao lp
on
  lp.cd_lancamento_padrao = nec.cd_lancamento_padrao 
left outer join
  plano_compra pc
on
  pc.cd_plano_compra = nec.cd_plano_compra
left outer join
  destinacao_produto dp
on
  dp.cd_destinacao_produto = nec.cd_destinacao_produto
left outer join
  Plano_Conta p
on
  p.cd_conta = lp.cd_conta_plano and
  p.cd_empresa = dbo.fn_empresa()
left outer join
  vw_destinatario_rapida vw
on
  vw.cd_destinatario = n.cd_fornecedor and
  vw.cd_tipo_destinatario = n.cd_tipo_destinatario
left outer join
  Operacao_Fiscal op
on
  op.cd_operacao_fiscal = n.cd_operacao_fiscal
inner join 
  Serie_Nota_Fiscal snf on
  snf.cd_serie_nota_fiscal = n.cd_serie_nota_fiscal and
  IsNull(snf.ic_rel_contab_serie_nota,'S') = 'S'
where 
  n.dt_receb_nota_entrada between @dt_inicial and @dt_final
group by
  vw.nm_fantasia,
  nec.cd_nota_entrada,
  nec.cd_fornecedor,
  nec.cd_operacao_fiscal,
  nec.cd_serie_nota_fiscal,
  op.cd_mascara_operacao,
  n.dt_receb_nota_entrada,
  pc.cd_mascara_plano_compra,
  dp.nm_destinacao_produto,
  nec.cd_destinacao_produto,
  nec.cd_plano_compra,
  n.cd_tributacao,
  n.cd_rem,
  lp.cd_conta_plano,
  snf.sg_serie_nota_fiscal,
  op.ic_servico_operacao
union all
select 
  vw.nm_fantasia as nm_fantasia_fornecedor,
  ne.cd_fornecedor,
  ne.cd_nota_entrada,
  ne.cd_serie_nota_fiscal,
  snf.sg_serie_nota_fiscal,
  op.cd_mascara_operacao,
  ne.dt_receb_nota_entrada,
  pc.cd_mascara_plano_compra,
  dp.nm_destinacao_produto,
  ne.cd_destinacao_produto,
  ne.cd_operacao_fiscal,
  nei.cd_plano_compra,
  nei.cd_tributacao,
  ne.cd_rem,
  (select top 1 nei.cd_pedido_compra from nota_entrada_item nei
   where nei.cd_nota_entrada = ne.cd_nota_entrada and
         nei.cd_fornecedor = ne.cd_fornecedor and
         nei.cd_operacao_fiscal = ne.cd_operacao_fiscal and
         nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal) as 'cd_pedido_compra',
  '0/0/0' as 'nm_classificacao_debito',
  '0/0/0' as 'nm_classificacao_credito',
  round(sum(isnull(nei.vl_total_nota_entr_item, 0) +
            isnull(nei.vl_ipi_nota_entrada, 0)),2) as 'vl_total_nota_entrada',
  round(sum(isnull(nei.vl_ipi_nota_entrada, 0)),2) as 'vl_ipi_nota_entrada', 
  round(sum(isnull(nei.vl_icms_nota_entrada, 0)),2) as 'vl_icms_nota_entrada',
  cast(null as decimal(25,2)) as 'vl_csll_nota_entrada',
  cast(null as decimal(25,2)) as 'vl_cofins_nota_entrada',
  cast(null as decimal(25,2)) as 'vl_pis_nota_entrada',
  cast(null as decimal(25,2)) as 'vl_inss_nota_entrada',
  cast(null as decimal(25,2)) as 'vl_iss_nota_entrada',
  cast(null as decimal(25,2)) as 'vl_irrf_nota_entrada',
  IsNull(op.ic_servico_operacao,'N') as ic_servico_operacao

from
  nota_entrada ne
left outer join
  nota_entrada_item nei
on
  ne.cd_nota_entrada = nei.cd_nota_entrada and
  ne.cd_fornecedor = nei.cd_fornecedor and
  ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
  ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
left outer join
  vw_destinatario_rapida vw
on
  vw.cd_destinatario = ne.cd_fornecedor and
  vw.cd_tipo_destinatario = ne.cd_tipo_destinatario
left outer join
  operacao_fiscal op
on
  op.cd_operacao_fiscal = ne.cd_operacao_fiscal
left outer join
  plano_compra pc
on
  pc.cd_plano_compra = nei.cd_plano_compra
left outer join
  destinacao_produto dp
on
  dp.cd_destinacao_produto = ne.cd_destinacao_produto
inner join
  Serie_Nota_Fiscal snf on
  snf.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
  IsNull(snf.ic_rel_contab_serie_nota,'S') = 'S'

where not exists(select 'x' from nota_entrada_contabil nec
                 where nec.cd_nota_entrada = ne.cd_nota_entrada and
                       nec.cd_fornecedor = ne.cd_fornecedor and
                       nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                       nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal) and
  ne.dt_receb_nota_entrada between @dt_inicial and @dt_final
group by
  vw.nm_fantasia,
  ne.cd_fornecedor,
  ne.cd_nota_entrada,
  ne.cd_serie_nota_fiscal,
  op.cd_mascara_operacao,
  ne.dt_receb_nota_entrada,
  pc.cd_mascara_plano_compra,
  dp.nm_destinacao_produto,
  ne.cd_destinacao_produto,
  ne.cd_operacao_fiscal,
  nei.cd_plano_compra,
  nei.cd_tributacao,
  ne.cd_rem,
  snf.sg_serie_nota_fiscal,
  op.ic_servico_operacao

 
order by
  1,3

end
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- LISTA AS INFORMAÇÕES CONTÁBEIS COM AS FISCAIS 
-------------------------------------------------------------------------------
begin

select 
  neir.cd_nota_entrada,
  neir.cd_fornecedor,
  neir.cd_operacao_fiscal,
  neir.cd_serie_nota_fiscal,
  neir.cd_classificacao_fiscal,
  neir.cd_item_nota_entrada,
  isnull(neir.cd_mascara_classificacao, cf.cd_mascara_classificacao) as cd_mascara_classificacao,
  isnull(sum(neir.vl_cont_reg_nota_entrada), 0) as 'ValorContabil',
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
into
  #Nota_Entrada_Livro
from
  nota_entrada_item_registro neir
left outer join
  nota_entrada n
on
  n.cd_nota_entrada      = neir.cd_nota_entrada and
  n.cd_fornecedor        = neir.cd_fornecedor   and
  n.cd_operacao_fiscal   = neir.cd_operacao_fiscal and
  n.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal 
left outer join
  Classificacao_Fiscal cf
on
  cf.cd_classificacao_fiscal = neir.cd_classificacao_fiscal        
where
  n.dt_receb_nota_entrada between @dt_inicial and @dt_final
group by
  neir.cd_nota_entrada,
  neir.cd_fornecedor,
  neir.cd_operacao_fiscal,
  neir.cd_serie_nota_fiscal,
  neir.cd_classificacao_fiscal,
  isnull(neir.cd_mascara_classificacao, cf.cd_mascara_classificacao),
  neir.cd_item_nota_entrada


select     
distinct
  e.nm_fantasia_destinatario,
  e.cd_fornecedor,
  e.cd_nota_entrada,
  e.cd_serie_nota_fiscal,
  opf.cd_mascara_operacao,
  e.dt_receb_nota_entrada,
  pl.cd_mascara_plano_compra, 
  dp.nm_destinacao_produto, 
  n.cd_destinacao_produto, 
  e.cd_operacao_fiscal, -- usado para descobrir o lançamento padrão
  n.cd_lancamento_padrao,
  nei.cd_plano_compra,
  nei.cd_tributacao,
  cast(isnull((select d.cd_conta_reduzido from nota_entrada_contabil l
               left outer join plano_conta d on d.cd_conta = l.cd_conta_debito
   where l.cd_nota_entrada = e.cd_nota_entrada and 
         l.cd_fornecedor = e.cd_fornecedor and
         l.cd_operacao_fiscal = e.cd_operacao_fiscal and 
         l.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal and
         l.vl_contab_nota_entrada is not null and
         l.cd_plano_compra = nei.cd_plano_compra),'') as varchar)+'/'+
  cast(isnull((select d.cd_conta_reduzido from nota_entrada_contabil l
               left outer join plano_conta d on d.cd_conta = l.cd_conta_debito
   where l.cd_nota_entrada = e.cd_nota_entrada and 
         l.cd_fornecedor = e.cd_fornecedor and
         l.cd_operacao_fiscal = e.cd_operacao_fiscal and 
         l.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal and
         l.vl_ipi_nota_entrada is not null and
         l.cd_plano_compra = nei.cd_plano_compra),'') as varchar)+'/'+
  cast(isnull((select d.cd_conta_reduzido from nota_entrada_contabil l
               left outer join plano_conta d on d.cd_conta = l.cd_conta_debito
   where l.cd_nota_entrada = e.cd_nota_entrada and 
         l.cd_fornecedor = e.cd_fornecedor and
         l.cd_operacao_fiscal = e.cd_operacao_fiscal and 
         l.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal and
         l.vl_icms_nota_entrada is not null and
         l.cd_plano_compra = nei.cd_plano_compra),'') as varchar) as nm_classificacao_debito,
  cast(isnull((select c.cd_conta_reduzido from nota_entrada_contabil l
               left outer join plano_conta c on c.cd_conta = l.cd_conta_credito
   where l.cd_nota_entrada = e.cd_nota_entrada and 
         l.cd_fornecedor = e.cd_fornecedor and
         l.cd_operacao_fiscal = e.cd_operacao_fiscal and 
         l.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal and
         l.vl_contab_nota_entrada is not null and
         l.cd_plano_compra = nei.cd_plano_compra),'') as varchar)+'/'+
  cast(isnull((select c.cd_conta_reduzido from nota_entrada_contabil l
               left outer join plano_conta c on c.cd_conta = l.cd_conta_credito
   where l.cd_nota_entrada = e.cd_nota_entrada and 
         l.cd_fornecedor = e.cd_fornecedor and
         l.cd_operacao_fiscal = e.cd_operacao_fiscal and 
         l.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal and
         l.vl_ipi_nota_entrada is not null and
         l.cd_plano_compra = nei.cd_plano_compra),'') as varchar)+'/'+
  cast(isnull((select c.cd_conta_reduzido from nota_entrada_contabil l
               left outer join plano_conta c on c.cd_conta = l.cd_conta_credito
   where l.cd_nota_entrada = e.cd_nota_entrada and 
         l.cd_fornecedor = e.cd_fornecedor and
         l.cd_operacao_fiscal = e.cd_operacao_fiscal and 
         l.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal and
         l.vl_icms_nota_entrada is not null and
         l.cd_plano_compra = nei.cd_plano_compra),'') as varchar) as nm_classificacao_credito,
  sum(isnull(n.vl_contab_nota_entrada,0)) as vl_total,
  sum(isnull(n.vl_ipi_nota_entrada,0)) as vl_ipi,
  sum(isnull(n.vl_icms_nota_entrada,0)) as vl_icms  
into
  #Nota_Entrada_Contabil
from
  nota_entrada e
left outer join
  nota_entrada_contabil n
on
  n.cd_fornecedor = e.cd_fornecedor and
  n.cd_nota_entrada = e.cd_nota_entrada and
  n.cd_operacao_fiscal = e.cd_operacao_fiscal and
  n.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal
left outer join
  nota_entrada_item nei
on
  nei.cd_fornecedor = e.cd_fornecedor and
  nei.cd_nota_entrada = e.cd_nota_entrada and
  nei.cd_operacao_fiscal = e.cd_operacao_fiscal and
  nei.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal
-- left outer join
--  plano_conta c
-- on
--  c.cd_conta = n.cd_conta_credito
left outer join
  Operacao_Fiscal opf
on
  e.cd_operacao_fiscal = opf.cd_operacao_fiscal   
left outer join
  Destinacao_Produto dp
on
  n.cd_destinacao_produto = dp.cd_destinacao_produto      
left outer join
  Plano_Compra pl
on 
  pl.cd_plano_compra = nei.cd_plano_compra   
where
  e.dt_receb_nota_entrada between @dt_inicial and @dt_final and
 ((@ic_comercial = 'A') or (opf.ic_comercial_operacao = @ic_comercial))  
group by
  e.nm_fantasia_destinatario,
  e.cd_fornecedor,
  e.cd_nota_entrada,
  opf.cd_mascara_operacao,
  e.dt_receb_nota_entrada,
  pl.cd_mascara_plano_compra,
  dp.nm_destinacao_produto,   
  n.cd_destinacao_produto, 
  nei.cd_plano_compra, 
  e.cd_operacao_fiscal,
  n.cd_lancamento_padrao,
  e.cd_serie_nota_fiscal,
  nei.cd_tributacao
order by
  e.nm_fantasia_destinatario,
  e.cd_fornecedor,
  e.cd_nota_entrada,
  opf.cd_mascara_operacao

select
  nec.nm_fantasia_destinatario as nm_fantasia_fornecedor,
  nec.cd_fornecedor,
  nec.cd_nota_entrada,
  nec.cd_mascara_operacao,
  nec.cd_tributacao,
  ne.dt_receb_nota_entrada,
  nei.cd_pedido_compra,
  case when (isnull(nec.vl_total,0)=0) then nel.ValorContabil else nec.vl_total end as vl_total_nota_entrada,
  case when (isnull(nec.vl_ipi,0)=0) then nel.ImpostoDevidoIPI else nec.vl_ipi end as vl_ipi_nota_entrada,
  case when (isnull(nec.vl_icms,0)=0) then nel.ImpostoDevidoICM else nec.vl_icms end as vl_icms_nota_entrada,
  ner.cd_rem,
  nel.cd_mascara_classificacao,
  pc.cd_mascara_plano_compra,
  dp.nm_destinacao_produto,
  nec.cd_destinacao_produto,
  nec.cd_plano_compra,
  ne.cd_operacao_fiscal,
  nec.cd_lancamento_padrao,
  nec.nm_classificacao_debito,
  nec.nm_classificacao_credito,
  nel.BaseCalculoICM,
  nel.BaseCalculoIPI,
  nel.AliquotaICM,
  nel.AliquotaIPI,
  nel.ImpostoDevidoICM,
  nel.ImpostoDevidoIPI,
  nel.IsentasICM,
  nel.IsentasIPI,
  nel.OutrasICM,
  nel.OutrasIPI,
  nel.ObservacaoICM,
  nel.ObservacaoIPI
from
  #Nota_Entrada_Contabil nec
left outer join
  Nota_Entrada ne
on
  ne.cd_nota_entrada = nec.cd_nota_entrada and
  ne.cd_fornecedor = nec.cd_fornecedor and
  ne.cd_operacao_fiscal = nec.cd_operacao_fiscal and
  ne.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
left outer join
  Nota_Entrada_Registro ner
on
  ner.cd_nota_entrada = nec.cd_nota_entrada and
  ner.cd_fornecedor = nec.cd_fornecedor and
  ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
  ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
left outer join
  Nota_Entrada_Item_Registro neir
on
  neir.cd_nota_entrada = nec.cd_nota_entrada and
  neir.cd_fornecedor = nec.cd_fornecedor and
  neir.cd_operacao_fiscal = nec.cd_operacao_fiscal and
  neir.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
left outer join
  #Nota_Entrada_Livro nel
on
  neir.cd_nota_entrada = nel.cd_nota_entrada and
  neir.cd_fornecedor = nel.cd_fornecedor and
  neir.cd_operacao_fiscal = nel.cd_operacao_fiscal and
  neir.cd_serie_nota_fiscal = nel.cd_serie_nota_fiscal
left outer join
  Nota_Entrada_Item nei
on
  nei.cd_nota_entrada = nel.cd_nota_entrada and
  nei.cd_fornecedor = nel.cd_fornecedor and
  nei.cd_operacao_fiscal = nel.cd_operacao_fiscal and
  nei.cd_serie_nota_fiscal = nel.cd_serie_nota_fiscal
left outer join
  Plano_Compra pc
on
  pc.cd_plano_compra = nec.cd_plano_compra
left outer join
  Destinacao_Produto dp
on
  dp.cd_destinacao_produto = nec.cd_destinacao_produto
order by
  nm_fantasia_fornecedor,
  nec.cd_fornecedor,
  nec.cd_nota_entrada,
  nec.cd_mascara_operacao,
  nec.cd_tributacao,
  nel.cd_mascara_classificacao

drop table #Nota_Entrada_Livro
drop table #Nota_Entrada_Contabil

end

