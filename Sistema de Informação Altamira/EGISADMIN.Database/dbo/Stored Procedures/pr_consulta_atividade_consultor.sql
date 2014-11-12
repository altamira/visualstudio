
CREATE  PROCEDURE pr_consulta_atividade_consultor

@cd_consultor int,
@ic_parametro char(1)

AS
select
  ci.nm_consultor CONSULTOR,
  rac.cd_registro_atividade REGISTRO_ATIVIDADE,
  rac.dt_registro_atividade DATA_REGISTRO_ATIVIDADE,
  cs.nm_cliente_sistema CLIENTE,
  rac.cd_usuario USUARIO,
  m.nm_modulo MODULO,
  ac.nm_atividade_cliente ATIVIDADE,
  rac.qt_hora_atividade HORA,
  ac.ds_atividade_cliente DESCRITIVO
from
   registro_atividade_cliente rac
 left outer join
   consultor_implantacao ci
     on (ci.cd_consultor = rac.cd_consultor)
 left outer join
   atividade_cliente ac
     on (ac.cd_atividade_cliente = rac.cd_atividade_cliente)
 left outer join cliente_sistema cs
     on (cs.cd_cliente_sistema = rac.cd_cliente_sistema)
 left outer join modulo m
     on (m.cd_modulo = rac.cd_modulo)
where
  ((@cd_consultor = 0) OR (rac.cd_consultor = @cd_consultor))
 and
  ((@ic_parametro = 'T') OR
   (@ic_parametro = 'A' AND rac.dt_conclusao_atividade is NULL) OR
   (@ic_parametro = 'C' AND rac.dt_conclusao_atividade is NOT NULL))

--------------------------------------------------------
-- TESTANDO A PROCEDURE
--------------------------------------------------------
-- exec pr_consulta_atividade_consultor 0, 'T'

