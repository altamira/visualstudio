
-------------------------------------------------------------------------------
--pr_limpeza_fila_email
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Limpeza Automática da Fila de E-mail
--Data             : 20/05/2005
--Atualizado       : 
--
--------------------------------------------------------------------------------------------------
create procedure pr_limpeza_fila_email

as

begin tran

  delete from servico_email

if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Não foi possível zerar a tabela de Fila de Serviço de Fax, pois ocorreram erros !',16,1)
     rollback tran
   end


