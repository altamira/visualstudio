
CREATE VIEW vw_nfe_adicional_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_adicional_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Informações Adicionais da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 06.11.2008
--Atualização           : 24.11.2008
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from nota_saida_item
--select * from nota_saida
--select * from nota_saida_parcela

select
  ns.cd_identificacao_nota_saida,
  ns.cd_nota_saida,
  'Z01'                                                          as 'infAdic',
  cast('' as varchar(2000))                                      as 'infAdFisco',
  --cast('' as varchar(5000))                                    as 'infCpf',
  cast(ns.ds_obs_compl_nota_saida as varchar(5000))              as 'infCpf',
  'Z04'                                                          as 'obsCont',
  cast('' as varchar(20))                                        as 'xCampo',
  cast('' as varchar(60))                                        as 'xTexto',
  cast('' as varchar)                                            as 'obsFisco',
  'Z10'                                                          as 'procRef',
  cast('' as varchar(60))                                        as 'nProc',
  --Não tem no Egis
  0                                                              as 'indProc',  --> 0 : SEFAZ,

  cast(substring(ns.ds_obs_compl_nota_saida,1,250)    as varchar(250))   as 'infCpf1',
  cast(substring(ns.ds_obs_compl_nota_saida,251,250)  as varchar(250))   as 'infCpf2',
  cast(substring(ns.ds_obs_compl_nota_saida,501,250)  as varchar(250))   as 'infCpf3',
  cast(substring(ns.ds_obs_compl_nota_saida,751,250)  as varchar(250))   as 'infCpf4',
  cast(substring(ns.ds_obs_compl_nota_saida,1001,250) as varchar(250))   as 'infCpf5',
  cast(substring(ns.ds_obs_compl_nota_saida,1251,250) as varchar(250))   as 'infCpf6',
  cast(substring(ns.ds_obs_compl_nota_saida,1501,250) as varchar(250))   as 'infCpf7',
  cast(substring(ns.ds_obs_compl_nota_saida,1751,250) as varchar(250))   as 'infCpf8',
  cast(substring(ns.ds_obs_compl_nota_saida,2001,250) as varchar(250))   as 'infCpf9',
  cast(substring(ns.ds_obs_compl_nota_saida,2251,250) as varchar(250))   as 'infCpf10',
  cast(substring(ns.ds_obs_compl_nota_saida,2501,250) as varchar(250))   as 'infCpf11',
  cast(substring(ns.ds_obs_compl_nota_saida,2751,250) as varchar(250))   as 'infCpf12',
  cast(substring(ns.ds_obs_compl_nota_saida,3001,250) as varchar(250))   as 'infCpf13',
  cast(substring(ns.ds_obs_compl_nota_saida,3251,250) as varchar(250))   as 'infCpf14',
  cast(substring(ns.ds_obs_compl_nota_saida,3501,250) as varchar(250))   as 'infCpf15',
  cast(substring(ns.ds_obs_compl_nota_saida,3751,250) as varchar(250))   as 'infCpf16',
  cast(substring(ns.ds_obs_compl_nota_saida,4001,250) as varchar(250))   as 'infCpf17',
  cast(substring(ns.ds_obs_compl_nota_saida,4251,250) as varchar(250))   as 'infCpf18',
  cast(substring(ns.ds_obs_compl_nota_saida,4751,250) as varchar(250))   as 'infCpf19'

  --Divisao dos Dados Adicionais-------------------------------------------------------------------------------
  

from
  nota_saida ns                           with (nolock) 

--select * from nota_saida

