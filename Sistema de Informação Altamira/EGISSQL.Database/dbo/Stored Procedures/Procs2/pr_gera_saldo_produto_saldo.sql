
-------------------------------------------------------------------------------
--sp_helptext pr_gera_saldo_produto_saldo
-------------------------------------------------------------------------------
--pr_gera_saldo_produto_saldo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Gera Saldo na Tabela Produto Saldo de Todos os Produtos
--                   para permitir faturamento
--
--Data             : 02.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_saldo_produto_saldo
@cd_fase_produto int   = 0,
@qt_saldo        float = 0
as


--select * from produto_saldo

update
  produto_saldo
set
  qt_saldo_reserva_produto = @qt_saldo,
  qt_saldo_atual_produto   = @qt_saldo
from
  produto_saldo
where
  cd_fase_produto = @cd_fase_produto


