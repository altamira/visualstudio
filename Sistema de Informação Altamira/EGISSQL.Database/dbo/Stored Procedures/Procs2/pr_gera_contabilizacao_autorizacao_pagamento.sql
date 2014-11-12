
-------------------------------------------------------------------------------
--sp_helptext pr_gera_contabilizacao_autorizacao_pagamento
-------------------------------------------------------------------------------
--pr_gera_contabilizacao_autorizacao_pagamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 07/05/2007
--Alteração        : 14.09.2007 - Carlos Fernandes
--                 : 24.09.2007 - Acerto Geral no Processo de Contabilização - Carlos Fernandes.
--                 : 27.09.2007 - flag para contabilização - Carlos Fernandes
-- 16.11.2007 - Acerto do Histórico - Carlos Fernandes.
-- 23.11.2007 - Acerto do Histórico - Carlos Fernandes
-- 10.12.2007 - Novo campo para controle lançamento contábil - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_contabilizacao_autorizacao_pagamento
@cd_prestacao int = 0,
@cd_ap        int = 0,
@cd_usuario   int = 0

as


declare @Tabela		      varchar(80)
declare @cd_contab_ap         int
declare @vl_ap                decimal(25,2)
declare @cd_requisicao_viagem int

if @cd_prestacao>0 
begin
  select
    @cd_ap = isnull(cd_ap,0)
  from
    Autorizacao_Pagamento
  where
    cd_prestacao = @cd_prestacao
end


--select * from prestacao_conta_composicao
--select * from prestacao_conta

