
-------------------------------------------------------------------------------
--sp_helptext pr_ordem_abastecimento
-------------------------------------------------------------------------------
--pr_ordem_abastecimento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Douglas Lopes
--Banco de Dados   : Egissql
--Objetivo         : Ordem de Abastecimento
--Data             : 16.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ordem_abastecimento
@cd_ordem   int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

select
  oa.*
from
  Ordem_Abastecimento oa with (nolock) 
where
  oa.cd_ordem = case when @cd_ordem = 0 then oa.cd_ordem else @cd_ordem end 
  and oa.dt_ordem between (case when @cd_ordem = 0 then @dt_inicial else oa.dt_ordem end ) and
                          (case when @cd_ordem = 0 then @dt_final   else oa.dt_ordem end ) 


