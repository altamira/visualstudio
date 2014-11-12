
CREATE VIEW vw_nfp_registro_20   
------------------------------------------------------------------------------------      
--vw_nfp_registro_20      
------------------------------------------------------------------------------------      
--GBS - Global Business Solution                                        2008      
------------------------------------------------------------------------------------      
--Stored Procedure : Microsoft SQL Server 2000      
--Autor(es)             : Douglas de Paula Lopes      
--Banco de Dados : EGISSQL      
--Objetivo         : Nota Fiscal Paulista      
--Data                  : 25/06/2008          
--Atualização           :       
-- 03.07.2008 - Complemento dos Campos - Carlos Fernandes      
-- 17.10.2008 - Complemento dos Campos Faltantes - Douglas de Paula Lopes   
-- 10.08.2009 - Nota Fiscais de Pedido sem Valor Comercial - Carlos Fernandes 
------------------------------------------------------------------------------------      
as      
      
select
  ns.cd_nota_saida,       
------------------------------------------------------------------------------------      
--FILTRO        
------------------------------------------------------------------------------------      
  ns.dt_nota_saida,      
------------------------------------------------------------------------------------      
  case when ns.dt_cancel_nota_saida is not null then      
    'C'      
  else      
    'I'                            
  end                                                                                                       as FREG,      
  case when ns.dt_cancel_nota_saida is not null then      
    cast(ns.nm_mot_cancel_nota_saida as varchar(230))      
  else      
    ''      
  end                                                                                                       as JUST,      
  cast(ns.nm_operacao_fiscal as varchar(60))                                                                as NATOP,      
  /*cast(snf.cd_mascara_classificacao as varchar(3))*/  
  '000'                                                                                                     as SERIE,      
  ns.cd_nota_saida                                                                                          as NNF,      
  rtrim(ltrim(convert(char,ns.dt_nota_saida,103))) + ' ' +      
  rtrim(ltrim(convert(char,ns.dt_nota_saida,108)))                                                          as DEMI,      
  rtrim(ltrim(convert(char,ns.dt_nota_saida,103))) + ' ' +      
  rtrim(ltrim(convert(char,ns.dt_nota_saida,108)))                                                          as DESAIENT,      
  case when ns.cd_tipo_operacao_fiscal = 2 then 1 else 0 end                                                as TPNF,      
  --isnull(substring(cf.cd_mascara_classificacao,1,4),'0000')                                                                as CFOP,      
  cast(replace(opf.cd_mascara_operacao,'.','') as varchar(4))                                               as CFOP,  
 -- cast(ns.cd_inscest_nota_saida as varchar(14))                                                             as IEST,    
  cast('' as varchar(14))                                                             as IEST,        
  (select nm_inscricao_municipal from egisadmin.dbo.empresa where cd_empresa = dbo.fn_empresa())            as IM,      

  case when lower(ns.nm_pais_nota_saida) = 'brasil' then      
    cast(ns.cd_cnpj_nota_saida      as varchar(14))
  else
   '00000000000000'
  end                                                                                                       as CNPJ,      
  cast(ns.nm_razao_social_nota    as varchar(60))                                                           as NOME,      
  cast(ns.nm_endereco_nota_saida  as varchar(60))                                                           as XLGR,      
  cast(ns.cd_numero_end_nota_saida as varchar(60))                                                          as NRO,      
  cast(ns.nm_compl_endereco_nota as varchar(60))                                                            as XCPL,      
  cast(ns.nm_bairro_nota_saida as varchar(60))                                                              as XBAIRRO,      
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then      
    cast(ns.nm_cidade_nota_saida as varchar(60))              
  else      
    'EXTERIOR'       
  end                                                                                                       as XMUN,      
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then      
    cast(ns.sg_estado_nota_saida as varchar(2))              
  else      
    'EX'       
  end                                                                                                       as UF,      
  replace(ns.cd_cep_nota_saida, '-', '')                                                                    as CEP,      
  cast(ns.nm_pais_nota_saida as varchar(60))                                                                as XPAIS,      
  case when lower(ns.nm_pais_nota_saida) = 'brasil' then      
    case when SUBSTRING(ns.cd_ddd_nota_saida,1,1) = '0' then      
      cast(SUBSTRING(ns.cd_ddd_nota_saida,2,2) + replace(ns.cd_telefone_nota_saida,'-','') as varchar(10))      
    else      
      cast(replace(ns.cd_ddd_nota_saida,' ','') + replace(ns.cd_telefone_nota_saida,'-','') as varchar(10))      
    end
  else
    '0000000000'
  end                                                                                                       as FONE,      
  cast(ns.cd_inscest_nota_saida as varchar(14))                                                             as IE,
  isnull(tp.ic_imposto_tipo_pedido,'N')  as ic_imposto_tipo_pedido,       
  nsi.cd_pedido_venda,
  nsi.cd_item_pedido_venda

from      
  Nota_Saida ns                           with (nolock)     
  inner join Nota_Saida_item        nsi   with (nolock) on (nsi.cd_nota_saida          = ns.cd_nota_saida and    
                                                            nsi.cd_item_nota_saida = (select     
                                                                                        min(cd_item_nota_saida)     
                                                                                      from     
                                                                                        nota_saida_item    
                                                                                      where     
                                                                                        cd_nota_saida = ns.cd_nota_saida))       
  left outer join pedido_venda_item pvi   with (nolock) on pvi.cd_pedido_venda        = nsi.cd_pedido_venda and  
                                                           pvi.cd_item_pedido_venda   = nsi.cd_item_pedido_venda  
  left outer join pedido_venda pv         with (nolock) on pv.cd_pedido_venda         = pvi.cd_pedido_venda  
  left outer join tipo_pedido tp          with (nolock) on tp.cd_tipo_pedido          = pv.cd_tipo_pedido and  
                                                           isnull(tp.ic_imposto_tipo_pedido,'N') = 'S'  
  left outer join Serie_Nota_Fiscal snf   with (nolock) on snf.cd_serie_nota_fiscal   = ns.cd_serie_nota      
  left outer join classificacao_fiscal cf with (nolocK) on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal    
  left outer join operacao_fiscal opf     with (nolock) on opf.cd_operacao_fiscal     = ns.cd_operacao_fiscal  

where
  isnull(ic_nfp_nota_saida,'S')='S'


--where
    
-- where  
--   ns.cd_nota_saida=8781   


-- delete nota_saida_item_registro 
--   from nota_saida_item_registro i
--   inner join nota_saida_item nsi on nsi.cd_nota_saida      = i.cd_nota_saida and
--                                     nsi.cd_item_nota_saida = i.cd_item_nota_saida
--   inner join pedido_venda pv     on pv.cd_pedido_venda     = nsi.cd_pedido_venda
-- 
--   inner join tipo_pedido  tp     on tp.cd_tipo_pedido      = pv.cd_tipo_pedido
-- where
--   isnull(nsi.cd_pedido_venda,0)>0    and isnull(nsi.cd_item_pedido_venda,0)>0 and
--   isnull(tp.ic_imposto_tipo_pedido,'S') = 'N'

