
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
-- 14/01/2005 - Trazer cópias relacionadas ao usuário no parametro 2- Daniel C. Neto.
-- 11/07/2006 - Usuario com Copia Baixar a Ocorrencia - Márcio Rodrigues
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
--                : 13.05.2005 - Consulta da Cliente - Carlos Fernandes
-- 11.11.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------
-- Parametros
@ic_parametro  integer,
@DataInicial   datetime,
@DataFinal     datetime,
@cd_ocorrencia integer,
@cd_usuario    integer,
@cd_status     integer,
@ic_mostrar_ocorrencia char(1) = 'S' -- MOstrar todas as ocorrências ou somentes as com = 'S'.
                                     -- Com S vai mostrar todas, sem S vai mostrar somente as com campo = 'S'

AS
-------------------------------------------------------------------------------------------
  if @ic_parametro in (1,2,7) --Mensagens enviadas / Recebidas ou Ambas.
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
      ( case when O.cd_usuario_origem = @cd_usuario then 'E' 
             else 'R' end ) as tipo,
      o.ic_mostra_ocorrencia,
      o.ic_mostra_ocorrencia_sup,
      o.ic_mostra_ocorrencia_cop,
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento,
      o.cd_tipo_pagamento_frete,
      o.cd_transportadora,
      v.nm_razao_social,
      o.cd_documento,
      o.cd_tipo_doc_ocorrencia,
      o.cd_item_documento,
      o.nm_assunto_ocorrencia,
      o.cd_tipo_assunto,
      o.cd_usuario_destino,
      o.cd_departamento,
      o.cd_tipo_custo,
      o.cd_usuario_origem,
      o.cd_usuario_gerente,
      o.cd_destinatario,
      o.cd_com_copias,
      o.nm_obs_baixa,
      o.cd_usuario,
      o.dt_usuario,
      uo.nm_usuario as nm_usuario_origem,
      uo.cd_departamento as cd_departamento_origem,
--      case o.cd_tipo_destinatario 
--			when 1 then 
				v.nm_fantasia 
--			when 2 then
--             Fornecedor
--	      when 8 then
--				Banco	
--			else '' 
		
--			end 
		as Cliente,
      o.cd_destinatario,
      o.cd_tipo_destinatario,
      case 
			when o.cd_tipo_destinatario <> 1 then 
				v.nm_fantasia 
			else '' 
			end 
		as Destinatario,
			o.cd_usuario_custo, o.vl_custo_ocorrencia, o.dt_custo_ocorrencia, o.ds_custo_ocorrencia,
      o.cd_origem_ocorrencia,  

      isnull((select top 1 'S'  from ocorrencia x where x.cd_ocorrencia = o.cd_ocorrencia and ';' + x.cd_com_copias + ';' like '%;' + cast(@cd_usuario as varchar) + ';%'), 'N') as Copia
    from 
         ocorrencia o
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_destino = u.cd_usuario
    Left outer Join egisadmin.dbo.usuario uo
    On o.Cd_usuario_origem = uo.cd_usuario
 
    Left outer Join departamento d
    On u.cd_departamento = d.cd_departamento
    left outer join
      vw_destinatario_rapida v on v.cd_destinatario = o.cd_destinatario and
                                  v.cd_tipo_destinatario = o.cd_tipo_destinatario
    where 
      ( case when @ic_parametro = 1 then
          O.cd_usuario_origem 
        when @ic_parametro = 2 then
          O.cd_usuario_destino
        when @ic_parametro = 7 then
          ( case when O.cd_usuario_origem = @cd_usuario then
              O.cd_usuario_origem else O.cd_usuario_destino end ) 
        end ) = ( case when @ic_parametro = 1 then @cd_usuario 
                       when @ic_parametro = 7 then @cd_usuario 
                       when @ic_parametro = 2 and O.cd_usuario_destino = @cd_usuario then @cd_usuario 
                       when @ic_parametro = 2 and exists ( select top 1 'x' 
                                                           from ocorrencia x 
                                                           where x.cd_ocorrencia = o.cd_ocorrencia and
                                                                 ';' + x.cd_com_copias + ';' like '%;' + cast(@cd_usuario as varchar) + ';%') then O.cd_usuario_destino end ) and

      O.cd_ocorrencia = ( case when @cd_ocorrencia = 0 then
                           O.cd_ocorrencia else
                           @cd_ocorrencia end ) and 
     IsNull(o.cd_status_ocorrencia,0) = ( case when @cd_status = 0 then
                                           IsNull(o.cd_status_ocorrencia,0) else
                                           @cd_status end ) and 
     o.dt_ocorrencia between ( case when @cd_ocorrencia = 0 then
                                 @DataInicial else
                                 o.dt_ocorrencia end ) and 
                             ( case when @cd_ocorrencia = 0 then
                                 @DataFinal else
                                o.dt_ocorrencia end ) and
    IsNull(o.ic_mostra_ocorrencia,'N') = ( case when @ic_mostrar_ocorrencia = 'S' then
                                              IsNull(o.ic_mostra_ocorrencia,'N') else
                                              'S' end )  and
    not exists ( select top 1 'x'  from ocorrencia x with (nolock)
                 where x.cd_ocorrencia = o.cd_ocorrencia and
                 ';' + x.cd_baixa_com_copia + ';' like '%;' + cast(@cd_usuario as varchar) + ';%')

    order by O.cd_ocorrencia desc

  end

