
-------------------------------------------------------------------------------
--pr_ajuste_total_movimento_caixa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste Manual do Total do Movimento de Caixa
--                   utilizar quando o Total do Movimento for diferente do Total dos Itens
--Data             : 30.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_ajuste_total_movimento_caixa
@dt_inicial         datetime = '',
@dt_final           datetime = '',
@cd_movimento_caixa int      = 0

as

update
  movimento_caixa
set
  vl_movimento_caixa = ( select sum(mci.qt_item_movimento_caixa*mci.vl_item_movimento_caixa)
                         from
                           Movimento_Caixa_item mci
                         where
                           mci.cd_movimento_caixa = mc.cd_movimento_caixa )
from 
  Movimento_Caixa mc
where
 mc.cd_movimento_caixa = case when @cd_movimento_caixa = 0 then mc.cd_movimento_caixa else @cd_movimento_caixa end and
 mc.dt_movimento_caixa between @dt_inicial and @dt_final

