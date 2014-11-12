
-------------------------------------------------------------------------------
--sp_helptext pr_gera_movimento_caixa
-------------------------------------------------------------------------------
--pr_gera_movimento_caixa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática do Movimento de Caixa
--Data             : 22.10.2007
--Alteração        : 09.11.2007 - Acerto da Estrutura da Tabela - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_movimento_caixa
@cd_tipo_caixa        int = 0,
@cd_usuario           int = 0,
@cd_tipo_operacao     int = 0,
@cd_requisicao_viagem int = 0,
@cd_solicitacao       int = 0,
@cd_prestacao         int = 0
as


declare @Tabela		     varchar(80)
declare @cd_lancamento_caixa int

-- Nome da Tabela usada na geração e liberação de códigos
set @Tabela = cast(DB_NAME()+'.dbo.Caixa_Lancamento' as varchar(80))
set @cd_lancamento_caixa = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_caixa', @codigo = @cd_lancamento_caixa output
	
  while exists(Select top 1 'x' from caixa_lancamento where cd_lancamento_caixa = @cd_lancamento_caixa)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_caixa', @codigo = @cd_lancamento_caixa output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_caixa, 'D'
  end


--Geração a Partir da Requisicao Viagem

if @cd_requisicao_viagem>0
begin

  delete from caixa_lancamento where cd_requisicao_viagem = @cd_requisicao_viagem

  --Geração do Lançamento
  --select * from requisicao_viagem
  --select * from caixa_lancamento

  select
    @cd_lancamento_caixa                    as cd_lancamento_caixa,
    @cd_tipo_operacao                       as cd_tipo_operacao,
    rv.dt_requisicao_viagem                 as dt_lancamento_caixa,
    case when rv.cd_moeda = 1 then
      rv.vl_adto_viagem 
    else 
      rv.vl_adto_moeda
    end                                     as vl_lancamento_caixa,
    'RV: '+cast( rv.cd_requisicao_viagem as varchar)
                                            as cd_documento_lancamento,
    'Retirada '                             as nm_historico_lancamento,
    m.cd_tipo_caixa                         as cd_tipo_caixa,
    null                                    as cd_plano_financeiro,
    null                                    as cd_historico_financeiro,
    rv.cd_moeda                             as cd_moeda,
    @cd_usuario                             as cd_usuario,
    getdate()                               as dt_usuario,
    null                                    as cd_lancamento_padrao,
    null                                    as cd_conta,
    null                                    as cd_conta_debito,
    null                                    as cd_conta_credito,
    null                                    as dt_contabilizacao,
    null                                    as cd_lancamento_contabil,
    null                                    as cd_lote,
    null                                    as cd_documento,
    null                                    as cd_documento_baixa,
    'N'                                     as ic_lancamento_conciliado,
    2                                       as cd_tipo_lancamento_fluxo,
   rv.vl_cotacao_requisicao                 as vl_cotacao_moeda,
   rv.dt_moeda_requisicao                   as dt_cotacao_moeda,
   rv.cd_requisicao_viagem,
   null                                     as cd_solicitacao,
   null                                     as cd_prestacao,
   rv.cd_ap                                 as cd_ap,
   rv.vl_adto_moeda                         as vl_caixa_moeda,
   null                                     as nm_obs_caixa_lancamento   
  into
    #Caixa_Lancamento

	  from
    Requisicao_Viagem    rv with (nolock)
    left outer join Moeda m on m.cd_moeda = rv.cd_moeda
  where
    rv.cd_requisicao_viagem = @cd_requisicao_viagem

  select * from #Caixa_lancamento

  insert into
    caixa_lancamento
  select
    *
  from
    #Caixa_Lancamento

  drop table #Caixa_Lancamento


end

--Prestação de Conta - Devolução de Moeda Estrangeira

