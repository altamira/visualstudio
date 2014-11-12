
CREATE VIEW vw_exporta_entrada_contmatic
----------------------------------------------------------------------------------------------------------------
--vw_exporta_entrada_contmatic
----------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
----------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes 
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Pharma Special
--Data                  : 19.03.2006
--Atualização           : 13.04.2006 - Alteracao Para o padrao da Pic - Danilo
--                      : 13.04.2006 - Acerto da Exportação para número com Zero a Esquerda - Carlos Fernandes
--                      : 15.04.2006 - Acertos Diversos - Carlos Fernades
--                      : 31.03.2007 - Verificação - Carlos Fernandes
--                      : 28.08.2007 - Acerto da Série da Nota Fiscal - Carlos Fernandes
-- 27.05.2009 - Filtro por Tipo de Entrada conforme a Operação Fiscal
-- 27.05.2009 - Entrada de Notas no Faturamento - Importação - Carlos Fernandes
-- 20.07.2009 - Série da Nota fiscal - Carlos Fernandes 
-- 20.08.2009 - Verificação da Nota de Entrada de Importação - Carlos Fernandes
-- 16.10.2009 - Ajustes - Carlos Fernandes
-- 10.12.2009 - Ajuste de conversão não pode existir float p/ float - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------
as
  

--select * from nota_entrada

select  
  ne.cd_nota_entrada,
  ne.dt_nota_entrada, 
  ne.dt_receb_nota_entrada,

  'R1'                                               as TIPOREGISTRO,

  --dbo.fn_strzero(day(ne.dt_nota_entrada),2) + 
  --dbo.fn_strzero(month(ne.dt_nota_entrada),2)      as DDMMNF, 
  dbo.fn_strzero(day(ne.dt_receb_nota_entrada),2) + 
  dbo.fn_strzero(month(ne.dt_receb_nota_entrada),2)  as DDMMNF, 

  --Verifica a Data de Entrada--------------------------------------------------------------------------

  case when ne.dt_receb_nota_entrada is null 
  then
       dbo.fn_strzero(day(ne.dt_nota_entrada),2) + 
       dbo.fn_strzero(month(ne.dt_nota_entrada),2) 
  else
       dbo.fn_strzero(day(ne.dt_receb_nota_entrada),2) + 
       dbo.fn_strzero(month(ne.dt_receb_nota_entrada),2) 
  end                                            as DDMMESNF,

  '00'                                           as DIAINTEGRACAO,

  ne.nm_especie_nota_entrada                     as ESPECIE,
  --ne.nm_serie_nota_entrada                       as SERIE, 
  dbo.fn_strzero(cast(snf.qt_serie_nota_fiscal as char(03)),3)     as SERIE, 

  --cast('000' as varchar(03))                     as SERIE,
  ne.cd_nota_entrada                             as NUM_NOTA_INICIAL,
  ne.cd_nota_entrada                             as NUM_NOTA_FINAL,
  opf.cd_mascara_operacao                        as NATUREZA,

  cast(ne.vl_total_nota_entrada as decimal(10,2))  as VALOR_CONTABIL,
  cast(ne.vl_bicms_nota_entrada as decimal(10,2))  as BASE_ICMS_1,

  --cast(0 as float )                              as ALIQ_ICMS_1,
  isnull(nr.pc_icms_reg_nota_entrada,0)                                  as ALIQ_ICMS_1,

  ne.vl_icms_nota_entrada                                                as ICMS_1,
  cast(isnull(nr.vl_icmsisen_reg_nota_entr,0)    as decimal(10,2))         as ISENTAS_ICMS_1,  
  cast(isnull(nr.vl_icmsoutr_reg_nota_entr,0)    as decimal(10,2))         as OUTRAS_ICMS_1,

  cast(0                 as decimal(10,2))         as BASE_ICMS_2,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_2,   
  cast(0                 as decimal(10,2))         as ICMS_2,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_2,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_2,

  cast(0                 as decimal(10,2))         as BASE_ICMS_3,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_3,   
  cast(0                 as decimal(10,2))         as ICMS_3,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_3,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_3,

  cast(0                 as decimal(10,2))         as BASE_ICMS_4,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_4,   
  cast(0                 as decimal(10,2))         as ICMS_4,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_4,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_4,

  cast(0                 as decimal(10,2))         as BASE_ICMS_5,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_5,   
  cast(0                 as decimal(10,2))         as ICMS_5,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_5,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_5,

  isnull(nr.vl_bipi_reg_nota_entrada,ne.vl_bipi_nota_entrada)         as BASE_IPI,
  isnull(nr.vl_ipi_reg_nota_entrada ,ne.vl_ipi_nota_entrada)          as IPI,  

  cast(isnull(nr.vl_ipiisen_reg_nota_entr,0)
  *
  case when isnull(nr.vl_ipiisen_reg_nota_entr,0)>0 then 1 else -1 end   as decimal(10,2))         as ISENTAS_IPI,

  cast(isnull(nr.vl_ipioutr_reg_nota_entr,0) 
  *
  case when isnull(nr.vl_ipioutr_reg_nota_entr,0)>0 then 1 else -1 end   as decimal(10,2))         as OUTRAS_IPI,

  cast(0                 as float )              as IPI_NAO_APRO,

  cast(0                 as decimal(10,2))         as ICMS_FONTE,
  cast(0                 as decimal(10,2))         as DESCONTONF,

  --Dados do Pagamento

  --A Vista

  case when cp.qt_parcela_condicao_pgto<2
       then
         ne.vl_total_nota_entrada 
       else 
         cast(0                 as float)   end  as VLRVISTA,

  --A Prazo

  case when cp.qt_parcela_condicao_pgto>1
       then
         ne.vl_total_nota_entrada 
       else 
         cast(0                 as float)   end      as VLRPRAZO,

  cast(0                 as float)                   as ISENTO_PIS, 

  '00'                                               as TIPONOTA,

  '0'                                                as CONTRIBUINTE,

  cast('00'                         as char(2))      as COD_CONTAB,
  cast(''                           as char(14))     as OBSLIVRE,
