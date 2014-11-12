
CREATE VIEW vw_nfe_dados_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_raiz_nota_saida
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Dados da Nota Fiscal Eletrônica
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from versao_nfe

select
  ns.cd_nota_saida,
  'A'                                                                                        as 'TAG',
  ( select top 1 sg_versao_nfe from Versao_NFE where isnull(ic_ativa_versao_nfe,'N') = 'S' ) as 'VERSAO',  

  'versao='+
  '"'+rtrim(ltrim(( select top 1 sg_versao_nfe from Versao_NFE where isnull(ic_ativa_versao_nfe,'N') = 'S')) )+
  '"'+'>'      
                                                                                             as 'VERSAO_A',

  'NFe'+
  ( select top 1 ChaveAcesso   from vw_nfe_chave_acesso vw 
    where 
      vw.cd_nota_saida = ns.cd_nota_saida )                                                  as 'Id',


  'infNFe Id="NFe' +
  (select top 1 ChaveAcesso
   from
     vw_nfe_chave_acesso vw 
   where
     vw.cd_nota_saida = ns.cd_nota_saida)
   +'" versao="' +
   rtrim(ltrim(( select top 1 sg_versao_nfe 
     from
       Versao_NFE )))
                                                                                        as 'A_DADOS'

from
  nota_saida ns with (nolock) 

 
