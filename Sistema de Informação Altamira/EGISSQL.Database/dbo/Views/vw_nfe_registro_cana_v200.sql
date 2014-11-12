
------------------------------------------------------------------------------------ 
--sp_helptext vw_nfe_registro_cana_v200
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                        2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Registro de Cana
--                        
--
--Data                  : 27.09.2010 
--Atualização           : 
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes

------------------------------------------------------------------------------------

CREATE VIEW vw_nfe_registro_cana_v200
as

--select * from nota_saida_item
-- select
--    pfi.*,
--    i.*
--    
-- from
--   Parametro_Faturamento_Imposto pfi
--   left outer join Imposto_Simples i with (nolock) on i.cd_imposto_simples = pfi.cd_imposto_simples
-- where
--   pfi.cd_empresa = dbo.fn_empresa()



select
  ns.cd_nota_saida,  
  nsi.cd_item_nota_saida,
  ns.dt_nota_saida,
  cast('' as varchar) as safra,
  cast('' as varchar) as ref,
  cast('' as varchar) as dia,
  cast('' as varchar) as qtde,
  cast('' as varchar) as qTotMes,
  cast('' as varchar) as qTotAnt,
  cast('' as varchar) as qTotGer,
  cast('' as varchar) as xDed,
  cast('' as varchar) as vDed,
  cast('' as varchar) as vFor,
  cast('' as varchar) as vTotDet,
  cast('' as varchar) as vLiqFor


from
  nota_saida ns                                     with (nolock) 
  inner join nota_saida_item nsi                    with (nolock) on nsi.cd_nota_saida             = ns.cd_nota_saida
  left outer join vw_destinatario vw                with (nolock) on vw.cd_destinatario            = ns.cd_cliente and
                                                                     vw.cd_tipo_destinatario       = ns.cd_tipo_destinatario
  left outer join produto                       p   with (nolock) on p.cd_produto                  = nsi.cd_produto


