
------------------------------------------------------------------------------------ 
--sp_helptext vw_nfe_informacao_compra_v200
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                        2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Informações de Compra - > Compras Públicas
--                        
--
--Data                  : 27.09.2010 
--Atualização           : 
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes

------------------------------------------------------------------------------------

CREATE VIEW vw_nfe_informacao_compra_v200
as

--select * from nota_saida_item



select
  ns.cd_identificacao_nota_saida,
  ns.cd_nota_saida,  
  nsi.cd_item_nota_saida,
  ns.dt_nota_saida,
  cast('' as varchar(17)) as 'xNFEmp',
  cast('' as varchar(60)) as 'xPed',
  cast('' as varchar(60)) as 'xCont'

from
  nota_saida ns                                     with (nolock) 
  inner join nota_saida_item nsi                    with (nolock) on nsi.cd_nota_saida             = ns.cd_nota_saida
  left outer join vw_destinatario vw                with (nolock) on vw.cd_destinatario            = ns.cd_cliente and
                                                                     vw.cd_tipo_destinatario       = ns.cd_tipo_destinatario
  left outer join produto                       p   with (nolock) on p.cd_produto                  = nsi.cd_produto


