
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo de Registro de Suporte por Cliente
--Data             : 09/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_registro_suporte_cliente
@dt_inicial datetime,
@dt_final   datetime

as

--select * from registro_suporte
--select * from cliente_sistema

select
  cs.nm_cliente_sistema                  as Cliente,
  count(*)                               as Entrada,
  Aberto = ( select count(*) 
             from 
               registro_suporte x
             where
               cs.cd_cliente_sistema = x.cd_cliente_sistema and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null ),

  count(rs.dt_solucao_registro)          as Solucao,
  count(distinct rs.cd_modulo)           as QtdModulo,
  count(rs.cd_usuario_sistema)           as QtdUsuario,
  count(distinct rs.cd_consultor      )  as QtdConsultor,

  MaisAntigaAberto = 
           ( select min(x.dt_registro_suporte)
             from 
               registro_suporte x
             where
               cs.cd_cliente_sistema = x.cd_cliente_sistema and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null ),

  AtualAberto = 
           ( select max(x.dt_registro_suporte)
             from 
               registro_suporte x
             where
               cs.cd_cliente_sistema = x.cd_cliente_sistema and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null )

from
  Cliente_Sistema  cs, 
  Registro_Suporte rs
where
  cs.cd_cliente_sistema = rs.cd_cliente_sistema and
  rs.dt_registro_suporte between @dt_inicial    and @dt_final  
group by
  cs.cd_cliente_sistema,
  cs.nm_cliente_sistema
order by
  cs.nm_cliente_sistema
