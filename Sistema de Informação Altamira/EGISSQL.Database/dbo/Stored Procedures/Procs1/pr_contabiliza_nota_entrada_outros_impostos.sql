
CREATE PROCEDURE pr_contabiliza_nota_entrada_outros_impostos
------------------------------------------------------------------------------ 
--GBS - Global Business Solution              2002 
------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)        : Daniel Duela
--Banco de Dados   : EGISSQL 
--Objetivo         : Contabilização de Nota de Entrada.
--Data             : 23/07/2003 
--Atualizado       : 22/10/2003 - Acerto na Instrução que traz os "Sem Valor Comercial" - ELIAS
--                 : 23/10/2003 - Acréscimo dos campos DataEmissão e REM - ELIAS
--                 : 06/11/2003 - Acerto p/ Buscar Fornecedor da vw_Destinatario - ELIAS 
--                   07/11/2003 - Acerto na Busca dos Códigos de Conta e Histórico - ELIAS 
--                   12/11/2003 - Acerto p/ mostrar como sem vlr comercial inclusive as diferenças
--                                entre o contabilizado e a nfe - ELIAS
--                   13/11/2003 - Modificação na listagem de sem valor comercial - ELIAS
--                   18 a 20/11/2003 - Diversos Acertos - ELIAS
--                   25/11/2003 - Acerto no Sintético, aplicando os mesmos acertos feitos anteriormente
--                                no Analítico - ELIAS
------------------------------------------------------------------------------ 

@ic_parametro  int,
@dt_inicial    datetime,
@dt_final      datetime

as

