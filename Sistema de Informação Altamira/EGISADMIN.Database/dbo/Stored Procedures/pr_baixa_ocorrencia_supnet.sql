CREATE PROCEDURE pr_baixa_ocorrencia_supnet  
@ic_parametro as char(1) = 'L',  
@cd_cliente_sistema as integer,  
@cd_registro_suporte as integer = NULL,  
@dt_solucao_registro as datetime = NULL  
AS  
  
IF @ic_parametro = 'L' --LISTA  
BEGIN  
SELECT  
  rs.cd_registro_suporte,  
  CONVERT(varchar, rs.dt_registro_suporte,103) as dt_registro_suporte,  
  ucs.nm_fantasia_usuario,  
  m.sg_modulo,    
  CONVERT(varchar, rs.dt_ocorrencia_suporte,103) as dt_ocorrencia_suporte,  
  cast(ds_ocorrencia_suporte as varchar(30)) as ds_ocorrencia_suporte  
    
FROM   
  Registro_Suporte rs   
  LEFT OUTER JOIN  
  Usuario_Cliente_Sistema ucs   
  ON  
  rs.cd_cliente_sistema = ucs.cd_cliente_sistema AND  
  rs.cd_usuario_sistema = ucs.cd_usuario_sistema  
  LEFT OUTER JOIN  
  Modulo m  
  ON  
  rs.cd_modulo = m.cd_modulo  
  
WHERE   
  rs.dt_solucao_dev is not null   
  AND rs.dt_solucao_registro is null
  AND rs.cd_cliente_sistema = @cd_cliente_sistema     

END  
  
IF @ic_parametro = 'D'  -- DETALHES  
BEGIN    
SELECT    
  rs.cd_registro_suporte,    
  rs.dt_registro_suporte,    
  cs.nm_cliente_sistema,    
  ps.nm_prioridade_suporte,    
  m.sg_modulo,     
  rs.cd_versao_modulo,    
  rs.dt_ocorrencia_suporte,    
  rs.ds_ocorrencia_suporte,    
  rs.ds_mensagem_suporte,    
  rs.ds_observacao_suporte    
FROM     
  Registro_Suporte rs     
  LEFT OUTER JOIN    
  Cliente_Sistema cs     
  ON    
  rs.cd_cliente_sistema = cs.cd_cliente_sistema    
  LEFT OUTER JOIN    
  Modulo m    
  ON    
  rs.cd_modulo = m.cd_modulo    
  LEFT OUTER JOIN    
  Prioridade_Suporte ps    
  ON    
  rs.cd_prioridade_suporte = ps.cd_prioridade_suporte    
WHERE     
  rs.cd_registro_suporte = @cd_registro_suporte    
END    
  
IF @ic_parametro = 'G'  -- GRAVAR BAIXA  
BEGIN    
UPDATE   
  Registro_Suporte  
SET  
  dt_solucao_registro = @dt_solucao_registro  
WHERE     
  cd_registro_suporte = @cd_registro_suporte    
END  

