
-------------------------------------------------------------------------------
--sp_helptext pr_copia_nota_entrada
-------------------------------------------------------------------------------
--pr_copia_nota_entrada
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 19.07.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_nota_entrada
@cd_nota_entrada int = 0
as

if @cd_nota_entrada>0 
begin
  print '1'
end