--   cast(f.cd_cnpj_fornecedor         as char(14))     as CGC_CPF, 
--   cast(f.cd_inscEstadual            as char(14))     as INSCESTADUAL,
--   cast(ne.nm_razao_social           as char(35))     as RAZAO,

  cast(vw.cd_cnpj                   as char(14))     as CGC_CPF, 
  cast(vw.cd_inscEstadual           as char(14))     as INSCESTADUAL,
  cast(vw.nm_razao_social           as char(35))     as RAZAO,

  --cast(null                         as varchar(18))  as CTACTBL,     
  cast(pc.cd_conta_reduzido as char(18))             as CTACTBL,
  ne.sg_estado                      as UF,
  cast(0                            as char(4))       as NUNMUNICP,  
  cast(null                         as char(50))      as VAGO,
  '000000000000'                                      as desconto,  
  '000000000000'                                      as pvv,
  ne.cd_destinacao_produto,
  ne.cd_fornecedor,
  ne.cd_operacao_fiscal 


from
  Nota_Entrada ne                               with (nolock)
  left outer join Operacao_Fiscal opf           with (nolock) on opf.cd_operacao_fiscal   = ne.cd_operacao_fiscal
  left outer join Fornecedor f                  with (nolock) on f.cd_fornecedor          = ne.cd_fornecedor
  left outer join Condicao_Pagamento cp         with (nolock) on cp.cd_condicao_pagamento = ne.cd_condicao_pagamento

  left outer join Nota_Entrada_Item_Registro nr with (nolock) on nr.cd_nota_entrada       = ne.cd_nota_entrada      and
                                                                 nr.cd_fornecedor         = ne.cd_fornecedor        and
                                                                 nr.cd_operacao_fiscal    = ne.cd_operacao_fiscal   and
                                                                 nr.cd_serie_nota_fiscal  = ne.cd_serie_nota_fiscal 
 	
  left outer join Grupo_Operacao_Fiscal gof     with (nolock) on gof.cd_grupo_operacao_fiscal   = opf.cd_grupo_operacao_fiscal 

  left outer join Plano_Conta pc                with (nolock) on pc.cd_conta                    = f.cd_conta
  left outer join Serie_Nota_Fiscal snf         with (nolock) on snf.cd_serie_nota_fiscal       = ne.cd_serie_nota_fiscal
  left outer join vw_destinatario vw            with (nolock) on vw.cd_destinatario             = ne.cd_fornecedor and
                                                                 vw.cd_tipo_destinatario         = ne.cd_tipo_destinatario