--------------------------------------------------------
if  @ic_parametro = 1 --Contabilização Analitíco
--------------------------------------------------------
begin

  -----------------------------------------------
  -- Traz Notas de Saída sem conta
  -----------------------------------------------

  --CONTÁBIL
  select 
    nec.cd_nota_entrada,
    nec.cd_fornecedor,
    nec.cd_operacao_fiscal,
    nec.cd_serie_nota_fiscal,
    round(sum(isnull(nec.vl_contab_nota_entrada,0)),2)              as 'vl_contab_nota_entrada',
    round(sum(isnull(nec.vl_ipi_nota_entrada,0)),2)                 as 'vl_ipi_nota_entrada',
    round(sum(isnull(nec.vl_icms_nota_entrada,0)),2)                as 'vl_icms_nota_entrada'
  into
    #Nota_Contabil
  from 
    Nota_Entrada_Contabil nec
  left outer join
    Nota_Entrada ne
  on
    ne.cd_nota_entrada = nec.cd_nota_entrada and
    ne.cd_fornecedor = nec.cd_fornecedor and
    ne.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  where 
    isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) between @dt_inicial and @dt_final and
   (isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    nec.cd_nota_entrada,
    nec.cd_fornecedor,
    nec.cd_operacao_fiscal,
    nec.cd_serie_nota_fiscal 

  -- FISCAL
  select
    cast('SEM VALOR CONTABIL' as varchar(40))                  as Nome_Lancamento_Padrao,
    cast('' as varchar(20))                                    as Mascara_Lancamento_Padrao,
    cast(null as varchar(10))                                  as Reduzido_Lancamento_Padrao,
    cast(null as varchar(10))                                  as Reduzido_Credito,
    0                                                          as cd_conta_plano,
    cast(ne.cd_nota_entrada as varchar(10))                    as Documento,
    vw.nm_fantasia                                             as Fornecedor,              
    ne.dt_receb_nota_entrada                                   as DataContabilizacao,
    ne.dt_nota_entrada		  		                               as DataEmissao,
    ner.cd_rem        				                                 as REM,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal         as Operacao_Fiscal,
    opf.nm_operacao_fiscal                                     as Operacao_Fiscal_Nome,
    opf.cd_mascara_operacao                                    as Operacao_Fiscal_Mascara,
    isnull(opf.ic_comercial_operacao,'N')		                   as ValorComercial,
    isnull(opf.ic_servico_operacao,'N')		                     as Servico,
    round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2)      as vl_contab_nota_entrada,
    round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2)       as vl_ipi_nota_entrada,
    round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2)      as vl_icms_nota_entrada,
    cast(null as decimal(25,2))                                as ValorIRRF,
    cast(null as decimal(25,2))                                as ValorINSS,
    cast(null as decimal(25,2))                                as ValorISS,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    IsNull(ne.vl_pis_nota_entrada,0)                           as vl_pis_nota_entrada,
    Isnull(ne.vl_cofins_nota_entrada,0)                        as vl_cofins_nota_entrada,
    IsNull(ne.vl_csll_nota_entrada,0)                          as vl_csll_nota_entrada
  into
    #Nota_Entrada_Fiscal           
  from
    Nota_Entrada ne
  inner join
    Nota_Entrada_Item_Registro neir
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
    not exists (select 'x' from Nota_Entrada_Contabil nec where
                nec.cd_nota_entrada = ne.cd_nota_entrada and
                nec.cd_fornecedor = ne.cd_fornecedor and
                nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    cast(ne.cd_nota_entrada as varchar(10)),
    vw.nm_fantasia,                       
    ne.dt_nota_entrada,
    ne.dt_receb_nota_entrada,
    ner.cd_rem,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal,
    opf.nm_operacao_fiscal,
    opf.cd_mascara_operacao,
    isnull(opf.ic_comercial_operacao,'N'),
    isnull(opf.ic_servico_operacao,'N'),
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada
    
  -- DIFERENÇA                             
  select 
    cast('SEM VALOR CONTABIL' as varchar(40))          as Nome_Lancamento_Padrao,
    cast('' as varchar(20))                            as Mascara_Lancamento_Padrao,
    cast(null as varchar(10))                          as Reduzido_Lancamento_Padrao,
    cast(null as varchar(10))                          as Reduzido_Credito,
    0                                                  as cd_conta_plano,
    cast(ne.cd_nota_entrada as varchar(10))            as Documento,
    vw.nm_fantasia                                     as Fornecedor,              
    ne.dt_receb_nota_entrada                           as DataContabilizacao,
    ne.dt_nota_entrada		  		       as DataEmissao,
    ner.cd_rem        				       as REM,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal as Operacao_Fiscal,
    opf.nm_operacao_fiscal                             as Operacao_Fiscal_Nome,
    opf.cd_mascara_operacao                            as Operacao_Fiscal_Mascara,
    isnull(opf.ic_comercial_operacao,'N')	       as ValorComercial,
    isnull(opf.ic_servico_operacao,'N')		       as Servico,
    (round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2) - isnull(nc.vl_contab_nota_entrada,0))     as 'vl_contab_nota_entrada',
    (round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2) - isnull(nc.vl_ipi_nota_entrada,0))         as 'vl_ipi_nota_entrada',
    (round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2) - isnull(nc.vl_icms_nota_entrada,0))       as 'vl_icms_nota_entrada',
    cast(null as decimal(25,2))                        as ValorIRRF,
    cast(null as decimal(25,2))                        as ValorINSS,
    cast(null as decimal(25,2))                        as ValorISS,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    IsNull(ne.vl_pis_nota_entrada,0) as vl_pis_nota_entrada,
    Isnull(ne.vl_cofins_nota_entrada,0) as vl_cofins_nota_entrada,
    IsNull(ne.vl_csll_nota_entrada,0) as vl_csll_nota_entrada
  into
    #Nota_Dif_Sem_Valor_Comercial
  from 
    nota_entrada_item_registro neir
  inner join
    nota_entrada ne
  on
    ne.cd_nota_entrada = neir.cd_nota_entrada and
    ne.cd_fornecedor = neir.cd_fornecedor and
    ne.cd_operacao_fiscal = neir.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal
  inner join
    #Nota_Contabil nc
  on
    nc.cd_nota_entrada = ne.cd_nota_entrada and
    nc.cd_fornecedor = ne.cd_fornecedor and
    nc.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    nc.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where 
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final
  group by
    cast(ne.cd_nota_entrada as varchar(10)),
    vw.nm_fantasia,                       
    ne.dt_nota_entrada,
    ne.dt_receb_nota_entrada,
    ner.cd_rem,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal,
    opf.nm_operacao_fiscal,
    opf.cd_mascara_operacao,
    isnull(opf.ic_comercial_operacao,'N'),
    isnull(opf.ic_servico_operacao,'N'),
    nc.vl_contab_nota_entrada,
    nc.vl_ipi_nota_entrada,
    nc.vl_icms_nota_entrada,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    ne.vl_pis_nota_entrada,
    ne.vl_cofins_nota_entrada,
    ne.vl_csll_nota_entrada

  having
    ((round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2) - isnull(nc.vl_contab_nota_entrada,0)) > 0) or
    ((round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2) - isnull(nc.vl_ipi_nota_entrada,0)) > 0) or
    ((round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2) - isnull(nc.vl_icms_nota_entrada,0)) > 0)

  -- 1º AGRUPAMENTO
  select
    cast('SEM VALOR CONTABIL' as varchar(40))                                  as Nome_Lancamento_Padrao,
    cast('' as varchar(20))                                                    as Mascara_Lancamento_Padrao,
    cast(null as varchar(10))                                                  as Reduzido_Lancamento_Padrao,
    cast(null as varchar(10))                                                  as Reduzido_Credito,
    0                                                                          as cd_conta_plano,
    cast(ne.cd_nota_entrada as varchar(10))                                    as Documento,
    vw.nm_fantasia                                                             as Fornecedor,              
    ne.dt_receb_nota_entrada                                                   as DataContabilizacao,
    ne.dt_nota_entrada                        		  		       as DataEmissao,
    ner.cd_rem  					                       as REM,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal                         as Operacao_Fiscal,
    opf.nm_operacao_fiscal                                                     as Operacao_Fiscal_Nome,
    opf.cd_mascara_operacao                                                    as Operacao_Fiscal_Mascara,
    isnull(opf.ic_comercial_operacao,'N')		                       as ValorComercial,
    isnull(opf.ic_servico_operacao,'N')		                               as Servico,
    round(sum(isnull(ne.vl_total_nota_entrada,0)),2)                           as ValorTotal,
    round(sum(isnull(ne.vl_ipi_nota_entrada,0)),2)                             as ValorIPI,
    round(sum(isnull(ne.vl_icms_nota_entrada,0)),2)                            as ValorICMS,
    round(sum(isnull(ne.vl_irrf_nota_entrada,0)),2)                            as ValorIRRF,
    round(sum(isnull(ne.vl_inss_nota_entrada,0)),2)                            as ValorINSS,
    round(sum(isnull(ne.vl_iss_nota_entrada,0)),2)                             as ValorISS,
    IsNull(ne.vl_pis_nota_entrada,0)                                           as vl_pis_nota_entrada,
    Isnull(ne.vl_cofins_nota_entrada,0)                                        as vl_cofins_nota_entrada,
    IsNull(ne.vl_csll_nota_entrada,0)                                          as vl_csll_nota_entrada
  into	
    #ContabilRazaoSemConta
  from
    Nota_Entrada ne
  left outer join
    Nota_Entrada_Item_Registro neir
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
     not exists (select 'x' from Nota_Entrada_Contabil nec where
                 nec.cd_nota_entrada = ne.cd_nota_entrada and
                 nec.cd_fornecedor = ne.cd_fornecedor and
                 nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                 nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                 isnull(nec.cd_lancamento_padrao,0)<>0) and
     not exists (select 'x'  from #Nota_Dif_Sem_Valor_Comercial nec where
                 nec.cd_nota_entrada = ne.cd_nota_entrada and
                 nec.cd_fornecedor = ne.cd_fornecedor and
                 nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                 nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal) and
     not exists (select 'x'  from #Nota_Entrada_Fiscal nec where
                 nec.cd_nota_entrada = ne.cd_nota_entrada and
                 nec.cd_fornecedor = ne.cd_fornecedor and
                 nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                 nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal)                               
  group by 
    cast(ne.cd_nota_entrada as varchar(10)),
    vw.nm_fantasia,                       
    ne.dt_nota_entrada,
    ne.dt_receb_nota_entrada,
    ner.cd_rem,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal,
    opf.nm_operacao_fiscal,
    opf.cd_mascara_operacao,
    isnull(opf.ic_comercial_operacao,'N'),
    isnull(opf.ic_servico_operacao,'N'),
    ne.vl_pis_nota_entrada,
    ne.vl_cofins_nota_entrada,
    ne.vl_csll_nota_entrada
  order by
    Documento

  -- 2º AGRUPAMENTO
  insert into 
    #ContabilRazaoSemConta 
  select 
    dif.Nome_Lancamento_Padrao,
    dif.Mascara_Lancamento_Padrao,
    dif.Reduzido_Lancamento_Padrao,
    dif.Reduzido_Credito,
    dif.cd_conta_plano,
    dif.Documento,
    dif.Fornecedor,              
    dif.DataContabilizacao,
    dif.DataEmissao,
    dif.REM,
    dif.Operacao_Fiscal,
    dif.Operacao_Fiscal_Nome,
    dif.Operacao_Fiscal_Mascara,
    dif.ValorComercial,
    dif.Servico,
    dif.vl_contab_nota_entrada,
    dif.vl_ipi_nota_entrada,
    dif.vl_icms_nota_entrada,
    dif.ValorIRRF,
    dif.ValorINSS,
    dif.ValorISS,
    dif.vl_pis_nota_entrada,
    dif.vl_cofins_nota_entrada,
    dif.vl_csll_nota_entrada
  from 
    #Nota_Dif_Sem_Valor_Comercial dif
  where
    not exists(select 'x' from #ContabilRazaoSemConta nec
               where nec.Documento = dif.Documento and
                     nec.Fornecedor = dif.Fornecedor)

  -- 3º AGRUPAMENTO
  insert into 
    #ContabilRazaoSemConta 
  select 
    dif.Nome_Lancamento_Padrao,
    dif.Mascara_Lancamento_Padrao,
    dif.Reduzido_Lancamento_Padrao,
    dif.Reduzido_Credito,
    dif.cd_conta_plano,
    dif.Documento,
    dif.Fornecedor,              
    dif.DataContabilizacao,
    dif.DataEmissao,
    dif.REM,
    dif.Operacao_Fiscal,
    dif.Operacao_Fiscal_Nome,
    dif.Operacao_Fiscal_Mascara,
    dif.ValorComercial,
    dif.Servico,
    dif.vl_contab_nota_entrada,
    dif.vl_ipi_nota_entrada,
    dif.vl_icms_nota_entrada,
    dif.ValorIRRF,
    dif.ValorINSS,
    dif.ValorISS,
    dif.vl_pis_nota_entrada,
    dif.vl_cofins_nota_entrada,
    dif.vl_csll_nota_entrada
  from 
    #Nota_Entrada_Fiscal dif
  where
    not exists(select 'x' from #ContabilRazaoSemConta nec
               where nec.Documento = dif.Documento and
                     nec.Fornecedor = dif.Fornecedor)

  ------------------------------------------------
  -- Traz Notas de Saída com conta
  ------------------------------------------------
		
  --Foi criada esta tabela para agrupara os valores sem a necessidade de uma 
  --restruturação da lógica empregada nos outros procedimentos

  -- TODOS OS VALORES DE IRRF, INSS E ISS
  select
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    nec.cd_nota_entrada,
    isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) as dt_contab_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    nec.cd_fornecedor,
    vw.nm_fantasia as nm_fantasia_fornecedor,
    nec.cd_operacao_fiscal,
    cast(null as decimal(25,2))                         as vl_contab_nota_entrada,
    cast(null as decimal(25,2))                         as vl_ipi_nota_entrada,
    cast(null as decimal(25,2))                         as vl_icms_nota_entrada,
    round(isnull(ne.vl_irrf_nota_entrada,0),2) 	        as vl_irrf_nota_entrada,
    round(isnull(ne.vl_inss_nota_entrada,0),2)          as vl_inss_nota_entrada,
    round(isnull(ne.vl_iss_nota_entrada,0),2)  	        as vl_iss_nota_entrada
  into
    #Nota_Contabil_IRRF
  from
    Nota_Entrada_Contabil nec
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne 
  on
    ne.cd_nota_entrada = nec.cd_nota_entrada and
    ne.cd_fornecedor = nec.cd_fornecedor and
    ne.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal 
  left outer join 
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario 
  inner join 
    Lancamento_Padrao lp 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao = 1
  where
    ((isnull(ne.vl_irrf_nota_entrada,0) <> 0) or
    (isnull(ne.vl_inss_nota_entrada,0) <> 0) or
    (isnull(ne.vl_iss_nota_entrada,0) <> 0)) and
    (isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) between @dt_inicial and @dt_final) and
    (isnull(nec.cd_lancamento_padrao,0)<>0)
  order by
    nec.cd_nota_entrada

  -- TODOS OS VALORES CONTABEIS, IPI E ICMS
  select 
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    nec.cd_nota_entrada,
    isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) as dt_contab_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    nec.cd_fornecedor,
    vw.nm_fantasia as nm_fantasia_fornecedor,
    nec.cd_operacao_fiscal,
    sum(round(isnull(nec.vl_contab_nota_entrada,0),2)) as vl_contab_nota_entrada,
    sum(round(isnull(nec.vl_ipi_nota_entrada,0),2))    as vl_ipi_nota_entrada,
    sum(round(isnull(nec.vl_icms_nota_entrada,0),2))   as vl_icms_nota_entrada,
    cast(null as decimal(25,2))                        as vl_irrf_nota_entrada,
    cast(null as decimal(25,2))                        as vl_inss_nota_entrada,
    cast(null as decimal(25,2))                        as vl_iss_nota_entrada
  into	
    #ContabilRazaoComContaBase
  from
    Nota_Entrada_Contabil nec
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne 
  on
    ne.cd_nota_entrada = nec.cd_nota_entrada and
    ne.cd_fornecedor = nec.cd_fornecedor and
    ne.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal 
  left outer join 
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario 
  inner join 
    Lancamento_Padrao lp 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  where
    (isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) between @dt_inicial and @dt_final) and
    (isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    nec.cd_nota_entrada,
    isnull(nec.dt_contab_nota_entrada,ne.dt_receb_nota_entrada),
    ne.dt_nota_entrada,
    ner.cd_rem,
    nec.cd_fornecedor,
    vw.nm_fantasia,
    nec.cd_operacao_fiscal,
    ne.vl_irrf_nota_entrada,
    ne.vl_inss_nota_entrada,
    ne.vl_iss_nota_entrada
  order by
    nec.cd_nota_entrada

  update 
    #ContabilRazaoComContaBase
  set
    vl_irrf_nota_entrada = ne.vl_irrf_nota_entrada,
    vl_inss_nota_entrada = ne.vl_inss_nota_entrada,
    vl_iss_nota_entrada  = ne.vl_iss_nota_entrada
  from
    #Nota_Contabil_IRRF ne,
    #ContabilRazaoComContaBase c
  where
    ne.cd_nota_entrada      = c.cd_nota_entrada and
    ne.cd_lancamento_padrao = c.cd_lancamento_padrao and
    ne.cd_conta_credito     = c.cd_conta_credito 

  select 
    distinct
    -- NOME DA CONTA
    cast('- '+(select nm_conta from Plano_conta
  	       where cd_conta = (select top 1 cd_conta_debito
		       	         from Lancamento_Padrao 
				 where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
 				                               from Lancamento_Padrao lanc
                               		   		       where cd_conta_plano = lp.cd_conta_plano and
				                                     cd_tipo_contabilizacao = 1 and
                                                                     ic_tipo_operacao = 'E')) and
                                       cd_empresa = dbo.fn_empresa()) as varchar(40)) as 'Nome_Lancamento_Padrao',

    -- MÁSCARA DA CONTA
    cast((Select cd_mascara_conta	from Plano_conta
	  where cd_conta = (Select top 1 cd_conta_debito 
		            from Lancamento_Padrao
			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
					                  from Lancamento_Padrao lanc
					                  where cd_conta_plano = lp.cd_conta_plano and
						                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(20)) as 'Mascara_Lancamento_Padrao',

    -- REDUZIDO DÉBITO
    cast((Select cd_conta_reduzido from Plano_conta
          where cd_conta = (Select top 1 cd_conta_debito
			    from Lancamento_Padrao
			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
				                          from Lancamento_Padrao lanc
                             		   		  where cd_conta_plano = lp.cd_conta_plano and
						                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Lancamento_Padrao',

    -- Código reduzido da conta crédito 
    cast((Select cd_conta_reduzido from Plano_conta
   	  where cd_conta = (Select top 1 cd_conta_credito
			    from Lancamento_Padrao
			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                         			  	  from Lancamento_Padrao lanc
                           				  where cd_conta_plano = lp.cd_conta_plano and
                           					cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Credito',

    isNull(lp.cd_conta_plano,0)		                         as cd_conta_plano,
    cast(nec.cd_nota_entrada as varchar(10))                     as 'Documento',
    nec.nm_fantasia_fornecedor                 as 'Fornecedor',
    nec.dt_contab_nota_entrada            	 as 'DataContabilizacao',
    nec.dt_nota_entrada			 as 'DataEmissao',
    nec.cd_rem			         as 'REM',
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal as 'Operacao_Fiscal',
    opf.nm_operacao_fiscal                 	 as 'Operacao_Fiscal_Nome',
    opf.cd_mascara_operacao			 as 'Operacao_Fiscal_Mascara',
    isnull(opf.ic_comercial_operacao,'N')	 as 'ValorComercial',
    isnull(opf.ic_servico_operacao,'N')      as 'Servico',
    /* ELIAS 16/07/2003 */ 
    cast(round(nec.vl_contab_nota_entrada,2) as decimal(25,2))             	as 'ValorTotal',
    cast(round(nec.vl_icms_nota_entrada,2) as decimal(25,2))               	as 'ValorICMS',
    cast(round(nec.vl_ipi_nota_entrada,2) as decimal(25,2))               	as 'ValorIPI',
    cast(round(isnull(nec.vl_irrf_nota_entrada,0),2) as decimal(25,2))	as 'ValorIRRF',
    cast(round(isnull(nec.vl_inss_nota_entrada,0),2) as decimal(25,2))      as 'ValorINSS',
    cast(round(isnull(nec.vl_iss_nota_entrada,0),2) as decimal(25,2)) 	as 'ValorISS'
  into
    #ContabilRazaoComConta 
  from
    #ContabilRazaoComContaBase nec
  inner join 
    Lancamento_Padrao lp 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  left outer join 
    Tipo_Contabilizacao t 
  on
    lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = nec.cd_operacao_fiscal

	
  -- Unir a temporária das sem conta com as que possuem contas
  insert into #ContabilRazaoSemConta
   (Nome_Lancamento_Padrao, 
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,
    Reduzido_Credito,
    cd_conta_plano,
    Documento,
    Fornecedor,
    DataContabilizacao,
    DataEmissao,
    REM,
    Operacao_Fiscal,
    Operacao_Fiscal_Nome,
    Operacao_Fiscal_Mascara,
    ValorComercial,
    Servico,
    ValorTotal,
    ValorICMS,
    ValorIPI,
    ValorIRRF,
    ValorINSS,
    ValorISS )
  select
    Nome_Lancamento_Padrao, 
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,
    Reduzido_Credito,  
    cd_conta_plano,
    Documento,
    Fornecedor,
    DataContabilizacao,
    DataEmissao,
    REM,
    Operacao_Fiscal,
    Operacao_Fiscal_Nome,
    Operacao_Fiscal_Mascara,
    ValorComercial,  
    Servico,
    sum(IsNull(ValorTotal,0)) as ValorTotal,
    sum(IsNull(ValorICMS,0))  as ValorICMS,
    sum(isNull(ValorIPI,0))   as ValorIPI,
    sum(isNull(ValorIRRF,0))  as ValorIRRF,
    sum(isNull(ValorINSS,0))  as ValorINSS,
    sum(isNull(ValorISS,0))   as ValorISS
  from	
    #ContabilRazaoComConta 
  group by
    Nome_Lancamento_Padrao, 
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,   
    Reduzido_Credito,
    cd_conta_plano,
    Documento,
    Fornecedor,
    DataContabilizacao,
    DataEmissao, 
    REM, 
    Operacao_Fiscal,
    Operacao_Fiscal_Nome,
    Operacao_Fiscal_Mascara,
    ValorComercial,
    Servico
 		
  --Define o nome do lancamento em função da contabilização da CFOP
  Update	
    #ContabilRazaoSemConta 
  set	
    Nome_Lancamento_Padrao = Left(Operacao_Fiscal_Nome,28),
    Mascara_Lancamento_Padrao = ' CFOP: ' + left(Operacao_Fiscal_Mascara,15)
  where	
    IsNull(Nome_Lancamento_Padrao,'') = ''		
		
  Select
    Nome_Lancamento_Padrao, 
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,   
    Reduzido_Credito,
    cd_conta_plano,
    Documento,
    Fornecedor,
    DataContabilizacao,
    DataEmissao,
    REM,
    Operacao_Fiscal,
    Operacao_Fiscal_Nome,
    Operacao_Fiscal_Mascara,
    ValorComercial, 
    Servico,
    sum(IsNull(ValorTotal,0)) as ValorTotal,
    sum(IsNull(ValorICMS,0))  as ValorICMS,
    sum(isNull(ValorIPI,0))   as ValorIPI,
    sum(isNull(ValorIRRF,0))  as ValorIRRF,
    sum(isNull(ValorINSS,0))  as ValorINSS,
    sum(isNull(ValorISS,0))   as ValorISS,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada

  from 
    #ContabilRazaoSemConta 
  where
    vl_pis_nota_entrada > 0 or
    vl_cofins_nota_entrada > 0 or
    vl_csll_nota_entrada > 0


  group by 
    Nome_Lancamento_Padrao, 
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,   
    Reduzido_Credito,
    cd_conta_plano,
    Documento,
    Fornecedor,
    DataContabilizacao,
    DataEmissao,
    REM,
    Operacao_Fiscal,
    Operacao_Fiscal_Nome,
    Operacao_Fiscal_Mascara,
    ValorComercial,
    Servico,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada
  order by 
    Servico,
    Mascara_Lancamento_Padrao, 
    DataEmissao, 
    Documento

end
--------------------------------------------------------
else if  @ic_parametro = 2 --Contabilização Sintético
--------------------------------------------------------
begin

  declare @cd_lancamento_padrao_irrf int
  declare @cd_lancamento_padrao_inss int

  -----------------------------------------------
  -- Carrega o Lancamento Padrão de IRRF 
  -----------------------------------------------
  select 
    @cd_lancamento_padrao_irrf = cd_lancamento_padrao_irrf
  from
    parametro_logistica
  where
    cd_empresa = dbo.fn_empresa()

  -----------------------------------------------
  -- Carrega o Lancamento Padrão de INSS 
  -----------------------------------------------
  select 
    @cd_lancamento_padrao_inss = cd_lancamento_padrao_inss
  from
    parametro_logistica
  where
    cd_empresa = dbo.fn_empresa()

  -- CONTÁBIL
  select 
    nec.cd_nota_entrada,
    nec.cd_fornecedor,
    nec.cd_operacao_fiscal,
    nec.cd_serie_nota_fiscal,
    round(sum(isnull(nec.vl_contab_nota_entrada,0)),2) as 'vl_contab_nota_entrada',
    round(sum(isnull(nec.vl_ipi_nota_entrada,0)),2) as 'vl_ipi_nota_entrada',
    round(sum(isnull(nec.vl_icms_nota_entrada,0)),2) as 'vl_icms_nota_entrada'
  into
    #Nota_Contabil_Sintetico
  from 
    Nota_Entrada_Contabil nec
  left outer join
    Nota_Entrada ne
  on
    ne.cd_nota_entrada = nec.cd_nota_entrada and
    ne.cd_fornecedor = nec.cd_fornecedor and
    ne.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  where 
    isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) between @dt_inicial and @dt_final and
   (isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    nec.cd_nota_entrada,
    nec.cd_fornecedor,
    nec.cd_operacao_fiscal,
    nec.cd_serie_nota_fiscal,
    ne.vl_pis_nota_entrada,
    ne.vl_cofins_nota_entrada,
    ne.vl_csll_nota_entrada

  -- FISCAL
  select
    round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2)       as vl_contab_nota_entrada,
    round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2)        as vl_ipi_nota_entrada,
    round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2)       as vl_icms_nota_entrada,
    cast(null as decimal(25,2))                                 as ValorIRRF,
    cast(null as decimal(25,2))                                 as ValorINSS,
    cast(null as decimal(25,2))                                 as ValorISS,
    isnull(opf.ic_servico_operacao,'N')	                        as Servico,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    IsNull(ne.vl_pis_nota_entrada,0) as vl_pis_nota_entrada,
    Isnull(ne.vl_cofins_nota_entrada,0) as vl_cofins_nota_entrada,
    IsNull(ne.vl_csll_nota_entrada,0) as vl_csll_nota_entrada
  into
    #Nota_Entrada_Fiscal_Sintetico
  from
    Nota_Entrada ne
  inner join
    Nota_Entrada_Item_Registro neir
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
    not exists (select 'x' from Nota_Entrada_Contabil nec where
                nec.cd_nota_entrada = ne.cd_nota_entrada and
                nec.cd_fornecedor = ne.cd_fornecedor and
                nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    isnull(opf.ic_servico_operacao,'N'),
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    ne.vl_pis_nota_entrada,
    ne.vl_cofins_nota_entrada,
    ne.vl_csll_nota_entrada

  -- DIFERENÇA
  select 
    (round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2) - isnull(nc.vl_contab_nota_entrada,0))    as 'vl_contab_nota_entrada',
    (round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2) - isnull(nc.vl_ipi_nota_entrada,0))        as 'vl_ipi_nota_entrada',
    (round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2) - isnull(nc.vl_icms_nota_entrada,0))      as 'vl_icms_nota_entrada',
    cast(null as decimal(25,2))         as ValorIRRF,
    cast(null as decimal(25,2))         as ValorINSS,
    cast(null as decimal(25,2))         as ValorISS,    
    isnull(opf.ic_servico_operacao,'N')	as Servico,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    IsNull(ne.vl_pis_nota_entrada,0) as vl_pis_nota_entrada,
    Isnull(ne.vl_cofins_nota_entrada,0) as vl_cofins_nota_entrada,
    IsNull(ne.vl_csll_nota_entrada,0) as vl_csll_nota_entrada
  into
    #Nota_Dif_Sem_Valor_Comercial_Sintetico
  from 
    nota_entrada_item_registro neir
  inner join
    nota_entrada ne
  on
    ne.cd_nota_entrada = neir.cd_nota_entrada and
    ne.cd_fornecedor = neir.cd_fornecedor and
    ne.cd_operacao_fiscal = neir.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal
  inner join
    #Nota_Contabil_Sintetico nc
  on
    nc.cd_nota_entrada = ne.cd_nota_entrada and
    nc.cd_fornecedor = ne.cd_fornecedor and
    nc.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    nc.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where 
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final
  group by
    isnull(opf.ic_servico_operacao,'N'),
    cast(ne.cd_nota_entrada as varchar(10)),
    nc.vl_contab_nota_entrada,
    nc.vl_ipi_nota_entrada,
    nc.vl_icms_nota_entrada,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    ne.vl_pis_nota_entrada,
    ne.vl_cofins_nota_entrada,
    ne.vl_csll_nota_entrada
  having
    ((round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2) - isnull(nc.vl_contab_nota_entrada,0)) > 0) or
    ((round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2) - isnull(nc.vl_ipi_nota_entrada,0)) > 0) or
    ((round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2) - isnull(nc.vl_icms_nota_entrada,0)) > 0)

  -- 1º AGRUPAMENTO
  select
    isnull(opf.ic_servico_operacao,'N')		                               as Servico,
    round(sum(isnull(ne.vl_total_nota_entrada,0)),2)                           as ValorTotal,
    round(sum(isnull(ne.vl_ipi_nota_entrada,0)),2)                             as ValorIPI,
    round(sum(isnull(ne.vl_icms_nota_entrada,0)),2)                            as ValorICMS,
    round(sum(isnull(ne.vl_irrf_nota_entrada,0)),2)                            as ValorIRRF,
    round(sum(isnull(ne.vl_inss_nota_entrada,0)),2)                            as ValorINSS,
    round(sum(isnull(ne.vl_iss_nota_entrada,0)),2)                             as ValorISS,
    isnull(ne.cd_nota_entrada,0)                                               as cd_nota_entrada,
    isnull(ne.cd_fornecedor,0)                                                 as cd_fornecedor,
    isnull(ne.cd_operacao_fiscal,0)                                            as cd_operacao_fiscal,
    isnull(ne.cd_serie_nota_fiscal,0)                                          as cd_serie_nota_fiscal,
    isnull(ne.vl_pis_nota_entrada,0)                                           as vl_pis_nota_entrada,
    isnull(ne.vl_cofins_nota_entrada,0)                                        as vl_cofins_nota_entrada,
    isnull(ne.vl_csll_nota_entrada,0)                                          as vl_csll_nota_entrada
  into	
    #Analitico
  from
    Nota_Entrada ne
  left outer join
    Nota_Entrada_Item_Registro neir
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
     not exists (select 'x' from Nota_Entrada_Contabil nec where
                 nec.cd_nota_entrada = ne.cd_nota_entrada and
                 nec.cd_fornecedor = ne.cd_fornecedor and
                 nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                 nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                 isnull(nec.cd_lancamento_padrao,0)<>0) and
     not exists (select 'x'  from #Nota_Dif_Sem_Valor_Comercial_Sintetico nec where
                 nec.cd_nota_entrada = ne.cd_nota_entrada and
                 nec.cd_fornecedor = ne.cd_fornecedor and
                 nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                 nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal) and
     not exists (select 'x'  from #Nota_Entrada_Fiscal_Sintetico nec where
                 nec.cd_nota_entrada = ne.cd_nota_entrada and
                 nec.cd_fornecedor = ne.cd_fornecedor and
                 nec.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                 nec.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal)                               
  group by 
    isnull(opf.ic_servico_operacao,'N'),
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada

  -- 2º AGRUPAMENTO
  insert into #Analitico
    (ValorTotal,
     ValorIPI,
     ValorICMS,
     ValorIRRF,
     ValorINSS,     
     ValorISS,
     Servico,
     cd_nota_entrada,
     cd_fornecedor,
     cd_operacao_fiscal,
     cd_serie_nota_fiscal,
     vl_pis_nota_entrada,
     vl_cofins_nota_entrada,
     vl_csll_nota_entrada)  
  select 
    dif.vl_contab_nota_entrada,
    dif.vl_ipi_nota_entrada,
    dif.vl_icms_nota_entrada,
    dif.ValorIRRF,
    dif.ValorINSS,     
    dif.ValorISS,
    dif.Servico,
    dif.cd_nota_entrada,
    dif.cd_fornecedor,
    dif.cd_operacao_fiscal,
    dif.cd_serie_nota_fiscal,
    isnull(dif.vl_pis_nota_entrada,0),
    isnull(dif.vl_cofins_nota_entrada,0),
    isnull(dif.vl_csll_nota_entrada,0)
  from 
    #Nota_Dif_Sem_Valor_Comercial_Sintetico dif
  where
    not exists(select 'x' from #Analitico nec
               where nec.cd_nota_entrada = dif.cd_nota_entrada and
                     nec.cd_fornecedor = dif.cd_fornecedor)

  -- 3º AGRUPAMENTO
  insert into #Analitico
    (ValorTotal,
     ValorIPI,
     ValorICMS,
     ValorIRRF,
     ValorINSS,     
     ValorISS,  
     Servico,
     cd_nota_entrada,
     cd_fornecedor,
     cd_operacao_fiscal,
     cd_serie_nota_fiscal,
     vl_pis_nota_entrada,
     vl_cofins_nota_entrada,
     vl_csll_nota_entrada)  
  select 
    dif.vl_contab_nota_entrada,
    dif.vl_ipi_nota_entrada,
    dif.vl_icms_nota_entrada,
    dif.ValorIRRF,
    dif.ValorINSS,     
    dif.ValorISS,
    dif.Servico,
    dif.cd_nota_entrada,
    dif.cd_fornecedor,
    dif.cd_operacao_fiscal,
    dif.cd_serie_nota_fiscal,
    IsNull(dif.vl_pis_nota_entrada,0),
    IsNull(dif.vl_cofins_nota_entrada,0),
    IsnUll(dif.vl_csll_nota_entrada,0)
  from 
    #Nota_Entrada_Fiscal_Sintetico dif
  where
    not exists(select 'x' from #Analitico nec
               where nec.cd_nota_entrada = dif.cd_nota_entrada and
                     nec.cd_fornecedor = dif.cd_fornecedor)


  select
    cast('- SEM VALOR CONTABIL' as varchar(40))         as 'Nome_Lancamento_Padrao',
    cast(' ' as varchar(20))                            as 'Mascara_Lancamento_Padrao',
    cast(null as varchar(10))                           as 'Reduzido_Lancamento_Padrao',
    --Conta de Débito da Nota
    null as 'cd_debito_nota_fiscal',
    --Conta de Crédito da nota
    null as 'cd_credito_nota_fiscal',
    --Conta de Débito do IPI
    null as 'cd_debito_ipi',
    --Conta de Crédito IPI
    null as 'cd_credito_ipi',
    --Conta de Débito do ICMS
    null as 'cd_debito_icms',
    --Conta de Crédito do ICMS
    null as 'cd_credito_icms',
    --Conta de Débito do IRRF
    null as 'cd_debito_irrf',
    --Conta de Crédito do IRRF
    null as 'cd_credito_irrf',
    --Conta de Débito do INSS
    null as 'cd_debito_inss',
    --Conta de Crédito do INSS
    null as 'cd_credito_inss',
    --Histórico Nota
    null as 'cd_historico_nota_fiscal',
    --Histórico IPI
    null as 'cd_historico_ipi',
    --Histórico ICMS
    null as 'cd_historico_icms',
    --Histórico IRRF
    null as 'cd_historico_irrf',
    --Histórico INSS
    null as 'cd_historico_inss',
    Servico,
    sum(ValorTotal)   as ValorTotal,
    sum(ValorIPI)     as ValorIPI,
    sum(ValorICMS)    as ValorICMS,
    sum(ValorIRRF)    as ValorIRRF,
    sum(ValorINSS)    as ValorINSS,
    sum(ValorISS)     as ValorISS,
    Isnull(vl_pis_nota_entrada,0)as vl_pis_nota_entrada,
    Isnull(vl_cofins_nota_entrada,0)as vl_cofins_nota_entrada,
    Isnull(vl_csll_nota_entrada,0)as vl_csll_nota_entrada
  into
    #ContabilRazaoSemContaSintetico
  from
    #Analitico
  group by
    Servico,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada

