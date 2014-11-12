
-------------------------------------------------------------------------------
--sp_helptext pr_zera_movimento_pedido
-------------------------------------------------------------------------------
--pr_zera_movimento_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Zera Movimento de Pedido Entrando pelo EDI ( Nextel/Mercador )
--Data             : 26.09.2008
--Alteração        : 25.04.2009 - Ajustes na Rotina - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_zera_movimento_pedido
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--Deleta a Tabela de Movimento de Pedido

delete from pedido_venda_nextel

