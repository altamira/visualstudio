
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_saldo_adiantamento_prestacao
-------------------------------------------------------------------------------
--pr_geracao_saldo_adiantamento_prestacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Novo Adiantamento com o Saldo da Prestação
--Data             : 01.01.2009
--Alteração        : 18.01.2010 - Acertos Diversos - Carlos Fernandes
--01.02.2010 - Geração da Aprovação - Carlos Fernandes
--
------------------------------------------------------------------------------
create procedure pr_geracao_saldo_adiantamento_prestacao
@cd_prestacao           int   = 0,
@vl_saldo_adiantamento  float = 0,
@cd_usuario             int   = 0,
@cd_solicitacao_retorno int   = 0 output

as

  declare @Tabela		     varchar(80)
  declare @cd_solicitacao            int


-----------------------------------------------------------------------------------------
--Geração do Adiantamento
-----------------------------------------------------------------------------------------


    set @cd_solicitacao = 0

    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Solicitacao_Adiantamento' as varchar(50))

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_solicitacao', @codigo = @cd_solicitacao output
	
    while exists(Select top 1 'x' from solicitacao_adiantamento where cd_solicitacao = @cd_solicitacao)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_solicitacao', @codigo = @cd_solicitacao output

      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_solicitacao, 'D'
    end

    --select * from finalidade_adiantamento

    select
      @cd_solicitacao                      as cd_solicitacao,
      --@dt_ap                             as dt_solicitacao,
      pc.dt_prestacao                         as dt_solicitacao,
      pc.dt_prestacao                         as dt_necessidade,
      pc.cd_funcionario,
      pc.cd_centro_custo,
      pc.cd_departamento,

--       isnull(( select top 1 cd_finalidade_adiantamento 
--           from
--            Finalidade_Adiantamento
--           where 
--             isnull(ic_tipo_finalidade,'D') = 'R' or
--             isnull(ic_pad_finalidade_adiantamento,'N') = 'S'),0)

      sa.cd_finalidade_adiantamento        as cd_finalidade_adiantamento,
      sa.cd_requisicao_viagem,
      pc.ds_prestacao                      as ds_solicitacao,
      pc.dt_prestacao                      as dt_vencimento,
      sa.cd_moeda,
      @vl_saldo_adiantamento               as vl_adiantamento,
      @vl_saldo_adiantamento               as vl_saldo_adiantamento,
      @cd_usuario                          as cd_usuario,
      getdate()                            as dt_usuario,
      null                                 as dt_liberacao_adiantamento,
      null                                 as cd_usuario_liberacao,
      sa.dt_moeda_solicitacao              as dt_moeda_solicitacao,
      sa.vl_cotacao_solicitacao            as vl_cotacao_solicitacao,
      sa.vl_total_moeda_solicitacao        as vl_total_moeda_solicitacao,
      null                                 as cd_prestacao,
      2                                    as ic_tipo_adiantamento,
      null                                 as cd_ap,
      isnull(sa.cd_tipo_adiantamento,1)    as cd_tipo_adiantamento,
      null                                 as dt_pagamento_solicitacao,
      null                                 as dt_contabilizacao_solicitacao,
      null                                 as cd_conta,
      null                                 as dt_conf_solicitacao,
      pc.cd_projeto_viagem                 as cd_projeto_viagem,
      'N'                                  as ic_sel_deposito_adiantamento,
      pc.cd_assunto_viagem                 as cd_assunto_viagem,
      sa.cd_usuario_aprovacao              as cd_usuario_aprovacao,
      sa.cd_funcionario_aprovacao          as cd_funcionario_aprovacao,
      sa.ic_email_solicitacao              as ic_email_solicitacao,
      null                                 as dt_financeiro_solicitacao,
      @cd_usuario                          as cd_usuario_requisicao,
      @vl_saldo_Adiantamento               as vl_solicitacao_moeda,
      sa.ds_temp_obs_aprovacao             as ds_temp_obs_aprovacao,
      null                                 as dt_liberacao_aprovacao,
      sa.cd_secretaria                     as cd_secretaria,
      null                                 as dt_aviso_cobranca,
      sa.cd_cartao_credito                 as cd_cartao_credito,
      null                                 as dt_lib_viagem_internacional,
      getdate()                            as dt_prevista_aprovacao,
      null                                 as dt_reenvio_aprovacao,
      sa.cd_funcionario_liberacao          as cd_funcionario_liberacao,
      null                                 as cd_documento_pagar

--select * from solicitacao_adiantamento

    into
      #Solicitacao_Adiantamento

    from
      Prestacao_Conta pc                     with (nolock) 
      inner join solicitacao_adiantamento sa with (nolock) on sa.cd_prestacao = pc.cd_prestacao

    where
      pc.cd_prestacao = @cd_prestacao

--select * from solicitacao_adiantamento where cd_prestacao = 10692
--select * from prestacao_conta
--select * from #Solicitacao_Adiantamento
--select * from Solicitacao_Adiantamento

    insert into Solicitacao_Adiantamento
    select
      *
    from
      #Solicitacao_Adiantamento


   --Geração da Tabela de Aprovação-------------------------------------------------------

   --select cd_prestacao,* from solicitacao_adiantamento
   --select * from solicitacao_adiantamento_aprovacao

   declare @cd_solicitacao_anterior int

   select
     @cd_solicitacao_anterior = isnull(cd_solicitacao,0)
   from
     solicitacao_adiantamento with (nolock) 
   where
     cd_prestacao = @cd_prestacao

   select
     *
   into
     #Solicitacao_Adiantamento_Aprovacao
   from
     Solicitacao_Adiantamento_Aprovacao


   --select * from solicitacao_adiantamento_aprovacao

   --Atualiza os Dados da Nova Solicitação
   update
     #Solicitacao_Adiantamento
   set
     cd_solicitacao = @cd_solicitacao_anterior

   print 'xxx'

   insert into
     solicitacao_adiantamento_aprovacao
   select
     *
   from
     #solicitacao_adiantamento_aprovacao
   where
     cd_solicitacao not in ( select cd_solicitacao from solicitacao_adiantamento_aprovacao )

   --Atualiza o Saldo do Adiantamento
   --Data : 30.12.2009
   --select * from prestacao_conta
   --select * from solicitacao_adiantamento

--    select 
--      @cd_solicitacao = isnull(cd_solicitacao,0)
--    from
--      solicitacao_Adiantamento
--    where
--      cd_prestacao = @cd_prestacao
-- 
--    update
--      solicitacao_adiantamento
--    set
--      vl_saldo_adiantamento = @vl_saldo_adiantamento
--    where
--      cd_solicitacao        = @cd_solicitacao
   
    --Geração da Contabilização do Adiantamento

    exec pr_gera_contabilizacao_adiantamento 1,@cd_solicitacao,@cd_usuario
    
    --Liberação do Código

    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_solicitacao, 'D'

    set @cd_solicitacao_retorno = @cd_solicitacao

--end



