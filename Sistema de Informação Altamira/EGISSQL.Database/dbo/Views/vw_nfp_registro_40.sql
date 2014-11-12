
CREATE VIEW vw_nfp_registro_40        
------------------------------------------------------------------------------------        
--vw_nfp_registro_40        
------------------------------------------------------------------------------------        
--GBS - Global Business Solution                                        2008        
------------------------------------------------------------------------------------        
--Stored Procedure : Microsoft SQL Server 2000        
--Autor(es)             : Douglas de Paula Lopes        
--Banco de Dados : EGISSQL        
--Objetivo         : Nota Fiscal Paulista        
--Data                  : 25/06/2008            
--Atualização           :         
-- 03.07.2008 - Ajuste Geral - Carlos / Douglas        
-- 17.10.2008 - Complemento dos Campos Faltantes - Douglas de Paula Lopes         
-- 10.08.2009 - Nota Fiscais de Pedido sem Valor Comercial - Carlos Fernandes 

------------------------------------------------------------------------------------        
as        
        
select            
  ns.cd_nota_saida,
------------------------------------------------------------------------------------        
--FILTRO          
------------------------------------------------------------------------------------        
  ns.dt_nota_saida,        
------------------------------------------------------------------------------------           
--  isnull(ns.vl_bc_icms,0)                                     as VBC,      
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_bc_icms,6,2)),103),'.',','),'0.00')       as VBC,            
--  isnull(ns.vl_icms,0)                                        as VICMS,        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_icms,6,2)),103),'.',','),'0.00')          as VICMS,            
--  isnull(ns.vl_bc_subst_icms,0)                               as VBCST,        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_bc_subst_icms,6,2)),103),'.',','),'0.00') as VBCST,       
--  isnull(ns.vl_icms_subst,0)                                  as VST,             
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_icms_subst,6,2)),103),'.',','),'0.00') as VST,         
--  isnull(ns.vl_produto,0) + isnull(ns.vl_servico,0)           as VPROD,        
--  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_produto,6,2)),103),'.',','),'0.00') as VPROD,        

  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round((select 
     sum( round(i.vl_total_item,6,2) )
   from
      nota_saida_item i
   where
      ns.cd_nota_saida = i.cd_nota_saida ),6,2)),103),'.',','),'0.00')
  as VPROD,        

--  isnull(ns.vl_frete,0)                                       as VFRETE,        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_frete,6,2)),103),'.',','),'0.00') as VFRETE,        
--  isnull(ns.vl_seguro,0)                                      as VSEG,       
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_seguro,6,2)),103),'.',','),'0.00') as VSEG,       
--  isnull(ns.vl_desconto_nota_saida,0)                         as VDESC,        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_desconto_nota_saida,6,2)),103),'.',','),'0.00') as VDESC,        
--  isnull(ns.vl_ipi,0)                                         as VIPI,        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_ipi,6,2)),103),'.',','),'0.00') as VIPI,       
--  isnull(ns.vl_desp_acess,0)                                  as VOUTRO,        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_desp_acess,6,2)),103),'.',','),'0.00') as VOUTRO,        
--  isnull(ns.vl_total,0)                                       as VNF,        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(ns.vl_total,6,2)),103),'.',','),'0.00') as VNF,        
  cast('0,00' as varchar)                                         as VSERV,        
  cast('0,00' as varchar)                                         as PISS,        
  cast('0,00' as varchar)                                         as VISS        
from        
  nota_saida ns with (nolock)        
where
  isnull(ic_nfp_nota_saida,'S')='S'

--   inner join nota_saida_item           nsi with (nolock) on nsi.cd_nota_saida          = ns.cd_nota_saida        
--   left outer join pedido_venda_item pvi   with (nolock) on pvi.cd_pedido_venda        = nsi.cd_pedido_venda and  
--                                                            pvi.cd_item_pedido_venda   = nsi.cd_item_pedido_venda  
--   left outer join pedido_venda pv         with (nolock) on pv.cd_pedido_venda         = pvi.cd_pedido_venda  
--   left outer join tipo_pedido tp          with (nolock) on tp.cd_tipo_pedido          = pv.cd_tipo_pedido and  
--                                                            isnull(tp.ic_imposto_tipo_pedido,'N') = 'S'  
    
-- where        
--   ns.dt_cancel_nota_saida is null   and    
--   ns.cd_nota_saida=8781    
    
  