-------------------------------------------------------------------------------------------
  if @ic_parametro = 3 -- Documentos para Baixa
-------------------------------------------------------------------------------------------
  begin
    
    Select    
      o.cd_ocorrencia,
      o.dt_ocorrencia, 
      o.dt_baixa_ocorrencia,
      o.cd_status_ocorrencia,
      d.nm_departamento,
      u.nm_fantasia_usuario,
      ts.nm_tipo_status_ocorrencia,
      0 as ic_Baixar,
      ds_ocorrencia,
      o.nm_obs_baixa,
      o.cd_usuario_origem,
      o.cd_usuario_destino,
      o.cd_usuario_gerente,
      o.cd_tipo_custo,
      o.cd_documento,
      o.cd_departamento,
      o.cd_item_documento,
      o.cd_transportadora,
      o.nm_assunto_ocorrencia,
      o.cd_tipo_doc_ocorrencia,
      o.cd_tipo_destinatario,
      o.cd_destinatario,
      o.cd_tipo_assunto,
      o.cd_baixa_com_copia,
      uo.cd_departamento as cd_departamento_origem,
      case when o.cd_tipo_destinatario = 1 then v.nm_fantasia else '' end as Cliente,
      case when o.cd_tipo_destinatario <> 1 then v.nm_fantasia else '' end as Destinatario,
      isnull((select top 1 'S'  from ocorrencia x where x.cd_ocorrencia = o.cd_ocorrencia and ';' + x.cd_com_copias + ';' like '%;' + cast(@cd_usuario as varchar) + ';%'), 'N') as Copia
    from 
         ocorrencia o with (nolock) 
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_destino = u.cd_usuario
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario uo
    On o.Cd_usuario_origem = uo.cd_usuario
    left outer join
      vw_destinatario_rapida v on v.cd_destinatario = o.cd_destinatario and
                                  v.cd_tipo_destinatario = o.cd_tipo_destinatario

    where 
      (((case when O.cd_usuario_origem = @cd_usuario then
        O.cd_usuario_origem else O.cd_usuario_destino end ) = @cd_usuario) or
       exists(select top 1 'x'  from ocorrencia x where x.cd_ocorrencia = o.cd_ocorrencia and ';' + x.cd_com_copias + ';' like '%;' + cast(@cd_usuario as varchar) + ';%')
      )and
     IsNull(o.cd_status_ocorrencia,0) = ( case when @cd_status = 0 then
                                           IsNull(o.cd_status_ocorrencia,0) else
                                           @cd_status end ) and 
     o.dt_ocorrencia between @DataInicial and @DataFinal and
    not exists(select top 1 'x'  from ocorrencia x where x.cd_ocorrencia = o.cd_ocorrencia and ';' + x.cd_baixa_com_copia + ';' like '%;' + cast(@cd_usuario as varchar) + ';%')

    order by O.cd_ocorrencia desc

  end

-------------------------------------------------------------------------------------------
  else if @ic_parametro = 4 --Todas as mensagens referente ao usuario
