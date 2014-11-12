CREATE PROCEDURE pr_contabiliza_nota_entrada
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
--                   17/06/2004 - Acerto do parametro 2 que estava multiplicando os valores indevidamente - ELIAS/LÚCIO
--                   22/06/2004 - Inclusão dos Outros Impostos, PIS, COFINS e CSLL - ELIAS
--                   24/06/2004 - Somente Consisderar ISS caso o mesmo tenha sido Retido - ELIAS
--                   15/07/2004 - Acerto no Relatório Analítico que estava multiplicando os valores
--                                de impostos retidos indevidamente - ELIAS
--                   10/08/2004 - Acerto no Somatório da Diferença - ELIAS
--                   02/09/2004 - Acerto para não mostrar os impostos da nota de entrada caso ela apareça
--                                mais de uma vez na parte de serviço. - Daniel C. Neto.
--                   10/11/2004 - Acerto para, na verificação de repetidos, (feito pelo Carrasco acima), 
--                                somente leve em consideração os valores com classificação, relacionando com a Conta - ELIAS
--                   04/08/2005 - Verificação do flag de Provisão e caso indicado como tal, apresentação
--                                do Valor líquido e a não aprsentação dos impostos retidos - ELIAS
--                   05/08/2005 - Acerto de Valores Retidos que não Estavam aparecendo no Analítico mas apareciam
--                                no Sintético e vice-versa - ELIAS
--                   24/08/2005 - Acerto na Busca dos Valores de Impostos Retidos que não estavam aparecendo
--                                devido filtro indevido de tipo de contabilização - ELIAS 
--                   30/08/2005 - Acerto de valores que estava duplicando - ELIAS
--                   18/07/2006 - Criação do Parâmetro 3 - Análitico por Conta Individual. Incluído with(nolock) - ELIAS
------------------------------------------------------------------------------ 

