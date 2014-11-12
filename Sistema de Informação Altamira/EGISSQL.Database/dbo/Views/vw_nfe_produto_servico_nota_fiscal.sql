
CREATE VIEW vw_nfe_produto_servico_nota_fiscal
------------------------------------------------------------------------------------ 
--sp_helptext vw_nfe_produto_servico_nota_fiscal
 ------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                        2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Detalhe Produto/Serviço da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 23.11.2008 - Ajustes Diversos - Carlos Fernandes
-- 29.11.2008 - Dados do IPI - Carlos Fernandes
-- 11.08.2009 - Ajustes Diversos - Carlos Fernandes
-- 11.09.2009 - Nota Fiscal de Complemento - Carlos Fernandes
-- 16.09.2009 - Auste dos Dados de importação - Carlos Fernandes 
-- 28.09.2009 - Ajuste da Alíquota PIS / COFINS - Carlos Fernandes
-- 30.11.2009 - Lote - Carlos Fernandes
-- 19.12.2009 - Ajuste dos (%) para SUBST. Tributária - Carlos Fernandes
-- 12.03.2010 - Ajuste do Valor do ICMS da Subst. Tributária - Carlos Fernandes
-- 03.05.2010 - Verificação BAse do ICMS ST - Carlos Fernandes
-- 17.06.2010 - Verificação da Tributação do IPI por Unidade - Carlos Fernandes
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
-- 17.11.2010 - Ajuste das casas decimais do valor do Frete - Carlos/Luis Santana
-- 07.12.2010 - Ajuste para Importação - Carlos Fernandes
-- 10.01.2011 - Código de Barra do Produto - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from nota_saida_item

select
  ns.cd_identificacao_nota_saida,
  ns.dt_nota_saida,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.cd_item_nota_saida                       as 'nItem',

  isnull(tme.ic_mov_tipo_movimento,'S')        as ic_mov_tipo_movimento,
  isnull(tipi.cd_digito_tributacao_ipi,'00')   as cd_digito_tributacao_ipi,
  isnull(ti.cd_digito_tributacao_icms,'00')    as cd_digito_tributacao_icms,
  isnull(tpis.cd_digito_tributacao_pis,'01')   as cd_digito_tributacao_pis,
  isnull(tci.cd_digito_tributacao_cofins,'01') as cd_digito_tributacao_cofins,

  case when isnull(nsi.cd_produto,0)=0 then
    'CFOP9999'
  else
    case when nsi.cd_mascara_produto is null then
      (select ppp.cd_mascara_produto from produto ppp where ppp.cd_produto = nsi.cd_produto)
    else
      nsi.cd_mascara_produto
    end
  end                                                                                                 as 'cProd',

  --select * from cd_barra_produto
  case when isnull(p.cd_codigo_barra_produto,'')<>'' then
    cast(p.cd_codigo_barra_produto as varchar(14))
  else
    cast('00000000000000' as varchar(14))	                                                     
  end                                                                                                 as 'cEan',

  cast( ltrim(rtrim(nsi.nm_produto_item_nota ))
  +
  case when isnull(pc.ic_nf_produto_cliente,'N')='S' and isnull(pc.nm_fantasia_prod_cliente,'')<>'' 
  then
    ' ('+ltrim(rtrim(pc.nm_fantasia_prod_cliente))+')'
  else
   ''
  end                                          

  +

  --Kardex digitado direto na Nota Fiscal
  case when isnull(pc.nm_fantasia_prod_cliente,'')='' and isnull(pc.nm_fantasia_prod_cliente,'')<>nsi.nm_kardex_item_nota_saida then
   ' ('+nsi.nm_kardex_item_nota_saida+')'
  else
    ''
  end

  --verifica o kardex do item da nota fiscal

  --Lote
  +
  case when isnull(nsi.cd_lote_item_nota_saida,'')<>'' then
    ' Lote: '+ltrim(rtrim(nsi.cd_lote_item_nota_saida))
  else
   ''
  end

  +

  --Pedido de Compra do Cliente
  --select * from nota_saida_item

  case when isnull(ic_pcd_serie_nota_fiscal,'N') = 'S' and isnull(nsi.cd_pd_compra_item_nota,'')<>''
  then
    ' '+rtrim(ltrim(isnull(nsi.cd_pd_compra_item_nota,'')))
  else
    ''
  end  as varchar(120))    

  + 

  case when isnull(p.cd_certificado_produto,'')<>'' then
    ' ('+ltrim(rtrim(p.cd_certificado_produto))+') '
  else
   ''
  end
                                                                                                         as 'xprod', 

  cast(
  case when isnull(nsi.cd_servico,0)<>0 then
    '99'
  else
    rtrim(ltrim(replace(cf.cd_mascara_classificacao,'.',''))) +   
    replicate('0',8 - len(rtrim(ltrim(replace(cf.cd_mascara_classificacao,'.','')))))
  end as varchar(8)) 
                                                                                                          as 'NCM',

  rtrim(ltrim(cast(cf.cd_extipi as varchar(10))))                                                         as 'EXTIPI',
  rtrim(ltrim(cast(cf.cd_genero_ncm_produto as varchar(10))))                                             as 'genero',
  rtrim(ltrim(cast(replace(opf.cd_mascara_operacao,'.','') as varchar(10))))                              as 'CFOP',

  --Unidade
