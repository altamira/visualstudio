
CREATE   PROCEDURE pr_rel_atendimento_suporte_cliente
------------------------------------------------------------------------------------------
--pr_rel_atendimento_suporte_cliente
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Rafael M. Santiago
--Banco de Dados: EGISADMIN
--Objetivo      : Relatório de Atendimento do Suporte
--Data          : 13.12.2004
--Atualizado    : 
------------------------------------------------------------------------------------
@dt_inicial AS DATETIME,
@dt_final AS DATETIME,
@cd_cliente_sistema AS INT,
@ic_parametro AS CHAR(1)


AS
SELECT 
  rs.cd_registro_suporte,
  rs.dt_registro_suporte,
	cs.nm_cliente_sistema,
	ucs.nm_usuario_sistema,
  m.sg_modulo,
  rs.cd_versao_modulo,
  rs.dt_ocorrencia_suporte,
  ci.nm_consultor,
  rs.dt_solucao_registro,
  rs.ds_observacao_suporte,
  ISNULL((SELECT 
     COUNT('X') 
   FROM 
     Registro_Suporte a 
   WHERE 
     a.dt_registro_suporte BETWEEN @dt_inicial AND @dt_final AND
     a.dt_solucao_registro is NULL),0) as 'ABERTOS',
  ISNULL((SELECT 
     COUNT('X') 
   FROM 
     Registro_Suporte b 
   WHERE 
     b.dt_registro_suporte BETWEEN @dt_inicial AND @dt_final AND
     b.dt_solucao_registro is NOT NULL),0) as 'ROSOLVIDOS'
FROM
  Registro_Suporte rs 
  LEFT OUTER JOIN
  Cliente_Sistema cs ON rs.cd_cliente_sistema = cs.cd_cliente_sistema 
  LEFT OUTER JOIN
  Usuario_Cliente_Sistema ucs ON rs.cd_usuario_Sistema = ucs.cd_usuario_Sistema AND
                                 rs.cd_cliente_sistema = ucs.cd_cliente_sistema
  LEFT OUTER JOIN
  Modulo m ON rs.cd_modulo = m.cd_modulo
  LEFT OUTER JOIN
  Consultor_Implantacao ci ON rs.cd_consultor = ci.cd_consultor
WHERE
  rs.dt_registro_suporte BETWEEN @dt_inicial AND @dt_final  AND
  ((@cd_cliente_sistema = 0) OR (rs.cd_cliente_sistema = @cd_cliente_sistema)) AND
   @ic_parametro = 'T' OR
  (@ic_parametro = 'A' AND rs.dt_solucao_registro is NULL) OR
  (@ic_parametro = 'R' AND rs.dt_solucao_registro is NOT NULL)
 

