
CREATE VIEW vw_nfe_imposto_importacao_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_imposto_importacao_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Local da Retirada da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as


select
  nsi.cd_item_nota_saida,
  nsi.cd_nota_saida,
  'P'                                                            as 'II',
  isnull(replace(CONVERT(varchar, convert(numeric(12,4),round(nsi.vl_total_item,6,2)),103),'.','.'),'')            as 'vBC',
  isnull(replace(CONVERT(varchar, convert(numeric(12,4),round(nsi.vl_desp_aduaneira_item,6,2)),103),'.','.'),'')   as 'vDespAdu',
  isnull(replace(CONVERT(varchar, convert(numeric(12,4),round(nsi.vl_ii,6,2)),103),'.','.'),'')                    as 'vl_ii',
  cast('' as varchar(10))                                           as 'vl_iof'
  --nsi.vl_iof  
  
from
  nota_saida_item nsi                               with (nolock)
  inner join nota_saida ns                          with (nolock) on ns.cd_nota_saida            = nsi.cd_nota_saida
    

--select * from nota_saida_item
--select cd_estado,* from nota_saida