--  case when isnull(opf.ic_ciap_operacao_fiscal,'N')='N' then

    rtrim(ltrim(cast(um.sg_unidade_medida as varchar(6))))                                              

--  else
--   'R$'
--  end
                                                                                                          as 'uCom',

  --Quantidade

--  case when isnull(opf.ic_ciap_operacao_fiscal,'N')='S' then
--     '0.00'
--  else

  isnull(CONVERT(varchar, convert(numeric(25,4),round(case when nsi.qt_item_nota_saida    > 0 
  then nsi.qt_item_nota_saida else null end,6,4)),103),'0.0000')                                  
  --end        
                                                                                                         as 'qCom',

  --Valor Unitário------------------------------------------------------------------------
  --case when isnull(opf.ic_ciap_operacao_fiscal,'N')='N' then
    isnull(CONVERT(varchar, convert(numeric(25,10),round(case when nsi.vl_unitario_item_nota > 0 
    then nsi.vl_unitario_item_nota else null end,6,6)),103),'0.000000000000')                               
  --else
  --   '0.00'
  --end     
                                                                                                  as 'vUnCom',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item         > 0 
  then nsi.vl_total_item else null end,6,2)),103),'0.00')                                                   as 'vProd',

  cast('00000000000000' as varchar(14))                                                                     as 'cEanTrib',

  --case when isnull(opf.ic_ciap_operacao_fiscal,'N')='N' then
     ltrim(rtrim(cast(um.sg_unidade_medida as varchar(6))))  
  --else
  --   'R$'
  --end
                                                                                                            as 'uTrib',    

  isnull(CONVERT(varchar, convert(numeric(14,4),round(case when nsi.qt_item_nota_saida    > 0 
  then nsi.qt_item_nota_saida else null end,6,2)),103),'0.00')                                              as 'qTrib',

  --case when isnull(opf.ic_ciap_operacao_fiscal,'N')='N' then
    isnull(CONVERT(varchar, convert(numeric(14,4),round(case when nsi.vl_unitario_item_nota > 0 
    then nsi.vl_unitario_item_nota else null end,6,2)),103),'0.00')                                       
  --else
  --  0.00
  --end
                                                                                                            as 'vUnTrib',
  
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_frete_Item         > 0 
  then nsi.vl_frete_Item else null end,6,2)),103),'0.00')                                                   as 'vFrete',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_seguro_item        > 0 
  then nsi.vl_seguro_item else null end ,6,2)),103),'0.00')                                                 as 'vSeg',

  case when isnull(nsi.pc_desconto_item,0)>0 then
    isnull(CONVERT(varchar, convert(numeric(14,2),round((nsi.vl_total_item * ( nsi.pc_desconto_item/100)),6,2)),103),'0.00')
  else
    '0.00'
  end                                                                                                     as 'vDesc',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item > 0 
  then nsi.vl_total_item else null end,14,2)),103),'0.00')                                               as 'vBC_II',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_desp_aduaneira_item > 0 
  then nsi.vl_desp_aduaneira_item else null end,14,2)),103),'0.00')                                      as 'vDespAnu',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_II > 0 
  then nsi.vl_II else null end,14,2)),103),'0.00')                                                       as 'vII',


  '0.00'                                                                                                 as 'vIOF',

  --Importação-----------------------------------------------------------------------------------------------------
  --select * from nota_saida_importacao

  isnull(replace(replace(isnull(nsi.nm_di,nimp.nm_di),'-',''),'/',''),'')                                                                                   as 'nDI',
  ltrim(rtrim(replace(convert(char,isnull(di.dt_emissao_di,nimp.dt_emissao_di),102),'.','-')))                                   as 'dDi',
  cast(isnull(pd.nm_porto,nimp.nm_porto_di) as varchar(60))                                                                    as 'xLocDesemb',
  cast(isnull(ed.sg_estado,isnull(nimp.sg_estado_di,'SP')) as varchar(02))                                                      as 'UFDesemb',
  ltrim(rtrim(replace(convert(char,isnull(di.dt_desembaraco,nimp.dt_desembaraco),102),'.','-')))                                  as 'dDesemb',

  cast(isnull(di.cd_fornecedor,ns.cd_cliente) as varchar(60))                                                               as 'cExportador',

  case when isnull(nsi.nm_di,'')<>'' or isnull(nimp.nm_di,'') <> '' then
   cast(isnull( (select count(*) from nota_saida_Item adi where adi.cd_nota_saida = nsi.cd_nota_saida
           group by nsi.cd_classificacao_fiscal),0) as varchar)
  else
    '0'                                                                                               
  end                                                                                                 as 'nAdicao',

  case when isnull(nsi.nm_di,'')<>'' or isnull(nimp.nm_di,'')<>'' then
   '1'
  else
    '0'
  end                                                                                                  as 'nSeqAdic',

  cast('.' as varchar(60))                                                                             as 'cFabricante',
  '0.00'                                                                as 'vDescDI',


  --ICMS

  'ICMS' + ti.cd_digito_tributacao_icms                                                               as 'ICMS',

  rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))                                as 'orig',
  rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,00) as varchar(2))))                           as 'CST',
  rtrim(ltrim(cast(isnull(mci.cd_digito_modalidade,0)  as varchar(1))))                               as 'modBC',

  dbo.fn_mascara_valor_duas_casas(isnull(nsi.vl_base_icms_item,0))                                    as 'vBC',
  dbo.fn_mascara_valor_duas_casas(isnull(nsi.pc_icms,0))                 as 'pICMS',
  dbo.fn_mascara_valor_duas_casas(isnull(nsi.vl_icms_item,0))            as 'vICMS',
  dbo.fn_mascara_valor_duas_casas(isnull(pf.pc_iva_icms_produto,0))      as 'pIVAICMS',
  dbo.fn_mascara_valor_duas_casas(isnull(pf.vl_pauta_icms_produto,0))    as 'PautaICMS',

  dbo.fn_mascara_valor_duas_casas(case when isnull(opf.ic_subst_tributaria,'N')='S' 
                                    then nsi.pc_subs_trib_item 
                                    else 0.00 end)                                                    as 'pICMSSUBST',

    dbo.fn_mascara_valor_duas_casas(case when isnull(opf.ic_subst_tributaria,'N')='S' and  
                                    nsi.vl_bc_subst_icms_item>0 
                                    then isnull(nsi.vl_icms_subst_icms_item,0)
                                    else 0.00 end)                         as 'vICMSSubst',

    dbo.fn_mascara_valor_duas_casas(case when isnull(opf.ic_subst_tributaria,'N')='S' 
                                    then isnull(nsi.vl_bc_subst_icms_item,0)
                                    else 0.00 end)                         as 'vBCICMSSubst',
   
