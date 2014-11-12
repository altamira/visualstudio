
CREATE VIEW vw_nfp_registro_30       
------------------------------------------------------------------------------------        
--vw_nfp_registro_30        
------------------------------------------------------------------------------------        
--GBS - Global Business Solution                                        2008        
------------------------------------------------------------------------------------        
--Stored Procedure : Microsoft SQL Server 2000        
--Autor(es)             : Douglas de Paula Lopes        
--Banco de Dados : EGISSQL        
--Objetivo         : Nota Fiscal Paulista        
--Data                  : 25.06.2008            
--Atualização           : 17.10.2008 - Complemento dos Campos Faltantes        
--                                     Douglas de Paula Lopes         
-- 10.08.2009 - Nota Fiscais de Pedido sem Valor Comercial - Carlos Fernandes 

------------------------------------------------------------------------------------        
as        
        
select         
------------------------------------------------------------------------------------        
--FILTRO                                                                          --        
------------------------------------------------------------------------------------    
  ns.cd_nota_saida,        
  ns.dt_nota_saida,                                                               --        
------------------------------------------------------------------------------------        
  cast(nsi.cd_mascara_produto as varchar(60))                  as CPROD,          --        
  ltrim(cast(p.nm_produto as varchar(120)))                    as XPROD,          --        
  case when lower(nsi.ic_tipo_nota_saida_item) = 'p' then        
    cast(cf.cd_mascara_classificacao as varchar(8))        
  else        
    ''        
  end                                                          as NCM,            --                                       
  cast(um.sg_unidade_medida as varchar(6))                     as UCOM,           --        
  isnull(replace(CONVERT(varchar, convert(numeric(14,4),round(nsi.qt_item_nota_saida,6,2)),103),'.',','),'0,0000')    as QCOM, --      
--  isnull(nsi.qt_item_nota_saida,0)                             as QCOM,           --        
  isnull(replace(CONVERT(varchar, convert(numeric(14,4),round(nsi.vl_unitario_item_nota,6,2)),103),'.',','),'0,0000') as VUNCOM, --                  
--  isnull(nsi.vl_unitario_item_nota,0)                          as VUNCOM,         --        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(nsi.vl_total_item,6,2)),103),'.',','),'0.00')           as VPROD,      
--  isnull(nsi.vl_total_item,0)                                  as VPROD,          --        
  isnull(nsi.cd_situacao_tributaria,0)                         as CST,            --        
  isnull(replace(CONVERT(varchar, convert(numeric(5,2),round(nsi.pc_icms,6,2)),103),'.',','),'0.00') as PICMS,       
--  isnull(nsi.pc_icms,0)                                        as PICMS,          --        
  isnull(replace(CONVERT(varchar, convert(numeric(5,2),round(nsi.pc_ipi,6,2)),103),'.',','),'0,00')  as PIPI,      
--  isnull(nsi.pc_ipi,0)                                         as PIPI,           --        
  isnull(replace(CONVERT(varchar, convert(numeric(15,2),round(nsi.vl_ipi,6,2)),103),'.',','),'0,00')  as VIPI,
  isnull(tp.ic_imposto_tipo_pedido,'N')  as ic_imposto_tipo_pedido,       
  nsi.cd_pedido_venda,
  nsi.cd_item_pedido_venda
        
--  isnull(nsi.vl_ipi,0)                                         as VIPI            --        ,
  
from        
  nota_saida ns                            with (nolock)        
  inner join nota_saida_item           nsi with (nolock) on nsi.cd_nota_saida          = ns.cd_nota_saida        
  left outer join classificacao_fiscal cf  with (nolock) on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal        
  left outer join produto              p   with (nolock) on p.cd_produto               = nsi.cd_produto          
  left outer join unidade_medida       um  with (nolock) on um.cd_unidade_medida        = nsi.cd_unidade_medida          
  left outer join pedido_venda_item pvi   with (nolock) on pvi.cd_pedido_venda        = nsi.cd_pedido_venda and  
                                                           pvi.cd_item_pedido_venda   = nsi.cd_item_pedido_venda  
  left outer join pedido_venda pv         with (nolock) on pv.cd_pedido_venda         = pvi.cd_pedido_venda  
  left outer join tipo_pedido tp          with (nolock) on tp.cd_tipo_pedido          = pv.cd_tipo_pedido and  
                                                           isnull(tp.ic_imposto_tipo_pedido,'N') = 'S'  
where
  isnull(ns.ic_nfp_nota_saida,'S')='S'
  
-- where        
--   ns.dt_cancel_nota_saida is null and  ns.cd_nota_saida = 8781    
  

