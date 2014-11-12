
CREATE PROCEDURE pr_consulta_ocorrencia

-------------------------------------------------------------------------------
--pr_Consulta_ocorrencia
-------------------------------------------------------------------------------
-- GBS  Global Businees Solution LTDA                                      2004
-------------------------------------------------------------------------------
-- Stored Procedure : Microsoft SQL Server 2000
-- Autor(es)        : Sandro Campos
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta das OcorrÛncias 
-- Data             : 13.03.2002
-- Atualizado       : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------
-- @ic_parametro : 1-> Mensagens enviadas
--	           2-> Mensagens recebidas
--	           3-> Nenhuma mensagem
-- @cd_ocorrencia : C¾digo da ocorrÛncia
-- @cd_usuario    : C¾digo do Usußrio
-- @cd_status     : C¾digo do Status
--                : 20/05/2003 - Colocado no padrão.
--                  - Trocado Left Joins por Left outer joins
--                  - É pra usar a tabela de Departamento do EGISADMIN
--                  - Daniel C. Neto.

-- Parametros
@ic_parametro integer,
@DataInicial Datetime,
@DataFinal Datetime,
@cd_ocorrencia integer,
@cd_usuario integer,
@cd_status integer

AS
-------------------------------------------------------------------------------------------
  if @ic_parametro = 1 --Mensagens enviadas
-------------------------------------------------------------------------------------------
  begin
    
    Select
      o.cd_ocorrencia ,
      o.ds_ocorrencia ,
      o.dt_ocorrencia , 
      o.dt_baixa_ocorrencia,
      o.cd_status_ocorrencia ,
      d.nm_departamento ,
      u.nm_usuario,
      u.nm_fantasia_usuario,
      ts.nm_tipo_status_ocorrencia,
      0 as ic_Baixar,
      'E' as tipo,
      o.ic_mostra_ocorrencia,
      o.ic_mostra_ocorrencia_sup,
      o.ic_mostra_ocorrencia_cop,
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento
    from 
         ocorrencia o
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_destino = u.cd_usuario
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = u.cd_departamento

    where 
      (O.cd_usuario_origem = @cd_usuario) and
      (O.cd_ocorrencia is not null) and
      (
       (@cd_ocorrencia = 0) or 
       ( 
        (@cd_ocorrencia <> 0) and
        (o.cd_ocorrencia = @cd_ocorrencia)
       ) 
      ) and
      (
       (@cd_status = 0) or 
       ( 
        (@cd_status <> 0) and
        (o.cd_status_ocorrencia = @cd_status)
       ) 
      ) and 
      (o.dt_ocorrencia between @DataInicial and @DataFinal)

    order by O.cd_ocorrencia desc
  end
-------------------------------------------------------------------------------------------
  if @ic_parametro = 2 --Mensagens recebidas
-------------------------------------------------------------------------------------------
  begin
    
    Select
      o.cd_ocorrencia,
      o.ds_ocorrencia,
      o.dt_ocorrencia,  
      o.dt_baixa_ocorrencia,
      o.cd_status_ocorrencia,
      d.nm_departamento,
      u.nm_usuario,
      u.nm_fantasia_usuario,
      ts.nm_tipo_status_ocorrencia,
      0 as ic_Baixar,
      'R' as tipo,
      o.ic_mostra_ocorrencia,
      o.ic_mostra_ocorrencia_sup,
      o.ic_mostra_ocorrencia_cop,
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento
    from 
         ocorrencia o
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_origem = u.cd_usuario
    where 
      (O.cd_usuario_destino = @cd_usuario) and
      (O.cd_ocorrencia is not null) and 
      (
       (@cd_ocorrencia = 0) or 
       ( 
        (@cd_ocorrencia <> 0) and
        (o.cd_ocorrencia = @cd_ocorrencia)
       ) 
      ) and
      (
       (@cd_status = 0) or 
       ( 
        (@cd_status <> 0) and
        (o.cd_status_ocorrencia = @cd_status)
       ) 
      ) and 
      (o.dt_ocorrencia between @DataInicial and @DataFinal)

    order by O.cd_ocorrencia desc
  end

  if @ic_parametro = 3 --Nenhuma mensagem
-------------------------------------------------------------------------------------------
  begin
    
    Select
      o.cd_ocorrencia,
      o.ds_ocorrencia,
      o.dt_ocorrencia, 
      o.dt_baixa_ocorrencia,
      o.cd_status_ocorrencia,
      d.nm_departamento,
      u.nm_usuario,
      u.nm_fantasia_usuario,
      ts.nm_tipo_status_ocorrencia,
      0 as ic_Baixar,
      ' ' as tipo,
      o.ic_mostra_ocorrencia,
      o.ic_mostra_ocorrencia_sup,
      o.ic_mostra_ocorrencia_cop,
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento
    from 
         ocorrencia o
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_destino = u.cd_usuario
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    where 
      (O.cd_usuario_origem = -1) and 
      (o.dt_ocorrencia between @DataInicial and @DataFinal)

    order by O.cd_ocorrencia desc
  end
-------------------------------------------------------------------------------------------
  if @ic_parametro = 4 --Todas as mensagens referente ao usuario
