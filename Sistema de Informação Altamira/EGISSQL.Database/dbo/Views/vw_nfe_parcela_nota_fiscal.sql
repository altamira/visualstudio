
CREATE VIEW vw_nfe_parcela_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_parcela_nota_fiscal
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
--Atualização           : 
------------------------------------------------------------------------------------
as
  
--select * from nota_saida_item  
--select * from nota_saida  
--select * from nota_saida_parcela  
  
select  
  ns.cd_nota_saida,  
  --ns.cd_nota_saida                                            as nfat,  
  
  dbo.fn_strzero(ns.cd_nota_saida,9)                                                              as nfat,  
  
  isnull(CONVERT(varchar, convert(numeric(14,2),round(ns.vl_total,6,2)),103),'0.00')              as vOrig,  
    
  
  ns.vl_total,                                                 
  
 isnull(CONVERT(varchar, convert(numeric(14,2),round(0.00,6,2)),103),'0.00')                        as vDesc,  
  
  isnull(CONVERT(varchar, convert(numeric(14,2),round(ns.vl_total,6,2)),103),'0.00')              as vLiq,  
  
  'Y07'                                                                                           as 'dup',  
  
  nsp.cd_ident_parc_nota_saida                                                                     as nDup,  
  
--  nsp.dt_parcela_nota_saida                                                                        as dVenc,  
  ltrim(rtrim(replace(convert(char,nsp.dt_parcela_nota_saida,102),'.','-')))                       as dVenc,  
  
  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsp.vl_parcela_nota_saida,6,2)),103),'0.00') as vDup  
    
from  
  nota_saida ns                           with (nolock)   
  inner join nota_saida_parcela nsp       with (nolock) on nsp.cd_nota_saida = ns.cd_nota_saida  
  
  
--select * from transportadora  
--select * from tipo_pagamento_frete  
--select * from nota_saida  
  
