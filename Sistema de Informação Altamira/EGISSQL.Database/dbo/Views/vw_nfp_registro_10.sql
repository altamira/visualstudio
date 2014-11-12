
CREATE VIEW vw_nfp_registro_10      
------------------------------------------------------------------------------------      
--vw_nfp_registro_10      
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
--10.08.2009 - Nota Fiscais de Pedido sem Valor Comercial - Carlos Fernandes
------------------------------------------------------------------------------------      
as      
      
select     
  cast('1,00' as varchar)                                                   as VLAYOUT,      
  dbo.fn_Formata_Mascara('00000000000000',(select       
                                           cd_cgc_empresa       
                                         from       
                                           egisadmin.dbo.empresa       
                                         where       
                                           cd_empresa = dbo.fn_empresa())) as CNPJEM,      
  rtrim(ltrim(convert(char,min(dt_nota_saida),103)))                       as DTINICIO,      
  rtrim(ltrim(convert(char,max(dt_nota_saida),103)))                       as DTFINAL      
from       
  nota_saida  with (nolock) 
where
  isnull(ic_nfp_nota_saida,'S')='S'

