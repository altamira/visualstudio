
CREATE VIEW vw_nfe_produto_info_adicional
------------------------------------------------------------------------------------ 
--sp_helptext vw_nfe_produto_info_adicional
 ------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                        2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Detalhe Produto/Serviço da Nota Fiscal 
--                        Dados Adicionais do Produto
--
--Data                  : 05.11.2008
--Atualização           : 23.11.2008 - Ajustes Diversos - Carlos Fernandes
-- 29.11.2008 - Dados do IPI - Carlos Fernandes
-- 11.08.2009 - Ajustes Diversos - Carlos Fernandes
-- 09.09.2009 - Desenvolvimento - Carlos Fernandes
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes

------------------------------------------------------------------------------------
as

--select * from nota_saida_item

select
  ns.cd_identificacao_nota_saida,
  ns.cd_nota_saida,  
  ns.dt_nota_saida,
  nsi.cd_item_nota_saida,

   --Descrição Técnica do Produto

   --case when isnull(p.ic_descritivo_nf_produto,'N') = 'S' then

   case when ltrim(rtrim(cast(nsi.ds_item_nota_saida as varchar(500))))<>'' 
   then
     ltrim(rtrim(cast(nsi.ds_item_nota_saida as varchar(250))))
   else
     case when isnull(p.ic_descritivo_nf_produto,'N') = 'S' then
         ltrim(rtrim(cast(p.ds_produto as varchar(250))))
     else
        cast('' as varchar(250))
     end
--    else
--       cast('' as varchar(250))
   end                                                                                              as 'infAdProd',

   --Descrição Técnica do Produto

   --case when isnull(p.ic_descritivo_nf_produto,'N') = 'S' then
   case when substring(ltrim(rtrim(cast(nsi.ds_item_nota_saida as varchar(500)))),251,250)<>'' 
   then
     substring(ltrim(rtrim(cast(nsi.ds_item_nota_saida as varchar(500)))),251,250)
   else
     case when isnull(p.ic_descritivo_nf_produto,'N') = 'S' then
         substring(ltrim(rtrim(cast(p.ds_produto as varchar(500)))),251,250)
     else
        cast('' as varchar(250))
     end
--    else
--       cast('' as varchar(500))
   end                                                                                              as 'infAdProdc'

        
          
--select * from dI  
--select * from nota_saida_item

from
  nota_saida ns                                     with (nolock) 
  inner join nota_saida_item nsi                    with (nolock) on nsi.cd_nota_saida             = ns.cd_nota_saida
  left outer join produto                       p   with (nolock) on p.cd_produto                  = nsi.cd_produto