----------------------------------------------------------------------------------------------------------------

  ltrim(rtrim(cast(isnull(tpis.cd_digito_tributacao_pis,'01') as varchar(2))))  as 'CSTPis',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item > 0 then isnull(nsi.vl_total_item,0.00) else 0.00 end,6,2)),103),'0.00') as 'vBCPis',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.pc_pis > 0 then 
                                                        nsi.pc_pis 
                                                      else
                                                        case when nsi.vl_pis > 0 then
                                                          isnull(CONVERT(varchar, convert(numeric(14,2),round(((nsi.vl_pis * 100)/(nsi.vl_total_item)),6,2)),103),'')   
                                                        else                                                                                                                  --Busca o (%) do Cadastro
                                                          ( select top 1 isnull(al.pc_imposto,0.65)
                                                            from
                                                             imposto_aliquota al with (nolock) 
                                                            where
                                                              cd_imposto = 5 )  

                                                          --'0.65'
                                                        end 
                                                      end,6,2)),103),'')  as 'pPIS',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_pis > 0 then nsi.vl_pis 
  else 
   nsi.vl_total_item * ( 1.65/100) 
  end,6,2)),103),'')                                             as 'vPIS',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.qt_item_nota_saida > 0 then nsi.qt_item_nota_saida else 0.00 end,6,2)),103),'0.00')     
                                                                 as 'qBCProd',
  '0.00'                                                         as 'vAliqProd',