@ic_parametro  int,
@dt_inicial    datetime,
@dt_final      datetime,
@cd_conta      int = null

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
    Nota_Entrada_Contabil nec with(nolock)
  left outer join
    Nota_Entrada ne with(nolock)
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
    ner.cd_rem        				      as REM,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal         as Operacao_Fiscal,
    opf.nm_operacao_fiscal                                     as Operacao_Fiscal_Nome,
    opf.cd_mascara_operacao                                    as Operacao_Fiscal_Mascara,
    isnull(opf.ic_comercial_operacao,'N')		                   as ValorComercial,
    isnull(opf.ic_servico_operacao,'N')		                     as Servico,
    round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2)      as vl_contab_nota_entrada,
    round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2)       as vl_ipi_nota_entrada,
    round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2)      as vl_icms_nota_entrada,
    -- ELIAS 05/08/2005 - Inclusão dos Valores retidos de IRRF, INSS e ISS
    isnull(ne.vl_irrf_nota_entrada,0)                          as ValorIRRF,
    isnull(ne.vl_inss_nota_entrada,0)                          as ValorINSS,
    isnull(ne.vl_iss_nota_entrada,0)                           as ValorISS,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    IsNull(ne.vl_pis_nota_entrada,0)                           as vl_pis_nota_entrada,
    Isnull(ne.vl_cofins_nota_entrada,0)                        as vl_cofins_nota_entrada,
    IsNull(ne.vl_csll_nota_entrada,0)                          as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')                    as ic_provisao_nota_entrada
  into
    #Nota_Entrada_Fiscal           
  from
    Nota_Entrada ne with(nolock)
  inner join
    Nota_Entrada_Item_Registro neir with(nolock)
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada_Registro ner with(nolock) 
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
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
    not exists (select 'x' from Nota_Entrada_Contabil nec with(nolock) where
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
    ne.vl_irrf_nota_entrada,
    ne.vl_iss_nota_entrada,
    ne.vl_inss_nota_entrada,
    vl_pis_nota_entrada,
    vl_cofins_nota_entrada,
    vl_csll_nota_entrada,
    ic_provisao_nota_entrada
    
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
    neir.cd_rem        				     as REM,
    opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal as Operacao_Fiscal,
    opf.nm_operacao_fiscal                             as Operacao_Fiscal_Nome,
    opf.cd_mascara_operacao                            as Operacao_Fiscal_Mascara,
    isnull(opf.ic_comercial_operacao,'N')	       as ValorComercial,
    isnull(opf.ic_servico_operacao,'N')		       as Servico,
    (round(sum(isnull(neir.vl_cont_reg_nota_entrada,0)),2) - round(isnull(nc.vl_contab_nota_entrada,0),2))     as 'vl_contab_nota_entrada',
    (round(sum(isnull(neir.vl_ipi_reg_nota_entrada,0)),2) - round(isnull(nc.vl_ipi_nota_entrada,0),2))         as 'vl_ipi_nota_entrada',
    (round(sum(isnull(neir.vl_icms_reg_nota_entrada,0)),2) - round(isnull(nc.vl_icms_nota_entrada,0),2))       as 'vl_icms_nota_entrada',
    cast(null as decimal(25,2))                        as ValorIRRF,
    cast(null as decimal(25,2))                        as ValorINSS,
    cast(null as decimal(25,2))                        as ValorISS,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    IsNull(ne.vl_pis_nota_entrada,0) as vl_pis_nota_entrada,
    Isnull(ne.vl_cofins_nota_entrada,0) as vl_cofins_nota_entrada,
    IsNull(ne.vl_csll_nota_entrada,0) as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N') as ic_provisao_nota_entrada
  into
    #Nota_Diferenca
  from 
    nota_entrada_item_registro neir with(nolock)
  inner join
    nota_entrada ne with(nolock)
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
    vw_Destinatario vw 
  on
    vw.cd_destinatario = ne.cd_fornecedor and
    vw.cd_tipo_destinatario = ne.cd_tipo_destinatario
  left outer join 
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where 
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final
  group by
    cast(ne.cd_nota_entrada as varchar(10)),
    vw.nm_fantasia,                       
    ne.dt_nota_entrada,
    ne.dt_receb_nota_entrada,
    neir.cd_rem,
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
    ne.vl_csll_nota_entrada,
    ne.ic_provisao_nota_entrada

  -- ELIAS 10/09/2004
  select * into
    #Nota_Dif_Sem_Valor_Comercial
  from 
    #Nota_Diferenca
  where     
    (vl_contab_nota_entrada > 0) or
    (vl_ipi_nota_entrada > 0) or
    (vl_icms_nota_entrada > 0)

  -- 1º AGRUPAMENTO
  select
    cast('SEM VALOR CONTABIL' as varchar(40))                                  as Nome_Lancamento_Padrao,
    cast('' as varchar(20))                         as Mascara_Lancamento_Padrao,
    cast(null as varchar(10))                                                  as Reduzido_Lancamento_Padrao,
    cast(null as varchar(10))                                                  as Reduzido_Credito,
    0 as cd_conta_plano,
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
    case when (isnull(ne.ic_reter_iss,'N')='S') then
      round(sum(isnull(ne.vl_iss_nota_entrada,0)),2)                             
    else 0 end                                                                 as ValorISS,
    round(sum(IsNull(ne.vl_pis_nota_entrada,0)),2)                             as ValorPIS,
    round(sum(Isnull(ne.vl_cofins_nota_entrada,0)),2)                          as ValorCOFINS,
    round(sum(IsNull(ne.vl_csll_nota_entrada,0)),2)                            as ValorCSLL,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')                                    as Provisao
  into	
    #ContabilRazaoSemConta
  from
    Nota_Entrada ne with(nolock)
  left outer join
    Nota_Entrada_Item_Registro neir with(nolock)
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
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
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
     not exists (select 'x' from Nota_Entrada_Contabil nec with(nolock) where
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
    isnull(ne.ic_reter_iss,'N'),
    ne.ic_provisao_nota_entrada
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
    dif.vl_csll_nota_entrada,
    dif.ic_provisao_nota_entrada
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
    dif.vl_csll_nota_entrada,
    dif.ic_provisao_nota_entrada
  from 
    #Nota_Entrada_Fiscal dif
  where
    not exists(select 'x' from #ContabilRazaoSemConta nec
               where nec.Documento = dif.Documento and
                     nec.Fornecedor = dif.Fornecedor)

  ------------------------------------------------
  -- Traz Notas de Saída com conta
  ------------------------------------------------
		
  -- Foi criada esta tabela para agrupara os valores sem a necessidade de uma 
  -- restruturação da lógica empregada nos outros procedimentos

  -- Passo a Utilizar o campo do lançamento padrão 
  -- e os demais campos, diretamente da Nota Fiscal
  -- Utilizado o max para permitir o agrupamento quando existe mais do
  -- que um registro no nota_Entrada_Contabil - ELIAS 15/07/2004  

  -- TODOS OS VALORES DE IRRF, INSS E ISS
  select
    min(nec.cd_lancamento_padrao) as cd_lancamento_padrao,
    min(lp.cd_conta_credito) as cd_conta_credito,   
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada as dt_contab_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia as nm_fantasia_fornecedor,
    ne.cd_operacao_fiscal,
    cast(null as decimal(25,2))                         as vl_contab_nota_entrada,
    cast(null as decimal(25,2))                         as vl_ipi_nota_entrada,
    cast(null as decimal(25,2))                         as vl_icms_nota_entrada,
    round(isnull(max(ne.vl_irrf_nota_entrada),0),2) 	as vl_irrf_nota_entrada,
    round(isnull(max(ne.vl_inss_nota_entrada),0),2)     as vl_inss_nota_entrada,
    case when (isnull(max(ne.ic_reter_iss),'N')='S') then
      round(isnull(max(ne.vl_iss_nota_entrada),0),2)                             
    else 0 end                                          as vl_iss_nota_entrada,
    round(isnull(max(ne.vl_pis_nota_entrada),0),2)      as vl_pis_nota_entrada,
    round(isnull(max(ne.vl_cofins_nota_entrada),0),2)   as vl_cofins_nota_entrada,
    round(isnull(max(ne.vl_csll_nota_entrada),0),2)     as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')             as ic_provisao_nota_entrada
  into
    #Nota_Contabil_IRRF
  from
    Nota_Entrada_Contabil nec with(nolock)
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne with(nolock)
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
    Lancamento_Padrao lp with(nolock)
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao --and
--    lp.cd_tipo_contabilizacao = 1  -- NOTA FISCAL
  where
    ((isnull(ne.vl_irrf_nota_entrada,0) <> 0) or
    (isnull(ne.vl_inss_nota_entrada,0) <> 0) or
    ((case when (isnull(ne.ic_reter_iss,'N')='S') then
      isnull(ne.vl_iss_nota_entrada,0)
      else 0 end) <> 0) or
    (isnull(ne.vl_pis_nota_entrada,0) <> 0) or
    (isnull(ne.vl_cofins_nota_entrada,0) <> 0) or
    (isnull(ne.vl_csll_nota_entrada,0) <> 0)) and
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
    (isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    --nec.cd_lancamento_padrao,
    --lp.cd_conta_credito,  
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia,
    ne.cd_operacao_fiscal,
    ne.ic_provisao_nota_entrada
  order by
    ne.cd_nota_entrada

  -- TODOS OS VALORES CONTABEIS, IPI E ICMS
  -- Neste trecho é necessário buscar a conta crédito de cada registro
  -- pois diferente do que é feito no trexo acima, aqui não é filtrado
  -- pelo tipo de lancamento = NOTA FISCAL
  select 
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada as dt_contab_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia as nm_fantasia_fornecedor,
    ne.cd_operacao_fiscal,
    sum(round(isnull(nec.vl_contab_nota_entrada,0),2)) as vl_contab_nota_entrada,
    sum(round(isnull(nec.vl_ipi_nota_entrada,0),2))    as vl_ipi_nota_entrada,
    sum(round(isnull(nec.vl_icms_nota_entrada,0),2))   as vl_icms_nota_entrada,
    cast(null as decimal(25,2))                        as vl_irrf_nota_entrada,
    cast(null as decimal(25,2))                        as vl_inss_nota_entrada,
    cast(null as decimal(25,2))                        as vl_iss_nota_entrada,
    cast(null as decimal(25,2))                        as vl_pis_nota_entrada,
    cast(null as decimal(25,2))                        as vl_cofins_nota_entrada,
    cast(null as decimal(25,2))                        as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')            as ic_provisao_nota_entrada
  into	
    #ContabilRazaoComContaBase
  from
    Nota_Entrada_Contabil nec with(nolock)
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne with(nolock)
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
    Lancamento_Padrao lp with(nolock)
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  where
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
    (isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia,
    ne.cd_operacao_fiscal,
    ne.ic_provisao_nota_entrada
  order by
    ne.cd_nota_entrada

  update 
    #ContabilRazaoComContaBase
  set
    vl_irrf_nota_entrada = ne.vl_irrf_nota_entrada,
    vl_inss_nota_entrada = ne.vl_inss_nota_entrada,
    vl_iss_nota_entrada  = ne.vl_iss_nota_entrada,
    vl_pis_nota_entrada  = ne.vl_pis_nota_entrada,
    vl_cofins_nota_entrada = ne.vl_cofins_nota_entrada,
    vl_csll_nota_entrada  = ne.vl_csll_nota_entrada
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
    cast('- '+(select nm_conta from Plano_conta with(nolock)
               where cd_conta = (select top 1 cd_conta_debito from Lancamento_Padrao with(nolock)
                                 where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                               from Lancamento_Padrao lanc with(nolock)
                                                               where cd_conta_plano = lp.cd_conta_plano and
                                                                     cd_tipo_contabilizacao = 1 and
                                                                     ic_tipo_operacao = 'E') and
                                       ic_tipo_operacao = 'E') and
                     cd_empresa = dbo.fn_empresa()) as varchar(40)) as 'Nome_Lancamento_Padrao',

    -- MÁSCARA DA CONTA
    cast((Select cd_mascara_conta from Plano_conta with(nolock)
          where cd_conta = (Select top 1 cd_conta_debito from Lancamento_Padrao with(nolock)
                            where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                          from Lancamento_Padrao lanc with(nolock)
                                                          where cd_conta_plano = lp.cd_conta_plano and
                                                                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                cd_empresa = dbo.fn_empresa()) as varchar(20)) as 'Mascara_Lancamento_Padrao',

    -- REDUZIDO DÉBITO
    cast((Select cd_conta_reduzido from Plano_conta with(nolock)
          where cd_conta = (Select top 1 cd_conta_debito from Lancamento_Padrao with(nolock)
                            where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                          from Lancamento_Padrao lanc with(nolock)
                                                          where cd_conta_plano = lp.cd_conta_plano and
                                                                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Lancamento_Padrao',

    -- Código reduzido da conta crédito 
    cast((Select cd_conta_reduzido from Plano_conta with(nolock)
          where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
                   			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                          from Lancamento_Padrao lanc with(nolock)
                                                          where cd_conta_plano = lp.cd_conta_plano and
                                                                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Credito',

    isNull(lp.cd_conta_plano,0)		                         as 'cd_conta_plano',
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
    cast(round(isnull(nec.vl_contab_nota_entrada,0),2) as decimal(25,2)) as 'ValorTotal',
    cast(round(isnull(nec.vl_icms_nota_entrada,0),2) as decimal(25,2))   as 'ValorICMS',
    cast(round(isnull(nec.vl_ipi_nota_entrada,0),2) as decimal(25,2))    as 'ValorIPI',
    cast(round(isnull(nec.vl_irrf_nota_entrada,0),2) as decimal(25,2))	 as 'ValorIRRF',
    cast(round(isnull(nec.vl_inss_nota_entrada,0),2) as decimal(25,2))   as 'ValorINSS',
    cast(round(isnull(nec.vl_iss_nota_entrada,0),2) as decimal(25,2)) 	 as 'ValorISS',
    cast(round(isnull(nec.vl_pis_nota_entrada,0),2) as decimal(25,2))	 as 'ValorPIS',
    cast(round(isnull(nec.vl_cofins_nota_entrada,0),2) as decimal(25,2)) as 'ValorCOFINS',
    cast(round(isnull(nec.vl_csll_nota_entrada,0),2) as decimal(25,2)) 	 as 'ValorCSLL',
    nec.ic_provisao_nota_entrada                                         as 'Provisao'
  into
    #ContabilRazaoComConta 
  from
    #ContabilRazaoComContaBase nec
  inner join 
    Lancamento_Padrao lp with(nolock) 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  left outer join 
    Tipo_Contabilizacao t with(nolock)
  on
    lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao
  left outer join 
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = nec.cd_operacao_fiscal
  where not (isnull(nec.vl_contab_nota_entrada,0) = 0 and
             isnull(nec.vl_icms_nota_entrada,0) = 0 and
             isnull(nec.vl_ipi_nota_entrada,0) = 0 and
             isnull(nec.vl_irrf_nota_entrada,0) = 0 and
             isnull(nec.vl_inss_nota_entrada,0) = 0 and
             isnull(nec.vl_iss_nota_entrada,0) = 0 and
             isnull(nec.vl_pis_nota_entrada,0) = 0 and
             isnull(nec.vl_cofins_nota_entrada,0) = 0 and
             isnull(nec.vl_csll_nota_entrada,0) = 0)
	
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
    ValorISS,
    ValorPIS,
    ValorCOFINS,
    ValorCSLL,
    Provisao )
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
    sum(isNull(ValorISS,0))   as ValorISS,
    sum(isNull(ValorPIS,0))   as ValorPIS,
    sum(isNull(ValorCOFINS,0))as ValorCOFINS,
    sum(isNull(ValorCSLL,0))  as ValorCSLL,
    Provisao

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
    Servico,
    Provisao
 		
  --Define o nome do lancamento em função da contabilização da CFOP
  Update	
    #ContabilRazaoSemConta 
  set	
    Nome_Lancamento_Padrao = Left(Operacao_Fiscal_Nome,28),
    Mascara_Lancamento_Padrao = ' CFOP: ' + left(Operacao_Fiscal_Mascara,15)
  where	
    IsNull(Nome_Lancamento_Padrao,'') = ''		

  Select
    identity(int,1,1) as 'cd_chave',
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
    case when Provisao = 'S' then
      sum(isnull(ValorTotal,0) -
          (isnull(ValorIRRF,0) +
           isnull(ValorINSS,0) +
           isnull(ValorISS,0) +
           isnull(ValorPIS,0) +
           isnull(ValorCOFINS,0) +
           isnull(ValorCSLL,0)))
    else sum(IsNull(ValorTotal,0)) end as ValorTotal,
    sum(IsNull(ValorICMS,0))  as ValorICMS,
    sum(isNull(ValorIPI,0))   as ValorIPI,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorIRRF,0))  end as ValorIRRF,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorINSS,0))  end as ValorINSS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorISS,0))   end as ValorISS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorPIS,0))   end as vl_pis_nota_entrada,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorCOFINS,0)) end as vl_cofins_nota_entrada,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorCSLL,0))  end as vl_csll_nota_entrada,
    Provisao
  into #Teste
  from 
    #ContabilRazaoSemConta 
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
    Provisao
  order by 
    Servico,
    Mascara_Lancamento_Padrao, 
    DataEmissao, 
    Documento

  Select
    cd_chave,
    Nome_Lancamento_Padrao, 
    Mascara_Lancamento_Padrao,
    t.Reduzido_Lancamento_Padrao,   
    Reduzido_Credito,
    cd_conta_plano,
    t.Documento,
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
    case when t.cd_chave <> w.cd_chave_minima then
      0 else ValorICMS end as ValorICMS,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else ValorIPI end as ValorIPI,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else ValorIRRF end as ValorIRRF,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else ValorINSS end as ValorINSS,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else ValorISS end as ValorISS,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else vl_pis_nota_entrada end as vl_pis_nota_entrada,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else vl_cofins_nota_entrada end as vl_cofins_nota_entrada,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else vl_csll_nota_entrada end as vl_csll_nota_entrada,
    Provisao
  from #Teste t left outer join
    ( select  
        te.Documento,
        te.Reduzido_Lancamento_Padrao,
        min(te.cd_chave) as cd_chave_minima
      from
        #Teste te
      group by 
        te.Documento,
        te.Reduzido_Lancamento_Padrao ) w on w.Documento = t.Documento and
                                             w.Reduzido_Lancamento_Padrao = t.Reduzido_Lancamento_Padrao
