
create VIEW vw_exporta_saida_contmatic  
------------------------------------------------------------------------------------  
--vw_exporta_saida_contmatic  
------------------------------------------------------------------------------------  
--GBS - Global Business Solution                                        2004  
------------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)             : Carlos Fernandes   
--Banco de Dados : EGISSQL   
--Objetivo         : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao  
--                        sistema da Pharma Special  
--Data                  : 19.03.2006  
--Atualização           : 13.04.2006 - Alteracao Para o padrao da Pic - Danilo  
--                      : 13.04.2006 - Acerto da Exportação para número com Zero a Esquerda - Carlos Fernandes  
--                      : 15.04.2006 - Revisão Geral - Carlos Fernandes  
--                        17.08.2007 - Acerto nas Bases de Cálculo - Carlos Fernandes.  
--                        01.11.2007 - Verificação da Duplicidade do IPI (JR - Pharma) - Carlos Fernandes  
-- 16.06.2009 - Consistência
              --Base ICMS + IPI + Isento IPI + Outras de IPI + ICMS na Fonte - Desconto = Valor Contábil
-- 18.08.2009 --Código Contábil do Fornecedor - Carlos Fernandes
-- 05.10.2009 --Ajustes Diversos - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------  
as  
    
--select * from nota_saida  
  
--select cd_mascara_operacao,* from nota_saida  where cd_nota_saida = 144
--select * from serie_nota_fiscal
  
select    
  distinct

  ns.cd_nota_saida,  
  ns.dt_nota_saida,   
  
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
--  'NFF'                                          as SERIE,   
  cast(dbo.fn_strzero(snf.qt_serie_nota_fiscal,2) as char(03)) as SERIE, 

  ns.cd_nota_saida                               as NUM_NOTA_INICIAL,  
  ns.cd_nota_saida                               as NUM_NOTA_FINAL,  
--  ns.cd_mascara_operacao                         as NATUREZA,  
  opf.cd_mascara_operacao                        as NATUREZA,
  
--   substring(ns.cd_mascara_operacao,1,1)+  
--   substring(ns.cd_mascara_operacao,3,3)+  
--   '0'                                           as NATUREZA,  
-- 'I'                                         as TIPO,  
  --cast(null                  as decimal(10,2))    as ALIQ_ICMS_1,  

  --select * from nota_saida_registro where cd_nota_saida = 20
  
  --Valor Total da Nota

  cast( round(case when isnull(nsr.vl_total_nota_saida,0)<>ns.vl_total and isnull(nsr.vl_total_nota_saida,0)>0 then
     nsr.vl_total_nota_saida + 
     case when isnull(ic_subst_tributaria,'N')='S'
     then
       isnull(vl_icms_subs_nota_saida,0)
     else
       0.00
     end
  else
     isnull(ns.vl_total,0.00) 
  end,2) as decimal(10,2))                          as VALOR_CONTABIL,  

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

  --select * from nota_saida
  
  dp.nm_destinacao_produto,

  round(ns.vl_total,2) -

  ( round(isnull(ns.vl_bc_icms,0),2) 

  --select * from destinacao_produto
  +
  case when ns.cd_destinacao_produto = 2 --Uso Próprio
  then
    round(isnull(ns.vl_ipi,0) + isnull(ns.vl_ipi_outros,0) + isnull(ns.vl_icms,0),2)
  else
    round(isnull(ns.vl_ipi,0),2)
  end
  - round( isnull(ns.vl_desconto_nota_saida,0.00),2))                   as VALOR_CONSISTENCIA,


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

  case when ns.cd_mascara_operacao = '5.405' or ns.cd_mascara_operacao = '6.405' then
    0.00
  else
   round(case when isnull(nsr.vl_icms_isento_nota_saida,0)>0 then
       nsr.vl_icms_isento_nota_saida
    else
      isnull(ns.vl_icms_isento,0.00)     
    end,2)

  end                                                                   as ISENTAS_ICMS_1,    

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
  
  round(isnull(isnull(nsr.vl_base_ipi_nota_saida,ns.vl_bc_ipi),0.00),2)       as BASE_IPI,  
  round(isnull(isnull(nsr.vl_ipi_nota_saida,ns.vl_ipi),0.00),2)               as IPI,    
  round(isnull(isnull(nsr.vl_ipi_isento_nota_saida,ns.vl_ipi_isento),0.00),2) as ISENTAS_IPI,  
  round(isnull(isnull(nsr.vl_ipi_outras_nota_saida,ns.vl_ipi_outros),0.00),2) as OUTRAS_IPI,  
  
  cast(0.00                 as float )                                        as IPI_NAO_APRO,  
  
  --round(isnull(ns.vl_icms_subst,0.00),2)                                      as ICMS_FONTE,  

  --select vl_icms_subst,* from nota_saida where cd_nota_saida = 20
  --select * from nota_saida_registro where cd_nota_saida = 20
  --select * from nota_saida_item_registro where cd_nota_saida = 20
  --round(isnull(isnull(nsr.vl_ipi_outras_nota_saida,ns.vl_ipi_outros),0.00),2)

  round(case when isnull(nsr.vl_base_icms_subs_n_saida,0)>0 then
    case when isnull(nsr.vl_icms_subs_nota_saida,0.00) < 0 then
      0.00
    else
      isnull(nsr.vl_icms_subs_nota_saida,0.00)
    end
  else
    --case when isnull(ns.vl_icms_subst,0)<0 then
      0.00 
    --else
      --isnull(ns.vl_icms_subst,0)
    --end
  end,2)                                                                      as ICMS_FONTE,