----------------------------------------------------------------------------------------------------------------
--select * from imposto
--select * from imposto_aliquota

  rtrim(ltrim(cast(isnull(tci.cd_digito_tributacao_cofins,'01') as varchar(80))))             as 'CSTCOFINS',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item > 0 then nsi.vl_total_item else 0.00 end,6,2)),103),'0.00')      as 'vBCCOFINS',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.pc_cofins > 0 then 
                                                        nsi.pc_cofins 
                                                      else
                                                        case when nsi.vl_cofins > 0 then
                                                          isnull(CONVERT(varchar, convert(numeric(14,2),round(((nsi.vl_cofins * 100)/(nsi.vl_total_item)),6,2)),103),'')   
                                                        else
                                                          --Busca o (%) do Cadastro
                                                          ( select top 1 isnull(al.pc_imposto,7.6)
                                                            from
                                                             imposto_aliquota al
                                                            where
                                                              cd_imposto = 4 )  
                                                          --antes 25.09.2009
                                                          --'7.6'
                                                        end 
                                                      end,6,2)),103),'')   as 'pCOFINS',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_cofins > 0 then nsi.vl_cofins 
  else 
   nsi.vl_total_item * (7.6/100)
  end,6,2)),103),'')                                                      as 'vCOFINS',

  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.qt_item_nota_saida > 0 then nsi.qt_item_nota_saida else null end,6,2)),103),'') as 'qBCProdCOFINS',

  '0.00'                                                           as 'vAliqProdCOFINS',
  'S04'                                                            as 'COFINSNT',
  'S05'                                                            as 'COFINSOutr',  

  ---------------------------------------------------------------------------------------------
  --IPI
  ---------------------------------------------------------------------------------------------
  --select * from tributacao_ipi

  'IPI'  + isnull(tipi.cd_digito_tributacao_ipi,'00')                                     as 'IPI',

  rtrim(ltrim(cast(isnull(tipi.cd_digito_tributacao_ipi,'00') as varchar(80))))                                                                 as 'CSTIPI',


  --Valor da Base do IPI-----------------------------------------------------------------------------------------------

  case when isnull(nsi.vl_base_ipi_item,0)>0 then	
    isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_base_ipi_item > 0 then nsi.vl_base_ipi_item else null end,6,2)),103),'0.00')
  else
    case when isnull(tipi.cd_digito_tributacao_ipi,'00') = '99' then
      isnull(CONVERT(varchar, convert(numeric(14,2),0.00),103),'0.00')
    else
      isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item    > 0 then nsi.vl_total_item else null end,6,2)),103),'0.00')
    end
  end 
                                                                                                                                                                             as 'vBCIPI',

  isnull(CONVERT(varchar, convert(numeric(14,4),round(case when isnull(nsi.qt_item_nota_saida,0)      > 0 then nsi.qt_item_nota_saida      else null end,6,2)),103),'0.0000')  as 'qUnid',
  isnull(CONVERT(varchar, convert(numeric(14,4),round(case when isnull(nsi.vl_unitario_ipi_produto,0) > 0 then nsi.vl_unitario_ipi_produto else null end,6,2)),103),'0.0000')  as 'vUnid',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when isnull(nsi.pc_ipi,0)                  > 0 then nsi.pc_ipi                  else null end,6,2)),103),'0.00')  as 'pIPI',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(case when isnull(nsi.vl_ipi,0)                  > 0 then nsi.vl_ipi                  else null end,6,2)),103),'0.00')  as 'vIPI',

  isnull(nsi.vl_unitario_ipi_produto,0)                                                                                                                                      as 'vl_unitario_ipi_produto',


  cast('NA' as varchar(5))                                       as 'cIEnq',
  cast('00000000000000' as varchar(14))                          as 'CNPJProd',
  cast('N' as varchar(1))                                        as 'cSelo',
  cast('0' as varchar(12))                                       as 'qSelo',
  cast('999' as varchar(03))                                     as 'cEnq',

----------------------------------------------------------------------------------------------------------------
          
  case when ti.cd_digito_tributacao_icms = '10' then           
      'ICMS10'           
  else          
      cast('ICMS10' as varchar(6))          
  end                                                                                               as 'ICMS10',          
          
  case when ti.cd_digito_tributacao_icms = '10' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig10',          
          
  case when ti.cd_digito_tributacao_icms = '10' then           
    rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,'00') as varchar(2))))                                            
  else          
    cast('00' as varchar(2))          
  end                                                                                               as 'CST10',          
          
  case when ti.cd_digito_tributacao_icms = '10' then           
    rtrim(ltrim(cast(isnull(mci.cd_digito_modalidade,0)  as varchar(1))))                                            
  else          
    cast('0' as varchar(1))          
  end                                                                                               as 'modBC10',          
          
  dbo.fn_mascara_valor_duas_casas(isnull(nsi.vl_base_icms_item,0))                                  as 'vBC10',
          
  dbo.fn_mascara_valor_duas_casas(isnull(nsi.pc_icms,0))                                             as 'pICMS10',
            
  dbo.fn_mascara_valor_duas_casas(isnull(nsi.vl_icms_item,0))                                        as 'vICMS10',


  case when ti.cd_digito_tributacao_icms = '10' then           
     ltrim(rtrim(cast(isnull(mct.cd_digito_modalidade_st,0) as varchar(10))))                                         
  else          
     cast('0' as varchar(10))          
  end                                                                                               as 'modBCST10',          
          
  case when ti.cd_digito_tributacao_icms = '10' then           
    case when isnull(cfe.pc_icms_strib_clas_fiscal,0)>0 then
        dbo.fn_mascara_valor_duas_casas(cfe.pc_icms_strib_clas_fiscal)           
    else
        case when nsi.pc_subs_trib_item > 0 then           
           dbo.fn_mascara_valor_duas_casas(nsi.pc_subs_trib_item)               
        else
           '0.00'
        end
 
    end

  else          
    '0.00'
  end                                                                                               as 'pMVAST10',          
          
  case when ti.cd_digito_tributacao_icms = '10' and cfe.pc_red_icms_clas_fiscal > 0 then           
    dbo.fn_mascara_valor_duas_casas(cfe.pc_red_icms_clas_fiscal)           
  else          
    '0.00'
  end                                                                                               as 'pRedBCST10',          
          
  case when ti.cd_digito_tributacao_icms = '10' then           
