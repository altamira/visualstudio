
---------------------------------------------------------------------------------    
--pr_gera_lote_processo    
-------------------------------------------------------------------------------    
--GBS Global Business Solution Ltda                                        2005    
-------------------------------------------------------------------------------    
--Stored Procedure : Microsoft SQL Server 2000    
--Autor(es)        : Vagner do Amaral    
--Banco de Dados   : EgisAdmin ou Egissql    
--Objetivo         : Consultar a function pr_gera_lote_processo    
--Data             : 29/07/2005    
--Alteração        : 24/11/2006 - Incluido customização de lote da trm - Daniel C Neto    
------------------------------------------------------------------------------    
create procedure pr_gera_lote_processo    
as    
  
  declare @ic_rateio int  
  
  set @ic_rateio = dbo.fn_ver_uso_custom('LOTE')  
  
  if @ic_rateio = 1   
  begin  
    update lote_numeracao  
    set  cd_numero_lote = IsNull(cd_numero_lote,0) + 1   
  end  

  select  dbo.fn_gera_lote_processo(substring(cast(year(getdate()) as char(4)),3,2)) as 'Lote'    

