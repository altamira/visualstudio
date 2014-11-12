
CREATE VIEW vw_nfe_destintario_nota_fiscal_texto
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_destintario_nota_fiscal_texto
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
--Atualização           : 04.04.2009 - Ajuste para Pessao Física - Carlos Fernandes
--
-- 06.04.2009 - Ajuste do Telefone - Carlos Fernandes
-- 10.04.2009 - Ajuste da IE p/ pessoa Física - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from versao_nfe
--select * from forma_condicao_pagamento
--select * from vw_destinatario

select    
  ns.dt_nota_saida,    
  ns.cd_nota_saida,    
  'E'                                                            as 'TAG',    
  ltrim(rtrim(cast(ns.nm_razao_social_nota as varchar(60))))     as 'xNome',    

  case when vw.cd_tipo_pessoa = 1 then
    case when ns.cd_inscest_nota_saida is null or ltrim(rtrim(ns.cd_inscest_nota_saida)) = '' then     
      ''    
    else     
      rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_inscest_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(14))))     
    end

  --Física
  else
    'ISENTO' 
  end                                                              as 'IE',    
                                           
 -- ltrim(rtrim(cast(ns.cd_inscest_nota_saida as varchar(60))))    as 'IE',    
  case when ns.cd_inscest_nota_saida is null or ltrim(rtrim(ns.cd_inscest_nota_saida)) = '' then     
    ''    
  else     
    replicate('0', 9 - len(rtrim(ltrim(cast(replace(replace(replace(replace(c.cd_suframa_cliente,'.',''),'-',''),'/',''),' ','') as varchar(9)))))) +    
    rtrim(ltrim(cast(replace(replace(replace(replace(c.cd_suframa_cliente,'.',''),'-',''),'/',''),' ','') as varchar(9))))     
    
  end    as 'ISUF',    
--  ltrim(rtrim(cast(c.cd_suframa_cliente as varchar(20))))        as 'ISUF',    
    
      
  'E02'                                                          as 'C02',    

  vw.cd_tipo_pessoa,
    
  --select * from tipo_pessoa      
--  case when vw.cd_tipo_pessoa = 1 then 'CNPJ>' else 'CPF>' end as 'ITpessoa',    
    
/*  case when vw.cd_tipo_pessoa = 1 then 'CNPJ>' else 'CPF>' end +    */
    
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
    
/*  +    
    
   case when vw.cd_tipo_pessoa = 1 then '</CNPJ' else '</CPF' end           */               as 'CNPJ',    
    
    
  case when vw.cd_tipo_pessoa = 2 then    
    case when ns.cd_cnpj_nota_saida is null or ltrim(rtrim(ns.cd_cnpj_nota_saida)) = '' then     
      ''    
    else     
      replicate('0', 11 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11)))))) +    
      rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cnpj_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(11))))     
    end     
--    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('00000000000', ns.cd_cnpj_nota_saida) as varchar(20))))    
  end                                                              as 'CPF',    
    
  'E05'     
                                                       as 'enderDest',    
  --Endereço

  case when ns.nm_endereco_nota_saida <> vw.nm_endereco or ns.nm_endereco_nota_saida is null then
    ltrim(rtrim(cast(vw.nm_endereco            as varchar(60))))
  else
    ltrim(rtrim(cast(ns.nm_endereco_nota_saida as varchar(60)))) 
  end                                                              as 'xLgr',    

  --Complemento
  case when ns.nm_compl_endereco_nota <> vw.nm_complemento_endereco then
    ltrim(rtrim(cast(vw.nm_complemento_endereco as varchar(60))))
  else
    ltrim(rtrim(cast(ns.nm_compl_endereco_nota as varchar(60))))   
  end                                                              as 'xCpl',    

  --Número
  case when ns.cd_numero_end_nota_saida<>vw.cd_numero_endereco or ns.cd_numero_end_nota_saida is null then
    ltrim(rtrim(cast(vw.cd_numero_endereco as varchar(60))))  
  else
    ltrim(rtrim(cast(ns.cd_numero_end_nota_saida as varchar(60))))  
  end                                                              as 'nro',     

  --Bairro
  case when ns.nm_bairro_nota_saida<>vw.nm_bairro or ns.nm_bairro_nota_saida is null then
    ltrim(rtrim(cast(vw.nm_bairro            as varchar(60))))
  else
    ltrim(rtrim(cast(ns.nm_bairro_nota_saida as varchar(60)))) 
  end                                                              as 'xBairro',    

  ltrim(rtrim(cast(cid.cd_cidade_ibge as varchar(60))))            as 'cMun',      
  ltrim(rtrim(cast(cid.nm_cidade as varchar(60))))                 as 'xMun',    
  ltrim(rtrim(cast(est.sg_estado as varchar(60))))                 as 'UF',    
    
  case when ns.cd_cep_nota_saida is null or ltrim(rtrim(ns.cd_cep_nota_saida)) = '' then     
    ''    
  else     
    replicate('0', 8 - len(rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cep_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(8)))))) +    
    rtrim(ltrim(cast(replace(replace(replace(replace(ns.cd_cep_nota_saida,'.',''),'-',''),'/',''),' ','') as varchar(8))))     
  end                                                                          as 'CEP',    
    
--ltrim(rtrim(cast(replace(ns.cd_cep_nota_saida,'-','') as varchar(60))))      as 'CEP',    
  ltrim(rtrim(cast(p.cd_bacen_pais as varchar(60))))                           as 'cPais',    
  ltrim(rtrim(cast(p.nm_pais   as varchar(60))))                               as 'xPais',    
    
  case when vw.cd_telefone <> ns.cd_telefone_nota_saida or ns.cd_telefone_nota_saida is null then
    case when substring(ltrim(rtrim(cast(replace(replace(replace(replace(vw.cd_telefone,'-',''),' ',''),'(',''),')','') as varchar(12)))),1,1) = '0' then    
       substring(ltrim(rtrim(cast(replace(replace(replace(replace(vw.cd_telefone,'-',''),' ',''),'(',''),')','') as varchar(12)))),2,12)        
    else    
       ltrim(rtrim(cast(replace(replace(replace(replace(vw.cd_telefone,'-',''),' ',''),'(',''),')','') as varchar(12))))        
     end                                                                          
    else
  case when substring(ltrim(rtrim(cast(replace(replace(replace(replace(ns.cd_telefone_nota_saida,'-',''),' ',''),'(',''),')','') as varchar(12)))),1,1) = '0' then    
    substring(ltrim(rtrim(cast(replace(replace(replace(replace(ns.cd_telefone_nota_saida,'-',''),' ',''),'(',''),')','') as varchar(12)))),2,12)        
  else    
    ltrim(rtrim(cast(replace(replace(replace(replace(ns.cd_telefone_nota_saida,'-',''),' ',''),'(',''),')','') as varchar(12))))        
  end
  end                                                                           as 'fone'    
    
--  ltrim(rtrim(cast(replace(ns.cd_telefone_nota_saida,'-','') as varchar(60)))) as 'fone'    
    
from    
 nota_saida ns                      with (nolock)     
 left outer join Cliente c          with (nolock) on c.cd_cliente            = ns.cd_cliente    
 left outer join vw_destinatario vw with (nolock) on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and    
                                                     vw.cd_destinatario      = ns.cd_cliente     
 left outer join estado est         with (nolock) on est.cd_estado           = vw.cd_estado    
 left outer join cidade cid         with (nolock) on cid.cd_cidade           = vw.cd_cidade    
 left outer join pais p             with (nolock) on p.cd_pais               = vw.cd_pais 

--select * from vw_destinatario