--    dbo.fn_mascara_valor_duas_casas(nsi.vl_bc_subst_icms_item)               
    dbo.fn_mascara_valor_duas_casas(case when isnull(opf.ic_subst_tributaria,'N')='S' and  
                                    nsi.vl_bc_subst_icms_item>0 
                                    then vl_bc_subst_icms_item
                                    else 0.00 end)

  else          
    '0.00'           
  end                                                                                               as 'vBCST10',          
          
  --Antes
  --04.05.2010

--   case when ti.cd_digito_tributacao_icms = '10' and nsi.pc_subs_trib_item > 0 then           
--     dbo.fn_mascara_valor_duas_casas(nsi.pc_subs_trib_item)               
--   else          
--     dbo.fn_mascara_valor_duas_casas(0.00)           
--   end                                                                                               as 'pICMSST10',          

  --% ICMS Interna
  case when isnull(cfe.pc_interna_icms_clas_fis,0)<>0 then
     dbo.fn_mascara_valor_duas_casas(isnull(cfe.pc_interna_icms_clas_fis,0))                                            
  else        
     dbo.fn_mascara_valor_duas_casas(isnull(nsi.pc_icms,0))                                             
  end                                                                                                  as 'pICMSST10',

  case when ti.cd_digito_tributacao_icms = '10' then           
