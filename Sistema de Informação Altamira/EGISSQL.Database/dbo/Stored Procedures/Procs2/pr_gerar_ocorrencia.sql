--pr_gerar_ocorrencia
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
-- Johnny / Sandro / Carlos
--Gerar ocorrência automaticamente pelo EGIS
--Data          : 28.06.2002
--Atualizado    : 18/07/2002
--              : Inclusão de campos novos
--   			    : 31/05/2005 Ricardo 	 - Incluso Parametro @cd_ocorrencia
---------------------------------------------------------------------------------------

CREATE procedure pr_gerar_ocorrencia
  @cd_ocorrencia 		int =-1,
  @dt_ocorrencia		datetime,
  @ds_ocorrencia		text,
  @cd_tipo_pagamento_frete	int,
  @nm_obs_transporte		varchar,
  @dt_baixa_ocorrencia		datetime,
  @cd_usuario_destino		int,
  @cd_documento			int,
  @cd_departamento		int,
  @cd_item_documento		int,
  @nm_obs_baixa			varchar,
  @cd_usuario			int,
  @dt_usuario			datetime,
  @cd_tipo_assunto		int,
  @cd_transportadora		int,
  @nm_assunto_ocorrencia	varchar,
  @cd_usuario_origem		int,
  @cd_status_ocorrencia		int,
  @cd_usuario_gerente		int,
  @cd_tipo_doc_ocorrencia	int,
  @cd_tipo_custo                int,
  @cd_com_copias                varchar(150),
  @ic_mostra_ocorrencia         char (1),
  @ic_mostra_ocorrencia_sup     char (1),
  @ic_mostra_ocorrencia_cop     varchar (100),
  @cd_tipo_Destinatario 	int,
  @cd_Destinatario 	        int

AS

--  declare @cd_ocorrencia int
  begin transaction

declare @New_codigo int
declare @Tabela varchar(100)

set @tabela = db_name() + '.dbo.Ocorrencia'

	if  @cd_ocorrencia = -1 
		 exec egisadmin.dbo.sp_PegaCodigo @tabela,'cd_Ocorrencia',@codigo = @New_codigo output
   else
		set @New_codigo = @cd_ocorrencia


  --Pegando código da próxima ocorrência
--  select-
--    @cd_ocorrencia = isnull(max(cd_ocorrencia),0) + 1
--  from
--    Ocorrencia

  --Verificando se foi informada a data
  if @dt_ocorrencia = ''
    set @dt_ocorrencia = getdate()

  --Verifica se usuário destino foi informado
  if not exists(select top 1 'x'
                from EGISAdmin.dbo.Usuario
                where cd_usuario = @cd_usuario_destino)             
  begin
    raiserror('Usuário destino da ocorrência não existe!', 16, 1)
    goto TrataErro
  end
  else
    insert into
      Ocorrencia
      ([cd_ocorrencia], 
       [dt_ocorrencia], 
       [ds_ocorrencia], 
       [cd_tipo_pagamento_frete], 
       [nm_obs_transporte], 
       [dt_baixa_ocorrencia], 
       [cd_usuario_destino], 
       [cd_documento], 
       [cd_departamento], 
       [cd_item_documento], 
       [nm_obs_baixa], 
       [cd_usuario], 
       [dt_usuario], 
       [cd_tipo_assunto], 
       [cd_transportadora], 
       [nm_assunto_ocorrencia], 
       [cd_usuario_origem], 
       [cd_status_ocorrencia], 
       [cd_usuario_gerente], 
       [cd_tipo_doc_ocorrencia],
       [cd_tipo_custo],
       [cd_com_copias],
       [ic_mostra_ocorrencia],
       [ic_mostra_ocorrencia_sup],
       [ic_mostra_ocorrencia_cop],
       [cd_tipo_Destinatario],
       [cd_Destinatario])
    values
      (@New_codigo,
       @dt_ocorrencia,
       @ds_ocorrencia,
       @cd_tipo_pagamento_frete,
       @nm_obs_transporte,
       @dt_baixa_ocorrencia,
       @cd_usuario_destino,
       @cd_documento,
       @cd_departamento,
       @cd_item_documento,
       @nm_obs_baixa,
       @cd_usuario,
       @dt_usuario,
       @cd_tipo_assunto,
       @cd_transportadora,
       @nm_assunto_ocorrencia,
       @cd_usuario_origem,
       @cd_status_ocorrencia,
       @cd_usuario_gerente,
       @cd_tipo_doc_ocorrencia,
       @cd_tipo_custo,
       @cd_com_copias,
       @ic_mostra_ocorrencia,
       @ic_mostra_ocorrencia_sup,
       @ic_mostra_ocorrencia_cop,
       @cd_tipo_Destinatario,
       @cd_Destinatario)


  --Confima Transação Caso Não Tenha Ocorrido Nenhum Erro
  TrataErro:
    if @@Error = 0
      commit transaction
    else
      rollback transaction


