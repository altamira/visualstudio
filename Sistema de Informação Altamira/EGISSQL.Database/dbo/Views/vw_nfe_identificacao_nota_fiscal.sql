
CREATE VIEW vw_nfe_identificacao_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_identificacao_nota_fiscal
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
--Atualização           : 22.11.2008 - Xml - Carlos Fernandes
-- 17.06.2010 - Finalidade da Nota Fiscal Eletrônica - Carlos Fernandes
-- 14.08.2010 - Complemento dos Campos - Carlos Fernandes 
-- 23.09.2010 - Mudança para o lay-out v2.0 - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from versao_nfe
--select * from forma_condicao_pagamento
--select * from serie_nota_fiscal

select
  ns.cd_identificacao_nota_saida,
  ns.cd_nota_saida,
  ns.dt_nota_saida,

  'B'                                                                                           as 'TAG',

  ltrim(rtrim(cast(est.cd_ibge_estado as varchar(2))))                                          as 'cUF',
  --ltrim(rtrim(cast(ns.cd_nota_saida as varchar(10))))                                        as 'cNF',
  dbo.fn_strzero(ns.cd_identificacao_nota_saida,08)                                             as 'cNF',
  ltrim(rtrim(cast(ns.cd_mascara_operacao as varchar(60))))                                     as 'natOp', 
  ltrim(rtrim(cast(ns.nm_operacao_fiscal  as varchar(60))))                                     as 'DesNatOP',
  ltrim(rtrim(cast(isnull(fcp.cd_digito_forma_condicao,0) as varchar(10))))                     as 'indPag',

  --Checar na Nota Fiscal

  dbo.fn_strzero(case when isnull(ns.cd_modelo_serie_nota,'')<>'' and 
                   ns.cd_modelo_serie_nota <> snf.cd_modelo_serie_nota 
  then isnull(ns.cd_modelo_serie_nota,'55') else isnull(snf.cd_modelo_serie_nota,'55') end,2)      as 'mod',

  case when ns.qt_serie_nota_fiscal = 0 then
    ltrim(rtrim(cast(isnull(ns.qt_serie_nota_fiscal,0) as varchar(3))))
  else
    ltrim(rtrim(cast(isnull(snf.qt_serie_nota_fiscal,0) as varchar(3))))
  end                                                                                           as 'serie',

  ltrim(rtrim(cast(ns.cd_identificacao_nota_saida as varchar(9))))                              as 'nNF',

  ltrim(rtrim(replace(convert(char,ns.dt_nota_saida,102),'.','-')))                             as 'dEmi',

  ltrim(rtrim(replace(convert(char,ns.dt_saida_nota_saida,102),'.','-')))                       as 'dSaiEnt',
  
  --Hora Saída/Entrada da Mercadoria
  --Verificar como podemos gravar e cadastrar o horário correto no sistema
  --14.08.2010

  case when ns.hr_nota_saida is null
  then '00:00:00'
  else
    ns.hr_nota_saida
  end                                                                                           as 'hSaiEnt',


  case when isnull(ns.cd_tipo_operacao_fiscal,0)=2 then '1' else '0' end                        as 'tpNF',
  ltrim(rtrim(cast(isnull(cid.cd_cidade_ibge,0) as varchar(10))))                               as 'cMunFG',
 
 --Nota Fiscal Referenciada

  '1'                                                                                           as 'NFref',

  case when isnull(nfr.cd_nota_referencia,0)>0 and
            isnull(vwr.chaveAcesso,'')<>''
  then
    substring(isnull(vwr.chaveAcesso,''),4,len(isnull(vwr.chaveacesso,'')))                 
  else
    ''
  end                                                                                           as 'refNFe',

  --Dados da Nota Fiscal referenciada
  --select * from nota_saida_referenciada

  --Complemento para lay-out 2.0---------------------------------------------------------------------------------------

  CAST(vwr.cUF  as char(2))              as B15_cUF,
  cast(vwr.AAMM as varchar(4))           as B16_AAMM,
  cast(vwr.CNPJ as varchar(14))          as B17_CNPJ,   --CNPJ
  cast(vwr.mod  as varchar(2))           as B18_MOD,    --MODELO
  cast(vwr.serie as varchar(3))          as B19_SERIE,  --SERIE
  vwr.cd_nota_saida                      as B20_nNF,

  --antes Carlos --> 23.06.2010
  --'' as 'refNFe',

  ''                                                                                            as 'RefNF',
 
  cast('' as varchar(14))                                                                       as 'CNPJ',
  'AAMM' as 'AAMM',  
  