--    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_subst_icms_item)          
    dbo.fn_mascara_valor_duas_casas(case when isnull(opf.ic_subst_tributaria,'N')='S' and  
                                    nsi.vl_bc_subst_icms_item>0 
                                    then nsi.vl_icms_subst_icms_item
                                    else 0.00 end)

  else          
    dbo.fn_mascara_valor_duas_casas(0.00)           
  end                                                                                               as 'vICMSST10',          

  '0.00'                                                                                            as 'ModVCST10',        

  --------------------------------------------------------------------------------------------------------------          
          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
      'ICMS20'           
  else          
      cast('ICMS20' as varchar(6))          
  end                                                                                               as 'ICMS20',          
                    
  case when ti.cd_digito_tributacao_icms = '20' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig20',          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    rtrim(ltrim(cast(ti.cd_digito_tributacao_icms as varchar(2))))                                            
  else          
    cast('20' as varchar(2))          
  end                                                                                               as 'CST20',          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    rtrim(ltrim(cast(isnull(mci.cd_digito_modalidade,0)  as varchar(1))))                                            
  else          
    cast('0' as varchar(1))          
  end                                                                                               as 'modBC20',          
          
          
  case when ti.cd_digito_tributacao_icms = '20' and isnull(nsi.vl_base_icms_item,0)>0 then           
    dbo.fn_mascara_valor_duas_casas(isnull(nsi.pc_reducao_icms,0))                  
  else          
    '0.00'
  end                                                                                               as 'pREDBC20',          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_base_icms_item)                 
  else          
    dbo.fn_mascara_valor_duas_casas(0.00)                  
  end                                                                                               as 'vBC20',          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_icms)                        
  else          
    '0.00'                        
  end                                                                                               as 'pICMS20',          
            
  case when ti.cd_digito_tributacao_icms = '20' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_item)          
  else          
    '0.00'          
  end                                                                                               as 'vICMS20',          
          
  --------------------------------------------------------------------------------------------------------------          
          
  case when ti.cd_digito_tributacao_icms = '30' then           
      'ICMS30'           
  else          
      cast('ICMS30' as varchar(6))          
  end                                                                                               as 'ICMS30',          
          
  case when ti.cd_digito_tributacao_icms = '30' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))          
  end                                                                                               as 'orig30',          
          
  case when ti.cd_digito_tributacao_icms = '30' then           
    rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,'30') as varchar(2))))                                            
  else          
    cast('30' as varchar(2))          
  end                                                                                               as 'CST30',          
          
  case when ti.cd_digito_tributacao_icms = '30' then
    rtrim(ltrim(cast(isnull(mct.cd_digito_modalidade_st,0) as varchar(1))))                                        
  else
     '0.00'
  end                                                                                                as 'modBCST30',
        
  case when ti.cd_digito_tributacao_icms = '30' then         
    dbo.fn_mascara_valor_duas_casas(cfe.pc_icms_strib_clas_fiscal)           
  else          
    '0.00'
  end                                                                                                as 'pMVAST30',          
          
  case when ti.cd_digito_tributacao_icms = '30' then           
    dbo.fn_mascara_valor_duas_casas(cfe.pc_red_icms_clas_fiscal)           
 else          
    '0.00'
  end                                                                                               as 'pRedBCST30',          
          
  case when ti.cd_digito_tributacao_icms = '30' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_bc_subst_icms_item)               
  else          
    '0.00'
  end                                                                                               as 'vBCST30',          
          
  case when ti.cd_digito_tributacao_icms = '30' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_subs_trib_item)               
  else          
    '0.00'
  end                                                                                               as 'pICMSST30',          
          
  case when ti.cd_digito_tributacao_icms = '30' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_subst_icms_item)          
  else          
    '0.00'
  end                                                                                               as 'vLCMSST30',          
          
 -- '' as vl        

  --------------------------------------------------------------------------------------------------------------          
          
  case when ti.cd_digito_tributacao_icms = '40' then           
      'ICMS40'           
  else          
      cast('ICMS40' as varchar(6))          
  end                                                                                               as 'ICMS40',          
          
  case when ti.cd_digito_tributacao_icms = '40' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig40',          
          
  case when ti.cd_digito_tributacao_icms = '40' then           
    --exportacao         
    case when   isnull(opf.ic_exportacao_op_fiscal,'N')='S' then
      '41'
    else
      rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,'40') as varchar(2))))                                            
    end
  else 
    --exportacao         
    case when   isnull(opf.ic_exportacao_op_fiscal,'N')='S' then
      '41'
    else
      cast('40' as varchar(2))          
    end
  end                                                                                               as 'CST40',          
          
  --------------------------------------------------------------------------------------------------------------          
          
  case when ti.cd_digito_tributacao_icms = '50' then           
      'ICMS50'           
  else          
      cast('ICMS50' as varchar(6))          
  end                                                                     as 'ICMS50',          
          
  case when ti.cd_digito_tributacao_icms = '50' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig50',          
          
  case when ti.cd_digito_tributacao_icms = '50' then           
    rtrim(ltrim(cast(ti.cd_digito_tributacao_icms as varchar(2))))                                            
  else          
    cast('50' as varchar(2))          
  end                                                                                               as 'CST50',          
          
  --------------------------------------------------------------------------------------------------------------          
  case when ti.cd_digito_tributacao_icms = '51' then           
      'ICMS51'           
  else          
      cast('ICMS51' as varchar(6))          
  end                                                                                               as 'ICMS51',          
          
  case when ti.cd_digito_tributacao_icms = '51' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig51',          
          
  case when ti.cd_digito_tributacao_icms = '51' then           
    rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,'51') as varchar(2))))                                            
  else          
    cast('51' as varchar(2))          
  end                                                                                               as 'CST51',          
          
  case when ti.cd_digito_tributacao_icms = '51' then           
    rtrim(ltrim(cast(isnull(mci.cd_digito_modalidade,0)  as varchar(1))))                                            
  else          
    cast('0' as varchar(1))          
  end                                                                                               as 'modBC51',          
          
          
  case when ti.cd_digito_tributacao_icms = '51' and isnull(nsi.vl_base_icms_item,0)>0 then           
    dbo.fn_mascara_valor_duas_casas(isnull(nsi.pc_reducao_icms,0) )                  
  else          
    '0.00'                  
  end                                                                                               as 'pREDBC51',          
          
  case when ti.cd_digito_tributacao_icms = '51' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_base_icms_item)                 
  else          
    '0.00'                  
  end                                                                                               as 'vBC51',          
          
  case when ti.cd_digito_tributacao_icms = '51' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_icms)                        
  else          
    '0.00'
  end                                                                                               as 'pICMS51',          
            
  case when ti.cd_digito_tributacao_icms = '51' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_item)          
  else          
    '0.00'           
  end                                                                                               as 'vICMS51',                    
          
  --------------------------------------------------------------------------------------------------------------          
  --ICMS Cobrado anteriormente por ST
  --------------------------------------------------------------------------------------------------------------
        
  case when ti.cd_digito_tributacao_icms = '60' then           
      'ICMS60'           
  else          
      cast('ICMS60' as varchar(6))          
  end                                                                                               as 'ICMS60',          
          
  case when ti.cd_digito_tributacao_icms = '60' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig60',          
          
  case when ti.cd_digito_tributacao_icms = '60' then           
    rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,'60') as varchar(2))))                                            
  else          
    cast('60' as varchar(2))          
  end                                                                                               as 'CST60',          
          
  case when ti.cd_digito_tributacao_icms = '60' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_bc_subst_icms_item)               
  else          
    '0.00'           
  end                                                                                               as 'vBCST60',          
          
  case when ti.cd_digito_tributacao_icms = '60' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_subst_icms_item)          
  else          
    '0.00'           
  end                                                                                               as 'vICMSST60',          
          
          
  --------------------------------------------------------------------------------------------------------------          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
      'ICMS70'           
  else          
      cast('ICMS70' as varchar(5))          
  end                                                                                               as 'ICMS70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,'70') as varchar(2))))                                            
  else          
    cast('70' as varchar(2))          
  end                                                                                               as 'CST70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    rtrim(ltrim(cast(isnull(mci.cd_digito_modalidade,0)  as varchar(1))))                                            
  else          
    cast('0' as varchar(1))          
  end                                                                                               as 'modBC70',          
            
          
  case when ti.cd_digito_tributacao_icms = '70' and isnull(nsi.vl_base_icms_item,0)>0  then           
    dbo.fn_mascara_valor_duas_casas(isnull(nsi.pc_reducao_icms,0))                  
  else          
    '0.00'                  
  end                                                                                               as 'pREDBC70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_base_icms_item)                 
  else          
    '0.00'                  
  end                                                                                               as 'vBC70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_icms)                        
  else          
    '0.00'                        
  end                                                                                               as 'pICMS70',          
            
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_item)          
  else          
    '0.00'          
  end                                                                                               as 'vICMS70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
     ltrim(rtrim(cast(mct.cd_digito_modalidade_st as varchar(10))))                                         
  else          
     cast('' as varchar(10))          
  end                                                                                               as 'modBCST70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(cfe.pc_icms_strib_clas_fiscal)           
  else          
    '0.00'           
  end                                                                                                as 'pMVAST70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(cfe.pc_red_icms_clas_fiscal)           
  else          
    '0.00'           
  end                                                                                               as 'pRedBCST70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_bc_subst_icms_item)               
  else          
    '0.00'           
  end                                                                                               as 'vBCST70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_subs_trib_item)               
  else          
    '0.00'           
  end                                                                                               as 'pICMSST70',          
          
  case when ti.cd_digito_tributacao_icms = '70' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_subst_icms_item)          
  else          
    '0.00'           
  end                                                                                               as 'vICMSST70',          
          
          
  --------------------------------------------------------------------------------------------------------------          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
      'ICMS90'           
  else          
      cast('ICMS90' as varchar(6))          
  end                                                                                               as 'ICMS90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))          
  else          
    cast('0' as varchar(1))           
  end                                                                                               as 'orig90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    rtrim(ltrim(cast(isnull(ti.cd_digito_tributacao_icms,'90') as varchar(2))))                                            
  else          
    cast('90' as varchar(2))              
  end                                                                                               as 'CST90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    rtrim(ltrim(cast(isnull(mci.cd_digito_modalidade,0)  as varchar(1))))                                            
  else          
    cast('0' as varchar(1))          
  end                                                                                               as 'modBC90',          
          
  case when ti.cd_digito_tributacao_icms = '90' and isnull(nsi.vl_base_icms_item,0)>0 then           
    dbo.fn_mascara_valor_duas_casas( isnull(nsi.pc_reducao_icms,0) )                  
  else          
    '0.00'                  
  end                                                                                               as 'pREDBC90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(isnull(nsi.vl_base_icms_item,0.00) )                 
  else          
    '0.00'                  
  end                                                                                               as 'vBC90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_icms)                        
  else          
    '0.00'                        
  end                                                                                               as 'pICMS90',          
            
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_item)          
  else          
    '0.00'          
  end                                                                                               as 'vICMS90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
     ltrim(rtrim(cast(isnull(mct.cd_digito_modalidade_st,0) as varchar(10))))                                         
  else          
     cast('0' as varchar(10))          
  end                                                                                               as 'modBCST90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(cfe.pc_icms_strib_clas_fiscal)           
  else          
    '0.00'           
  end                                                                                               as 'pMVAST90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(cfe.pc_red_icms_clas_fiscal)           
  else          
    '0.00'           
  end                                                                                               as 'pRedBCST90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_bc_subst_icms_item)               
  else          
    '0.00'           
  end                                                                                               as 'vBCST90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_subs_trib_item)               
  else          
    '0.00'                
  end                                                                                               as 'pICMSST90',          
          
  case when ti.cd_digito_tributacao_icms = '90' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_subst_icms_item)          
  else          
    '0.00'           
  end                                                                                               as 'vICMSST90',

  --select * from nota_saida_item
  case when cast(nsi.ds_item_nota_saida as varchar(500))<>'' then
   'S'
  else
    isnull(p.ic_descritivo_nf_produto,'N')                                                            
  end                                                                                               as 'ic_descritivo_nf_produto',

  --Lote

  case when isnull(nsi.cd_lote_item_nota_saida,'')<>'' then
    ltrim(rtrim(nsi.cd_lote_item_nota_saida))
  else
   ''
  end                                                                                               as 'Lote',

  --v2.0
  
  cast(nsi.cd_pdcompra_item_nota as varchar(15))                                                    as 'xPed',
  cast(0 as varchar(1))                                                                             as 'nItemPed',

  --Valor de Outras Despesas Acessórias do Item

  dbo.fn_mascara_valor_duas_casas(isnull(nsi.vl_desp_acess_item,0))                                 as 'vOutro',


  --Serviço--------------------------------------------------------------------------------------

  case when isnull(nsi.cd_servico,0)<>0 then
    isnull(CONVERT(varchar, convert(numeric(14,2),round(case when nsi.vl_total_item         > 0 
    then nsi.vl_total_item else null end,6,2)),103),'0.00')                                                
  else
    '0.00'  
  end                                                                                               as 'vBC_U02',

  '0.00' as 'vAliq_U03',

  '0.00' as 'vISSQN_U04',
  
  cast('' as varchar)                   as 'cMunFG_U05',
  cast('' as varchar)                   as 'cListServ_U06',
  'N'                                   as 'cSitTrib_U07',

  --------------------------------------------------------------------------------------------------

  '0.00' as 'vICMS_N17',
  cast('0' as varchar(1))               as 'motDesICMS_N28',                                     
  


  --Carlos - 27.09.2010 --> Verificar quando será 1 --> Não entra no valor comercial
  cast('1' as char(1))                                                                            as 'indTot'

  --select * from operacao_fiscal
  --select * from nota_saida_item



