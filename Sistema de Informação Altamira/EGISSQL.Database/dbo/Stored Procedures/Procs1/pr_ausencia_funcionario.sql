
-------------------------------------------------------------------------------
--pr_ausencia_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Ausência de Funcionários que Executam Aprovação pelo
--                   Sistema - WorkFlow
--Data             : 22.02.2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_ausencia_funcionario
@dt_inicial datetime,
@dt_final   datetime
--@cd_usuario int

as

--select * from usuario_autorizacao_aprovacao

select
  d.nm_departamento        as Departamento,
  u.nm_fantasia_usuario    as Usuario,
  ta.nm_tipo_ausencia      as Ausencia,
  ua.dt_inicio_autorizacao as Saida,
  ua.dt_final_autorizacao  as Retorno,    
  us.nm_fantasia_usuario   as Autorizado,
  ua.nm_obs_usuario_aut    as Observacao   

from
  egisadmin.dbo.usuario u
  inner join usuario_autorizacao_aprovacao ua      on ua.cd_usuario_aut_aprovado = u.cd_usuario
  left outer join departamento d                   on d.cd_departamento          = u.cd_departamento
  left outer join tipo_ausencia ta                 on ta.cd_tipo_ausencia        = ua.cd_tipo_ausencia
  left outer join egisadmin.dbo.usuario us         on us.cd_usuario              = ua.cd_usuario_autorizado

--where
--  u.cd_usuario = case when @cd_usuario = 0 then u.cd_usuario else @cd_usuario end