-------------------------------------------------------------------------------------------
  begin
    
    Select
      o.cd_ocorrencia ,
      o.ds_ocorrencia ,
      o.dt_ocorrencia , 
      o.dt_baixa_ocorrencia,
      o.cd_status_ocorrencia ,
      d.nm_departamento ,
      nm_usuario = case 
          when o.cd_usuario_origem = @cd_usuario then
              (
               select nm_usuario
               from egisadmin.dbo.usuario u
               where u.cd_usuario = o.cd_usuario_destino
              )
          when o.cd_usuario_destino = @cd_usuario then
              ( 
               select nm_usuario
               from egisadmin.dbo.usuario u
               where u.cd_usuario = o.cd_usuario_origem
              )
      end,
      nm_fantasia_usuario = case 
          when o.cd_usuario_origem = @cd_usuario then
              (
               select nm_fantasia_usuario
               from egisadmin.dbo.usuario u
               where u.cd_usuario = o.cd_usuario_destino
              )
          when o.cd_usuario_destino = @cd_usuario then
              ( 
               select nm_fantasia_usuario
               from egisadmin.dbo.usuario u
               where u.cd_usuario = o.cd_usuario_origem
              )
      end,
      ts.nm_tipo_status_ocorrencia,
      0 as ic_Baixar,
      tipo = case
               when o.cd_usuario_origem = @cd_usuario 
               then 'E'
             
          when o.cd_usuario_destino = @cd_usuario 
          then 'R'
      end,
      o.ic_mostra_ocorrencia,
      o.ic_mostra_ocorrencia_sup,
      o.ic_mostra_ocorrencia_cop,
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento


    from 
         ocorrencia o
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia

    where 
      (
       (O.cd_usuario_Destino = @cd_usuario) or
       (O.cd_usuario_origem = @cd_usuario)
      ) and
      (O.cd_ocorrencia is not null) and
      (
       (@cd_ocorrencia = 0) or 
       ( 
        (@cd_ocorrencia <> 0) and
        (o.cd_ocorrencia = @cd_ocorrencia)
       ) 
      ) and
      (
       (@cd_status = 0) or 
       ( 
        (@cd_status <> 0) and
        (o.cd_status_ocorrencia = @cd_status)
       ) 
      ) and 
      (o.dt_ocorrencia between @DataInicial and @DataFinal)

    order by O.cd_ocorrencia desc
  end

-------------------------------------------------------------------------------------------
  if @ic_parametro = 5 --Mensagens recebidas por supervisor
-------------------------------------------------------------------------------------------
  begin
    
    Select
      o.cd_ocorrencia,
      o.ds_ocorrencia,
      o.dt_ocorrencia,  
      o.dt_baixa_ocorrencia,
      o.cd_status_ocorrencia,
      d.nm_departamento,
      u.nm_usuario,
      u.nm_fantasia_usuario,
      ts.nm_tipo_status_ocorrencia,
      0 as ic_Baixar,
      'R' as tipo,
      o.ic_mostra_ocorrencia,
      o.ic_mostra_ocorrencia_sup,
      o.ic_mostra_ocorrencia_cop,
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento

    from 
         ocorrencia o
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_origem = u.cd_usuario
    where 
      (O.cd_usuario_gerente = @cd_usuario) and
      (O.cd_ocorrencia is not null) and 
      (
       (@cd_ocorrencia = 0) or 
       ( 
        (@cd_ocorrencia <> 0) and
        (o.cd_ocorrencia = @cd_ocorrencia)
       ) 
      ) and
      (
       (@cd_status = 0) or 
       ( 
        (@cd_status <> 0) and
        (o.cd_status_ocorrencia = @cd_status)
       ) 
      ) and 
      (o.dt_ocorrencia between @DataInicial and @DataFinal)

    order by O.cd_ocorrencia desc
  end
-------------------------------------------------------------------------------------------
  if @ic_parametro = 6 --Mensagens recebidas por cópias
-------------------------------------------------------------------------------------------
  begin
    
    Select
      o.cd_ocorrencia,
      o.cd_com_copias,
      o.ds_ocorrencia,
      o.dt_ocorrencia,  
      o.dt_baixa_ocorrencia,
      o.cd_status_ocorrencia,
      d.nm_departamento,
      u.nm_usuario,
      u.nm_fantasia_usuario,
      ts.nm_tipo_status_ocorrencia,
      0 as ic_Baixar,
      'R' as tipo,
      o.ic_mostra_ocorrencia,
      o.ic_mostra_ocorrencia_sup,
      o.ic_mostra_ocorrencia_cop,
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento

    from 
         ocorrencia o
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_origem = u.cd_usuario
    where (
           ';'+(O.cd_com_copias)+';' like '%;'+ltrim(rtrim(cast (@cd_usuario as char (10))))+';%'
          ) and
      (O.cd_ocorrencia is not null) and 
      (
       (@cd_ocorrencia = 0) or 
       ( 
        (@cd_ocorrencia <> 0) and
        (o.cd_ocorrencia = @cd_ocorrencia)
       ) 
      ) and
      (
       (@cd_status = 0) or 
       ( 
        (@cd_status <> 0) and
        (o.cd_status_ocorrencia = @cd_status)
       ) 
      ) and 
      (o.dt_ocorrencia between @DataInicial and @DataFinal)

    order by O.cd_ocorrencia desc
  end

-------------------------------------------------------------------------------
--Testando a Stored Procedure
-------------------------------------------------------------------------------
--exec pr_consulta_ocorrencia