--  isnull(nsr.vl_base_icms_subs_n_saida,0)                                     as BASE_ICMS_SUBSTITUICAO,  
  case when nsr.vl_base_icms_subs_n_saida>0 then
     isnull(nsr.vl_base_icms_subs_n_saida,0)                               
  else
     0.00
  end                                                                          as DESCONTONF,  

--  round(isnull(ns.vl_desconto_nota_saida,0.00),2)                             as DESCONTONF,  
  
  --Dados do Pagamento  
  
  --A Vista  
  
  case when cp.qt_parcela_condicao_pgto<2  
       then  
         isnull(ns.vl_total,0.00)   
       else   
         cast(0.00                 as float)   end  as VLRVISTA,  
  
  --A Prazo  
  
  case when cp.qt_parcela_condicao_pgto>1  
       then  
         isnull(ns.vl_total,0.00)   
       else   
         cast(0.00                 as float)   end  as VLRPRAZO,  
  
  cast(0.00                 as float)               as ISENTO_PIS,   
  
  case when cd_status_nota = 7   
       then '99'  
       else '00' end                                as TIPONOTA,  
  
  case when isnull(c.ic_contrib_icms_cliente,'S')='S'   
       then '0'  
       else '1' end                                 as CONTRIBUINTE,  
  
  --cast(isnull(pc.cd_conta_reduzido,0)      as int)         as COD_CONTAB,  
  cast('00'                         as char(02))    as COD_CONTAB,
  cast(' '                          as char(14))    as OBSLIVRE,  
  cast(ns.cd_cnpj_nota_saida        as char(14))    as CGC_CPF,   
  cast(ns.cd_inscest_nota_saida     as char(16))    as INSCESTADUAL,  
  cast(ns.nm_razao_social_nota      as char(35))    as RAZAO,  
  --cast(null                         as varchar(18)) as CTACTBL,       
  cast(isnull(pc.cd_conta_reduzido,' ') as  char(18)) as CTACTBL,
  ns.sg_estado_nota_saida                            as UF,  
  cast('0000'                       as char(4))      as NUNMUNICP,    
  '000000000000'                                     as desconto,  
  '000000000000'                                     as pvv,  
  cast(' '                          as char(21))     as VAGO,
  opf.cd_operacao_fiscal,
  opf.cd_grupo_operacao_fiscal, 
  gof.cd_tipo_operacao_fiscal,
  opf.cd_mascara_operacao,
  isnull(ns.vl_total,0.00)         as vl_total,
  nsr.vl_total_nota_saida,
  isnull(vl_icms_subs_nota_saida,0) as vl_icms_subs_nota_saida


    

    
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

--select * from nota_saida_registro where cd_nota_saida = 20
  
from  
  Nota_Saida ns                             with(nolock)  

  left outer join Nota_Saida_Registro nsr   with (nolock)  on nsr.cd_nota_saida              = ns.cd_nota_saida   and
                                                              nsr.cd_operacao_fiscal = case when isnull(nsr.cd_operacao_fiscal,0)>0 then
                                                                nsr.cd_operacao_fiscal
                                                              else
                                                                ns.cd_operacao_fiscal
                                                              end

  left outer join Cliente c                 with (nolock)  on c.cd_cliente                   = ns.cd_cliente  
  left outer join Condicao_Pagamento cp     with (nolock)  on cp.cd_condicao_pagamento       = ns.cd_condicao_pagamento  
  left outer join Operacao_Fiscal opf       with (nolock)  on opf.cd_operacao_fiscal         = 
                                                              case when isnull(nsr.cd_operacao_fiscal,0)>0 then
                                                                nsr.cd_operacao_fiscal
                                                              else
                                                                ns.cd_operacao_fiscal
                                                              end

  left outer join Grupo_Operacao_Fiscal gof with (nolock)  on gof.cd_grupo_operacao_fiscal   = opf.cd_grupo_operacao_fiscal 
  left outer join Destinacao_Produto dp     with (nolock)  on dp.cd_destinacao_produto       = ns.cd_destinacao_produto
  left outer join Plano_Conta pc            with (nolock)  on pc.cd_conta                    = c.cd_conta
  left outer join Serie_Nota_Fiscal snf     with (nolock)  on snf.cd_serie_nota_fiscal       = ns.cd_serie_nota
  
where
  gof.cd_tipo_operacao_fiscal = 2 --SAÍDAS
  and
  ns.cd_nota_saida in ( select cd_nota_saida from vw_faturamento vw with (nolock) 
                        where 
                          vw.ic_imposto_tipo_pedido = 'S'
                          and
                          vw.cd_nota_saida = ns.cd_nota_saida 
                       )


