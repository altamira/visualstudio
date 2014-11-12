

/****** Object:  Stored Procedure dbo.pr_grava_recepcao_pedidoWap    Script Date: 13/12/2002 15:08:33 ******/
--pr_grava_recepcao_pedidoWap	
-------------------------------------------------------------------------
--Global Business Solution Ltda
--Stored Procedure : SQL Server Microsoft 2000
--Cleiton Marques de Souza
--Carlos Cardoso Fernandes
--Rotina de Recepcao de Base de Pedidos Wap
--Data        :   03/03/2002
--Atualizaçao :
-------------------------------------------------------------------------
create procedure pr_grava_recepcao_pedidoWap	
--@cd_vendedor int,
@nm_recepcao_pedidowap varchar(100)
as
begin
declare @cd_recepcao_pedidowap int
set @cd_recepcao_pedidowap = 0
Begin Transaction
-- Busca do Codigo Sequencial
Select 
   @cd_recepcao_pedidowap = ISNULL(MAX(cd_recepcao_pedidowap),0) + 1 FROM Recepcao_PedidoWap TABLOCK
-- Gravacao da Tabela de Recepcao da Tabela de Pedidos Wap
Insert Into Recepcao_PedidoWap
       (cd_recepcao_pedidoWap,
        cd_vendedor,
        nm_recepcao_pedidoWap,
        cd_usuario,
        dt_usuario)
         
Values
       (@cd_recepcao_pedidoWap,
        1,
        @nm_recepcao_pedidoWap,
        1,
        getdate() )
 if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


