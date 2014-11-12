
-------------------------------------------------------------------------------  
--sp_helptext pr_zera_programacao_entrega  
-------------------------------------------------------------------------------  
--pr_documentacao_padrao  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2007   
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Carlos Cardoso Fernandes  
--Banco de Dados   : Egissql  
--Objetivo         : Zera a Programação de Entrega  
--Data             : 19/09/2007  
--Alteração        :   
------------------------------------------------------------------------------  
create procedure pr_zera_programacao_entrega  
@dt_inicial datetime = '',  
@dt_final   datetime = ''  
  
as  
  
delete from programacao_entrega_remessa  
  
delete from programacao_entrega_composicao  
  
delete from programacao_entrega  
 

