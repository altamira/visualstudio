
-------------------------------------------------------------------------------
--pr_criacao_indice_pedido_venda_origem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Criação de Índice do Pedido de Venda Origem
--Data             : 20.07.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_criacao_indice_pedido_venda_origem
as

IF EXISTS (SELECT name FROM sysindexes 
      WHERE name = 'IX_Pedido_Venda_Origem')
   DROP INDEX Pedido_Venda.IX_Pedido_Venda_Origem

CREATE INDEX IX_Pedido_Venda_Origem
   ON Pedido_venda (cd_pedido_venda_origem)