--select * from vw_destinatario

where
  gof.cd_tipo_operacao_fiscal = 1 --ENTRADA
  and isnull(vl_cont_reg_nota_entrada,0)>0

union

select  
--   ne.cd_nota_entrada,
--   ne.dt_nota_entrada, 
--   ne.dt_receb_nota_entrada,

  ns.cd_nota_saida                               as cd_nota_entrada,
  ns.dt_nota_saida                               as dt_nota_entrada,  
  ns.dt_nota_saida                               as dt_receb_nota_entrada,  

  'R1'                                           as TIPOREGISTRO,

  dbo.fn_strzero(day(ns.dt_nota_saida),2) + 
  dbo.fn_strzero(month(ns.dt_nota_saida),2)      as DDMMNF, 

  --Verifica a Data de Saída

  --Antes com Data de Saída

--   case when ns.dt_saida_nota_saida is null 
--   then
--        dbo.fn_strzero(day(ns.dt_nota_saida),2) + 
--        dbo.fn_strzero(month(ns.dt_nota_saida),2) 
--   else
--        dbo.fn_strzero(day(ns.dt_saida_nota_saida),2) + 
--        dbo.fn_strzero(month(ns.dt_saida_nota_saida),2) 
--   end                                            as DDMMESNF,

  --Somente a Data de Emissão

  dbo.fn_strzero(day(ns.dt_nota_saida),2) + 
       dbo.fn_strzero(month(ns.dt_nota_saida),2) as DDMMESNF,

  '00'                                           as DIAINTEGRACAO,

  'NFE'                                          as ESPECIE,
--  'NFE'                                          as SERIE, 
  dbo.fn_strzero(cast(snf.qt_serie_nota_fiscal as char(03)),3)     as SERIE, 

  ns.cd_nota_saida                               as NUM_NOTA_INICIAL,
  ns.cd_nota_saida                               as NUM_NOTA_FINAL,
  ns.cd_mascara_operacao                         as NATUREZA,

--   substring(ns.cd_mascara_operacao,1,1)+
--   substring(ns.cd_mascara_operacao,3,3)+
--   '0'                                           as NATUREZA,
-- 'I'                                         as TIPO,
  --cast(null                  as decimal(10,2))    as ALIQ_ICMS_1,

--Antes
   cast(ns.vl_total           as decimal(10,2))    as VALOR_CONTABIL,

--   cast(ns.vl_bc_icms         as decimal(10,2))    as BASE_ICMS_1,
-- 
--   (select top 1 isnull(pc_icms,0) 
--    from 
--      Nota_Saida_Item with (nolock)
--    where cd_nota_saida = ns.cd_nota_saida )      as ALIQ_ICMS_1,
-- 
--   isnull(ns.vl_icms,0)                           as ICMS_1,
--   ns.vl_icms_isento                              as ISENTAS_ICMS_1,  
--   ns.vl_icms_outros                              as OUTRAS_ICMS_1,

  --Valor Total da Nota
  --select * from nota_saida_registro where cd_nota_saida = 120

--   round(cast(case when isnull(nsr.vl_total_nota_saida,0)<>ns.vl_total and isnull(nsr.vl_total_nota_saida,0)>0 then
--      nsr.vl_total_nota_saida + isnull(vl_icms_subs_nota_saida,0)
--   else
--      isnull(ns.vl_total,0.00) 
--   end as decimal(10,2)),2)                          as VALOR_CONTABIL,  

  --Valor da Base do ICMS
  --select * from nota_saida_registro where cd_nota_saida = 141

  round(cast(
  case when isnull(nsr.vl_base_icms_nota_saida,0)>0 and nsr.vl_base_icms_nota_saida<>ns.vl_bc_icms then
       case when ns.cd_mascara_operacao = '5.405' or ns.cd_mascara_operacao = '6.405' then
         0.00
       else
         nsr.vl_base_icms_nota_saida
       end
  else
     case when ns.vl_bc_icms>0   then
       isnull(ns.vl_bc_icms,0.00)      
     else
       case when ns.cd_mascara_operacao = '5.405' or ns.cd_mascara_operacao = '6.405' then
         0.00
       else
          isnull(ns.vl_bc_subst_icms,0.00)       
       end
     end
  end as decimal(10,2)),2)   as BASE_ICMS_1,  

 
  --Alíquota de ICMS

