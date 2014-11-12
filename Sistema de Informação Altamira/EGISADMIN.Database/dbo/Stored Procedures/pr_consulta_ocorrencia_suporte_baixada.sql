CREATE PROCEDURE pr_consulta_ocorrencia_suporte_baixada
@ic_parametro as char(1) = 'D', 
@cd_cliente_sistema as integer = 0,
@dt_inicial as datetime = NULL,
@dt_final as datetime = NULL
AS
IF @ic_parametro = 'D'
BEGIN
  SELECT 
    rs.dt_solucao_registro,
    cs.nm_cliente_sistema,
    rs.cd_registro_suporte,
    rs.dt_registro_suporte,
    mh.nm_os,
    (select 
       count('x') 
     from  
       EGISSQL.DBO.agenda 
     where 
       dt_agenda between rs.dt_registro_suporte and rs.dt_solucao_registro and ic_util = 'S') as 'dias',
    ucs.nm_usuario_sistema,
    ps.nm_prioridade_suporte,
    m.sg_modulo,
    rs.cd_versao_modulo,
    rs.dt_ocorrencia_suporte
  FROM
    Registro_Suporte rs
    LEFT OUTER JOIN
    Cliente_Sistema cs ON rs.cd_cliente_sistema = cs.cd_cliente_sistema
    LEFT OUTER JOIN  
    Menu_Historico mh ON rs.cd_menu_historico = mh.cd_menu_historico
    LEFT OUTER JOIN
    Usuario_Cliente_Sistema ucs ON rs.cd_usuario_sistema = ucs.cd_usuario_sistema AND
                                   rs.cd_cliente_sistema = ucs.cd_cliente_sistema
    LEFT OUTER JOIN
    Prioridade_Suporte ps ON rs.cd_prioridade_suporte = ps.cd_prioridade_suporte
    LEFT OUTER JOIN
    Modulo m ON rs.cd_modulo = m.cd_modulo
  WHERE
    rs.dt_solucao_registro BETWEEN @dt_inicial AND @dt_final
END
