
CREATE VIEW vw_nfp_registro_60    
------------------------------------------------------------------------------------    
--vw_nfp_registro_60    
------------------------------------------------------------------------------------    
--GBS - Global Business Solution                                        2004    
------------------------------------------------------------------------------------    
--Stored Procedure : Microsoft SQL Server 2000    
--Autor(es)             : Douglas de Paula Lopes    
--Banco de Dados : EGISSQL    
--Objetivo         : Nota Fiscal Paulista    
--Data                  : 25/06/2008        
--Atualização           :     
--03.07.2008 - Acerto dos campos - Carlos / Douglas     
-- 10.08.2009 - Nota Fiscais de Pedido sem Valor Comercial - Carlos Fernandes 
------------------------------------------------------------------------------------    
as    
    
select     
------------------------------------------------------------------------------------    
--FILTRO      
------------------------------------------------------------------------------------    
  ns.dt_nota_saida,    
------------------------------------------------------------------------------------    
  cast(ns.ds_obs_compl_nota_saida as varchar(256)) as FATURA,    
  cast('' as varchar(256))    as INFADFISCO,    
  cast('' as varchar(5000))   as INFCPL    
from    
  nota_saida ns with (nolock)     
where    
  ns.dt_cancel_nota_saida is null    
  and isnull(ic_nfp_nota_saida,'S')='S'
  