--   (select top 1 isnull(pc_icms,0)   
--     from   
--       Nota_Saida_Item   
--     where cd_nota_saida = ns.cd_nota_saida )                            as ALIQ_ICMS_1,  

  case when isnull(nsr.pc_aliq_icms_nota_saida,0)>0 then
    nsr.pc_aliq_icms_nota_saida
  else
    (select top 1 isnull(pc_icms,0)   
    from   
      Nota_Saida_Item   
    where cd_nota_saida = ns.cd_nota_saida )               
   end                                                                  as ALIQ_ICMS_1,  
  
  --Valor do ICMS

  round(case when isnull(nsr.vl_icms_nota_saida,0)>0 then
    nsr.vl_icms_nota_saida
  else
    isnull(ns.vl_icms,0.00)
  end ,2)                                                               as ICMS_1,  

  --Valor do ICMS Isento

  round(case when isnull(nsr.vl_icms_isento_nota_saida,0)>0 then
       case when ns.cd_mascara_operacao = '5.405' or ns.cd_mascara_operacao = '6.405' then
         0.00
       else
         nsr.vl_icms_isento_nota_saida
       end
  else
    isnull(ns.vl_icms_isento,0.00)     
  end,2)                                                                   as ISENTAS_ICMS_1,    

  round(case when isnull(nsr.vl_icms_outras_nota_saida,0)>0 then
    nsr.vl_icms_outras_nota_saida
  else
    case when ns.cd_mascara_operacao = '5.405' or ns.cd_mascara_operacao = '6.405' then
      ns.vl_produto
    else  
      isnull(ns.vl_icms_outros,0.00)
    end
  end  ,2)                                                       as OUTRAS_ICMS_1,  


  cast(0                 as decimal(10,2))         as BASE_ICMS_2,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_2,   
  cast(0                 as decimal(10,2))         as ICMS_2,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_2,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_2,

  cast(0                 as decimal(10,2))         as BASE_ICMS_3,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_3,   
  cast(0                 as decimal(10,2))         as ICMS_3,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_3,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_3,

  cast(0                 as decimal(10,2))         as BASE_ICMS_4,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_4,   
  cast(0                 as decimal(10,2))         as ICMS_4,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_4,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_4,

  cast(0                 as decimal(10,2))         as BASE_ICMS_5,
  cast(0                 as decimal(10,2))         as ALIQ_ICMS_5,   
  cast(0                 as decimal(10,2))         as ICMS_5,
  cast(0                 as decimal(10,2))         as ISENTAS_ICMS_5,
  cast(0                 as decimal(10,2))         as OUTRAS_ICMS_5,

  --IPI
  --select * from nota_saida_registro where cd_nota_saida = 98308
  --ns.vl_bc_ipi                                   as BASE_IPI,

  case when isnull(ns.vl_produto,0)>0 then
    ns.vl_produto --+ isnull(ns.vl_desp_acess,0) + ns.vl_ipi
  else
    isnull(nsr.vl_base_ipi_nota_saida,ns.vl_bc_ipi) 
  end                                                   as BASE_IPI,

  case when isnull(ns.vl_ipi,0)>0 then
    ns.vl_ipi
  else
    isnull(nsr.vl_ipi_nota_saida,ns.vl_ipi)   
  end                                                   as IPI,  

  isnull(nsr.vl_ipi_isento_nota_saida,ns.vl_ipi_isento) as ISENTAS_IPI,

  --select * from nota_saida where cd_nota_saida = 50036

  case when isnull(ns.vl_desp_acess,0)>0 then
    isnull(ns.vl_desp_acess,0)
  else
    isnull(nsr.vl_ipi_outras_nota_saida,ns.vl_ipi_outros)
  end                                                   as OUTRAS_IPI,

  cast(0                 as float )                     as IPI_NAO_APRO,

  ns.vl_icms_subst                                      as ICMS_FONTE,
  ns.vl_desconto_nota_saida                             as DESCONTONF,

  --Dados do Pagamento

  --A Vista

  case when cp.qt_parcela_condicao_pgto<2
       then
         ns.vl_total 
       else 
         cast(0                 as float)   end  as VLRVISTA,

  --A Prazo

  case when cp.qt_parcela_condicao_pgto>1
       then
         ns.vl_total 
       else 
         cast(0                 as float)   end  as VLRPRAZO,

  cast(0                 as float)               as ISENTO_PIS, 

  case when cd_status_nota = 7 --Nota Cancelada
       then '99'
       else '02'               --Nota de Entrada de Importação

  end                                               as TIPONOTA,

  case when isnull(c.ic_contrib_icms_cliente,'S')='S' 
       then '0'
       else '1' end                                 as CONTRIBUINTE,

  cast('00'                         as char(2) )    as COD_CONTAB,
  cast(''                           as char(14))    as OBSLIVRE,
  cast(ns.cd_cnpj_nota_saida        as char(14))    as CGC_CPF, 
  cast(ns.cd_inscest_nota_saida     as char(14))    as INSCESTADUAL,
  cast(ns.nm_razao_social_nota      as char(35))    as RAZAO,
  cast(null                         as char(18))    as CTACTBL,     
  ns.sg_estado_nota_saida                           as UF,
  cast('0000'                       as char(4))     as NUNMUNICP,  
  cast(''                           as char(50))    as VAGO,  
  '000000000000'                                    as desconto,  
  '000000000000'                                    as pvv,
  ns.cd_destinacao_produto,
  ns.cd_cliente                                     as cd_fornecedor,
  ns.cd_operacao_fiscal
  
  -- cast(null                  as varchar(03))  as SERIE,
  --  ns.dt_nota_saida                            as DATA_DOCUMENTO,
  --case when ns.dt_saida_nota_saida is null 
  --     then ns.dt_nota_saida                  
  --     else ns.dt_saida_nota_saida end        as DATA_SAIDA_ENTRADA,   
  -- ns.vl_bc_icms                               as BASE_ICMS_1,
  --cast(null                 as float )        as BASE_ICMS_3,
  
  --cast(null                 as float )        as ALIQ_ICMS_3,
  
  
  --cast(null                 as float )        as ICMS_3,
  
  
  -- (select top 1 pc_ipi 
  --  from 
  --    Nota_Saida_Item 
  --  where cd_nota_saida = ns.cd_nota_saida )   as ALIQ_IPI,
  
 
  
  --  cast(null as varchar(80))                   as OBSERVACAO_DESCRICAO,
  --  cast(null as varchar(19))                   as OBSERVACAO_VALOR,
  --  '00'                                        as CONSTANTE,
  --  cast(null as int )                          as CODIGO_SERVICO,
  --  ns.vl_bc_subst_icms                         as BASE_ICMS_SUBSTITUICAO,
  --  case when ns.cd_status_nota = 7 
  --       then 'C'
  --       else 'N' end                           as SITUACAO_NOTA,
  --  '#13'                                       as FINAL_LINHA

from
  Nota_Saida ns                             with (nolock)
  left outer join Nota_Saida_Registro nsr   with (nolock)  on nsr.cd_nota_saida              = ns.cd_nota_saida
  left outer join Cliente c                 with (nolock)  on c.cd_cliente                   = ns.cd_cliente
  left outer join Fornecedor f              with (nolock)  on f.cd_fornecedor                = ns.cd_cliente
  left outer join Condicao_Pagamento cp     with (nolock)  on cp.cd_condicao_pagamento       = ns.cd_condicao_pagamento
  left outer join Operacao_Fiscal opf       with (nolock)  on opf.cd_operacao_fiscal         = ns.cd_operacao_fiscal
  left outer join Grupo_Operacao_Fiscal gof with (nolock)  on gof.cd_grupo_operacao_fiscal   = opf.cd_grupo_operacao_fiscal 
  left outer join Serie_Nota_fiscal snf     with (nolock)  on snf.cd_serie_nota_fiscal       = ns.cd_serie_nota

where
  gof.cd_tipo_operacao_fiscal = 1     --ENTRADAS NO FATURAMENTO



