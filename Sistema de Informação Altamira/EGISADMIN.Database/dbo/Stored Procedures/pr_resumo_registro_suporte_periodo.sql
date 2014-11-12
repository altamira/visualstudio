
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo de Registro de Suporte por Período
--Data             : 09/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_registro_suporte_periodo
@dt_inicial datetime,
@dt_final   datetime

as

--select * from registro_suporte

select
  rs.dt_registro_suporte                 as DataRegistro,
  count(*)                               as Entrada,
  count(rs.dt_solucao_registro)          as Solucao,
  count(distinct rs.cd_modulo)           as QtdModulo,
  count(distinct rs.cd_cliente_sistema)  as QtdCliente,
  count(rs.cd_usuario_sistema)           as QtdUsuario,
  count(distinct rs.cd_consultor      )  as QtdConsultor
from
  Registro_Suporte rs
where
  rs.dt_registro_suporte between @dt_inicial and @dt_final  
group by
  rs.dt_registro_suporte
order by
  rs.dt_registro_suporte
