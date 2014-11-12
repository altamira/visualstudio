
CREATE VIEW vw_nfe_entrega_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_entrega_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Local de Entrega da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 04.04.2009
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from versao_nfe
--select * from forma_condicao_pagamento
--select * from vw_destinatario

select
  ns.cd_identificacao_nota_saida,
  ns.cd_nota_saida,
  'G'                                                            as 'entrega',

  case when ns.cd_cnpj_entrega_nota is not null then
    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('00000000000000',
                            ns.cd_cnpj_nota_saida) as varchar(14))))            
  else
    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('00000000000000',
                            ns.cd_cnpj_entrega_nota) as varchar(14))))     
  end                                                              as 'CNPJ',

  --Verificar como pode ser feito o CPF

  case when ns.cd_cnpj_entrega_nota is not null then
    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('00000000000000',
                            ns.cd_cnpj_nota_saida) as varchar(14))))            
  else
    ltrim(rtrim(cast(dbo.fn_Formata_Mascara('00000000000000',
                            ns.cd_cnpj_entrega_nota) as varchar(14))))     
  end                                                              as 'CPF',

  cast(rtrim(ltrim(ns.nm_endereco_entrega)) as varchar(60) )       as 'xLgr',
  cast(rtrim(ltrim(ns.nm_complemento_end_ent)) as varchar(60))     as 'xCpl',
  cast(rtrim(ltrim(ns.cd_numero_endereco_ent)) as varchar(10))     as 'nro', 
  cast(rtrim(ltrim(ns.nm_bairro_entrega)) as varchar(60))          as 'xBairro',
  cast(rtrim(ltrim(isnull(cid.cd_cidade_ibge,0))) as varchar(60))  as 'cMun',  
  cast(rtrim(ltrim(ns.nm_cidade_entrega)) as varchar(60))                                  as 'xMun',
  cast(rtrim(ltrim(ns.sg_estado_entrega)) as varchar(2))                                   as 'UF',
  cast(rtrim(ltrim(dbo.fn_Formata_Mascara('99999999',ns.cd_cep_entrega))) as varchar(60))  as 'CEP'

   

from
 nota_saida ns                      with (nolock) 
 left outer join Cliente c          with (nolock) on c.cd_cliente            = ns.cd_cliente
 left outer join vw_destinatario vw with (nolock) on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                                                     vw.cd_destinatario      = ns.cd_cliente 
 left outer join cidade cid         with (nolock) on cid.nm_cidade           = ns.nm_cidade_entrega

--where
--  ns.nm_endereco_entrega is not null

--select * from vw_destinatario