if @cd_ap > 0
begin

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Autorizacao_Pagamento_Contabil' as varchar(80))

  --Parâmetros para Contabilização

  declare @cd_conta_adiantamento   int
  declare @cd_conta_banco          int
  declare @cd_conta_caixa          int
  declare @cd_conta_adto_moeda     int
  declare @cd_cartao_credito       int

  select
    @cd_conta_adiantamento   = isnull(cd_conta_adiantamento,0),  --Débito
    @cd_conta_banco          = isnull(cd_conta_banco,0),
    @cd_conta_caixa          = isnull(cd_conta_caixa,0),
    @cd_conta_adto_moeda     = isnull(cd_conta_adto_moeda,0)
  from
    parametro_prestacao_conta
  where
    cd_empresa = dbo.fn_empresa()  

  --Busca o Valor Total da Prestação de Contas e o Valor do Adiantamento

  select
    @vl_ap                = isnull(vl_ap,0)
  from
    Autorizacao_Pagamento
  where
    cd_ap = @cd_ap


  end

  --deleta todas as contabilizações da prestação

  delete from autorizacao_pagamento_contabil where cd_ap = @cd_ap

  --Contabilização da Autorização de Pagamento
  --select * from autorizacao_pagamento


  if @vl_ap>0
  begin

    --Débito

    select
      identity(int,1,1)                  as cd_contab_ap,                
      ap.cd_ap,
      ap.dt_ap,        
      ap.cd_requisicao_viagem,
      @cd_conta_adiantamento             as cd_conta_debito,
      0                                  as cd_conta_credito,
      pcc.cd_mascara_conta,
      pcc.nm_conta,
      isnull(ap.dt_ap,getdate())         as dt_fechamento_prestacao,
      0                                  as cd_lancamento_padrao,
      cast('PC N.'+rtrim(ltrim(cast(ap.cd_prestacao as varchar))) as varchar(40))
                                         as nm_historico_contabil,
      null                               as cd_centro_custo,
      null as cd_projeto_viagem,
      null as nm_projeto_viagem,
      'N'  as ic_contabilizado,   
      'N'  as ic_cartao_credito,
      ap.cd_prestacao
             
    into
      #AuxDebito

    from
      autorizacao_pagamento             ap   with (nolock) 
      left outer join plano_conta pcc        with (nolock) on pcc.cd_conta            = @cd_conta_adiantamento
      left outer join prestacao_conta   pc   with (nolock) on pc.cd_prestacao         = ap.cd_prestacao
      left outer join funcionario       f    with (nolock) on f.cd_funcionario        = pc.cd_funcionario
    where
      ap.cd_ap = case when @cd_ap=0 then ap.cd_ap else @cd_ap end 
 
    --atualização do controle de lançamento contábil

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_ap', @codigo = @cd_contab_ap output
	
    while exists(Select top 1 'x' from autorizacao_pagamento_contabil where cd_contab_ap = @cd_contab_ap)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_ap', @codigo = @cd_contab_ap output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_ap, 'D'
    end

    select
      @cd_contab_ap+cd_contab_ap                as cd_contab_ap,
      dt_ap                                     as dt_contab_ap,
      cd_ap,
      cd_lancamento_padrao,
      cd_conta_debito,
      cd_conta_credito,
      0                                         as cd_historico_contabil,
      nm_historico_contabil,
     'N'                                        as ic_sct_prestacao,
      null                                      as dt_sct_prestacao,
      isnull(@vl_ap,0)                          as vl_contab_prestacao,
      0                                         as cd_lote_contabil,
     'N'                                        as ic_manutencao_contabil,
      @cd_usuario                               as cd_usuario,
      getdate()                                 as dt_usuario,
      0                                         as cd_centro_custo,
      cd_projeto_viagem,
      nm_projeto_viagem,
      ic_contabilizado,
      ic_cartao_credito,
      cd_prestacao,
      null                                      as cd_lancamento_contabil

  into
    #Autorizacao_Pagamento_Contabil_Debito
  from
    #AuxDebito

  --select * from #AuxPrestacaoContabilAdiantamento

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Autorizacao_Pagamento_Contabil
  select
    * 
  from
    #Autorizacao_Pagamento_Contabil_Debito

  drop table #Autorizacao_Pagamento_Contabil_Debito
  drop table #AuxDebito

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_ap, 'D'

  --select * from  #Prestacao_Conta_Contabil_Adiantamento

    --Crédito

    select
      identity(int,1,1)                  as cd_contab_ap,                
      ap.cd_ap,
      ap.dt_ap,        
      ap.cd_requisicao_viagem,
      0                                  as cd_conta_debito,
      @cd_conta_banco                    as cd_conta_credito,
      pcc.cd_mascara_conta,
      pcc.nm_conta,
      isnull(ap.dt_ap,getdate())         as dt_fechamento_prestacao,
      0                                  as cd_lancamento_padrao,
      cast('AP N.'+rtrim(ltrim(cast(ap.cd_ap as varchar))) as varchar(40))
                                         as nm_historico_contabil,

      null                               as cd_centro_custo,
      null as cd_projeto_viagem,
      null as nm_projeto_viagem,
      'N'  as ic_contabilizado,   
      'N'  as ic_cartao_credito,
      ap.cd_prestacao
             
    into
      #AuxCredito

    from
      autorizacao_pagamento             ap   with (nolock) 
      left outer join plano_conta pcc  with (nolock) on pcc.cd_conta            = @cd_conta_adiantamento
    where
      ap.cd_ap = case when @cd_ap=0 then ap.cd_ap else @cd_ap end 
 
    --atualização do controle de lançamento contábil

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_ap', @codigo = @cd_contab_ap output
	
    while exists(Select top 1 'x' from autorizacao_pagamento_contabil where cd_contab_ap = @cd_contab_ap)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_ap', @codigo = @cd_contab_ap output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_ap, 'D'
    end

    select
      @cd_contab_ap+cd_contab_ap                as cd_contab_ap,
      dt_ap                                     as dt_contab_ap,
      cd_ap,
      cd_lancamento_padrao,
      cd_conta_debito,
      cd_conta_credito,
      0                                         as cd_historico_contabil,
      nm_historico_contabil,
     'N'                                        as ic_sct_prestacao,
      null                                      as dt_sct_prestacao,
      isnull(@vl_ap,0)                          as vl_contab_prestacao,
      0                                         as cd_lote_contabil,
     'N'                                        as ic_manutencao_contabil,
      @cd_usuario                               as cd_usuario,
      getdate()                                 as dt_usuario,
      0                                         as cd_centro_custo,
      cd_projeto_viagem,
      nm_projeto_viagem,
      ic_contabilizado,
      ic_cartao_credito,
      cd_prestacao,
      null                                      as cd_lancamento_contabil

  into
    #Autorizacao_Pagamento_Contabil_Credito
  from
    #AuxCredito

  --select * from #AuxPrestacaoContabilAdiantamento

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Autorizacao_Pagamento_Contabil
  select
    * 
  from
    #Autorizacao_Pagamento_Contabil_Credito

  drop table #Autorizacao_Pagamento_Contabil_Credito
  drop table #AuxCredito

  -- limpeza da tabela de código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_ap, 'D'

  --select * from  #Prestacao_Conta_Contabil_Adiantamento


 end


