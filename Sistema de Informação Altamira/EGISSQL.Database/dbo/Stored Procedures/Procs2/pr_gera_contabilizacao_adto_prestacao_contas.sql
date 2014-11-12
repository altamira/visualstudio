
-------------------------------------------------------------------------------
--sp_helptext pr_gera_contabilizacao_adto_prestacao_contas
-------------------------------------------------------------------------------
--pr_gera_contabilizacao_adto_prestacao_contas
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Prestação de Contas do Adiantamentos
--                    
--Data             : 02.10.2007
--Alteração        : 15.10.2007 - Acertos Diversos - Carlos Fernandes
--14.11.2007 - Revisão - Carlos Fernandes
--16.11.2007 - Acerto do Histórico - Carlos Fernandes
--23.11.2007 - Acerto do Histórico para Incluir o Número da Solicitação
--10.12.2007 - Novo campo para controle lançamento contábil - Carlos Fernandes
--04.04.2008 - Acerto do Adiantamento para Cartão de Crédito - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_contabilizacao_adto_prestacao_contas
@cd_prestacao           int = 0,
@cd_solicitacao         int = 0,
@cd_conta_adiantamento  int = 0,
@cd_usuario             int = 0,
@vl_adiantamento        decimal(25,2) = 0
as

--select * from prestacao_conta_contabil

declare @Tabela		      varchar(80)
declare @cd_contab_prestacao  int
declare @vl_prestacao         decimal(25,2)

-- Nome da Tabela usada na geração e liberação de códigos
set @Tabela = cast(DB_NAME()+'.dbo.Prestacao_Conta_Contabil' as varchar(80))

if @cd_prestacao>0 and @cd_solicitacao>0
begin

    select
      identity(int,1,1)                  as cd_contab_prestacao,                
      pc.cd_prestacao,
      pc.dt_prestacao,        
      pc.cd_requisicao_viagem,
      0                                  as cd_conta_debito,
      @cd_conta_adiantamento             as cd_conta_credito,
      pcc.cd_mascara_conta,
      pcc.nm_conta,
      isnull(pc.dt_fechamento_prestacao,getdate()) as dt_fechamento_prestacao,
      0                                            as cd_lancamento_padrao,
--       cast('Adiantamento PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar)))+ 
--       '/'    +rtrim(ltrim(cast(isnull(pc.dt_fechamento_prestacao,getdate()) as varchar)))
--       as varchar(40))                                                                     as nm_historico_contabil,
      cast('Adto '+ case when @cd_solicitacao>0 then
                                 'SA N. '+rtrim(ltrim(cast(@cd_solicitacao as varchar)))
                            end +' '+
      +'PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar))) as varchar(40))
                                                                                          as nm_historico_contabil,

      null                                                                                as cd_centro_custo,
      pc.cd_projeto_viagem,
      null as nm_projeto_viagem,
      'N'  as ic_contabilizado,   
      case when isnull(pc.cd_cartao_credito,0)=0
      then 'N'
      else
           'S' 
      end                                                                                 as ic_cartao_credito
             
    into
      #AuxPrestacaoContabilAdiantamento

    from
      prestacao_conta             pc   with (nolock) 
      left outer join plano_conta pcc  with (nolock) on pcc.cd_conta            = @cd_conta_adiantamento
    where
      pc.cd_prestacao = case when @cd_prestacao=0 then pc.cd_prestacao else @cd_prestacao end and
      @cd_conta_adiantamento>0

    --select * from #AuxPrestacaoContabilAdiantamento
 
    --atualização do controle de lançamento contábil
    set @cd_contab_prestacao = 0

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
	
    while exists(Select top 1 'x' from prestacao_conta_contabil where cd_contab_prestacao = @cd_contab_prestacao)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'
    end

--    select @cd_contab_prestacao

    select
      @cd_contab_prestacao                      as cd_contab_prestacao,
      isnull(dt_fechamento_prestacao,getdate()) as dt_contab_prestacao,
      cd_prestacao,
      cd_lancamento_padrao,
      cd_conta_debito,
      cd_conta_credito,
      0                                         as cd_historico_contabil,
      nm_historico_contabil,
     'N'                                        as ic_sct_prestacao,
      null                                      as dt_sct_prestacao,
      isnull(@vl_adiantamento,0)                as vl_contab_prestacao,
      0                                         as cd_lote_contabil,
     'N'                                        as ic_manutencao_contabil,
      @cd_usuario                               as cd_usuario,
      getdate()                                 as dt_usuario,
      0                                         as cd_centro_custo,
      cd_projeto_viagem,
      nm_projeto_viagem,
      ic_contabilizado,
      ic_cartao_credito,
      null                                      as cd_lancamento_contabil,
      null                                      as ic_contabilizado_fornecedor   
 
  into
    #Prestacao_Conta_Contabil_Adiantamento
  from
    #AuxPrestacaoContabilAdiantamento

  --select * from #AuxPrestacaoContabilAdiantamento

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Prestacao_Conta_Contabil
  select
    * 
  from
    #Prestacao_Conta_Contabil_Adiantamento

  --select * from #Prestacao_Conta_Contabil_Adiantamento

  drop table #Prestacao_Conta_Contabil_Adiantamento
  drop table #AuxPrestacaoContabilAdiantamento

  --select @cd_contab_prestacao

  -- limpeza da tabela de código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'

end