--  ns.cd_nota_saida                                                                           as 'nNf',  

  ltrim(rtrim(cast(( select top 1 cd_formato_danfe_nfe from Versao_NFE with (nolock)
    where isnull(ic_ativa_versao_nfe,'N') = 'S' ) as varchar(1))))                              as 'tpImp',

  ltrim(rtrim(cast(( select top 1 cd_forma_emissao_nfe   from Versao_NFE with (nolock)
    where isnull(ic_ativa_versao_nfe,'N') = 'S' ) as varchar(1))))                              as 'tpEmis',
  
  (select top 1 cDV
   from vw_nfe_chave_acesso vw  with (nolock) where vw.cd_nota_saida = ns.cd_nota_saida )       as 'cDV',
  
  rtrim(ltrim(cast(( select top 1 cd_ambiente_nfe       from Versao_NFE with (nolock)
    where isnull(ic_ativa_versao_nfe,'N') = 'S' ) as varchar(10))))                             as 'tpAmb',
  

  case when isnull(ns.cd_finalidade_nfe,0)=0 or isnull(ns.cd_finalidade_nfe,0)=1 then
    ltrim(rtrim(cast(( select top 1 cd_finalidade_nfe       from Versao_NFE with (nolock)
      where isnull(ic_ativa_versao_nfe,'N') = 'S' ) as varchar(5))))                        
  else
    ltrim(rtrim(cast(isnull(ns.cd_finalidade_nfe,0) as varchar(5))))                        


  end                                                                                           as 'finNFE',

   ltrim(rtrim(cast(( select top 1 cd_digito_processo_nfe  from Versao_NFE with (nolock)
    where isnull(ic_ativa_versao_nfe,'N') = 'S' ) as varchar(8))))                              as 'procEmi',

  ( select top 1 nm_processo_emissao_nfe from Versao_NFE with (nolock)
    where isnull(ic_ativa_versao_nfe,'N') = 'S' )                                               as 'verProc',

  nfr.cd_nota_referencia,

  --Complemento para lay-out 2.0---------------------------------------------------------------------------------------
  
  CAST('' as char(2))             as B20b_cUF,
  cast('' as varchar(4))          as B20C_AAMM,
  cast('' as varchar(14))         as B20D_CNPJ,   --CNPJ
  cast('' as varchar(11))         as B20E_CPF,    --CPF
  cast('' as varchar(14))         as B20F_IE,     --IE
  cast('' as varchar(2))          as B20F_MOD,    --MODELO
  cast('000' as varchar(3))       as B20G_SERIE,  --SERIE
  0                               as B20H_nNF,
  cast('' as varchar(44))         as B20I_refCTe,
  0                               as B20J_nrefECF,
  cast('' as varchar(2))          as B20K_mod,
  cast('' as varchar(3))          as B201_NECF,
  cast('' as varchar(6))          as B20m_nCOO,

  --Contingência---------------------------------------------------------------------------------------------------------

  cast('' as varchar(8))          as B28_dhCont, --Data e Hora de Entrada em Contingência,
  cast('' as varchar(256))        as B29_xjust   --Justificativa de entrada em Contingência
 


    
from
  nota_saida ns                                with (nolock) 
  left outer join egisadmin.dbo.empresa e      with (nolock) on e.cd_empresa             = dbo.fn_empresa() 
  left outer join cnae  c                      with (nolock) on c.cd_cnae                = e.cd_cnae
  left outer join Pais  p                      with (nolock) on p.cd_pais                = e.cd_pais
  left outer join Estado est                   with (nolock) on est.cd_estado            = e.cd_estado
  left outer join Cidade cid                   with (nolock) on cid.cd_estado            = e.cd_estado and
                                                                cid.cd_cidade            = e.cd_cidade
  left outer join Condicao_Pagamento cp        with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
  left outer join Forma_Condicao_Pagamento fcp with (nolock) on fcp.cd_forma_condicao    = cp.cd_forma_condicao
  left outer join Serie_Nota_Fiscal snf        with (nolock) on snf.cd_serie_nota_fiscal = ns.cd_serie_nota

  left outer join Nota_Saida_Referenciada nfr  with (nolock) on nfr.cd_nota_saida        = ns.cd_nota_saida
  left outer join vw_nfe_chave_acesso     vwr  with (nolock) on vwr.cd_nota_saida        = nfr.cd_nota_referencia  
  
--select * from serie_nota_fiscal
--select top 10 * from cidade
--select sg_estado_saida,* from nota_saida
 
