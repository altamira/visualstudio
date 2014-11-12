
--sp_helptext pr_resumo_projeto_implantacao

-------------------------------------------------------------------------------
--pr_resumo_projeto_implantacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 08.11.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_resumo_projeto_implantacao
@cd_cliente int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from projeto_sistema
--select * from cliente_modulo
--select * from egisadmin.dbo.modulo
--select * from registro_atividade_cliente

select
  c.nm_fantasia_cliente         as Cliente,
  ps.cd_identificacao_projeto   as Projeto,
  ps.qt_hora_projeto_sistema    as Hora_Total,
  ps.qt_real_projeto_sistema    as Hora_Realizado_Total,
  ps.qt_hora_impl_projeto       as Hora_Implantacao,
  ps.qt_hora_coord_projeto      as Hora_Coordenacao,
  0.00                          as Total_Projeto,
  0.00                          as Total_Realizado_Projeto,
  0.00                          as Total_Despesas,
  0.00                          as Total_Custo,
  0.00                          as Margem,

  ( select sum( isnull(rx.qt_hora_atividade,0) )
    from
      Registro_Atividade_Cliente rx
    where
      rx.cd_cliente = ps.cd_cliente and
      rx.dt_registro_atividade between @dt_inicial and @dt_final ) as Total_Hora_Atividade,
 
  mc.cd_modulo,
  mc.cd_modulo_cliente,
  m.nm_modulo,
  m.sg_modulo,
  cv.nm_cadeia_valor,
  ra.nm_ra,
  ra.dt_registro_atividade,
  ra.qt_hora_atividade,
  ci.nm_consultor,
  a.nm_atividade

--select * from atividade_implantacao

from
  Projeto_Sistema ps
  inner join Cliente              c             on c.cd_cliente               = ps.cd_cliente
  left outer join Modulo_Cliente mc             on mc.cd_cliente              = ps.cd_cliente 
  left outer join egisadmin.dbo.Modulo m        on m.cd_modulo                = mc.cd_modulo
  left outer join egisadmin.dbo.Cadeia_valor cv on cv.cd_cadeia_valor         = m.cd_cadeia_valor                                     
  left outer join registro_atividade_cliente ra on ra.cd_cliente              = c.cd_cliente and
                                                   ra.dt_registro_atividade between @dt_inicial and @dt_final 
  left outer join Consultor_Implantacao ci      on ci.cd_consultor            = ra.cd_consultor
  left outer join Atividade_Implantacao a       on a.cd_atividade             = ra.cd_atividade_analista
where
  ps.cd_cliente = case when @cd_cliente = 0 then ps.cd_cliente else @cd_cliente end  

order by
  c.nm_fantasia_cliente
  