if @cd_prestacao>0
begin

  --select * from prestacao_conta

  delete from caixa_lancamento where cd_prestacao = @cd_prestacao

  --Montagem da Tabela agrupada

  --select * from prestacao_conta_moeda
    
  select
    identity(int,1,1)                 as cd_controle,    
    cd_prestacao,
    cd_moeda,
    sum(isnull(vl_prestacao_moeda,0)) as vl_prestacao_moeda,
    max(vl_cotacao_prestacao_moeda)   as vl_cotacao_prestacao_moeda,
    max(dt_prestacao_moeda)           as dt_prestacao_moeda
  into
    #TotalPrestacaoMoeda
  from
    Prestacao_Conta_moeda
  where
    cd_prestacao = @cd_prestacao  and
    isnull(ic_tipo_lancamento,'M')='M'
  group by
    cd_prestacao,
    cd_moeda

  select
    @cd_lancamento_caixa + cd_controle      as cd_lancamento_caixa,
    @cd_tipo_operacao                       as cd_tipo_operacao,
    pc.dt_prestacao                         as dt_lancamento_caixa,
    pcm.vl_prestacao_moeda                  as vl_lancamento_caixa,
    'PC: '+cast( pc.cd_prestacao as varchar)
                                            as cd_documento_lancamento,
    'Devolução '                            as nm_historico_lancamento,
    m.cd_tipo_caixa                          as cd_tipo_caixa,
    null                                    as cd_plano_financeiro,
    null                                    as cd_historico_financeiro,
    pcm.cd_moeda                             as cd_moeda,
    @cd_usuario                             as cd_usuario,
    getdate()                               as dt_usuario,
    null                                    as cd_lancamento_padrao,
    null                                    as cd_conta,
    null                                    as cd_conta_debito,
    null                                    as cd_conta_credito,
    null                                    as dt_contabilizacao,
    null                                    as cd_lancamento_contabil,
    null                                    as cd_lote,
    null                                    as cd_documento,
    null                                    as cd_documento_baixa,
    'N'                                     as ic_lancamento_conciliado,
    2                                       as cd_tipo_lancamento_fluxo,
   pcm.vl_cotacao_prestacao_moeda           as vl_cotacao_moeda,
   pcm.dt_prestacao_moeda                   as dt_cotacao_moeda,
   null                                     as cd_requisicao_viagem,
   null                                     as cd_solicitacao,
   @cd_prestacao                            as cd_prestacao,
   pc.cd_ap                                 as cd_ap,
   pcm.vl_prestacao_moeda                   as vl_caixa_moeda,
   null                                     as nm_obs_caixa_lancamento   
  into
    #Caixa_Lancamento_Prestacao

  from
    Prestacao_Conta pc                   with (nolock)
    inner join  #TotalPrestacaoMoeda pcm with (nolock) on pcm.cd_prestacao = pc.cd_prestacao
    left outer join Moeda m              with (nolock) on m.cd_moeda       = pcm.cd_moeda
  where
    pc.cd_prestacao = @cd_prestacao

  insert into
    caixa_lancamento
  select
    *
  from
    #Caixa_Lancamento_Prestacao

  drop table #Caixa_Lancamento_Prestacao

--select * from prestacao_conta_moeda

end

if @cd_solicitacao>0
begin

  delete from caixa_lancamento where cd_solicitacao = @cd_solicitacao

  --Geração do Lançamento
  --select * from solicitacao_adiantamento
  --select * from caixa_lancamento

  select
    @cd_lancamento_caixa                    as cd_lancamento_caixa,
    @cd_tipo_operacao                       as cd_tipo_operacao,
    sa.dt_solicitacao                       as dt_lancamento_caixa,
    case when sa.cd_moeda = 1 then
      sa.vl_adiantamento
    else 
      sa.vl_total_moeda_solicitacao
    end                                     as vl_lancamento_caixa,
    'SA: '+cast( sa.cd_solicitacao as varchar)
                                            as cd_documento_lancamento,
    'Retirada '                             as nm_historico_lancamento,
    m.cd_tipo_caixa                          as cd_tipo_caixa,
    null                                    as cd_plano_financeiro,
    null                                    as cd_historico_financeiro,
    sa.cd_moeda                             as cd_moeda,
    @cd_usuario                             as cd_usuario,
    getdate()                               as dt_usuario,
    null                                    as cd_lancamento_padrao,
    null                                    as cd_conta,
    null                                    as cd_conta_debito,
    null                                    as cd_conta_credito,
    null                                    as dt_contabilizacao,
    null                                    as cd_lancamento_contabil,
    null                                    as cd_lote,
    null                                    as cd_documento,
    null                                    as cd_documento_baixa,
    'N'                                     as ic_lancamento_conciliado,
    2                                       as cd_tipo_lancamento_fluxo,
   sa.vl_cotacao_solicitacao                as vl_cotacao_moeda,
   sa.dt_moeda_solicitacao                  as dt_cotacao_moeda,
   null                                     as cd_requisicao_viagem,
   sa.cd_solicitacao,
   null                                     as cd_prestacao,
   sa.cd_ap                                 as cd_ap,
   sa.vl_total_moeda_solicitacao            as vl_caixa_moeda,
   null                                     as nm_obs_caixa_lancamento
  into
    #Caixa_Lancamento_Solicitacao

  from
    Solicitacao_Adiantamento sa with (nolock)
    left outer join Moeda m on m.cd_moeda = sa.cd_moeda
  where
    cd_solicitacao = @cd_solicitacao

  insert into
    caixa_lancamento
  select
    *
  from
    #Caixa_Lancamento_Solicitacao

  drop table #Caixa_Lancamento_Solicitacao

end



-- limpeza da tabela de código
exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_caixa, 'D'

--select * from caixa_lancamento

