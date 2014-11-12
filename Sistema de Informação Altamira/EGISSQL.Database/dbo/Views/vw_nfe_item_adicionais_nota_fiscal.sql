
CREATE VIEW vw_nfe_item_adicionais_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_item_adicionais_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Detalhe Produto/Serviço da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from nota_saida_item

select
  ns.cd_nota_saida,
  'V'                                                         as 'V01',
  cast(ds_item_nota_saida as varchar(500))                    as 'infAdProd'
      
--select * from dI  

from
  nota_saida ns                           with (nolock) 
  inner join nota_saida_item nsi          with (nolock) on nsi.cd_nota_saida          = ns.cd_nota_saida

