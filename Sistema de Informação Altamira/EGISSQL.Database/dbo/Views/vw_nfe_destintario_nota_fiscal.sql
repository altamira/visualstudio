
CREATE VIEW vw_nfe_destintario_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_destintario_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Destinatário da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 04.11.2008
--Atualização           : 30.07.2009 - Tipo de Mercado - Carlos Fernandes
-- 08.08.2009 - Dados do Cliente/Fornecedor do Mercado Externo - Carlos Fernandes
-- 20.09.2009 - Dados do Endereço de Entrega - Carlos Fernandes
-- 14.08.2010 - Complemento de Endereço - Carlos Fernandes
-- 27.09.2010 - Ajuste para o Lay-out v2.00 - Carlos Fernandes
-- 10.12.2010 - Ajuste do Endereço/Local de Entrega - Carlos Fernandes
------------------------------------------------------------------------------------
as  
  
--select * from versao_nfe  
--select * from forma_condicao_pagamento  
--select * from vw_destinatario  
  
select      
  ns.cd_identificacao_nota_saida,
  ns.dt_nota_saida,      
  ns.cd_nota_saida,  
  vw.cd_tipo_mercado,
  vw.cd_tipo_pessoa,      
  vw.cd_destinatario,
  'E'                                                            as 'TAG',      

  ltrim(rtrim(cast(ltrim(rtrim(ns.nm_razao_social_nota))
                   + 
                   ltrim(rtrim(isnull(vw.nm_razao_social_complemento,''))) as varchar(60))))

                                                                  as 'xNome',      
      
  case when vw.cd_tipo_mercado=2 then
    'ISENTO'
  else
    case when ns.cd_inscest_nota_saida is null or ltrim(rtrim(ns.cd_inscest_nota_saida)) = '' then  
      case when isnull(vw.IsentoInscEstadual,'N') = 'S' then
        'ISENTO'
      else       
        ''
      end      
    else
      case when isnull(vw.IsentoInscEstadual,'N') = 'S' then
        'ISENTO'
      else       
        rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_inscest_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(14))))       
      end       
    end
  end    as 'IE',      
                                             
 -- ltrim(rtrim(cast(ns.cd_inscest_nota_saida as varchar(60))))    as 'IE',      
 cast(
  case when ns.cd_inscest_nota_saida is null or ltrim(rtrim(ns.cd_inscest_nota_saida)) = '' then       
    ''      
  else       
    replicate('0', 9 - len(rtrim(ltrim(cast(replace(replace(replace(replace(c.cd_suframa_cliente,'.',''),'-',''),'/',''),' ','') as varchar(9)))))) +      
    rtrim(ltrim(cast(replace(replace(replace(replace(c.cd_suframa_cliente,'.',''),'-',''),'/',''),' ','') as varchar(9))))       
      
  end as varchar(09))                                              as 'ISUF',      

--  ltrim(rtrim(cast(c.cd_suframa_cliente as varchar(20))))        as 'ISUF',      
      
        
  'E02'                                                          as 'C02',      
      
  --select * from tipo_pessoa        
--  case when vw.cd_tipo_pessoa = 1 then 'CNPJ>' else 'CPF>' end as 'ITpessoa',      
      
  case when vw.cd_tipo_pessoa = 1 then 'CNPJ>' else 'CPF>' end +      
      
--  case when vw.cd_tipo_pessoa = 1 then '</CNPJ' else '</CPF' end as 'FTpessoa',      
  --Jurídica ( CNPJ )      

  case when vw.cd_tipo_pessoa = 1 then      
    case when ns.cd_cnpj_nota_saida is null or ltrim(rtrim(ns.cd_cnpj_nota_saida)) = '' then       
      ''      
    else       
      replicate('0', 14 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(14)))))) +      
      rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(14))))       
    end       
--    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('0000000000000000', ns.cd_cnpj_nota_saida) as varchar(20))))      
  else      
