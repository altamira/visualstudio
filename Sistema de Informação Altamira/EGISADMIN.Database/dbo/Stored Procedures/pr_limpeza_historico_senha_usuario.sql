
-------------------------------------------------------------------------------
--pr_limpeza_historico_senha_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisADMIN
--Objetivo         : Limpeza da Tabela de Histórico das Senhas dos Usuários
--Data             : 15.10.2005
--Atualizado       : 15.10.2005
--------------------------------------------------------------------------------------------------
create procedure pr_limpeza_historico_senha_usuario
as

begin tran

  delete from historico_senha_usuario

if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Não foi possível zerar a tabela de Histórico de Senhas de Usuário, pois ocorreram erros !',16,1)
     rollback tran
   end