from

  nota_saida ns                                     with (nolock) 
  inner join nota_saida_item nsi                    with (nolock) on nsi.cd_nota_saida             = ns.cd_nota_saida
  left outer join vw_destinatario vw                with (nolock) on vw.cd_destinatario            = ns.cd_cliente and
                                                                     vw.cd_tipo_destinatario       = ns.cd_tipo_destinatario

  left outer join classificacao_fiscal cf           with (nolock) on cf.cd_classificacao_fiscal    = nsi.cd_classificacao_fiscal
  left outer join operacao_fiscal opf               with (nolock) on opf.cd_operacao_fiscal        = nsi.cd_operacao_fiscal
  left outer join tipo_movimento_estoque tme        with (nolock) on tme.cd_tipo_movimento_estoque = opf.cd_tipo_movimento_estoque
  left outer join unidade_medida um                 with (nolock) on um.cd_unidade_medida          = nsi.cd_unidade_medida
  left outer join di                                with (nolock) on di.cd_di                      = nsi.cd_di
  left outer join porto pd                          with (nolock) on pd.cd_porto                   = di.cd_porto_destino
  left outer join estado ed                         with (nolock) on ed.cd_estado                  = pd.cd_estado
  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto                 = nsi.cd_produto
  left outer join procedencia_produto pp            with (nolock) on pp.cd_procedencia_produto     = pf.cd_procedencia_produto
  left outer join tributacao t                      with (nolock) on t.cd_tributacao               = nsi.cd_tributacao
  left outer join tributacao_icms ti                with (nolock) on ti.cd_tributacao_icms         = t.cd_tributacao_icms
  left outer join modalidade_calculo_icms mci       with (nolock) on mci.cd_modalidade_icms        = t.cd_modalidade_icms
  left outer join modalidade_calculo_icms_sTrib mct with (nolock) on mct.cd_modalidade_icms_st     = t.cd_modalidade_icms_st

  left outer join classificacao_fiscal_estado cfe   with (nolock) on cfe.cd_classificacao_fiscal   = nsi.cd_classificacao_fiscal and
                                                                     cfe.cd_estado                 = vw.cd_estado

  left outer join tributacao_pis tpis               with (nolock) on tpis.cd_tributacao_pis        = t.cd_tributacao_pis
  left outer join tributacao_cofins tci             with (nolock) on tci.cd_tributacao_cofins      = t.cd_tributacao_cofins 
  left outer join tributacao_ipi tipi               with (nolock) on tipi.cd_tributacao_ipi        = t.cd_tributacao_ipi 
  left outer join produto                       p   with (nolock) on p.cd_produto                  = nsi.cd_produto

  left outer join produto_cliente               pc  with (nolock) on pc.cd_produto                 = nsi.cd_produto and
                                                                     pc.cd_cliente                 = ns.cd_cliente

  left outer join Serie_Nota_Fiscal snf            with (nolock) on snf.cd_serie_nota_fiscal       = ns.cd_serie_nota

  left outer join Nota_Saida_Importacao      nimp  with (nolock) on nimp.cd_nota_saida             = ns.cd_identificacao_nota_saida
  
  --Antes
  --left outer join Nota_Saida_Importacao      nimp  with (nolock) on nimp.cd_nota_saida             = ns.cd_nota_saida


