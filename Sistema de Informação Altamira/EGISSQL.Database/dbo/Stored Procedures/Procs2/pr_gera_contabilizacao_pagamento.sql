
-------------------------------------------------------------------------------
--sp_helptext pr_gera_contabilizacao_pagamento
-------------------------------------------------------------------------------
--pr_gera_contabilizacao_pagamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Contabilização da Solicitação de Pagamento
--Data             : 17.05.2007
--Alteração        : 04.06.2007
--                 : 31.08.2007 - Verificação - Carlos Fernandes
--                 : 27.09.2007 - Flag para Contabilização - Carlos Fernandes
--                 : 05.11.2007 - Ajustes Diversos - Carlos Fernandes
-- 23.11.2007 - Acerto do Histórico - Carlos Fernandes  
-- 06.12.2007 - Modificação do Histórico Contábil - Carlos Fernandes
-- 10.12.2007 - Novo campo para controle lançamento contábil - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_contabilizacao_pagamento
@ic_parametro   int = 0,
@cd_solicitacao int = 0,
@cd_usuario     int = 0

as

------------------------------------------------------------------------------
--Geração da Contabilização
------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  declare @Tabela		         varchar(80)
  declare @cd_contab_solicitacao   int
  declare @cd_contab_pagamento  int 
  declare @cd_conta_pagamento   int

--select * from solicitacao_pagamento
--select * from tipo_pagamento

if @cd_solicitacao > 0
begin

  --Atualiza a Conta Contábil conforme o Tipo de A

  --deleta todas as contabilizações da prestação

  delete from solicitacao_pagamento_contabil where cd_solicitacao = @cd_solicitacao

  select
    identity(int,1,1)                            as cd_contab_pagamento,                
    sa.cd_solicitacao,
    sa.dt_solicitacao,        
    null                                         as cd_requisicao_viagem,
    null                                         as cd_projeto_viagem,
    sa.vl_pagamento,

    --Conta Débito do pagamento
    null                                         as cd_conta_debito,       
    null                                         as cd_mascara_conta_debito,
    null                                         as nm_conta_debito,

    --Conta Crédito do pagamento
    pcp.cd_conta                                 as cd_conta_credito,
    pcp.cd_mascara_conta                         as cd_mascara_credito,
    pcp.nm_conta                                 as nm_conta_credito,
    0                                            as cd_lancamento_padrao,

    cast('SP N.'+rtrim(ltrim(cast(sa.cd_solicitacao as varchar)))
    +' '+ta.nm_finalidade_pagamento as varchar(40))
 
                                                 as nm_historico_contabil,
    null                                         as cd_item_solicitacao

  into
    #AuxPagamentoContabil
  
--select * from tipo_pagamento

  from
    solicitacao_pagamento                sa  with (nolock) 
    left outer join finalidade_pagamento ta  with (nolock) on ta.cd_finalidade_pagamento = sa.cd_finalidade_pagamento
    --left outer join requisicao_viagem    rv  with (nolock) on rv.cd_requisicao_viagem = sa.cd_requisicao_viagem
    --left outer join projeto_viagem       pv  with (nolock) on pv.cd_projeto_viagem    = rv.cd_projeto_viagem
    left outer join plano_conta          pcp with (nolock) on pcp.cd_conta            = ta.cd_conta
    left outer join funcionario          f   with (nolock) on f.cd_funcionario = sa.cd_funcionario
  where
    sa.cd_solicitacao = case when @cd_solicitacao=0 then sa.cd_solicitacao else @cd_solicitacao end 

  --select * from #AuxpagamentoContabil

  --atualização do controle de lançamento contábil

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Solicitacao_pagamento_Contabil' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_pagamento', @codigo = @cd_contab_pagamento output
	
  while exists(Select top 1 'x' from Solicitacao_pagamento_Contabil where cd_contab_pagamento = @cd_contab_pagamento)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_pagamento', @codigo = @cd_contab_pagamento output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_pagamento, 'D'
  end

  --solicitacao_pagamento_contabil

  select
    @cd_contab_pagamento+cd_contab_pagamento  as cd_contab_pagamento,
    dt_solicitacao                                  as dt_contab_pagamento,
    cd_solicitacao,
    cd_lancamento_padrao,
    cd_conta_debito,
    cd_conta_credito,
    0                                              as cd_historico_contabil,
    nm_historico_contabil,
    'N'                                            as ic_sct_pagamento,
    null                                           as dt_sct_pagamento,
    vl_pagamento                                as vl_contab_pagamento,
    0                                              as cd_lote_contabil,
    'N'                                            as ic_manutencao_contabil,
    @cd_usuario                                    as cd_usuario,
    getdate()                                      as dt_usuario,
    'N'                                            as ic_contabilizado,
    cd_item_solicitacao,
    null                                           as cd_lancamento_contabil
  into
    #Solicitacao_pagamento_Contabil
  from
    #AuxpagamentoContabil

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Solicitacao_pagamento_Contabil
  select
    * 
  from
    #Solicitacao_pagamento_Contabil

  drop table #Solicitacao_pagamento_Contabil
  drop table #AuxpagamentoContabil

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_pagamento, 'D'


