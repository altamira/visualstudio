
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo de Registro de Suporte por Módulo
--Data             : 09/12/2004
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_registro_suporte_modulo
@dt_inicial datetime,
@dt_final   datetime

as

--select * from registro_suporte
--select * from cliente_sistema

select
  m.sg_modulo                            as Modulo,
  count(*)                               as Entrada,
  Aberto = ( select count(*) 
             from 
               registro_suporte x
             where
               m.cd_modulo =  x.cd_modulo and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null ),

  count(rs.dt_solucao_registro)          as Solucao,
  count(distinct rs.cd_cliente_sistema)  as QtdCliente,
  count(rs.cd_usuario_sistema)           as QtdUsuario,
  count(distinct rs.cd_consultor      )  as QtdConsultor,

  MaisAntigaAberto = 
           ( select min(x.dt_registro_suporte)
             from 
               registro_suporte x
             where
               m.cd_modulo =  x.cd_modulo and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null ),

  AtualAberto = 
           ( select max(x.dt_registro_suporte)
             from 
               registro_suporte x
             where
               m.cd_modulo =  x.cd_modulo and
               x.dt_registro_suporte between @dt_inicial    and @dt_final  and
               x.dt_solucao_registro is null )

from
  Modulo m, 
  Registro_Suporte rs
where
  m.cd_modulo = rs.cd_modulo and
  rs.dt_registro_suporte between @dt_inicial    and @dt_final  
group by
  m.cd_modulo,
  m.sg_modulo
order by
  m.sg_modulo
