
CREATE VIEW vw_nfe_cobranca_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_cobranca_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Valores Totais da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 29.11.2008 - Dados da cobrança - Carlos Fernandes
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from nota_saida_item
--select * from nota_saida

select
  ns.cd_nota_saida,
  ns.cd_identificacao_nota_saida,
  'cobr><fat><nFat>'+
   isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') +
   '</nFat><vOrig>' +
   isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') + 
   '</vOrig><vDesc>0.00</vDesc><vLiq>' +
   isnull(CONVERT(varchar, convert(numeric(14,2),round(case when ns.vl_total       > 0 then ns.vl_total else null end,6,2)),103),'0.00') + 
   '</vLiq></fat>'
   +
   '<dup><nDup>'+isnull( (select top 1 nsp.cd_ident_parc_nota_saida
                   from nota_saida_parcela nsp
                   where nsp.cd_nota_saida = ns.cd_nota_saida ),'')+
   '</nDup><dVenc>'+
     isnull(( select top 1 ltrim(rtrim(replace(convert(char,nsp.dt_parcela_nota_saida,102),'.','-')))  
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida ),'') +
   '</dVenc><vDup>'+
     isnull(( select top 1 isnull(CONVERT(varchar, convert(numeric(14,2),round(case when vl_parcela_nota_saida       > 0 then vl_parcela_nota_saida else null end,6,2)),103),'0.00')
       from nota_saida_parcela nsp
       where nsp.cd_nota_saida = ns.cd_nota_saida ),'') +

    '/vDup></dup>'+
    '</cobr|'                                                 as 'Y_DADOS',
  'Y'                                                         as 'cobr',
  'Y02'                                                       as 'fat',

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida
  end                                                         as 'nFat',

  isnull(ns.vl_total,0)                                       as 'vOrig',
  0.00                                                        as 'vDesc',
  isnull(ns.vl_total,0)                                       as 'vLiq'

--  nsp.cd_parcela_nota_saida,
--  nsp.cd_ident_parc_nota_saida                                as 'nDup',
--  nsp.dt_parcela_nota_saida                                   as 'dVenc',
--  nsp.vl_parcela_nota_saida                                   as 'vDup',


  
from
  nota_saida ns                     with (nolock) 
--  inner join nota_saida_parcela nsp with (nolock) on nsp.cd_nota_saida = ns.cd_nota_saida

--select * from nota_saida_parcela
--select * from transportadora
--select * from tipo_pagamento_frete
--select * from nota_saida

