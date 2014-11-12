
CREATE VIEW vw_nfp_registro_90      
------------------------------------------------------------------------------------      
--vw_nfp_registro_90      
------------------------------------------------------------------------------------      
--GBS - Global Business Solution                                        2008      
------------------------------------------------------------------------------------      
--Stored Procedure : Microsoft SQL Server 2000      
--Autor(es)             : Douglas de Paula Lopes      
--Banco de Dados : EGISSQL      
--Objetivo         : Nota Fiscal Paulista      
--Data                  : 25/06/2008          
--Atualização           :       
-- 03.07.2008 - ajustes gerais - carlos fernandes      
-- 10.08.2009 - Nota Fiscais de Pedido sem Valor Comercial - Carlos Fernandes 
------------------------------------------------------------------------------------      
as      
      
select      
  (select count(*) from vw_nfp_registro_20) as Total20,      
  (select count(*) from vw_nfp_registro_30) as Total30,      
  (select count(*) from vw_nfp_registro_40) as Total40,      
  (select count(*) from vw_nfp_registro_50) as Total50,      
  (select count(*) from vw_nfp_registro_60) as Total60      
  

