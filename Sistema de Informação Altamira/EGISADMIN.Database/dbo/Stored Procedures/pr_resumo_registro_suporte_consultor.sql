
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo de Registro de Suporte por Consultor
--Data             : 09/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_registro_suporte_consultor
@dt_inicial datetime,
@dt_final   datetime

as

--select * from registro_suporte
--select * from cliente_sistema

select
  ci.nm_consultor                        as Consultor,
  count(*)                               as Entrada,
  Aberto = ( select count(*) 
             from 
               registro_suporte x
             where
               ci.cd_consultor = x.cd_consultor and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null ),

  count(rs.dt_solucao_registro)          as Solucao,
  count(distinct rs.cd_modulo)           as QtdModulo,
  count(distinct rs.cd_cliente_sistema)  as QtdCliente,
  count(rs.cd_usuario_sistema)           as QtdUsuario,

  MaisAntigaAberto = 
           ( select min(x.dt_registro_suporte)
             from 
               registro_suporte x
             where
               ci.cd_consultor = x.cd_consultor and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null ),

  AtualAberto = 
           ( select max(x.dt_registro_suporte)
             from 
               registro_suporte x
             where
               ci.cd_consultor = x.cd_consultor and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null )

from
  Consultor_Implantacao ci, 
  Registro_Suporte rs
where
  ci.cd_consultor = rs.cd_consultor and
  rs.dt_registro_suporte between @dt_inicial    and @dt_final  and
  isnull(rs.cd_consultor,0) > 0
group by
  ci.cd_consultor,
  ci.nm_consultor
order by
  ci.nm_consultor
