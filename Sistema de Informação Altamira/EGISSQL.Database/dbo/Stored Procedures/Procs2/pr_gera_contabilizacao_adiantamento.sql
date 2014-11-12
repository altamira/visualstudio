
-------------------------------------------------------------------------------
--sp_helptext pr_gera_contabilizacao_adiantamento
-------------------------------------------------------------------------------
--pr_gera_contabilizacao_adiantamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Contabilização do Adiantamento de Viagem
--Data             : 17.05.2007
--Alteração        : 04.06.2007
--                 : 31.08.2007 - Verificação - Carlos Fernandes
--                 : 27.09.2007 - Flag para Contabilização - Carlos Fernandes
--                 : 14.11.2007 - Acerto do Histórico - Carlos Fernandes
--                 : 17.11.2007 - Tirar a Data do Histórico - Carlos Fernandes
-- 10.12.2007 - Novo campo para controle lançamento contábil - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_contabilizacao_adiantamento
@ic_parametro   int = 0,
@cd_solicitacao int = 0,
@cd_usuario     int = 0

as

------------------------------------------------------------------------------
--Geração da Contabilização
------------------------------------------------------------------------------
--select * from solicitacao_adiantamento_contabil


if @ic_parametro = 1
begin

  declare @Tabela		         varchar(80)
  declare @cd_contab_solicitacao   int
  declare @cd_contab_adiantamento  int 
  declare @cd_conta_adiantamento   int
  declare @cd_conta_banco          int
  declare @cd_conta_caixa          int
  declare @cd_conta_adto_moeda     int

--verifica a tabela de parâmetros

select
  @cd_conta_adiantamento   = isnull(cd_conta_adiantamento,0),  --Débito
  @cd_conta_banco          = isnull(cd_conta_banco,0),
  @cd_conta_caixa          = isnull(cd_conta_caixa,0),
  @cd_conta_adto_moeda     = isnull(cd_conta_adto_moeda,0)
from
  parametro_prestacao_conta
where
  cd_empresa = dbo.fn_empresa()  

--select * from solicitacao_adiantamento
--select * from tipo_adiantamento

if @cd_solicitacao > 0
begin

  --Atualiza a Conta Contábil conforme o Tipo de A

  --deleta todas as contabilizações da prestação

  delete from solicitacao_adiantamento_contabil where cd_solicitacao = @cd_solicitacao

  select
    identity(int,1,1)                            as cd_contab_adiantamento,                
    sa.cd_solicitacao,
    sa.dt_solicitacao,        
    sa.cd_requisicao_viagem,
    rv.cd_projeto_viagem,
    sa.vl_adiantamento,

    --Conta Débito do Adiantamento
    pcd.cd_conta                                 as cd_conta_debito,       
    pcd.cd_mascara_conta                         as cd_mascara_conta_debito,
    pcd.nm_conta                                 as nm_conta_debito,

    --Conta Crédito do Adiantamento
    pcp.cd_conta                                 as cd_conta_credito,
    pcp.cd_mascara_conta                         as cd_mascara_credito,
    pcp.nm_conta                                 as nm_conta_credito,
    0                                            as cd_lancamento_padrao,
--    'SA N.'+rtrim(ltrim(cast(sa.cd_solicitacao as varchar)))+ 
--    '-'    +rtrim(ltrim(convert(varchar(10),isnull(sa.dt_solicitacao,getdate()),103 ))) as nm_historico_contabil
    cast('SA N.'+rtrim(ltrim(cast(sa.cd_solicitacao as varchar))) as varchar(40))  as nm_historico_contabil


  into
    #AuxAdiantamentoContabil
  