--    cast('' as varchar(14))      
    case when ns.cd_cnpj_nota_saida is null or ltrim(rtrim(ns.cd_cnpj_nota_saida)) = '' then       
      ''      
    else       
      replicate('0', 11 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11)))))) +      
      rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11))))       
    end       
      
  end      
      
  +      
      
   case when vw.cd_tipo_pessoa = 1 then '</CNPJ' else '</CPF' end                          as 'CNPJ',      
      
   
  case when vw.cd_tipo_mercado = 2 then
  --'00000000000000'
  ''
  else
  case when vw.cd_tipo_pessoa = 1 then      
    case when ns.cd_cnpj_nota_saida is null or ltrim(rtrim(ns.cd_cnpj_nota_saida)) = '' then       
      ''      
    else       
      replicate('0', 14 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(14)))))) +      
      rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(14))))       
    end       
--    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('0000000000000000', ns.cd_cnpj_nota_saida) as varchar(20))))      
  else      
--    cast('' as varchar(14))      
    case when ns.cd_cnpj_nota_saida is null or ltrim(rtrim(ns.cd_cnpj_nota_saida)) = '' then       
      ''      
    else       
      replicate('0', 11 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11)))))) +      
      rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11))))       
    end       
      
    end
  end                                                  as 'CNPJ2',   
   
  --Tipo de Pessoa
   
  case when vw.cd_tipo_pessoa = 2 then      
    case when ns.cd_cnpj_nota_saida is null or ltrim(rtrim(ns.cd_cnpj_nota_saida)) = '' then       
      ''      
    else       
      replicate('0', 11 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11)))))) +      
      rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11))))       
    end       
--    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('00000000000', ns.cd_cnpj_nota_saida) as varchar(20))))      
  end                                                              as 'CPF',      
      
  'E05'                                                            as 'enderDest',      
  ltrim(rtrim(cast(ns.nm_endereco_nota_saida as varchar(60))))     as 'xLgr',      
  ltrim(rtrim(cast(ns.nm_compl_endereco_nota as varchar(60))))     as 'xCpl',      
  ltrim(rtrim(cast(ns.cd_numero_end_nota_saida as varchar(60))))   as 'nro',       
  ltrim(rtrim(cast(ns.nm_bairro_nota_saida as varchar(60))))       as 'xBairro',      

  --Mercado Externo
  case when vw.cd_tipo_mercado=2 then
    '9999999'
  else
    ltrim(rtrim(cast(cid.cd_cidade_ibge as varchar(60))))         
  end                                                              as 'cMun',        

  case when vw.cd_tipo_mercado=2 then
   'EXTERIOR'
  else
    ltrim(rtrim(cast(cid.nm_cidade as varchar(60))))            
  end                                                              as 'xMun',      
  case
 when vw.cd_tipo_mercado=2 then
    'EX'
  else
    ltrim(rtrim(cast(est.sg_estado as varchar(60)))) 
  end                                                              as 'UF',      
      
  case when ns.cd_cep_nota_saida is null or ltrim(rtrim(ns.cd_cep_nota_saida)) = '' then       
    ''      
  else       
    replicate('0', 8 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cep_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(8)))))) +      
    rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cep_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(8))))       
  end                                                                          as 'CEP',      
      
--ltrim(rtrim(cast(replace(ns.cd_cep_nota_saida,'-','') as varchar(60))))      as 'CEP',      
  ltrim(rtrim(cast(p.cd_bacen_pais as varchar(60))))                           as 'cPais',      
  ltrim(rtrim(cast(p.nm_pais   as varchar(60))))                               as 'xPais',      
/*      
  case when substring(ltrim(rtrim(cast(replace(replace(replace(replace(cd_ddd_nota_saida + ' ' + ns.cd_telefone_nota_saida,'-',''),' ',''),'(',''),')','') as varchar(12)))),1,1) = '0' then      
    substring(ltrim(rtrim(cast(replace(replace(replace(replace(cd_ddd_nota_saida + ' ' + ns.cd_telefone_nota_saida,'-',''),' ',''),'(',''),')','') as varchar(12)))),2,12)          
  else      
    ltrim(rtrim(cast(replace(replace(replace(replace(cd_ddd_nota_saida + ' ' + ns.cd_telefone_nota_saida,'-',''),' ',''),'(',''),')','') as varchar(12))))          
  end                                                                          as 'fone'      
*/  