-------------------------------------------------------------------------------------------
  begin
    
    Select

      o.cd_ocorrencia ,
      o.ds_ocorrencia ,
      o.dt_ocorrencia , 
      nm_departamento = case 
          when o.cd_usuario_origem = @cd_usuario then
              (
               select nm_Departamento 
               from egisadmin.dbo.usuario u Left outer Join 
                    departamento d On u.cd_departamento = d.cd_departamento
               where u.cd_usuario = o.cd_usuario_destino
              )
          when o.cd_usuario_destino = @cd_usuario then
              ( 
               select nm_Departamento
               from egisadmin.dbo.usuario u Left outer Join 
                    departamento d On u.cd_departamento = d.cd_departamento
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
      o.dt_cancela_ocorrencia,
      o.nm_motivo_cancelamento,
      case when o.cd_tipo_destinatario = 1 then v.nm_fantasia else '' end as Cliente,
      case when o.cd_tipo_destinatario <> 1 then v.nm_fantasia else '' end as Destinatario


    from 
      ocorrencia o             with (nolock) 
      left outer join
      vw_destinatario_rapida v on v.cd_destinatario      = o.cd_destinatario and
                                  v.cd_tipo_destinatario = o.cd_tipo_destinatario
    where 
      (
       (O.cd_usuario_Destino = @cd_usuario) or
       (O.cd_usuario_origem = @cd_usuario)
      ) and
     IsNull(o.cd_status_ocorrencia,0) = ( case when @cd_status = 0 then
                                           IsNull(o.cd_status_ocorrencia,0) else
                                           @cd_status end ) and 
     o.dt_ocorrencia between ( case when @cd_ocorrencia = 0 then
                                 @DataInicial else
                                 o.dt_ocorrencia end ) and 
                             ( case when @cd_ocorrencia = 0 then
                                 @DataFinal else
                                o.dt_ocorrencia end )

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
         ocorrencia o with (nolock) 
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_origem = u.cd_usuario
    where 
      (O.cd_usuario_gerente = @cd_usuario) and
      O.cd_ocorrencia = ( case when @cd_ocorrencia = 0 then
                           O.cd_ocorrencia else
                           @cd_ocorrencia end ) and 
     IsNull(o.cd_status_ocorrencia,0) = ( case when @cd_status = 0 then
                                           IsNull(o.cd_status_ocorrencia,0) else
                                           @cd_status end ) and 
     o.dt_ocorrencia between ( case when @cd_ocorrencia = 0 then
                                 @DataInicial else
                                 o.dt_ocorrencia end ) and 
                             ( case when @cd_ocorrencia = 0 then
                                 @DataFinal else
                                o.dt_ocorrencia end )

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
         ocorrencia o with (nolock) 
    Left outer Join EGISADMIN.dbo.departamento d
    On o.cd_departamento = d.cd_departamento
    Left outer Join ocorrencia_tipo_status ts
    On o.cd_status_ocorrencia = ts.cd_tipo_status_ocorrencia
    Left outer Join egisadmin.dbo.usuario u
    On o.Cd_usuario_origem = u.cd_usuario
    where (
           ';'+(O.cd_com_copias)+';' like '%;'+ltrim(rtrim(cast (@cd_usuario as char (10))))+';%'
          ) and
      O.cd_ocorrencia = ( case when @cd_ocorrencia = 0 then
                           O.cd_ocorrencia else
                           @cd_ocorrencia end ) and 
     IsNull(o.cd_status_ocorrencia,0) = ( case when @cd_status = 0 then
                                           IsNull(o.cd_status_ocorrencia,0) else
                                           @cd_status end ) and 
     o.dt_ocorrencia between ( case when @cd_ocorrencia = 0 then
                                 @DataInicial else
                                 o.dt_ocorrencia end ) and 
                             ( case when @cd_ocorrencia = 0 then
                                 @DataFinal else
                                o.dt_ocorrencia end ) and
    not exists ( select top 1 'x'  from ocorrencia x 
                 where x.cd_ocorrencia = o.cd_ocorrencia and
                 ';' + x.cd_baixa_com_copia + ';' like '%;' + cast(@cd_usuario as varchar) + ';%')
    order by O.cd_ocorrencia desc

  end