--select * from tipo_adiantamento

  from
    solicitacao_adiantamento             sa  with (nolock) 
    left outer join tipo_adiantamento    ta  with (nolock) on ta.cd_tipo_adiantamento = sa.cd_tipo_adiantamento
    left outer join requisicao_viagem    rv  with (nolock) on rv.cd_requisicao_viagem = sa.cd_requisicao_viagem
    left outer join projeto_viagem       pv  with (nolock) on pv.cd_projeto_viagem    = rv.cd_projeto_viagem
    left outer join plano_conta          pcd with (nolock) on pcd.cd_conta            = case when isnull(ta.cd_conta_debito,0)=0 
                                                                                        then @cd_conta_adiantamento
                                                                                        else ta.cd_conta_debito 
                                                                                        end
    left outer join plano_conta          pcp with (nolock) on pcp.cd_conta            = ta.cd_conta
  where
    sa.cd_solicitacao = case when @cd_solicitacao=0 then sa.cd_solicitacao else @cd_solicitacao end 

  --select * from #AuxAdiantamentoContabil

  --atualização do controle de lançamento contábil

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Solicitacao_Adiantamento_Contabil' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_adiantamento', @codigo = @cd_contab_adiantamento output
	
  while exists(Select top 1 'x' from Solicitacao_Adiantamento_Contabil where cd_contab_adiantamento = @cd_contab_adiantamento)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_adiantamento', @codigo = @cd_contab_adiantamento output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_adiantamento, 'D'
  end

  --Contabilizacao das Contas Contabeis

  --solicitacao_adiantamento_contabil

  select
    @cd_contab_adiantamento+cd_contab_adiantamento  as cd_contab_adiantamento,
    dt_solicitacao                                  as dt_contab_adiantamento,
    cd_solicitacao,
    cd_lancamento_padrao,
    cd_conta_debito,
    cd_conta_credito,
    0                                              as cd_historico_contabil,
    nm_historico_contabil,
    'N'                                            as ic_sct_adiantamento,
    null                                           as dt_sct_adiantamento,
    vl_adiantamento                                as vl_contab_adiantamento,
    0                                              as cd_lote_contabil,
    'N'                                            as ic_manutencao_contabil,
    @cd_usuario                                    as cd_usuario,
    getdate()                                      as dt_usuario,
    'N'                                            as ic_contabilizado,
    null                                           as cd_lancamento_contabil

  into
    #Solicitacao_Adiantamento_Contabil
  from
    #AuxAdiantamentoContabil

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Solicitacao_Adiantamento_Contabil
  select
    * 
  from
    #Solicitacao_Adiantamento_Contabil

  drop table #Solicitacao_Adiantamento_Contabil

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_adiantamento, 'D'


--   select * from solicitacao_adiantamento_contabil
--   where
--     cd_solicitacao = @cd_solicitacao
-- 

  end

end

------------------------------------------------------------------------------
--Consulta da Contabilização
------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  select 
    sac.*,
    sac.cd_contab_adiantamento                   as cd_contab_solicitacao,
    sac.dt_contab_adiantamento                   as dt_contab_solicitacao,
    --Conta Débito do Adiantamento
    pcd.cd_conta                                 as cd_conta_debito,       
    pcd.cd_mascara_conta                         as cd_mascara_conta_debito,
    pcd.nm_conta                                 as nm_conta_debito,

    --Conta Crédito do Adiantamento
    pcp.cd_conta                                 as cd_conta_credito,
    pcp.cd_mascara_conta                         as cd_mascara_conta_credito,
    pcp.nm_conta                                 as nm_conta_credito
 
  from 
    solicitacao_adiantamento_contabil sac
    left outer join plano_conta          pcd with (nolock) on pcd.cd_conta = sac.cd_conta_debito
    left outer join plano_conta          pcp with (nolock) on pcp.cd_conta = sac.cd_conta_credito                                                                          
  where
    sac.cd_solicitacao = @cd_solicitacao

end

--select * from projeto_viagem
--select * from requisicao_viagem
--select * from tipo_despesa
--select * from tipo_despesa_viagem
--select * from tipo_prestacao_conta
--select * from plano_conta