--  select * from #ContabilRazaoSemContaSintetico

  -----------------------------------------------
  -- Traz Notas de Saída com conta
  -----------------------------------------------

  --Foi criada esta tabela para agrupara os valores sem a necessidade de uma 
  --restruturação da lógica empregada nos outros procedimentos


  -- TODOS OS VALORES DE IRRF, INSS E ISS
  select
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    nec.cd_nota_entrada,
    nec.cd_operacao_fiscal,
    isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) as dt_contab_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_contab_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_ipi_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_icms_nota_entrada,
    round(isnull(ne.vl_irrf_nota_entrada,0),2) 	                 as vl_irrf_nota_entrada,
    round(isnull(ne.vl_inss_nota_entrada,0),2)                   as vl_inss_nota_entrada,
    round(isnull(ne.vl_iss_nota_entrada,0),2)  	                 as vl_iss_nota_entrada
  into
    #Nota_Contabil_IRRF_Sintetico
  from
    Nota_Entrada_Contabil nec
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne 
  on
    ne.cd_nota_entrada = nec.cd_nota_entrada and
    ne.cd_fornecedor = nec.cd_fornecedor and
    ne.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal 
  left outer join 
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario 
  inner join 
    Lancamento_Padrao lp 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao and
    lp.cd_tipo_contabilizacao = 1
  where
    ((isnull(ne.vl_irrf_nota_entrada,0) <> 0) or
    (isnull(ne.vl_inss_nota_entrada,0) <> 0) or
    (isnull(ne.vl_iss_nota_entrada,0) <> 0)) and
    (isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) between @dt_inicial and @dt_final) and
    (isnull(nec.cd_lancamento_padrao,0)<>0)
  order by
    nec.cd_nota_entrada

  -- TODOS OS VALORES CONTABEIS, IPI E ICMS
  select 
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    nec.cd_nota_entrada,
    nec.cd_operacao_fiscal,
    isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) as dt_contab_nota_entrada,
    sum(round(isnull(nec.vl_contab_nota_entrada,0),2))           as vl_contab_nota_entrada,
    sum(round(isnull(nec.vl_ipi_nota_entrada,0),2))              as vl_ipi_nota_entrada,
    sum(round(isnull(nec.vl_icms_nota_entrada,0),2))             as vl_icms_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_irrf_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_inss_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_iss_nota_entrada,
    sum(round(isnull(ne.vl_pis_nota_entrada,0),2))               as  vl_pis_nota_entrada,
    sum(round(isnull(ne.vl_cofins_nota_entrada,0),2))            as vl_cofins_nota_entrada,
    sum(round(isnull(ne.vl_csll_nota_entrada,0),2))              as vl_csll_nota_entrada
    
  into	
    #AnaliticoComConta
  from
    Nota_Entrada_Contabil nec
  left outer join 
    Nota_Entrada_Registro ner 
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne 
  on
    ne.cd_nota_entrada = nec.cd_nota_entrada and
    ne.cd_fornecedor = nec.cd_fornecedor and
    ne.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal 
  left outer join 
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario 
  inner join 
    Lancamento_Padrao lp 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  where
    (isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada) between @dt_inicial and @dt_final) and
    (isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    isnull(nec.dt_contab_nota_entrada, ne.dt_receb_nota_entrada),
    nec.cd_operacao_fiscal,
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    nec.cd_nota_entrada

  order by
    nec.cd_nota_entrada

  update 
    #AnaliticoComConta
  set
    vl_irrf_nota_entrada = ne.vl_irrf_nota_entrada,
    vl_inss_nota_entrada = ne.vl_inss_nota_entrada,
    vl_iss_nota_entrada  = ne.vl_iss_nota_entrada
  from
    #Nota_Contabil_IRRF_Sintetico ne,
    #AnaliticoComConta c
  where
    ne.cd_nota_entrada      = c.cd_nota_entrada and
    ne.cd_lancamento_padrao = c.cd_lancamento_padrao and
    ne.cd_conta_credito     = c.cd_conta_credito 

  Select
    nec.cd_lancamento_padrao,
    --Define a conta principal
    cast('- '+
    (Select nm_conta from Plano_conta
     where  cd_conta = (Select top 1 cd_conta_debito from Lancamento_Padrao 
			where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                      		  	              from Lancamento_Padrao lanc
					              where cd_conta_plano = lp.cd_conta_plano and
				                            rtrim(nm_lancamento_padrao) like '%NF')) and
                              cd_empresa = dbo.fn_empresa()) as varchar(40)) as 'Nome_Lancamento_Padrao',

    --Retorna a mascara da conta
    cast((select cd_mascara_conta from Plano_conta
	  where	cd_conta = (Select top 1 cd_conta_debito from Lancamento_Padrao
			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                      					  from Lancamento_Padrao lanc
				 	                  where cd_conta_plano = lp.cd_conta_plano and
                						rtrim(nm_lancamento_padrao) like '%NF')) and
                                  cd_empresa = dbo.fn_empresa()) as varchar(20)) as 'Mascara_Lancamento_Padrao',

    --Código reduzido da conta débito
    cast((select cd_conta_reduzido from	Plano_conta
	  where	cd_conta = (Select top 1 cd_conta_debito from Lancamento_Padrao
 			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
         					          from Lancamento_Padrao lanc
   					                  where	cd_conta_plano = lp.cd_conta_plano and
 						                rtrim(nm_lancamento_padrao) like '%NF')) and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Lancamento_Padrao',

    -- Código reduzido da conta crédito 
    cast((Select cd_conta_reduzido from Plano_conta
 	  where	cd_conta = (Select top 1 cd_conta_credito
			    from Lancamento_Padrao
                            where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
					                  from Lancamento_Padrao lanc
                                                          where	cd_conta_plano = lp.cd_conta_plano and
						                rtrim(nm_lancamento_padrao) like '%NF')) and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Credito',

    cast(round(nec.vl_contab_nota_entrada,2) as decimal(25,2))             	as 'ValorTotal',
    cast(round(nec.vl_icms_nota_entrada,2) as decimal(25,2))               	as 'ValorICMS',
    cast(round(nec.vl_ipi_nota_entrada,2) as decimal(25,2))               	as 'ValorIPI',
    cast(round(isnull(nec.vl_irrf_nota_entrada,0),2) as decimal(25,2))	as 'ValorIRRF',
    cast(round(isnull(nec.vl_inss_nota_entrada,0),2) as decimal(25,2))      as 'ValorINSS',
    cast(round(isnull(nec.vl_iss_nota_entrada,0),2) as decimal(25,2)) 	as 'ValorISS',
    (Select cd_conta_debito from lancamento_padrao where cd_lancamento_padrao = nec.cd_lancamento_padrao) as cd_conta_debito,
    (Select cd_conta_credito from lancamento_padrao where cd_lancamento_padrao = nec.cd_lancamento_padrao) as cd_conta_credito,
    (Select cd_historico_contabil from lancamento_padrao where cd_lancamento_padrao = nec.cd_lancamento_padrao) as cd_historico,
    isnull(opf.ic_servico_operacao,'N') as Servico,
    IsNull(vl_pis_nota_entrada,0)as vl_pis_nota_entrada,
    Isnull(vl_cofins_nota_entrada,0) as vl_cofins_nota_entrada,
    IsNull(vl_csll_nota_entrada,0) as vl_csll_nota_entrada
  into	
    #ContabilRazaoComContaBaseSINTETICO
  from	
    #AnaliticoComConta nec
  inner join 
    Lancamento_Padrao lp 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  left outer join 
    Operacao_Fiscal opf 
  on
    opf.cd_operacao_fiscal = nec.cd_operacao_fiscal    
  where
    (nec.dt_contab_nota_entrada between @dt_inicial and @dt_final) and
    (IsNull(nec.cd_lancamento_padrao,0) <> 0)
  Select	
    Nome_Lancamento_Padrao,
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,
    (Select sum(ValorTotal) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_total,
    (Select sum(ValorICMS) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_icms,
    (Select sum(ValorIPI) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_ipi,
    (Select sum(ValorIRRF) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_irrf,
    (Select sum(ValorINSS) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_inss,
    (Select sum(ValorISS) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_iss,
    (Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico
     and ValorTotal > 0) as cd_lancamento_nota,
    (Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico
     and ValorICMS > 0) as cd_lancamento_icms,
    (Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico
     and ValorIPI > 0) as cd_lancamento_ipi,
    @cd_lancamento_padrao_irrf as cd_lancamento_irrf,
    @cd_lancamento_padrao_inss as cd_lancamento_inss,
    Servico ,
    (Select sum(vl_pis_nota_entrada) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_pis_nota_entrada,
    (Select sum(vl_cofins_nota_entrada) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_cofins_nota_entrada,
    (Select sum(vl_csll_nota_entrada) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico) as vl_csll_nota_entrada
    
  into	
    #ContabilRazaoComContaBaseSINTETICO_Contas
  from	
    #ContabilRazaoComContaBaseSINTETICO nec
  group by
    Nome_Lancamento_Padrao,
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,
    Servico,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada


  Select 
    Nome_Lancamento_Padrao,
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,
    --===============
    -- Contas Crédito:
    --===============
    --Nota
    (Select cd_conta_reduzido from Plano_conta
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao
 		       where cd_conta_plano = (select top 1 lanc.cd_conta_plano from Lancamento_Padrao lanc
			                       where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                             cd_tipo_contabilizacao = 1 and
                             cd_empresa = dbo.fn_empresa())) as cd_credito_nota_fiscal,      
    --ICMS
    (Select cd_conta_reduzido from Plano_conta
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao
 		       where cd_conta_plano = (select top 1 lanc.cd_conta_plano from Lancamento_Padrao lanc
				               where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                             cd_tipo_contabilizacao = 2 and
                             cd_empresa = dbo.fn_empresa())) as cd_credito_icms,
    --IPI
    (Select cd_conta_reduzido from Plano_conta
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao
		       where cd_conta_plano = (select top 1 lanc.cd_conta_plano from Lancamento_Padrao lanc
				               where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                             cd_tipo_contabilizacao = 3 and
                             cd_empresa = dbo.fn_empresa())) as cd_credito_ipi,
    --IRRF
    (Select top 1 cd_conta_reduzido from plano_conta
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_padrao
			where cd_lancamento_padrao = @cd_lancamento_padrao_irrf) and
                              cd_empresa = dbo.fn_empresa()) as cd_credito_irrf,
    --INSS
    (Select top 1 cd_conta_reduzido from plano_conta
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_padrao
                       where cd_lancamento_padrao = @cd_lancamento_padrao_inss) and
                             cd_empresa = dbo.fn_empresa()) as cd_credito_inss,
    --===============
    -- Contas Débito:
    --===============
    --Nota

            	(Select	cd_conta_reduzido
		 from	Plano_conta
		 where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_Padrao
			where	cd_conta_plano =
				(select top 1 lanc.cd_conta_plano
				from	Lancamento_Padrao lanc
				where	lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                        cd_tipo_contabilizacao = 1 and
                        cd_empresa = dbo.fn_empresa())) as cd_debito_nota_fiscal,


		--ICMS

            	(Select	cd_conta_reduzido
		 from	Plano_conta
		 where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_Padrao
			where	cd_conta_plano =
				(select top 1 lanc.cd_conta_plano
				from	Lancamento_Padrao lanc
				where	lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                        cd_tipo_contabilizacao = 2 and
                        cd_empresa = dbo.fn_empresa())) as cd_debito_icms,


		--IPI
            	(Select	cd_conta_reduzido
		 from	Plano_conta
		 where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_Padrao
			where	cd_conta_plano =
				(select top 1 lanc.cd_conta_plano
				from	Lancamento_Padrao lanc
				where	lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                        cd_tipo_contabilizacao = 3 and
                        cd_empresa = dbo.fn_empresa())) as cd_debito_ipi,


		--IRRF
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = @cd_lancamento_padrao_irrf) and
                        cd_empresa = dbo.fn_empresa()) as cd_debito_irrf,

		--INSS
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = @cd_lancamento_padrao_inss) and
                        cd_empresa=dbo.fn_empresa()) as cd_debito_inss,


		--============
		-- Históricos:
		--============

		--Nota
  	       (Select top 1 cd_historico_contabil
		from	Lancamento_Padrao
		where	cd_conta_plano =
			(select top 1 lanc.cd_conta_plano
			from	Lancamento_Padrao lanc
			where	lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                cd_tipo_contabilizacao = 1 and
                cd_empresa = dbo.fn_empresa()) as cd_historico_nota_fiscal,

		--ICMS
  	       (Select top 1 cd_historico_contabil
		from	Lancamento_Padrao
		where	cd_conta_plano =
			(select top 1 lanc.cd_conta_plano
			from	Lancamento_Padrao lanc
			where	lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                cd_tipo_contabilizacao = 2 and
                cd_empresa = dbo.fn_empresa()) as cd_historico_icms,

		--IPI
  	       (Select top 1 cd_historico_contabil
		from	Lancamento_Padrao
		where	cd_conta_plano =
			(select top 1 lanc.cd_conta_plano
			from	Lancamento_Padrao lanc
			where	lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                cd_tipo_contabilizacao = 3 and
                cd_empresa = dbo.fn_empresa()) as cd_historico_ipi,


		--IRRF
		(Select top 1 cd_historico_contabil
		from	Lancamento_padrao 
		where	cd_lancamento_padrao = @cd_lancamento_padrao_irrf) as cd_historico_irrf,
		--INSS
		(Select top 1 cd_historico_contabil
		from	Lancamento_padrao 
		where	cd_lancamento_padrao = @cd_lancamento_padrao_inss) as cd_historico_inss,
		--Valor NF
		vl_total as ValorTotal,
		--Valor ICMS
		vl_icms  as ValorICMS,
		--Valor IPI
		vl_ipi   as ValorIPI,
                vl_irrf  as ValorIRRF,
                vl_inss  as ValorINSS,
                vl_iss   as ValorISS,
                Servico,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada

	into	#ContabilRazaoComContaBaseSINTETICO_Final

	from	#ContabilRazaoComContaBaseSINTETICO_Contas as nec


	-------------------------------------------------------------
	-- Unir a temporária das sem conta com as que possuem contas
	-------------------------------------------------------------
	Insert 
	into	#ContabilRazaoSemContaSINTETICO 

		(Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_credito_irrf,
		cd_debito_irrf,
		cd_credito_inss,
		cd_debito_inss,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms,
		cd_historico_irrf,
		cd_historico_inss,
		ValorTotal,
		ValorICMS,
		ValorIPI,
                ValorIRRF,
                ValorINSS,
                ValorISS,
                Servico,
     vl_pis_nota_entrada,
     vl_cofins_nota_entrada,
     vl_csll_nota_entrada)
	select 
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_credito_irrf,
		cd_debito_irrf,
		cd_credito_inss,
		cd_debito_inss,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms,
		cd_historico_irrf,
		cd_historico_inss,
		ValorTotal,
		ValorICMS,
		ValorIPI,
                ValorIRRF,
                ValorINSS,
                ValorISS,
                Servico,
    IsNull(vl_pis_nota_entrada,0)as vl_pis_nota_entrada,
    IsNull(vl_cofins_nota_entrada,0) as vl_cofins_nota_entrada,
    IsNull(vl_csll_nota_entrada,0) as vl_csll_nota_entrada

	from	#ContabilRazaoComContaBaseSINTETICO_Final


	select
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,   
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_credito_irrf,
		cd_debito_irrf,
		cd_credito_inss,
		cd_debito_inss,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms,
		cd_historico_irrf,
		cd_historico_inss,
		sum(IsNull(ValorTotal,0)) as ValorTotal,
		sum(IsNull(ValorICMS,0))  as ValorICMS,
		sum(isNull(ValorIPI,0))   as ValorIPI,
		sum(IsNull(ValorIRRF,0))  as ValorIRRF,
		sum(isNull(ValorINSS,0))   as ValorINSS,
    sum(isnull(valorISS,0))   as ValorISS,
    Servico,
		sum(IsNull(vl_pis_nota_entrada,0)) as vl_pis_nota_entrada,
		sum(IsNull(vl_cofins_nota_entrada,0))  as vl_cofins_nota_entrada,
		sum(isNull(vl_csll_nota_entrada,0))   as vl_csll_nota_entrada
    
	from 
		#ContabilRazaoSemContaSINTETICO 

where 
  vl_pis_nota_entrada > 0 or
  vl_cofins_nota_entrada > 0 or
  vl_csll_nota_entrada > 0
	
group by 
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_credito_irrf,
		cd_debito_irrf,
		cd_credito_inss,
		cd_debito_inss,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms,
		cd_historico_irrf,
		cd_historico_inss,
    Servico
	order by
                Servico,
                Mascara_Lancamento_Padrao, 
                cd_debito_nota_fiscal

		--cd_debito_nota_fiscal, Mascara_Lancamento_Padrao, Nome_Lancamento_Padrao

end

