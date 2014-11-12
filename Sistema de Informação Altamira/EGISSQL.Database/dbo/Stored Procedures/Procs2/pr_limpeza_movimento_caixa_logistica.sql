
-------------------------------------------------------------------------------
--sp_helptext pr_limpeza_movimento_caixa_logistica
-------------------------------------------------------------------------------
--pr_limpeza_movimento_caixa_logistica
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Limpeza do Movimento de Caixa
--
--Data             : 23.03.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_limpeza_movimento_caixa_logistica
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from movimento_caixa_recebimento

delete from
  movimento_caixa_recebimento
where
  dt_movimento_caixa between @dt_inicial and @dt_final