--      left outer join
--      ( select  
--          te.Documento,
--          min(te.cd_chave) as cd_chave_minima
--        from
--          #Teste te
--        group by 
--          te.Documento ) z on z.Documento = t.Documento
  order by 
    t.Servico,
    t.Mascara_Lancamento_Padrao, 
    t.DataEmissao, 
    t.Documento
   
end
--------------------------------------------------------
else if  @ic_parametro = 2 --Contabilização Sintético
--------------------------------------------------------
begin

  declare @cd_lancamento_padrao_irrf int
  declare @cd_lancamento_padrao_inss int
  declare @cd_lancamento_padrao_iss int
  declare @cd_lancamento_padrao_pis int
  declare @cd_lancamento_padrao_cofins int
  declare @cd_lancamento_padrao_csll int

  -----------------------------------------------
  -- Carrega os Lancamentos Padrões
  -----------------------------------------------
  select 
    @cd_lancamento_padrao_irrf = cd_lancamento_padrao_irrf,
    @cd_lancamento_padrao_inss = cd_lancamento_padrao_inss,
    @cd_lancamento_padrao_iss = cd_lancamento_padrao_iss,
    @cd_lancamento_padrao_pis = cd_lancamento_padrao_pis,
    @cd_lancamento_padrao_cofins = cd_lancamento_padrao_cofins,
    @cd_lancamento_padrao_csll = cd_lancamento_padrao_csll
  from
    Parametro_Logistica with(nolock)
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
    Nota_Entrada_Contabil nec with(nolock)
  left outer join
    Nota_Entrada ne with(nolock)
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
    isnull(ne.vl_irrf_nota_entrada,0)                           as ValorIRRF,
    isnull(ne.vl_inss_nota_entrada,0)                           as ValorINSS,
    isnull(ne.vl_iss_nota_entrada,0)                            as ValorISS,
    isnull(ne.vl_pis_nota_entrada,0)                            as ValorPIS,
    isnull(ne.vl_cofins_nota_entrada,0)                         as ValorCOFINS,
    isnull(ne.vl_csll_nota_entrada,0)                           as ValorCSLL,
    isnull(opf.ic_servico_operacao,'N')	                        as Servico,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')                     as ic_provisao_nota_entrada    
  into
    #Nota_Entrada_Fiscal_Sintetico
  from
    Nota_Entrada ne with(nolock)
  inner join
    Nota_Entrada_Item_Registro neir with(nolock)
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
    not exists (select 'x' from Nota_Entrada_Contabil nec with(nolock) where
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
    ne.ic_provisao_nota_entrada,
    ne.vl_irrf_nota_entrada,
    ne.vl_inss_nota_entrada,
    ne.vl_iss_nota_entrada,
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
    cast(null as decimal(25,2))         as ValorPIS,
    cast(null as decimal(25,2))         as ValorCOFINS,
    cast(null as decimal(25,2))         as ValorCSLL,    
    isnull(opf.ic_servico_operacao,'N')	as Servico,
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')                     as ic_provisao_nota_entrada 
  into
    #Nota_Diferenca_Sintetico
  from 
    Nota_Entrada_Item_Registro neir with(nolock)
  inner join
    Nota_Entrada ne with(nolock)
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
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Operacao_Fiscal opf with(nolock)
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
    ne.ic_provisao_nota_entrada

  -- ELIAS 10/08/2004
  select * into
    #Nota_Dif_Sem_Valor_Comercial_Sintetico
  from 
    #Nota_Diferenca_Sintetico
  where     
    (vl_contab_nota_entrada > 0) or
    (vl_ipi_nota_entrada > 0) or
    (vl_icms_nota_entrada > 0)

  -- 1º AGRUPAMENTO
  select
    isnull(opf.ic_servico_operacao,'N')		                               as Servico,
    round(sum(isnull(ne.vl_total_nota_entrada,0)),2)                           as ValorTotal,
    round(sum(isnull(ne.vl_ipi_nota_entrada,0)),2)                             as ValorIPI,
    round(sum(isnull(ne.vl_icms_nota_entrada,0)),2)                            as ValorICMS,
    round(sum(isnull(ne.vl_irrf_nota_entrada,0)),2)                            as ValorIRRF,
    round(sum(isnull(ne.vl_inss_nota_entrada,0)),2)                            as ValorINSS,
    case when (isnull(ne.ic_reter_iss,'N')='S') then
      round(sum(isnull(ne.vl_iss_nota_entrada,0)),2)                             
    else 0 end                                                                 as ValorISS,
    round(sum(isnull(ne.vl_pis_nota_entrada,0)),2)                             as ValorPIS,
    round(sum(isnull(ne.vl_cofins_nota_entrada,0)),2)                          as ValorCOFINS,
    round(sum(isnull(ne.vl_csll_nota_entrada,0)),2)                            as ValorCSLL,
    isnull(ne.cd_nota_entrada,0)                                               as cd_nota_entrada,
    isnull(ne.cd_fornecedor,0)                                                 as cd_fornecedor,
    isnull(ne.cd_operacao_fiscal,0)                                            as cd_operacao_fiscal,
    isnull(ne.cd_serie_nota_fiscal,0)                                          as cd_serie_nota_fiscal,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')                                    as Provisao    
  into	
    #Analitico
  from
    Nota_Entrada ne with(nolock)
  left outer join
    Nota_Entrada_Item_Registro neir with(nolock)
  on
    neir.cd_nota_entrada = ne.cd_nota_entrada and
    neir.cd_fornecedor = ne.cd_fornecedor and
    neir.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    neir.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Nota_Entrada_Registro ner with(nolock) 
  on
    ner.cd_nota_entrada = ne.cd_nota_entrada and
    ner.cd_fornecedor = ne.cd_fornecedor and
    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join 
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_receb_nota_entrada between @dt_inicial and @dt_final) and              
     not exists (select 'x' from Nota_Entrada_Contabil nec with(nolock) where
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
    isnull(ne.ic_reter_iss,'N'),
    ne.ic_provisao_nota_entrada

  -- 2º AGRUPAMENTO
  insert into #Analitico
    (ValorTotal,
     ValorIPI,
     ValorICMS,
     ValorIRRF,
     ValorINSS,     
     ValorISS,
     ValorPIS,
     ValorCOFINS,
     ValorCSLL,
     Servico,
     cd_nota_entrada,
     cd_fornecedor,
     cd_operacao_fiscal,
     cd_serie_nota_fiscal,
     Provisao)  
  select 
    dif.vl_contab_nota_entrada,
    dif.vl_ipi_nota_entrada,
    dif.vl_icms_nota_entrada,
    dif.ValorIRRF,
    dif.ValorINSS,     
    dif.ValorISS,
    dif.ValorPIS,
    dif.ValorCOFINS,
    dif.ValorCSLL,
    dif.Servico,
    dif.cd_nota_entrada,
    dif.cd_fornecedor,
    dif.cd_operacao_fiscal,
    dif.cd_serie_nota_fiscal,
    dif.ic_provisao_nota_entrada
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
     ValorPIS,
     ValorCOFINS,
     ValorCSLL,
     Servico,
     cd_nota_entrada,
     cd_fornecedor,
     cd_operacao_fiscal,
     cd_serie_nota_fiscal,
     Provisao)  
  select 
    dif.vl_contab_nota_entrada,
    dif.vl_ipi_nota_entrada,
    dif.vl_icms_nota_entrada,
    dif.ValorIRRF,
    dif.ValorINSS,     
    dif.ValorISS,
    dif.ValorPIS,
    dif.ValorCOFINS,
    dif.ValorCSLL,
    dif.Servico,
    dif.cd_nota_entrada,
    dif.cd_fornecedor,
    dif.cd_operacao_fiscal,
    dif.cd_serie_nota_fiscal,
    dif.ic_provisao_nota_entrada
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
    --Conta de Débito do ISS
    null as 'cd_debito_iss',
    --Conta de Crédito do ISS
    null as 'cd_credito_iss',
    --Conta de Débito do PIS
    null as 'cd_debito_pis',
    --Conta de Crédito do PIS
    null as 'cd_credito_pis',
    --Conta de Débito do COFINS
    null as 'cd_debito_cofins',
    --Conta de Crédito do COFINS
    null as 'cd_credito_cofins',
    --Conta de Débito do CSLL
    null as 'cd_debito_csll',
    --Conta de Crédito do CSLL
    null as 'cd_credito_csll',
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
    --Histórico ISS
    null as 'cd_historico_iss',
    --Histórico PIS
    null as 'cd_historico_pis',
    --Histórico COFINS
    null as 'cd_historico_cofins',
    --Histórico CSLL
    null as 'cd_historico_csll',
    Servico,
    case when Provisao = 'S' then
      sum(isnull(ValorTotal,0) -
          (isnull(ValorIRRF,0) +
           isnull(ValorINSS,0) +
           isnull(ValorISS,0) +
           isnull(ValorPIS,0) +
           isnull(ValorCOFINS,0) +
           isnull(ValorCSLL,0)))
    else sum(IsNull(ValorTotal,0)) end as ValorTotal,
    sum(ValorIPI)     as ValorIPI,
    sum(ValorICMS)    as ValorICMS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorIRRF,0))  end as ValorIRRF,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorINSS,0))  end as ValorINSS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorISS,0))   end as ValorISS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorPIS,0))   end as ValorPIS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorCOFINS,0)) end as ValorCOFINS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorCSLL,0))  end as ValorCSLL,
    Provisao
  into
    #ContabilRazaoSemContaSintetico
  from
    #Analitico
  group by
    Servico,
    Provisao

  -----------------------------------------------
  -- Traz Notas de Saída com conta
  -----------------------------------------------

  --Foi criada esta tabela para agrupara os valores sem a necessidade de uma 
  --restruturação da lógica empregada nos outros procedimentos

  -- Passo a Utilizar o campo do lançamento padrão 
  -- e os demais campos, diretamente da Nota Fiscal
  -- Utilizado o max para permitir o agrupamento quando existe mais do
  -- que um registro no nota_Entrada_Contabil - ELIAS 15/07/2004  

  -- TODOS OS VALORES DE IRRF, INSS E ISS
  select
    min(nec.cd_lancamento_padrao) as cd_lancamento_padrao,
    min(lp.cd_conta_credito) as cd_conta_credito,  
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada as dt_contab_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia as nm_fantasia_fornecedor,
    ne.cd_operacao_fiscal,
    cast(null as decimal(25,2))                         as vl_contab_nota_entrada,
    cast(null as decimal(25,2))                         as vl_ipi_nota_entrada,
    cast(null as decimal(25,2))                         as vl_icms_nota_entrada,
    round(isnull(max(ne.vl_irrf_nota_entrada),0),2) 	        as vl_irrf_nota_entrada,
    round(isnull(max(ne.vl_inss_nota_entrada),0),2)          as vl_inss_nota_entrada,
    case when (isnull(max(ne.ic_reter_iss),'N')='S') then
      round(isnull(max(ne.vl_iss_nota_entrada),0),2)                             
    else 0 end                                          as vl_iss_nota_entrada,
    round(isnull(max(ne.vl_pis_nota_entrada),0),2)           as vl_pis_nota_entrada,
    round(isnull(max(ne.vl_cofins_nota_entrada),0),2)        as vl_cofins_nota_entrada,
    round(isnull(max(ne.vl_csll_nota_entrada),0),2)          as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')            as ic_provisao_nota_entrada    
  into
    #Nota_Contabil_IRRF_Sintetico
  from
    Nota_Entrada_Contabil nec with(nolock)
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne with(nolock) 
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
    Lancamento_Padrao lp with(nolock)
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao --and
    --lp.cd_tipo_contabilizacao = 1  -- NOTA FISCAL
  where
    ((isnull(ne.vl_irrf_nota_entrada,0) <> 0) or
    (isnull(ne.vl_inss_nota_entrada,0) <> 0) or
    ((case when (isnull(ne.ic_reter_iss,'N')='S') then
      isnull(ne.vl_iss_nota_entrada,0)
      else 0 end) <> 0) or
    (isnull(ne.vl_pis_nota_entrada,0) <> 0) or
    (isnull(ne.vl_cofins_nota_entrada,0) <> 0) or
    (isnull(ne.vl_csll_nota_entrada,0) <> 0)) and
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
    (isnull(nec.cd_lancamento_padrao,0)<>0)
  group by
    --nec.cd_lancamento_padrao,
    --lp.cd_conta_credito,  
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia,
    ne.cd_operacao_fiscal,
    ne.ic_provisao_nota_entrada
  order by
    ne.cd_nota_entrada


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
    cast(null as decimal(25,2))                                  as vl_pis_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_cofins_nota_entrada,
    cast(null as decimal(25,2))                                  as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')                      as ic_provisao_nota_entrada
  into	
    #AnaliticoComConta
  from
    Nota_Entrada_Contabil nec with(nolock)
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne with(nolock)
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
    Lancamento_Padrao lp with(nolock)
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
    nec.cd_nota_entrada,
    ne.ic_provisao_nota_entrada

  order by
    nec.cd_nota_entrada

  update 
    #AnaliticoComConta
  set
    vl_irrf_nota_entrada   = ne.vl_irrf_nota_entrada,
    vl_inss_nota_entrada   = ne.vl_inss_nota_entrada,
    vl_iss_nota_entrada    = ne.vl_iss_nota_entrada,
    vl_pis_nota_entrada    = ne.vl_pis_nota_entrada,
    vl_cofins_nota_entrada = ne.vl_cofins_nota_entrada,
    vl_csll_nota_entrada   = ne.vl_csll_nota_entrada
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
    -- NOME DA CONTA
    cast('- '+(select nm_conta from Plano_Conta with(nolock)
  	       where cd_conta = (select top 1 cd_conta_debito
		       	         from Lancamento_Padrao with(nolock)
				 where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
 				                               from Lancamento_Padrao lanc with(nolock)
                               		   		       where cd_conta_plano = lp.cd_conta_plano and
				                                     cd_tipo_contabilizacao = 1 and
                                                                     ic_tipo_operacao = 'E')) and
                                       cd_empresa = dbo.fn_empresa()) as varchar(40)) as 'Nome_Lancamento_Padrao',


    -- MÁSCARA DA CONTA
    cast((Select cd_mascara_conta from Plano_conta with(nolock)
	  where cd_conta = (Select top 1 cd_conta_debito 
		            from Lancamento_Padrao with(nolock)
			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
					                  from Lancamento_Padrao lanc with(nolock)
					                  where cd_conta_plano = lp.cd_conta_plano and
						                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(20)) as 'Mascara_Lancamento_Padrao',


    -- REDUZIDO DÉBITO
    cast((Select cd_conta_reduzido from Plano_conta with(nolock)
          where cd_conta = (Select top 1 cd_conta_debito
			    from Lancamento_Padrao with(nolock)
			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
				                          from Lancamento_Padrao lanc with(nolock)
                             		   		  where cd_conta_plano = lp.cd_conta_plano and
						                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Lancamento_Padrao',


    -- Código reduzido da conta crédito 
    cast((Select cd_conta_reduzido from Plano_Conta with(nolock)
   	  where cd_conta = (Select top 1 cd_conta_credito
			    from Lancamento_Padrao with(nolock)
			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                         			  	  from Lancamento_Padrao lanc with(nolock)
                           				  where cd_conta_plano = lp.cd_conta_plano and
                           					cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Credito',

    cast(round(nec.vl_contab_nota_entrada,2) as decimal(25,2))             	as 'ValorTotal',
    cast(round(nec.vl_icms_nota_entrada,2) as decimal(25,2))               	as 'ValorICMS',
    cast(round(nec.vl_ipi_nota_entrada,2) as decimal(25,2))               	as 'ValorIPI',
    cast(round(isnull(nec.vl_irrf_nota_entrada,0),2) as decimal(25,2))	as 'ValorIRRF',
    cast(round(isnull(nec.vl_inss_nota_entrada,0),2) as decimal(25,2))      as 'ValorINSS',
    cast(round(isnull(nec.vl_iss_nota_entrada,0),2) as decimal(25,2)) 	as 'ValorISS',
    cast(round(isnull(nec.vl_pis_nota_entrada,0),2) as decimal(25,2))	as 'ValorPIS',
    cast(round(isnull(nec.vl_cofins_nota_entrada,0),2) as decimal(25,2))      as 'ValorCOFINS',
    cast(round(isnull(nec.vl_csll_nota_entrada,0),2) as decimal(25,2)) 	as 'ValorCSLL',
    (Select cd_conta_debito from lancamento_padrao with(nolock) where cd_lancamento_padrao = nec.cd_lancamento_padrao) as cd_conta_debito,
    (Select cd_conta_credito from lancamento_padrao with(nolock) where cd_lancamento_padrao = nec.cd_lancamento_padrao) as cd_conta_credito,
    (Select cd_historico_contabil from lancamento_padrao with(nolock) where cd_lancamento_padrao = nec.cd_lancamento_padrao) as cd_historico,
    isnull(opf.ic_servico_operacao,'N') as Servico,
    ic_provisao_nota_entrada as Provisao
  into	
    #ContabilRazaoComContaBaseSINTETICO
  from	
    #AnaliticoComConta nec
  left outer join 
    Lancamento_Padrao lp with(nolock)
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  left outer join 
    Tipo_Contabilizacao t with(nolock)
  on
    lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao
  left outer join 
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = nec.cd_operacao_fiscal    
  where
    (nec.dt_contab_nota_entrada between @dt_inicial and @dt_final) and
    (IsNull(nec.cd_lancamento_padrao,0) <> 0)

  delete from
    #ContabilRazaoComContaBaseSINTETICO
  where
    ValorTotal = 0 and
    ValorICMS = 0 and
    ValorIPI = 0 and
    ValorIRRF = 0 and
    ValorINSS = 0 and
    ValorISS = 0 and
    ValorPIS = 0 and
    ValorCOFINS = 0 and
    ValorCSLL = 0 

  Select	
    Nome_Lancamento_Padrao,
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,

    -- ELIAS/LUCIO 17/06/2004
    sum(nec.ValorTotal) as vl_total,  
    sum(nec.ValorICMS) as vl_icms,  
    sum(nec.ValorIPI) as vl_ipi,  
    sum(nec.ValorIRRF) as vl_irrf,  
    sum(nec.ValorINSS) as vl_inss,  
    sum(nec.ValorISS) as vl_iss,  
    -- ELIAS/LÚCIO 17/06/2004
    sum(nec.ValorPIS) as vl_pis,
    sum(nec.ValorCOFINS) as vl_cofins,
    sum(nec.ValorCSLL) as vl_csll,
    (Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico
     and ValorTotal > 0) as cd_lancamento_nota,
    (Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico
     and ValorICMS > 0) as cd_lancamento_icms,
    (Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nec.Mascara_Lancamento_Padrao and Servico = nec.Servico
     and ValorIPI > 0) as cd_lancamento_ipi,
    @cd_lancamento_padrao_irrf as cd_lancamento_irrf,
    @cd_lancamento_padrao_inss as cd_lancamento_inss,
    Servico,
    Provisao
  into	
   #ContabilRazaoComContaBaseSINTETICO_Contas
  from	
    #ContabilRazaoComContaBaseSINTETICO nec
  group by
    Nome_Lancamento_Padrao,
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,
    Servico,
    Provisao

  Select 
    Nome_Lancamento_Padrao,
    Mascara_Lancamento_Padrao,
    Reduzido_Lancamento_Padrao,
    --===============
    -- Contas Crédito:
    --===============
    --Nota
    (Select cd_conta_reduzido from Plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
 		       where cd_conta_plano = (select top 1 lanc.cd_conta_plano from Lancamento_Padrao lanc with(nolock)
			                       where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                             cd_tipo_contabilizacao = 1 and
                             cd_empresa = dbo.fn_empresa())) as cd_credito_nota_fiscal,      
    --ICMS
    (Select cd_conta_reduzido from Plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
 		       where cd_conta_plano = (select top 1 lanc.cd_conta_plano from Lancamento_Padrao lanc with(nolock)
				               where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                    cd_tipo_contabilizacao = 2 and
                             cd_empresa = dbo.fn_empresa())) as cd_credito_icms,
    --IPI
    (Select cd_conta_reduzido from Plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
		       where cd_conta_plano = (select top 1 lanc.cd_conta_plano from Lancamento_Padrao lanc with(nolock)
				               where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                             cd_tipo_contabilizacao = 3 and
                             cd_empresa = dbo.fn_empresa())) as cd_credito_ipi,
    --IRRF
    (Select top 1 cd_conta_reduzido from Plano_Conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
			where cd_lancamento_padrao = @cd_lancamento_padrao_irrf) and
                              cd_empresa = dbo.fn_empresa()) as cd_credito_irrf,
    --INSS
    (Select top 1 cd_conta_reduzido from Plano_Conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
                       where cd_lancamento_padrao = @cd_lancamento_padrao_inss) and
                             cd_empresa = dbo.fn_empresa()) as cd_credito_inss,
    --ISS
    (Select top 1 cd_conta_reduzido from Plano_Conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
			where cd_lancamento_padrao = @cd_lancamento_padrao_iss) and
                              cd_empresa = dbo.fn_empresa()) as cd_credito_iss,
    --PIS
    (Select top 1 cd_conta_reduzido from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_padrao with(nolock)
                       where cd_lancamento_padrao = @cd_lancamento_padrao_pis) and
                             cd_empresa = dbo.fn_empresa()) as cd_credito_pis,
    --COFINS
    (Select top 1 cd_conta_reduzido from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_padrao with(nolock)
			where cd_lancamento_padrao = @cd_lancamento_padrao_cofins) and
                              cd_empresa = dbo.fn_empresa()) as cd_credito_cofins,
    --CSLL
    (Select top 1 cd_conta_reduzido from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_credito from Lancamento_padrao with(nolock)
                       where cd_lancamento_padrao = @cd_lancamento_padrao_csll) and
                             cd_empresa = dbo.fn_empresa()) as cd_credito_csll,

     --===============
     -- Contas Débito:
     --===============
     --Nota
     (Select cd_conta_reduzido
      from Plano_conta with(nolock)
      where cd_conta = (Select top 1 cd_conta_debito
                        from Lancamento_Padrao with(nolock)
                        where cd_conta_plano = (select top 1 lanc.cd_conta_plano
                                                from Lancamento_Padrao lanc with(nolock)
                                                where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                                                      cd_tipo_contabilizacao = 1 and
                                                      cd_empresa = dbo.fn_empresa())) as cd_debito_nota_fiscal,
     --ICMS
     (Select cd_conta_reduzido
      from Plano_conta with(nolock)
      where cd_conta = (Select top 1 cd_conta_debito
                        from Lancamento_Padrao with(nolock)
                        where cd_conta_plano = (select top 1 lanc.cd_conta_plano
                                                from Lancamento_Padrao lanc with(nolock)
                                                where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                                                      cd_tipo_contabilizacao = 2 and
                                                      cd_empresa = dbo.fn_empresa())) as cd_debito_icms,
    --IPI
    (Select cd_conta_reduzido
     from Plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_debito
                       from Lancamento_Padrao with(nolock)
                       where cd_conta_plano = (select top 1 lanc.cd_conta_plano
                                               from Lancamento_Padrao lanc with(nolock)
                                               where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                                                     cd_tipo_contabilizacao = 3 and
                                                     cd_empresa = dbo.fn_empresa())) as cd_debito_ipi,
    --IRRF
    (Select top 1 cd_conta_reduzido
     from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_debito
                       from Lancamento_padrao with(nolock)
                       where cd_lancamento_padrao = @cd_lancamento_padrao_irrf) and
                             cd_empresa = dbo.fn_empresa()) as cd_debito_irrf,
    --INSS
    (Select top 1 cd_conta_reduzido
     from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_debito
                      from Lancamento_padrao with(nolock)
                      where cd_lancamento_padrao = @cd_lancamento_padrao_inss) and
                            cd_empresa=dbo.fn_empresa()) as cd_debito_inss,
    --ISS
    (Select top 1 cd_conta_reduzido
     from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_debito
                       from Lancamento_padrao with(nolock)
                       where cd_lancamento_padrao = @cd_lancamento_padrao_iss) and
                             cd_empresa = dbo.fn_empresa()) as cd_debito_iss,
    --PIS
    (Select top 1 cd_conta_reduzido
     from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_debito
                       from Lancamento_padrao with(nolock)
                       where cd_lancamento_padrao = @cd_lancamento_padrao_pis) and
                             cd_empresa = dbo.fn_empresa()) as cd_debito_pis,
    --COFINS
    (Select top 1 cd_conta_reduzido
     from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_debito
                      from Lancamento_padrao with(nolock)
                      where cd_lancamento_padrao = @cd_lancamento_padrao_cofins) and
                            cd_empresa=dbo.fn_empresa()) as cd_debito_cofins,
    --CSLL
    (Select top 1 cd_conta_reduzido
     from plano_conta with(nolock)
     where cd_conta = (Select top 1 cd_conta_debito
                       from Lancamento_padrao with(nolock)
                       where cd_lancamento_padrao = @cd_lancamento_padrao_csll) and
                             cd_empresa=dbo.fn_empresa()) as cd_debito_csll,

    --============
    -- Históricos:
    --============
 
    --Nota
    (Select top 1 cd_historico_contabil
     from Lancamento_Padrao with(nolock)
     where cd_conta_plano = (select top 1 lanc.cd_conta_plano
                             from Lancamento_Padrao lanc with(nolock)
                             where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                                   cd_tipo_contabilizacao = 1 and
           cd_empresa = dbo.fn_empresa()) as cd_historico_nota_fiscal,
    --ICMS
    (Select top 1 cd_historico_contabil
     from Lancamento_Padrao with(nolock)
     where cd_conta_plano = (select top 1 lanc.cd_conta_plano
                             from Lancamento_Padrao lanc with(nolock)
                             where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                                   cd_tipo_contabilizacao = 2 and
           cd_empresa = dbo.fn_empresa()) as cd_historico_icms,
    --IPI
    (Select top 1 cd_historico_contabil
     from Lancamento_Padrao with(nolock)
     where cd_conta_plano = (select top 1 lanc.cd_conta_plano
                             from Lancamento_Padrao lanc with(nolock)
                             where lanc.cd_lancamento_padrao = nec.cd_lancamento_nota) and
                                   cd_tipo_contabilizacao = 3 and
           cd_empresa = dbo.fn_empresa()) as cd_historico_ipi,
    --IRRF
    (Select top 1 cd_historico_contabil
     from Lancamento_padrao with(nolock)
     where cd_lancamento_padrao = @cd_lancamento_padrao_irrf) as cd_historico_irrf,
    --INSS
    (Select top 1 cd_historico_contabil
     from Lancamento_padrao with(nolock)
     where cd_lancamento_padrao = @cd_lancamento_padrao_inss) as cd_historico_inss,
    --ISS
    (Select top 1 cd_historico_contabil
     from Lancamento_padrao with(nolock)
     where cd_lancamento_padrao = @cd_lancamento_padrao_iss) as cd_historico_iss,
    --PIS
    (Select top 1 cd_historico_contabil
     from Lancamento_padrao with(nolock)
     where cd_lancamento_padrao = @cd_lancamento_padrao_pis) as cd_historico_pis,
    --COFINS
    (Select top 1 cd_historico_contabil
     from Lancamento_padrao with(nolock)
     where cd_lancamento_padrao = @cd_lancamento_padrao_cofins) as cd_historico_cofins,
    --CSLL
    (Select top 1 cd_historico_contabil
     from Lancamento_padrao with(nolock)
     where cd_lancamento_padrao = @cd_lancamento_padrao_csll) as cd_historico_csll,
    --Valor NF
    case when Provisao = 'S' then
      vl_total - (vl_irrf + vl_INSS + vl_ISS +
                  vl_PIS + vl_COFINS + vl_CSLL)
    else vl_total end as ValorTotal,
    --Valor ICMS
    vl_icms  as ValorICMS,
    --Valor IPI
    vl_ipi   as ValorIPI,

    case when Provisao = 'S' then 0 else 
      vl_IRRF end as ValorIRRF,
    case when Provisao = 'S' then 0 else 
      vl_INSS end as ValorINSS,
    case when Provisao = 'S' then 0 else 
      vl_ISS  end as ValorISS,
    case when Provisao = 'S' then 0 else 
      vl_PIS  end as ValorPIS,
    case when Provisao = 'S' then 0 else 
      vl_COFINS end as ValorCOFINS,
    case when Provisao = 'S' then 0 else 
      vl_CSLL end as ValorCSLL,
    Servico,
    Provisao
  into 
    #ContabilRazaoComContaBaseSINTETICO_Final
  from 
    #ContabilRazaoComContaBaseSINTETICO_Contas as nec


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
    cd_credito_iss,
    cd_debito_iss,
    cd_credito_pis,
    cd_debito_pis,
    cd_credito_cofins,
    cd_debito_cofins,
    cd_credito_csll,
    cd_debito_csll,
    cd_historico_nota_fiscal,
    cd_historico_ipi,
    cd_historico_icms,
    cd_historico_irrf,
    cd_historico_inss,
    cd_historico_iss,
    cd_historico_pis,
    cd_historico_cofins,
    cd_historico_csll,
    ValorTotal,
    ValorICMS,
    ValorIPI,
    ValorIRRF,
    ValorINSS,
    ValorISS,
    ValorPIS,
    ValorCOFINS,
    ValorCSLL,
    Servico,
    Provisao)
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
    cd_credito_iss,
    cd_debito_iss,
    cd_credito_pis,
    cd_debito_pis,
    cd_credito_cofins,
    cd_debito_cofins,
    cd_credito_csll,
    cd_debito_csll,
    cd_historico_nota_fiscal,
    cd_historico_ipi,
    cd_historico_icms,
    cd_historico_irrf,
    cd_historico_inss,
    cd_historico_iss,
    cd_historico_pis,
    cd_historico_cofins,
    cd_historico_csll,
    ValorTotal,
    ValorICMS,
    ValorIPI,
    ValorIRRF,
    ValorINSS,
    ValorISS,
    ValorPIS,
    ValorCOFINS,
    ValorCSLL,
    Servico,
    Provisao
  from #ContabilRazaoComContaBaseSINTETICO_Final

  select
    identity(int,1,1) as cd_chave,
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
    cd_credito_iss,
    cd_debito_iss,
    cd_credito_pis,
    cd_debito_pis,
    cd_credito_cofins,
    cd_debito_cofins,
    cd_credito_csll,
    cd_debito_csll,
    cd_historico_nota_fiscal,
    cd_historico_ipi,
    cd_historico_icms,
    cd_historico_irrf,
    cd_historico_inss,
    cd_historico_iss,		
    cd_historico_pis,		
    cd_historico_cofins,
    cd_historico_csll,
    sum(IsNull(ValorTotal,0)) as ValorTotal,
    sum(IsNull(ValorICMS,0))  as ValorICMS,
    sum(isNull(ValorIPI,0))   as ValorIPI,
    sum(IsNull(ValorIRRF,0))  as ValorIRRF,
    sum(isNull(ValorINSS,0))   as ValorINSS,
    sum(isnull(valorISS,0))   as ValorISS,
    sum(IsNull(ValorPIS,0))  as ValorPIS,
    sum(isNull(ValorCOFINS,0))   as ValorCOFINS,
    sum(isnull(valorCSLL,0))   as ValorCSLL,
    Servico,
    Provisao    
  into #Teste2
  from 
    #ContabilRazaoSemContaSINTETICO 
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
    cd_credito_iss,
    cd_debito_iss,
    cd_credito_pis,
    cd_debito_pis,
    cd_credito_cofins,
    cd_debito_cofins,
    cd_credito_csll,
    cd_debito_csll,
    cd_historico_nota_fiscal,
    cd_historico_ipi,
    cd_historico_icms,
    cd_historico_irrf,
    cd_historico_inss,
    cd_historico_iss,		
    cd_historico_pis,		
    cd_historico_cofins,
    cd_historico_csll,
    Servico,
    Provisao
  order by
    Servico,
    Mascara_Lancamento_Padrao, 
    cd_debito_nota_fiscal

select
    cd_chave,
    Nome_Lancamento_Padrao, 
    Mascara_Lancamento_Padrao,
    t.Reduzido_Lancamento_Padrao,   
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
    cd_credito_iss,
    cd_debito_iss,
    cd_credito_pis,
    cd_debito_pis,
    cd_credito_cofins,
    cd_debito_cofins,
    cd_credito_csll,
    cd_debito_csll,
    cd_historico_nota_fiscal,
    cd_historico_ipi,
    cd_historico_icms,
    cd_historico_irrf,
    cd_historico_inss,
    cd_historico_iss,		
    cd_historico_pis,		
    cd_historico_cofins,
    cd_historico_csll,
    ValorTotal,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else t.ValorICMS end as ValorICMS,
    case when t.cd_chave <> w.cd_chave_minima then
      0 else t.ValorIPI end as ValorIPI,
    case when t.cd_chave <> z.cd_chave_minima then
      0 else t.ValorIRRF end as ValorIRRF,
    case when t.cd_chave <> z.cd_chave_minima then
      0 else t.ValorINSS end as ValorINSS,
    case when t.cd_chave <> z.cd_chave_minima then
      0 else t.ValorISS end as ValorISS,
    case when t.cd_chave <> z.cd_chave_minima then
      0 else t.ValorPIS end as ValorPIS,
    case when t.cd_chave <> z.cd_chave_minima then
      0 else t.ValorCOFINS end as ValorCOFINS,
    case when t.cd_chave <> z.cd_chave_minima then
      0 else t.ValorCSLL end as ValorCSLL,
    t.Servico,    
    Provisao
  from #Teste2 t left outer join
    ------------------------------------------------------------------------------
    -- Observações:
    -- Devido a não haver o número na Note de Entrada neste Select, parto da probabilidade
    -- de que todos os impostos iguais constituem uma mesma nota de entrada,
    -- podendo portando não mostrá-la da segunda vez.
    -- Daniel C. Neto em 02/08/2004
    ------------------------------------------------------------------------------
    ( select  
        te.ValorICMS,
        te.ValorIPI,
        te.ValorIRRF,
        te.ValorINSS,
        te.ValorISS,
        te.ValorPIS,
        te.ValorCofins,
        te.ValorCSLL,
        te.Servico,
        te.Reduzido_Lancamento_Padrao,
        min(te.cd_chave) as cd_chave_minima
      from
        #Teste2 te
      group by 
        te.Reduzido_Lancamento_Padrao,
        te.ValorICMS,
        te.ValorIPI,
        te.ValorIRRF,
        te.ValorINSS,
        te.ValorISS,
        te.ValorPIS,
        te.ValorCofins,
        te.ValorCSLL,
        te.Servico ) w on w.Reduzido_Lancamento_Padrao = t.Reduzido_Lancamento_Padrao and
                          w.ValorICMS   = t.ValorICMS and
                          w.ValorIPI    = t.ValorIPI and
                          w.ValorIRRF   = t.ValorIRRF and 
                          w.ValorINSS   = t.ValorINSS and
                          w.ValorISS    = t.ValorISS  and
                          w.ValorPIS    = t.ValorPIS and
                          w.ValorCofins = t.ValorCofins and
                          w.ValorCSLL   = t.ValorCSLL and
                          w.Servico     = t.Servico
     left outer join
    ( select  
        te.ValorICMS,
        te.ValorIPI,
        te.ValorIRRF,
        te.ValorINSS,
        te.ValorISS,
        te.ValorPIS,
        te.ValorCofins,
        te.ValorCSLL,
        te.Servico,
        min(te.cd_chave) as cd_chave_minima
      from
        #Teste2 te
      group by 
        te.ValorICMS,
        te.ValorIPI,
        te.ValorIRRF,
        te.ValorINSS,
        te.ValorISS,
        te.ValorPIS,
        te.ValorCofins,
        te.ValorCSLL,
        te.Servico ) z on z.ValorICMS   = t.ValorICMS and
                          z.ValorIPI    = t.ValorIPI and
                          z.ValorIRRF   = t.ValorIRRF and 
                          z.ValorINSS   = t.ValorINSS and
                          z.ValorISS    = t.ValorISS  and
                          z.ValorPIS    = t.ValorPIS and
                          z.ValorCofins = t.ValorCofins and
                          z.ValorCSLL   = t.ValorCSLL and
                          z.Servico     = t.Servico



end
-------------------------------------------------------------------------------
else if  @ic_parametro = 3 --Contabilização Analitíco por Conta individual
-------------------------------------------------------------------------------
begin

  ------------------------------------------------
  -- Traz Notas de Saída com conta
  ------------------------------------------------
		
  -- Foi criada esta tabela para agrupara os valores sem a necessidade de uma 
  -- restruturação da lógica empregada nos outros procedimentos

  -- Passo a Utilizar o campo do lançamento padrão 
  -- e os demais campos, diretamente da Nota Fiscal
  -- Utilizado o max para permitir o agrupamento quando existe mais do
  -- que um registro no nota_Entrada_Contabil - ELIAS 15/07/2004  

  -- TODOS OS VALORES DE IRRF, INSS E ISS
  select
    min(nec.cd_lancamento_padrao) as cd_lancamento_padrao,
    min(lp.cd_conta_credito) as cd_conta_credito,   
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada as dt_contab_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia as nm_fantasia_fornecedor,
    ne.cd_operacao_fiscal,
    cast(null as decimal(25,2))                         as vl_contab_nota_entrada,
    cast(null as decimal(25,2))                         as vl_ipi_nota_entrada,
    cast(null as decimal(25,2))                         as vl_icms_nota_entrada,
    round(isnull(max(ne.vl_irrf_nota_entrada),0),2) 	as vl_irrf_nota_entrada,
    round(isnull(max(ne.vl_inss_nota_entrada),0),2)     as vl_inss_nota_entrada,
    case when (isnull(max(ne.ic_reter_iss),'N')='S') then
      round(isnull(max(ne.vl_iss_nota_entrada),0),2)                             
    else 0 end                                          as vl_iss_nota_entrada,
    round(isnull(max(ne.vl_pis_nota_entrada),0),2)      as vl_pis_nota_entrada,
    round(isnull(max(ne.vl_cofins_nota_entrada),0),2)   as vl_cofins_nota_entrada,
    round(isnull(max(ne.vl_csll_nota_entrada),0),2)     as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')             as ic_provisao_nota_entrada
  into
    #Nota_Contabil_IRRF_Individual
  from
    Nota_Entrada_Contabil nec with(nolock)
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne with(nolock)
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
    Lancamento_Padrao lp with(nolock)
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao --and
--    lp.cd_tipo_contabilizacao = 1  -- NOTA FISCAL
  where
    ((isnull(ne.vl_irrf_nota_entrada,0) <> 0) or
    (isnull(ne.vl_inss_nota_entrada,0) <> 0) or
    ((case when (isnull(ne.ic_reter_iss,'N')='S') then
      isnull(ne.vl_iss_nota_entrada,0)
      else 0 end) <> 0) or
    (isnull(ne.vl_pis_nota_entrada,0) <> 0) or
    (isnull(ne.vl_cofins_nota_entrada,0) <> 0) or
    (isnull(ne.vl_csll_nota_entrada,0) <> 0)) and
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
    (isnull(nec.cd_lancamento_padrao,0)<>0) and
    lp.cd_conta_plano = @cd_conta
  group by
    --nec.cd_lancamento_padrao,
    --lp.cd_conta_credito,  
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia,
    ne.cd_operacao_fiscal,
    ne.ic_provisao_nota_entrada
  order by
    ne.cd_nota_entrada

  -- TODOS OS VALORES CONTABEIS, IPI E ICMS
  -- Neste trecho é necessário buscar a conta crédito de cada registro
  -- pois diferente do que é feito no trexo acima, aqui não é filtrado
  -- pelo tipo de lancamento = NOTA FISCAL
  select 
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada as dt_contab_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia as nm_fantasia_fornecedor,
    ne.cd_operacao_fiscal,
    sum(round(isnull(nec.vl_contab_nota_entrada,0),2)) as vl_contab_nota_entrada,
    sum(round(isnull(nec.vl_ipi_nota_entrada,0),2))    as vl_ipi_nota_entrada,
    sum(round(isnull(nec.vl_icms_nota_entrada,0),2))   as vl_icms_nota_entrada,
    cast(null as decimal(25,2))                        as vl_irrf_nota_entrada,
    cast(null as decimal(25,2))                        as vl_inss_nota_entrada,
    cast(null as decimal(25,2))                        as vl_iss_nota_entrada,
    cast(null as decimal(25,2))                        as vl_pis_nota_entrada,
    cast(null as decimal(25,2))                        as vl_cofins_nota_entrada,
    cast(null as decimal(25,2))                        as vl_csll_nota_entrada,
    -- ELIAS 04/08/2005
    isnull(ne.ic_provisao_nota_entrada,'N')            as ic_provisao_nota_entrada
  into	
    #ContabilRazaoComContaBaseIndividual
  from
    Nota_Entrada_Contabil nec with(nolock)
  left outer join 
    Nota_Entrada_Registro ner with(nolock)
  on
    ner.cd_nota_entrada = nec.cd_nota_entrada and
    ner.cd_fornecedor = nec.cd_fornecedor and
    ner.cd_operacao_fiscal = nec.cd_operacao_fiscal and
    ner.cd_serie_nota_fiscal = nec.cd_serie_nota_fiscal
  left outer join 
    Nota_Entrada ne with(nolock)
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
    Lancamento_Padrao lp with(nolock)
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  where
    ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
    (isnull(nec.cd_lancamento_padrao,0)<>0) and
    lp.cd_conta_plano = @cd_conta
  group by
    nec.cd_lancamento_padrao,
    nec.cd_conta_credito,
    ne.cd_nota_entrada,
    ne.dt_receb_nota_entrada,
    ne.dt_nota_entrada,
    ner.cd_rem,
    ne.cd_fornecedor,
    vw.nm_fantasia,
    ne.cd_operacao_fiscal,
    ne.ic_provisao_nota_entrada
  order by
    ne.cd_nota_entrada

  update 
    #ContabilRazaoComContaBaseIndividual
  set
    vl_irrf_nota_entrada = ne.vl_irrf_nota_entrada,
    vl_inss_nota_entrada = ne.vl_inss_nota_entrada,
    vl_iss_nota_entrada  = ne.vl_iss_nota_entrada,
    vl_pis_nota_entrada  = ne.vl_pis_nota_entrada,
    vl_cofins_nota_entrada = ne.vl_cofins_nota_entrada,
    vl_csll_nota_entrada  = ne.vl_csll_nota_entrada
  from
    #Nota_Contabil_IRRF_Individual ne,
    #ContabilRazaoComContaBaseIndividual c
  where
    ne.cd_nota_entrada      = c.cd_nota_entrada and
    ne.cd_lancamento_padrao = c.cd_lancamento_padrao and
    ne.cd_conta_credito     = c.cd_conta_credito 

  select 
    distinct
    -- NOME DA CONTA
    cast('- '+(select nm_conta from Plano_conta with(nolock)
               where cd_conta = (select top 1 cd_conta_debito from Lancamento_Padrao with(nolock)
                                 where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                               from Lancamento_Padrao lanc with(nolock)
                                                               where cd_conta_plano = lp.cd_conta_plano and
                                                                     cd_tipo_contabilizacao = 1 and
                                                                     ic_tipo_operacao = 'E') and
                                       ic_tipo_operacao = 'E') and
                     cd_empresa = dbo.fn_empresa()) as varchar(40)) as 'Nome_Lancamento_Padrao',

    -- MÁSCARA DA CONTA
    cast((Select cd_mascara_conta from Plano_conta with(nolock)
          where cd_conta = (Select top 1 cd_conta_debito from Lancamento_Padrao with(nolock)
                            where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                          from Lancamento_Padrao lanc with(nolock)
                                                          where cd_conta_plano = lp.cd_conta_plano and
                                                                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                cd_empresa = dbo.fn_empresa()) as varchar(20)) as 'Mascara_Lancamento_Padrao',

    -- REDUZIDO DÉBITO
    cast((Select cd_conta_reduzido from Plano_conta with(nolock)
          where cd_conta = (Select top 1 cd_conta_debito from Lancamento_Padrao with(nolock)
                            where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                          from Lancamento_Padrao lanc with(nolock)
                                                          where cd_conta_plano = lp.cd_conta_plano and
                                                                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Lancamento_Padrao',

    -- Código reduzido da conta crédito 
    cast((Select cd_conta_reduzido from Plano_conta with(nolock)
          where cd_conta = (Select top 1 cd_conta_credito from Lancamento_Padrao with(nolock)
                   			    where cd_lancamento_padrao = (select top 1 lanc.cd_lancamento_padrao
                                                          from Lancamento_Padrao lanc with(nolock)
                                                          where cd_conta_plano = lp.cd_conta_plano and
                                                                cd_tipo_contabilizacao = 1 and
                                                                ic_tipo_operacao = 'E') and
                                  ic_tipo_operacao = 'E') and
                                  cd_empresa = dbo.fn_empresa()) as varchar(10)) as 'Reduzido_Credito',

    isNull(lp.cd_conta_plano,0)		                         as 'cd_conta_plano',
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
    cast(round(isnull(nec.vl_contab_nota_entrada,0),2) as decimal(25,2)) as 'ValorTotal',
    cast(round(isnull(nec.vl_icms_nota_entrada,0),2) as decimal(25,2))   as 'ValorICMS',
    cast(round(isnull(nec.vl_ipi_nota_entrada,0),2) as decimal(25,2))    as 'ValorIPI',
    cast(round(isnull(nec.vl_irrf_nota_entrada,0),2) as decimal(25,2))	 as 'ValorIRRF',
    cast(round(isnull(nec.vl_inss_nota_entrada,0),2) as decimal(25,2))   as 'ValorINSS',
    cast(round(isnull(nec.vl_iss_nota_entrada,0),2) as decimal(25,2)) 	 as 'ValorISS',
    cast(round(isnull(nec.vl_pis_nota_entrada,0),2) as decimal(25,2))	 as 'ValorPIS',
    cast(round(isnull(nec.vl_cofins_nota_entrada,0),2) as decimal(25,2)) as 'ValorCOFINS',
    cast(round(isnull(nec.vl_csll_nota_entrada,0),2) as decimal(25,2)) 	 as 'ValorCSLL',
    nec.ic_provisao_nota_entrada                                         as 'Provisao'
  into
    #ContabilRazaoComContaIndividual
  from
    #ContabilRazaoComContaBaseIndividual nec
  inner join 
    Lancamento_Padrao lp with(nolock) 
  on
    nec.cd_lancamento_padrao = lp.cd_lancamento_padrao
  left outer join 
    Tipo_Contabilizacao t with(nolock)
  on
    lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao
  left outer join 
    Operacao_Fiscal opf with(nolock)
  on
    opf.cd_operacao_fiscal = nec.cd_operacao_fiscal
  where not (isnull(nec.vl_contab_nota_entrada,0) = 0 and
             isnull(nec.vl_icms_nota_entrada,0) = 0 and
             isnull(nec.vl_ipi_nota_entrada,0) = 0 and
             isnull(nec.vl_irrf_nota_entrada,0) = 0 and
             isnull(nec.vl_inss_nota_entrada,0) = 0 and
             isnull(nec.vl_iss_nota_entrada,0) = 0 and
             isnull(nec.vl_pis_nota_entrada,0) = 0 and
             isnull(nec.vl_cofins_nota_entrada,0) = 0 and
             isnull(nec.vl_csll_nota_entrada,0) = 0)
	
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
    sum(isNull(ValorISS,0))   as ValorISS,
    sum(isNull(ValorPIS,0))   as ValorPIS,
    sum(isNull(ValorCOFINS,0))as ValorCOFINS,
    sum(isNull(ValorCSLL,0))  as ValorCSLL,
    Provisao
  into 
    #ContabilIndividual
  from	
    #ContabilRazaoComContaIndividual 
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
    Provisao
 		
  --Define o nome do lancamento em função da contabilização da CFOP
  Update	
    #ContabilIndividual
  set	
    Nome_Lancamento_Padrao = Left(Operacao_Fiscal_Nome,28),
    Mascara_Lancamento_Padrao = ' CFOP: ' + left(Operacao_Fiscal_Mascara,15)
  where	
    IsNull(Nome_Lancamento_Padrao,'') = ''		

  Select
    identity(int,1,1) as 'cd_chave',
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
    case when Provisao = 'S' then
      sum(isnull(ValorTotal,0) -
          (isnull(ValorIRRF,0) +
           isnull(ValorINSS,0) +
           isnull(ValorISS,0) +
           isnull(ValorPIS,0) +
           isnull(ValorCOFINS,0) +
           isnull(ValorCSLL,0)))
    else sum(IsNull(ValorTotal,0)) end as ValorTotal,
    sum(IsNull(ValorICMS,0))  as ValorICMS,
    sum(isNull(ValorIPI,0))   as ValorIPI,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorIRRF,0))  end as ValorIRRF,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorINSS,0))  end as ValorINSS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorISS,0))   end as ValorISS,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorPIS,0))   end as vl_pis_nota_entrada,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorCOFINS,0)) end as vl_cofins_nota_entrada,
    case when Provisao = 'S' then 0 else 
    sum(isNull(ValorCSLL,0))  end as vl_csll_nota_entrada,
    Provisao
  into #Individual
  from 
    #ContabilIndividual
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
    Provisao
  order by 
    Servico,
    Mascara_Lancamento_Padrao, 
    DataEmissao, 
    Documento

  Select
--    Nome_Lancamento_Padrao as NomeConta, 
--    Mascara_Lancamento_Padrao as ClassificacaoConta,
    t.Reduzido_Lancamento_Padrao as Conta,   
--    Reduzido_Credito as Contrapartida,
    t.Documento,
    Fornecedor,
    DataContabilizacao as Data,
--    DataEmissao as Emissao,
--    Operacao_Fiscal as CFOP,
    ValorTotal --,
--    case when t.cd_chave <> w.cd_chave_minima then
--      0 else ValorICMS end as ValorICMS,
--    case when t.cd_chave <> w.cd_chave_minima then
--      0 else ValorIPI end as ValorIPI
  from #Individual t left outer join
    ( select  
        te.Documento,
        te.Reduzido_Lancamento_Padrao,
        min(te.cd_chave) as cd_chave_minima
      from
        #Individual te
      group by 
        te.Documento,
        te.Reduzido_Lancamento_Padrao ) w on w.Documento = t.Documento and
                                             w.Reduzido_Lancamento_Padrao = t.Reduzido_Lancamento_Padrao
  order by 
    t.DataContabilizacao, 
    t.Documento
   
end