--   select * from solicitacao_pagamento_contabil
--   where
--     cd_solicitacao = @cd_solicitacao
-- 

  --Contabilizacao da Composicaom com Contas Contabeis referente as Despesas

  select
    identity(int,1,1)                            as cd_contab_pagamento,                
    sp.cd_solicitacao,
    sp.dt_solicitacao,        
    null                                         as cd_requisicao_viagem,
    null                                         as cd_projeto_viagem,
    spc.vl_total_item_solicitacao                as vl_pagamento,

    --Conta Débito do pagamento

    spc.cd_conta                                 as cd_conta_debito,       
    pcd.cd_mascara_conta                         as cd_mascara_conta_debito,
    pcd.nm_conta                                 as nm_conta_debito,

    --Conta Crédito do pagamento

    null                                         as cd_conta_credito,
    null                                         as cd_mascara_credito,
    null                                         as nm_conta_credito,
    0                                            as cd_lancamento_padrao,
    cast('SP N.'+rtrim(ltrim(cast(sp.cd_solicitacao as varchar))) 
    +' '+case when isnull(spc.nm_complemento_historico,'')<>''
     then
       rtrim(ltrim(spc.nm_complemento_historico))+' '+ fpa.nm_finalidade_pagamento
     else
       fpa.nm_finalidade_pagamento
     end as varchar(40))
                                                 as nm_historico_contabil,
    spc.cd_item_solicitacao                      as cd_item_solicitacao

  into
    #AuxPagamentoContabilComposicao
  
--select * from tipo_pagamento
--select * from solicitacao_pagamento_composicao

  from
    solicitacao_pagamento                       sp  with (nolock) 
    inner join solicitacao_pagamento_composicao spc with (nolock) on spc.cd_solicitacao  = sp.cd_solicitacao
    left outer join plano_conta                 pcd with (nolock) on pcd.cd_conta        = spc.cd_conta
    left outer join finalidade_pagamento        fpa with (nolock) on fpa.cd_finalidade_pagamento = sp.cd_finalidade_pagamento
  where
    sp.cd_solicitacao = case when @cd_solicitacao=0 then sp.cd_solicitacao else @cd_solicitacao end 

  --select * from #AuxpagamentoContabil

  --atualização do controle de lançamento contábil

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Solicitacao_pagamento_Contabil' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_pagamento', @codigo = @cd_contab_pagamento output
	
  while exists(Select top 1 'x' from Solicitacao_pagamento_Contabil where cd_contab_pagamento = @cd_contab_pagamento)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_pagamento', @codigo = @cd_contab_pagamento output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_pagamento, 'D'
  end

  --solicitacao_pagamento_contabil

  select
    @cd_contab_pagamento+cd_contab_pagamento  as cd_contab_pagamento,
    dt_solicitacao                            as dt_contab_pagamento,
    cd_solicitacao,
    cd_lancamento_padrao,
    cd_conta_debito,
    cd_conta_credito,
    0                                              as cd_historico_contabil,
    nm_historico_contabil,
    'N'                                            as ic_sct_pagamento,
    null                                           as dt_sct_pagamento,
    vl_pagamento                                   as vl_contab_pagamento,
    0                                              as cd_lote_contabil,
    'N'                                            as ic_manutencao_contabil,
    @cd_usuario                                    as cd_usuario,
    getdate()                                      as dt_usuario,
    'N'                                            as ic_contabilizado,
    cd_item_solicitacao,
    null                                           as cd_lancamento_contabil
  into
    #Solicitacao_pagamento_Contabil_Composicao
  from
    #AuxPagamentoContabilComposicao

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Solicitacao_pagamento_Contabil
  select
    * 
  from
    #Solicitacao_pagamento_Contabil_Composicao

  drop table #Solicitacao_pagamento_Contabil_Composicao
  drop table #AuxPagamentoContabilComposicao

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_pagamento, 'D'

  end

end

------------------------------------------------------------------------------
--Consulta da Contabilização
------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  --select * from solicitacao_pagamento_contabil

  select 
    sac.*,
    sac.cd_contab_pagamento                   as cd_contab_solicitacao,
    sac.dt_contab_pagamento                   as dt_contab_solicitacao,
    --Conta Débito do pagamento
    pcd.cd_conta                                 as cd_conta_debito,       
    pcd.cd_mascara_conta                         as cd_mascara_conta_debito,
    pcd.nm_conta                                 as nm_conta_debito,

    --Conta Crédito do pagamento
    pcp.cd_conta                                 as cd_conta_credito,
    pcp.cd_mascara_conta                         as cd_mascara_conta_credito,
    pcp.nm_conta                                 as nm_conta_credito
 
  from 
    solicitacao_pagamento_contabil sac
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

