CREATE PROCEDURE pr_consulta_ocorrencia_suporte_aberta
@cd_cliente_sistema as integer = 0
AS
SELECT 
    cs.nm_cliente_sistema,
    rs.cd_registro_suporte,
    rs.dt_registro_suporte,
    mh.nm_os,
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
    ((@cd_cliente_sistema = 0) OR (rs.cd_cliente_sistema = @cd_cliente_sistema)) AND
    rs.dt_solucao_dev IS NULL OR
    rs.dt_solucao_registro IS NULL
    