cast(  
replace(case when ns.cd_ddd_nota_saida is null then  
  ltrim(rtrim(cast((select cd_ddd_cidade from cidade where cd_cidade = c.cd_cidade) as varchar(4))))  
else   
  case when len(ltrim(rtrim(cast(ns.cd_ddd_nota_saida as varchar(4))))) > 2 then  
    substring(ltrim(rtrim(cast(ns.cd_ddd_nota_saida as varchar(4)))),2,4)  
  else  
    ltrim(rtrim(cast(ns.cd_ddd_nota_saida as varchar(4))))  
  end  
end  
+ '' + ltrim(rtrim(replace(ns.cd_telefone_nota_saida,'-',''))),' ','')  as varchar(14)) as 'fone',    


-- select cd_cidade from cliente     
-- select * from cidade  
--  ltrim(rtrim(cast(replace(ns.cd_telefone_nota_saida,'-','') as varchar(60)))) as 'fone',

    --Endereço de Entrega------------------------------------------------------------------------

    case when ltrim(rtrim(isnull(ns.nm_endereco_entrega,''))) = ltrim(rtrim(isnull(ns.nm_endereco_nota_saida,''))) or
         ns.nm_endereco_entrega is null or isnull(ns.nm_endereco_entrega,'')=''
    then
      'S'
    else
      'N'
    end                                       as 'ic_local_entrega',

--     isnull(ns.cd_cnpj_entrega_nota,'')        as 'CNPJ_G02',
--     isnull(ns.nm_endereco_entrega,'')         as 'xLgr_G03',
--     isnull(ns.cd_numero_endereco_ent,'')      as 'nro_G04',
--     cast('' as varchar(60))                   as 'xCpl_G05',
--     isnull(ns.nm_bairro_entrega,'')           as 'xBairro_G06',
-- 
--     ( select top 1 cide.cd_cidade_ibge
--       from
--         Cidade cide with (nolock) 
--       where
--         cide.nm_cidade = ns.nm_cidade_entrega) as 'cMun_G07',
--           
--     ns.nm_cidade_entrega                       as 'xMun_G08',
--     ns.sg_estado_entrega                       as 'UF_G09',


    ltrim(rtrim(case when isnull(ns.cd_cnpj_entrega_nota,'')<>'' then
      isnull(ns.cd_cnpj_entrega_nota,'')     
    else
      cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(14))
    end))                                                          as 'CNPJ_G02',

    case when isnull(ns.nm_endereco_entrega,'')<>'' then 
       ns.nm_endereco_entrega 
    else
       cast(ns.nm_endereco_nota_saida as varchar(60))
    end                                       as 'xLgr_G03',
    case when isnull(ns.cd_numero_endereco_ent,'')<>'' then
      ns.cd_numero_endereco_ent               
    else
      ns.cd_numero_end_nota_saida
    end                                       as 'nro_G04',
    ''                                        as 'xCpl_G05',

    case when isnull(ns.nm_bairro_entrega,'')<>'' then
      ns.nm_bairro_entrega
    else
      ns.nm_bairro_nota_saida
    end                                        as 'xBairro_G06',


    ( select top 1 cide.cd_cidade_ibge
      from
        Cidade cide with (nolock) 
      where
        cide.nm_cidade = case when isnull(ns.nm_cidade_entrega,'')<>''
                         then
                           ns.nm_cidade_entrega
                         else
                           ns.nm_cidade_nota_saida
                         end                 ) as 'cMun_G07',
          
--select * from nota_saida

    case when isnull(ns.nm_cidade_entrega,'')<>'' then
      ns.nm_cidade_entrega                   
    else
      ns.nm_cidade_nota_saida
    end                                        as 'xMun_G08',

    case when isnull(ns.sg_estado_entrega,'')<>'' then
      ns.sg_estado_entrega
    else
      ns.sg_estado_nota_saida
    end                                         as 'UF_G09',

   cast('' as varchar(60))                     as 'E19_email'

   ----------------------------------------------------------------------------------------
      
--select * from cidade
 --Endereço de Entrega
      
from      
 nota_saida ns                      with (nolock)       
 left outer join Cliente c          with (nolock) on c.cd_cliente            = ns.cd_cliente  
 left outer join vw_destinatario vw with (nolock) on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and      
                                                     vw.cd_destinatario      = ns.cd_cliente       
 left outer join estado est         with (nolock) on est.cd_estado           = vw.cd_estado      
 left outer join cidade cid         with (nolock) on cid.cd_cidade           = vw.cd_cidade      
 left outer join pais p             with (nolock) on p.cd_pais               = vw.cd_pais   
  
--select * from vw_destinatario  
  
