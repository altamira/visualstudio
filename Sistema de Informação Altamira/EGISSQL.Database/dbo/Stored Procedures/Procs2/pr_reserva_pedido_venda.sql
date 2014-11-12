
-----------------------------------------------------------------------------------
--pr_reserva_pedido_venda
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Deleta todos os Pedidos Reservados e gera a Reserva
--                 : atualiza a tabela Produto_Saldo, de acordo com a fase que a
--                 : Empresa trabalha
--Data             : 18.02.2003
--Atualizado       : 
--                 : 
-----------------------------------------------------------------------------------
create procedure pr_reserva_pedido_venda
@cd_pedido_venda   int,
@dt_inicial        datetime,
@dt_final          datetime

as

declare @sql varchar(8000)

--Monta a Tabela Auxiliar com os Pedidos de Venda para deletar a Reserva

--Pedido Individual

if @cd_pedido_venda>0
begin
  set @sql = '
  select
    cd_pedido_venda as Pedido 
  into #Pedido
  from
    Pedido_Venda
  where
    @cd_pedido_venda = cd_pedido_venda'
end
else
begin
  set @sql = '
  select  
    cd_pedido_venda as Pedido 
  into #Pedido
  from
    Pedido_Venda
  where
    dt_pedido_venda between @dt_inicial and @dt_final'

end

exec(@sql)

begin tran

  select * from #Pedido

if @@error = 0 
   begin
     commit tran
   end
else
   begin
    raiserror ('Atenção... Atualização da Reserva do(s) Pedido(s), não processado !',16,1)
    rollback tran
   end

