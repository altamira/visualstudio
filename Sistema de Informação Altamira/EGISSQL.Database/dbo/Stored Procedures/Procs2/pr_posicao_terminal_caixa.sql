
-------------------------------------------------------------------------------
--pr_posicao_terminal_caixa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 21.03.2005
--Atualizado       : 21.03.2005
--------------------------------------------------------------------------------------------------
create procedure pr_posicao_terminal_caixa
@dt_inicial datetime,
@dt_final   datetime

as

--select * from terminal_caixa
--select * from movimento_caixa
--select * from abertura_caixa

select
  tc.cd_terminal_caixa,
  tc.nm_terminal_caixa         as Terminal,
  tc.ic_status_terminal_caixa  as Status,
  oc.nm_operador_caixa         as Operador,
  ( select isnull( count(*),0 ) from movimento_caixa where tc.cd_terminal_caixa = cd_terminal_caixa and
                                                                          dt_movimento_caixa between @dt_inicial and @dt_final ) as Total,

  ( select isnull( sum( vl_movimento_caixa ),0 ) from movimento_caixa where tc.cd_terminal_caixa = cd_terminal_caixa and
                                                                          dt_movimento_caixa between @dt_inicial and @dt_final ) as TotalMovimento,
  '' as Observacao

from
  Terminal_Caixa tc 
  left outer join Abertura_caixa ac on ac.cd_terminal_caixa = tc.cd_terminal_caixa and
                                       ac.dt_abertura_caixa between @dt_inicial and @dt_final
  left outer Join Operador_caixa oc on oc.cd_operador_caixa = ac.cd_operador_caixa

    

