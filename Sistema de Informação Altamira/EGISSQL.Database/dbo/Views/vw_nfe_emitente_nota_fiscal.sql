
CREATE VIEW vw_nfe_emitente_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_emitente_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 04.11.2008
--Atualização           : 26.08.2009 - Ajustes da consistência do Cep - Carlos/Luis
-- 14.08.2010 - Complemento de Endereço - Carlos Fernandes
-- 23.09.2010 - Modificação do tamanho do telefone lay-out v2.0 - Carlos / Luis 
------------------------------------------------------------------------------------
as

--select * from versao_nfe
--select * from forma_condicao_pagamento

select
  ns.cd_identificacao_nota_saida,
  ns.dt_nota_saida,
  ns.cd_nota_saida,
  'C'                                                                         as 'emit',
  rtrim(ltrim(cast(e.nm_empresa as varchar(60))))                             as 'xNome',                                       
  rtrim(ltrim(cast(e.nm_fantasia_empresa as varchar(60))))                    as 'xFant',

  rtrim(ltrim(replace(replace(replace(cast(e.cd_iest_empresa as varchar(16)),'.',''),'-',''),'/','')))  as 'IE',

  case when e.cd_iest_st_empresa is null or ltrim(rtrim(e.cd_iest_st_empresa)) = '' then 
    ''
  else 
    replicate('0', 14 - len(rtrim(ltrim(cast(e.cd_iest_st_empresa as varchar(14)))))) +
    rtrim(ltrim(cast(e.cd_iest_st_empresa as varchar(14)))) 

  end                                                                         as 'IEST',

  case when e.nm_inscricao_municipal is null or ltrim(rtrim(e.nm_inscricao_municipal)) = '' then 
    replicate('0',15)
  else 
    replicate('0', 15 - len(rtrim(ltrim(cast(e.nm_inscricao_municipal as varchar(15)))))) +
    rtrim(ltrim(cast(e.nm_inscricao_municipal as varchar(15)))) 

  end                                                                            as 'IM',

  --Código do CNAE---------------------------------------------------------------------------
 
  case when e.cd_cnae is null or ltrim(rtrim(e.cd_cnae)) = '' then 
    ''
  else 
    replicate('0', 7 - len(rtrim(ltrim(cast(e.cd_cnae as varchar(7)))))) +
    rtrim(ltrim(cast(e.cd_cnae as varchar(7)))) 

  end                                                                            as 'CNAE',

  'C02'                                                         as 'C02',
  cast(dbo.fn_Formata_Mascara('00000000000000',e.cd_cgc_empresa) as varchar(14)) as 'CNPJ',
  cast('' as varchar(14))                                                        as 'CPF',
  'C05'                                                                          as 'enderEmit',
  cast(rtrim(ltrim(e.nm_endereco_empresa)) as varchar(60) )                      as 'xLgr',
  cast(rtrim(ltrim(e.nm_complemento_endereco)) as varchar(60))                   as 'xCpl',
  ltrim(rtrim(cast(e.cd_numero as varchar(8))))                                  as 'nro', 
  ltrim(rtrim(cast(e.nm_bairro_empresa as varchar(60))))                         as 'xBairro',
  ltrim(rtrim(cast(cid.cd_cidade_ibge as varchar(8))))                           as 'cMun',  
  ltrim(rtrim(cast(cid.nm_cidade as varchar(60))))                               as 'xMun',
  ltrim(rtrim(cast(est.sg_estado as varchar(2))))                                as 'UF',

  -- Carlos Fernandes
 
  replicate('0', 8 - len(rtrim(ltrim(cast(replace(e.cd_cep,'-','') as varchar(8)))))) +
  rtrim(ltrim(cast(replace(e.cd_cep,'-','') as varchar(8))))                                   as 'CEP',
 
  ltrim(rtrim(cast(p.cd_bacen_pais as varchar(8))))                                            as 'cPais',
  ltrim(rtrim(cast(p.nm_pais as varchar(20))))                                                 as 'xPais',

  --select * from egisadmin.dbo.empresa
  cast(
  case when e.cd_telefone_empresa is null then
    '' 
  else 
    case when substring(ltrim(rtrim(cast(replace(replace(replace(replace(e.cd_telefone_empresa,'-',''),' ',''),'(',''),')','') as varchar(12)))),1,1) = '0' then
      substring(ltrim(rtrim(cast(replace(replace(replace(replace(e.cd_telefone_empresa,'-',''),' ',''),'(',''),')','') as varchar(12)))),2,12)    
    else
      ltrim(rtrim(cast(replace(replace(replace(replace(e.cd_telefone_empresa,'-',''),' ',''),'(',''),')','') as varchar(12))))    
    end 
  end  as varchar(14))                                                                         as 'fone',

  --Código de Regime para Simples Nacional
  cast(isnull(rt.cd_nfe_regime,'') as char(1))                                                 as 'C21_CRT'   
   
  --select * from regime_tributario

from
  nota_saida                            ns with (nolock) 
  left outer join egisadmin.dbo.empresa e  with (nolock) on e.cd_empresa  = dbo.fn_empresa() 
  left outer join cnae  c                  with (nolock) on c.cd_cnae     = e.cd_cnae
  left outer join Pais  p                  with (nolock) on p.cd_pais     = e.cd_pais
  left outer join Estado est               with (nolock) on est.cd_estado = e.cd_estado
  left outer join Cidade cid               with (nolock) on cid.cd_estado = e.cd_estado and
                                                            cid.cd_cidade = e.cd_cidade

  left outer join versao_nfe v             with (nolock) on v.cd_empresa  = e.cd_empresa
  left outer join regime_tributario rt     with (nolock) on rt.cd_regime_tributario = v.cd_regime_tributario

--where
--  isnull(ns.ic_nfe_nota_saida,'N') = 'N'

