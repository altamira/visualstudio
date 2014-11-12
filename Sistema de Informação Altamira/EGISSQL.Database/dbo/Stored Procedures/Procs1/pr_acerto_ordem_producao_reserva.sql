
-------------------------------------------------------------------------------
--sp_helptext pr_acerto_ordem_producao_reserva
-------------------------------------------------------------------------------
--pr_acerto_ordem_producao_reserva
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Acerto do flag da reserva para baixa da Ordem de Produção
--                   para enquanto não implanta o módulo de estoque
--     
--Data             : 30.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_acerto_ordem_producao_reserva
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

UPDATE 
  processo_producao_componente 
set 
  cd_movimento_estoque_reserva = 999999, 
  ic_estoque_processo = 'S' 
from 
  processo_producao_componente 
where 
  isnull (cd_movimento_estoque_reserva,0)=0

