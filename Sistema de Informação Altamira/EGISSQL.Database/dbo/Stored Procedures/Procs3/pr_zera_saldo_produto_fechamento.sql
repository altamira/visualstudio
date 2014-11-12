
create procedure pr_zera_saldo_produto_fechamento
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes
--Banco Dados      : EGISSQL
--Objetivo         : Zera Tabela Completa de Produto Fechamento
--                 : 
--Data             : 23.04.2003
--Atualizado       : 
--                 : 
-----------------------------------------------------------------------------------
as
begin tran

  delete from Produto_Fechamento

if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Não foi possível zerar a tabela Produto Fechamento, pois ocorreram erros !',16,1)
     rollback tran
   end

