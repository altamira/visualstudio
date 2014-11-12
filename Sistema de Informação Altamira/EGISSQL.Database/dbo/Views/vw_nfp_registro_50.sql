
CREATE VIEW vw_nfp_registro_50  
------------------------------------------------------------------------------------      
--vw_nfp_registro_50      
------------------------------------------------------------------------------------      
--GBS - Global Business Solution                                        2008      
------------------------------------------------------------------------------------      
--Stored Procedure : Microsoft SQL Server 2000      
--Autor(es)             : Douglas de Paula Lopes      
--Banco de Dados : EGISSQL      
--Objetivo         : Nota Fiscal Paulista      
--Data                  : 25/06/2008          
--Atualização           :       
--03.07.2008 - ajustes gerais - carlos fernandes      
--17.10.2008 - Complemento dos Campos Faltantes - Douglas de Paula Lopes      
-- 10.08.2009 - Nota Fiscais de Pedido sem Valor Comercial - Carlos Fernandes 
------------------------------------------------------------------------------------      
as      
      
select       
      
------------------------------------------------------------------------------------      
--FILTRO        
------------------------------------------------------------------------------------      
  ns.dt_nota_saida,      
------------------------------------------------------------------------------------         
  case when ns.cd_tipo_pagamento_frete = 1 then 0 else 1 end                                    as MODFRETE,--       
  cast(replace(replace(replace(t.cd_cnpj_transportadora,'-',''),'/',''),'.','') as varchar(14)) as CNPJ,    --      
  cast(ltrim(t.nm_transportadora) as varchar(60))                                               as XNOME,   --      
  cast(t.cd_insc_estadual as varchar(14))                                                       as IE,      --      
  cast(ns.nm_endereco_entrega + ' ' + rtrim(ltrim(ns.cd_numero_endereco_ent)) as varchar(60))   as XENDER,  --      
  cast(ns.nm_cidade_entrega  as varchar(60))                                                    as XMUN,    --      
  cast(ns.sg_estado_entrega  as varchar(2))                                                     as UF1,     --      
  cast(ns.cd_placa_nota_saida as varchar(8))                                                    as PLACA,   --      
  cast(sg_estado_placa as varchar(2))                                                           as UF2,     --      
  isnull(cast(ns.qt_volume_nota_saida as int),0)                                                as QVOL,      
  cast(ns.nm_especie_nota_saida as varchar(60))                                                 as ESP,      
  cast(ns.nm_marca_nota_saida as varchar(60))                                                   as MARCA,      
  cast(ns.nm_numero_emb_nota_saida as varchar(60))                                              as NVOL,    
  isnull(replace(CONVERT(varchar, convert(numeric(15,3),round(ns.qt_peso_liq_nota_saida,6,2)),103),'.',','),'0,000') as PESOL,      
--  isnull(ns.qt_peso_liq_nota_saida,0)                                                           as PESOL,     
  isnull(replace(CONVERT(varchar, convert(numeric(15,3),round(ns.qt_peso_bruto_nota_saida,6,2)),103),'.',','),'0,000') as PESOB     
--  isnull(ns.qt_peso_bruto_nota_saida,0)                                                         as PESOB      
from       
  nota_saida ns      
  left outer join Transportadora t on t.cd_transportadora = ns.cd_transportadora      
  left outer join Cidade c         on c.cd_cidade         = t.cd_cidade           and       
                                      c.cd_estado         = t.cd_estado           and      
                                      c.cd_pais           = t.cd_pais      
  left outer join Estado e         on e.cd_estado         = t.cd_estado           and      
                                      e.cd_pais           = t.cd_pais      

where
  isnull(ic_nfp_nota_saida,'S')='S'

-- where      
--   ns.dt_cancel_nota_saida is null and  
--   ns.cd_nota_saida=8781     
  
