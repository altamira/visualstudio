
CREATE VIEW vw_nfe_detalhe_produto_servico
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_detalhe_produto_servico
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


select  
--  'H'                                                  as 'det',  

  ns.cd_nota_saida,  
  'det nitem="'+rtrim(ltrim(cast(nsi.cd_item_nota_saida as varchar)))+'"' as det,
  nsi.cd_item_nota_saida                               as 'nItem'

--  count(nsi.cd_item_nota_saida)                      as 'nItem'  

from  
  nota_saida ns                  with (nolock)   
  inner join nota_saida_item nsi with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida  

--group by  
--  ns.cd_nota_saida  


