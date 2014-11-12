
-------------------------------------------------------------------------------
--sp_helptext pr_gera_contabilizacao_prestacao_conta
-------------------------------------------------------------------------------
--pr_gera_contabilizacao_prestacao_conta
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
--                   15.10.2007 - Acertos Diversos - Carlos Fernandes
--                   05.11.2007 - Alteração do Projeto - Carlos Fernandes
-- 09.11.2007 - Acerto do Histórico - Carlos Fernandes
-- 14.11.2007 - Acerto de Contabilização com Saldo Zero - Carlos Fernandes
-- 10.12.2007 - Novo campo para controle lançamento contábil - Carlos Fernandes
-- 14.12.2007 - Estorno de Lançamento Contábil - Carlos Fernandes
-- 26.12.2007 - Estorno do Cartão de Crédito - Carlos Fernandes
-- 26.12.2007 - Sinal da Conta de Despesa
-- 26.02.2008 - Verificação da Rotina - Carlos Fernandes
-- 24.03.2008 - Modificação da Contabilização do Cartão de Crédito, retirado
--              o crédito - Carlos Fernandes/João Carlos.
-- 04.04.2008 - Acerto do Flag de SIM, para Cartão de Crédito - Carlos Fernandes
-- 28.07.2008 - Novo flag de contabilização de Pagamento Fornecedor - Carlos Fernandes
-- 13.10.2008 - Ajuste da Contabilização - Prestação de Diversos Funcionários - Carlos Fernandes
------------------------------------------------------------------------------------------------
create procedure pr_gera_contabilizacao_prestacao_conta
@cd_prestacao int = 0,
@cd_usuario   int = 0

as

declare @Tabela		      varchar(80)
declare @cd_contab_prestacao  int
declare @vl_prestacao         decimal(25,2)
declare @vl_adiantamento      decimal(25,2)
declare @vl_soma_adiantamento decimal(25,2)
declare @cd_requisicao_viagem int
declare @qt_adiantamento      int 
declare @cd_solicitacao       int
declare @vl_devolucao_moeda   decimal(25,2)
declare @vl_imposto_prestacao decimal(25,2)


--select * from prestacao_conta_composicao
--select * from prestacao_conta
--select * from prestacao_conta_contabil
--select * from parametro_prestacao_conta

if @cd_prestacao > 0
begin

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Prestacao_Conta_Contabil' as varchar(80))

  --Parâmetros para Contabilização

  declare @cd_conta_adiantamento    int
  declare @cd_conta_banco           int
  declare @cd_conta_caixa           int
  declare @cd_conta_adto_moeda      int
  declare @cd_cartao_credito        int
  declare @cd_tipo_despesa_imposto  int
  declare @cd_conta_fornecedor      int

  select
    @cd_conta_adiantamento   = isnull(cd_conta_adiantamento,0),  --Débito
    @cd_conta_banco          = isnull(cd_conta_banco,0),
    @cd_conta_caixa          = isnull(cd_conta_caixa,0),
    @cd_conta_adto_moeda     = isnull(cd_conta_adto_moeda,0),
    @cd_tipo_despesa_imposto = isnull(cd_tipo_despesa,0),
    @cd_conta_fornecedor     = isnull(cd_conta_fornecedor,0)
  from
    parametro_prestacao_conta with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()  

  --Busca o Valor Total da Prestação de Contas e o Valor do Adiantamento

  select
    @vl_prestacao         = isnull(vl_prestacao,0),
    @vl_adiantamento      = isnull(vl_adiantamento,0),
    @cd_requisicao_viagem = isnull(cd_requisicao_viagem,0),
    @cd_cartao_credito    = isnull(cd_cartao_credito,0),
    @vl_devolucao_moeda   = isnull(vl_devolucao_moeda,0),
    @vl_imposto_prestacao = isnull(vl_imposto_prestacao,0)
  from
    Prestacao_Conta with (nolock) 
  where
    cd_prestacao = @cd_prestacao    


  if @cd_requisicao_viagem>0 and @vl_adiantamento=0
  begin
    --select * from requisicao_viagem
    --select 
    select
      @vl_adiantamento = isnull(vl_adto_viagem,0)
    from
      requisicao_viagem with (nolock) 
    where
      cd_requisicao_viagem = @cd_requisicao_viagem

  end

  --deleta todas as contabilizações da prestação

  delete from prestacao_conta_contabil where cd_prestacao = @cd_prestacao

  --print @vl_adiantamento
  --print @vl_prestacao

  --Verifica a Quantidade de Adiantamentos
  
  select
    sa.cd_solicitacao,
    sa.cd_prestacao,
    sa.cd_tipo_adiantamento,
    count(*)                              as QtdAdiantamento,
    sum( isnull(sa.vl_adiantamento,0) )   as Adiantamento,
    --max(isnull(ta.cd_conta,0))            as cd_conta_adiantamento,
    max(isnull(ta.cd_conta_credito_pc,0)) as cd_conta_adiantamento
    
    --@qt_adiantamento      = count(*),
    --@vl_soma_adiantamento = sum( isnull(vl_adiantamento,0) )
  into
    #TipoAdiantamento
  from
    solicitacao_adiantamento sa with (nolock) 
    left outer join Tipo_Adiantamento ta on ta.cd_tipo_adiantamento = sa.cd_tipo_adiantamento
  where
    sa.cd_prestacao = @cd_prestacao     and
    isnull(sa.cd_tipo_adiantamento,0)>0 and
    isnull(sa.vl_adiantamento,0)>0
  group by
    sa.cd_solicitacao,
    sa.cd_prestacao,
    sa.cd_tipo_adiantamento

  --select * from prestacao_conta
  --select * from solicitacao_adiantamento
  --select * from #TipoAdiantamento
  --select * from tipo_adiantamento

  --select @qt_adiantamento,@vl_soma_adiantamento,@vl_adiantamento

  --Contabilização do Adiantamento

  if @vl_adiantamento>0  --and @vl_prestacao<>0 --and @vl_soma_adiantamento = @vl_adiantamento
  begin
    
    while exists ( select top 1 cd_solicitacao from #TipoAdiantamento )
    begin
      select 
        top 1
        @cd_solicitacao        = cd_solicitacao,
        @vl_adiantamento       = Adiantamento,
        @cd_conta_adiantamento = case when isnull(cd_conta_adiantamento,0)>0 then cd_conta_adiantamento else @cd_conta_adiantamento end
      from
        #TipoAdiantamento


      --Gera a Contabilização do Adiantamento

      --select @cd_solicitacao, @vl_adiantamento, @cd_conta_adiantamento

      if @cd_solicitacao>0 and @vl_adiantamento>0 and @cd_conta_adiantamento>0
      begin      

        --select @cd_prestacao

        exec pr_gera_contabilizacao_adto_prestacao_contas
             @cd_prestacao,           
             @cd_solicitacao,         
             @cd_conta_adiantamento,  
             @cd_usuario,
             @vl_adiantamento         

        --select * from prestacao_conta_contabil where cd_prestacao = @cd_prestacao
 
      end
 
      delete from #TipoAdiantamento where cd_solicitacao = @cd_solicitacao

    end

  end

  -------------------------------------------------------------------------------
  --Contabilização dos Valores de Devolução de Moeda Estrangeira
  -------------------------------------------------------------------------------

  if @vl_devolucao_moeda>0
  begin
    --select * from prestacao_conta

    set @cd_contab_prestacao = 0
    --select @cd_conta_adiantamento,@cd_conta_banco,@vl_prestacao

    select
      identity(int,1,1)                                                as cd_contab_prestacao,                
      pc.cd_prestacao,
      pc.dt_prestacao,        
      pc.cd_requisicao_viagem,
    
      case when @vl_devolucao_moeda>0 then @cd_conta_adto_moeda  end   as cd_conta_debito,
      0                                                                as cd_conta_credito,
      --0 as cd_conta_debito,
      --0 as cd_conta_credito,
      --@cd_conta_adiantamento as cd_conta_credito,
      pcc.cd_mascara_conta,
      pcc.nm_conta,
      isnull(pc.dt_fechamento_prestacao,getdate())                      as dt_fechamento_prestacao,
      0                                                                 as cd_lancamento_padrao,

--       cast('Dv.Moeda Estrang.PC '+rtrim(ltrim(cast(pc.cd_prestacao as varchar)))+ 
--       '/'    +rtrim(ltrim(cast(isnull(pc.dt_fechamento_prestacao,getdate()) as varchar))) as varchar(40))
--                                                                         as nm_historico_contabil,

      cast('Dv.Moeda Estrang.PC '+rtrim(ltrim(cast(pc.cd_prestacao as varchar))) as varchar(40))
                                                                        as nm_historico_contabil,

      null                                                              as cd_centro_custo,
      pc.cd_projeto_viagem,
      cast(null as varchar) as nm_projeto_viagem,                
      'N'                   as ic_contabilizado,
      'N'                   as ic_cartao_credito,
--      null                  as cd_lancamento_contabil,
      'N'                   as ic_contabilizado_fornecedor,
      null                  as cd_funcionario,
      null                  as cd_item_prestacao         

    into
      #AuxMoedaEstrangeira

    from
      prestacao_conta             pc   with (nolock) 
      left outer join plano_conta pcc  with (nolock) on pcc.cd_conta     = @cd_conta_adiantamento
      left outer join funcionario f    with (nolock) on f.cd_funcionario = pc.cd_funcionario
    where
      pc.cd_prestacao = case when @cd_prestacao=0 then pc.cd_prestacao else @cd_prestacao end 

    --atualização do controle de lançamento contábil

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
	
    while exists(Select top 1 'x' from prestacao_conta_contabil where cd_contab_prestacao = @cd_contab_prestacao)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'
    end

    select
      @cd_contab_prestacao+cd_contab_prestacao  as cd_contab_prestacao,
      dt_fechamento_prestacao                   as dt_contab_prestacao,
      cd_prestacao,
      cd_lancamento_padrao,
      cd_conta_debito,
      cd_conta_credito,
      0                                         as cd_historico_contabil,
      nm_historico_contabil,
     'N'                                        as ic_sct_prestacao,
      null                                      as dt_sct_prestacao,
      case when @vl_devolucao_moeda<0 then 
        @vl_devolucao_moeda*-1 
      else
        @vl_devolucao_moeda end                 as vl_contab_prestacao,
      0                                         as cd_lote_contabil,
     'N'                                        as ic_manutencao_contabil,
      @cd_usuario                               as cd_usuario,
      getdate()                                 as dt_usuario,
      0                                         as cd_centro_custo,
      0                                         as cd_projeto_viagem,
      nm_projeto_viagem,
      ic_contabilizado,
      ic_cartao_credito,
      null                                      as cd_lancamento_contabil,   
      ic_contabilizado_fornecedor,
      cd_funcionario,
      cd_item_prestacao

    into
      #PrestacaoMoedaEstrangeira
    from
      #AuxMoedaEstrangeira

    --Montagem da Tabela de Prestacao de Conta
    --select * from prestacao_conta_contabil

    insert into
      Prestacao_Conta_Contabil
    select
      * 
    from
      #PrestacaoMoedaEstrangeira

    drop table #PrestacaoMoedaEstrangeira
    drop table #AuxMoedaEstrangeira

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'

  end


  --Contabilização dos Valores a Pagar para funcionário

--  select @vl_prestacao,@cd_conta_adiantamento

  if @vl_prestacao<>0 and @cd_cartao_credito = 0 --and @cd_requisicao_viagem>0 
  begin

    --select * from prestacao_conta

    set @cd_contab_prestacao = 0
    --select @cd_conta_adiantamento,@cd_conta_banco,@vl_prestacao
    --select * from funcionario

    select
      identity(int,1,1)                                                as cd_contab_prestacao,                
      pc.cd_prestacao,
      pc.dt_prestacao,        
      pc.cd_requisicao_viagem,
    
      case when @vl_prestacao>0 then 
      case when isnull(f.cd_conta,0)=0 then @cd_conta_adiantamento else f.cd_conta end
      end                                                              as cd_conta_credito,
      case when @vl_prestacao<0 then @cd_conta_banco        else 0 end as cd_conta_debito,
      --0 as cd_conta_debito,
      --0 as cd_conta_credito,
      --@cd_conta_adiantamento as cd_conta_credito,
      pcc.cd_mascara_conta,
      pcc.nm_conta,
      isnull(pc.dt_fechamento_prestacao,getdate())                      as dt_fechamento_prestacao,
      0                                                                 as cd_lancamento_padrao,

      cast('PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar))) as varchar(40))
                                                                        as nm_historico_contabil,
      null                                                              as cd_centro_custo,
      pc.cd_projeto_viagem,
      cast(null as varchar) as nm_projeto_viagem,                
      'N'                   as ic_contabilizado,
      'N'                   as ic_cartao_credito,
      'N'                   as ic_contabilizado_fornecedor,
      null                  as cd_funcionario,
      null                  as cd_item_prestacao      

    into
      #AuxPrestacaoContabilPagar

    from
      prestacao_conta             pc   with (nolock) 
      left outer join plano_conta pcc  with (nolock) on pcc.cd_conta     = @cd_conta_adiantamento
      left outer join funcionario f    with (nolock) on f.cd_funcionario = pc.cd_funcionario
    where
      pc.cd_prestacao = case when @cd_prestacao=0 then pc.cd_prestacao else @cd_prestacao end 

    --select * from  #AuxPrestacaoContabilPagar
   
 
    --atualização do controle de lançamento contábil

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
	
    while exists(Select top 1 'x' from prestacao_conta_contabil where cd_contab_prestacao = @cd_contab_prestacao)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'
    end

    select
      @cd_contab_prestacao+cd_contab_prestacao  as cd_contab_prestacao,
      dt_fechamento_prestacao                   as dt_contab_prestacao,
      cd_prestacao,
      cd_lancamento_padrao,
      cd_conta_debito,
      cd_conta_credito,
      0                                         as cd_historico_contabil,
      nm_historico_contabil,
     'N'                                        as ic_sct_prestacao,
      null                                      as dt_sct_prestacao,
      case when @vl_prestacao<0 then 
        @vl_prestacao*-1 
      else
        @vl_prestacao end                       as vl_contab_prestacao,
      0                                         as cd_lote_contabil,
     'N'                                        as ic_manutencao_contabil,
      @cd_usuario                               as cd_usuario,
      getdate()                                 as dt_usuario,
      0                                         as cd_centro_custo,
      0                                         as cd_projeto_viagem,
      nm_projeto_viagem,
      ic_contabilizado,
      ic_cartao_credito,
      null                                      as cd_lancamento_contabil,   
      ic_contabilizado_fornecedor,
      cd_funcionario,
      cd_item_prestacao

  into
    #Prestacao_Conta_Contabil_Pagar
  from
    #AuxPrestacaoContabilPagar

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Prestacao_Conta_Contabil
  select
    * 
  from
    #Prestacao_Conta_Contabil_Pagar

  drop table #Prestacao_Conta_Contabil_Pagar

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'

  --select * from  #Prestacao_Conta_Contabil_Adiantamento

  end

  -------------------------------------------------------------------------------
  --Contabilização das Despesas
  -------------------------------------------------------------------------------

  select
    identity(int,1,1)                  as cd_contab_prestacao,                
    pc.cd_prestacao,
    pc.dt_prestacao,        
    pc.cd_requisicao_viagem,

    --rv.cd_projeto_viagem,

    pv.cd_conta                        as cd_conta_projeto,
    tpc.nm_tipo_prestacao,
    tpc.cd_conta                       as cd_conta_prestacao,
    td.nm_tipo_despesa,
    td.cd_conta,
    pcc.vl_total_despesa *
    case when isnull(pcc.vl_total_despesa,0)<0 then -1 else 1 end 
                                      as vl_total_despesa,
     
    pcc.cd_documento_despesa,
    pcc.nm_obs_item_despesa,  

    --Despesa

    --Conta Débito

    case when isnull(td.ic_tipo_contabilizacao,'D')='D' and isnull(pcc.ic_tipo_lancamento,'N')='N' then
      case when isnull(pcp.cd_conta,0)>0 then
        pcp.cd_conta
      else
        pcd.cd_conta                               
      end
    else
      0
    end                                          as cd_conta_debito,        --conta débito despesa

   --Conta Crédito    
   
   case when isnull(td.ic_tipo_contabilizacao,'D')='C' and isnull(pcc.ic_tipo_lancamento,'N')='N' then
      case when isnull(pcp.cd_conta,0)>0 then
        pcp.cd_conta
      else
        pcd.cd_conta                               
      end
   else
     case when isnull(pcc.ic_tipo_lancamento,'N')='S' 
     then
      case when isnull(pcp.cd_conta,0)>0 then
        pcp.cd_conta
      else
        pcd.cd_conta                               
      end
     else       
       0
--        isnull(pct.cd_conta,pcp.cd_conta)
     end
   end                                           as cd_conta_credito,        --conta crédito tipo ou projeto 

    case when isnull(pcp.cd_conta,0)>0 then
       pcp.cd_mascara_conta
    else
      pcd.cd_mascara_conta end                   as cd_mascara_conta_despesa,

    case when isnull(pcp.cd_conta,0)>0 then
       pcp.nm_conta
    else
       pcd.nm_conta  end                         as nm_conta_despesa,

    --Projeto
  
    pcp.cd_mascara_conta                         as cd_mascara_conta_projeto,
    pcp.nm_conta                                 as nm_conta_projeto,
    pct.cd_mascara_conta                         as cd_mascara_conta_prestacao,
    pct.nm_conta                                 as nm_conta_prestacao,

--    isnull(pct.cd_conta,pcp.cd_conta)            as cd_conta_credito,        --conta crédito tipo ou projeto

    isnull(pc.dt_fechamento_prestacao,getdate()) as dt_fechamento_prestacao,
    0                                            as cd_lancamento_padrao,
--     rtrim(ltrim(td.nm_tipo_despesa)) + ' PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar)))+ 
-- 
--     cast(' ' +isnull(rtrim(ltrim(pcc.cd_documento_despesa)),'')+
--     '/'    +rtrim(ltrim(cast(isnull(pc.dt_fechamento_prestacao,getdate()) as varchar))) as varchar(40))
-- 
--                                                                                         as nm_historico_contabil,
    cast(' PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar))) as varchar(40))    as nm_historico_contabil,


    --Centro de Custo

    case when isnull(pcc.cd_centro_custo,0)>0 then
      pcc.cd_centro_custo
    else
      case when isnull(rv.cd_centro_custo,0)>0 then
        rv.cd_centro_custo
      else
        pc.cd_centro_custo
      end   
    end                                                                                 as cd_centro_custo,

    --Projeto

    case when isnull(pcc.nm_projeto_viagem,'')<>'' and isnull(pcc.cd_projeto_viagem,0)<>0 
    then
      isnull(pcc.cd_projeto_viagem,0)
    else
      0
    end                                                                                 as cd_projeto_viagem,
    
    pcc.nm_projeto_viagem,

    'N'  as ic_contabilizado,

    case when @cd_cartao_credito=0 and isnull(pcc.cd_tipo_cartao_credito,0)=0 then 'N' else 'S' end  as ic_cartao_credito,
    'N'  as ic_contabilizado_fornecedor,
    isnull(pcc.cd_funcionario_composicao,0) as cd_funcionario,
    pcc.cd_item_prestacao

  into
    #AuxPrestacaoContabil

  from
    prestacao_conta_composicao           pcc  with (nolock) 
    inner join prestacao_conta           pc   with (nolock) on pc.cd_prestacao         = pcc.cd_prestacao
    left outer join requisicao_viagem    rv   with (nolock) on rv.cd_requisicao_viagem = pc.cd_requisicao_viagem
    left outer join projeto_viagem       pv   with (nolock) on pv.cd_projeto_viagem    = pcc.cd_projeto_viagem
    left outer join tipo_prestacao_conta tpc  with (nolock) on tpc.cd_tipo_prestacao   = pc.cd_tipo_prestacao
    left outer join tipo_despesa         td   with (nolock) on td.cd_tipo_despesa      = pcc.cd_tipo_despesa
    left outer join plano_conta          pcd  with (nolock) on pcd.cd_conta            = td.cd_conta
    left outer join plano_conta          pcp  with (nolock) on pcp.cd_conta            = pv.cd_conta
    left outer join plano_conta          pct  with (nolock) on pct.cd_conta            = tpc.cd_conta
--    left outer join plano_conta          pcdc with (nolock) on pcdc.cd_conta           = td.cd_conta
    left outer join funcionario          f    with (nolock) on f.cd_funcionario        = pc.cd_funcionario
  where
    pcc.cd_prestacao = case when @cd_prestacao=0 then pcc.cd_prestacao else @cd_prestacao end 
    and isnull(td.ic_sct_tipo_despesa,'S')='S' 
    --and isnull(pcc.ic_tipo_lancamento,'N')='N'

    --Liberar quando entrar no ar.
    --ccf - 07.05.2007
    --and
    --pc.dt_fechamento_prestacao is not null

   --Mostra a Tabela gerada
   --select * from #AuxPrestacaoContabil
   --select * from prestacao_conta_composicao

  --atualização do controle de lançamento contábil

  set @cd_contab_prestacao = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
	
  while exists(Select top 1 'x' from prestacao_conta_contabil where cd_contab_prestacao = @cd_contab_prestacao)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'
  end

  --Contabilizacao das Contas Contabeis

  --prestacao_conta_contabil

  select
    @cd_contab_prestacao+cd_contab_prestacao  as cd_contab_prestacao,
    dt_fechamento_prestacao                   as dt_contab_prestacao,
    cd_prestacao,
    cd_lancamento_padrao,
    cd_conta_debito,
    cd_conta_credito,--                          as cd_conta_credito,
    0                                         as cd_historico_contabil,
    nm_historico_contabil,
    'N'                                       as ic_sct_prestacao,
    null                                      as dt_sct_prestacao,
    isnull(vl_total_despesa,0)                as vl_contab_prestacao,
    0                                         as cd_lote_contabil,
    'N'                                       as ic_manutencao_contabil,
    @cd_usuario                               as cd_usuario,
    getdate()                                 as dt_usuario,
    cd_centro_custo,
    cd_projeto_viagem,
    nm_projeto_viagem,
    ic_contabilizado,
    ic_cartao_credito,
    null                                      as cd_lancamento_contabil,   
    ic_contabilizado_fornecedor,
    cd_funcionario,
    cd_item_prestacao

  into
    #Prestacao_Conta_Contabil
  from
    #AuxPrestacaoContabil

  --Montagem da Tabela de Prestacao de Conta

  insert into
    Prestacao_Conta_Contabil
  select
    * 
  from
    #Prestacao_Conta_Contabil

  drop table #Prestacao_Conta_Contabil

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'

  -------------------------------------------------------------------------------
  --Contabilização das Despesas com Cartão de Crédito
  -------------------------------------------------------------------------------

  select
    identity(int,1,1)                  as cd_contab_prestacao,                
    pc.cd_prestacao,
    pc.dt_prestacao,        
    pc.cd_requisicao_viagem,
    --rv.cd_projeto_viagem,
    pv.cd_conta                        as cd_conta_projeto,
    tpc.nm_tipo_prestacao,
    tpc.cd_conta                       as cd_conta_prestacao,
    td.nm_tipo_despesa,
    td.cd_conta,
--    pcc.vl_total_despesa,

    pcc.vl_total_despesa *
    case when isnull(pcc.vl_total_despesa,0)<0 then -1 else 1 end 
                                      as vl_total_despesa,

    pcc.cd_documento_despesa,
    pcc.nm_obs_item_despesa,  

    --Despesa será Debita ou Crédito de acordo com o tipo de Lançamento

    case when isnull(pcc.ic_tipo_lancamento,'N')='N'
    then
       0
    else
       isnull(tcc.cd_conta_estorno,0)
    end                                as cd_conta_debito,        --conta débito despesa

   cast(null as varchar(20))           as cd_mascara_conta_despesa,
   cast(null as varchar(40))           as nm_conta_despesa,

   --Crédito do Cartão
	
    case when isnull(pcc.ic_tipo_lancamento,'N')='S'
    then
      0
    else
      isnull(tcc.cd_conta,0)  
    end                                          as cd_conta_credito,        --conta crédito tipo ou projeto

    isnull(pc.dt_fechamento_prestacao,getdate()) as dt_fechamento_prestacao,
    0                                            as cd_lancamento_padrao,

--     cast(rtrim(ltrim(tcc.nm_cartao_credito)) + ' PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar)))+ 
--     '/'    +rtrim(ltrim(cast(isnull(pc.dt_fechamento_prestacao,getdate()) as varchar)))as varchar(40))
--                                                                                         as nm_historico_contabil,

    cast('PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar))) as varchar(40))
                                                                                        as nm_historico_contabil,

    isnull(rv.cd_centro_custo,pc.cd_centro_custo)                                       as cd_centro_custo,
    pcc.cd_projeto_viagem,
    pcc.nm_projeto_viagem,
    'N'  as ic_contabilizado,
    'S'  as ic_cartao_credito,
    'N'  as ic_contabilizado_fornecedor,
    null as cd_funcionario,
    pcc.cd_item_prestacao

  into
    #AuxPrestacaoContabilCartao

  from
    prestacao_conta_composicao           pcc  with (nolock) 
    inner join prestacao_conta           pc   with (nolock) on pc.cd_prestacao         = pcc.cd_prestacao
    left outer join requisicao_viagem    rv   with (nolock) on rv.cd_requisicao_viagem = pc.cd_requisicao_viagem
    left outer join projeto_viagem       pv   with (nolock) on pv.cd_projeto_viagem    = pcc.cd_projeto_viagem
    left outer join tipo_prestacao_conta tpc  with (nolock) on tpc.cd_tipo_prestacao   = pc.cd_tipo_prestacao
    left outer join tipo_despesa         td   with (nolock) on td.cd_tipo_despesa      = pcc.cd_tipo_despesa
    left outer join tipo_cartao_credito  tcc  with (nolock) on tcc.cd_cartao_credito   = pcc.cd_tipo_cartao_credito   
    left outer join plano_conta          pcp  with (nolock) on pcp.cd_conta            = tcc.cd_conta
    left outer join funcionario          f    with (nolock) on f.cd_funcionario        = pc.cd_funcionario
  where
    pcc.cd_prestacao = case when @cd_prestacao=0 then pcc.cd_prestacao else @cd_prestacao end 
    and isnull(td.ic_sct_tipo_despesa,'S')='S' 
    and isnull(pcc.cd_tipo_cartao_credito,0)>0
    
    --Liberar quando entrar no ar.
    --ccf - 07.05.2007
    --and
    --pc.dt_fechamento_prestacao is not null

   --Mostra a Tabela gerada
   --select * from #AuxPrestacaoContabil

  --atualização do controle de lançamento contábil

  set @cd_contab_prestacao = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
	
  while exists(Select top 1 'x' from prestacao_conta_contabil where cd_contab_prestacao = @cd_contab_prestacao)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'
  end

  --Contabilizacao das Contas Contabeis

  --prestacao_conta_contabil

  select
    @cd_contab_prestacao+cd_contab_prestacao  as cd_contab_prestacao,
    dt_fechamento_prestacao                   as dt_contab_prestacao,
    cd_prestacao,
    cd_lancamento_padrao,
    cd_conta_debito,
    cd_conta_credito                          as cd_conta_credito,
    0                                         as cd_historico_contabil,
    nm_historico_contabil,
    'N'                                       as ic_sct_prestacao,
    null                                      as dt_sct_prestacao,
    isnull(vl_total_despesa,0)                as vl_contab_prestacao,
    0                                         as cd_lote_contabil,
    'N'                                       as ic_manutencao_contabil,
    @cd_usuario                               as cd_usuario,
    getdate()                                 as dt_usuario,
    cd_centro_custo,
    cd_projeto_viagem,
    nm_projeto_viagem,
    ic_contabilizado,
    ic_cartao_credito,
    null                                      as cd_lancamento_contabil,
    ic_contabilizado_fornecedor,
    cd_funcionario,
    cd_item_prestacao
 
  into
    #Prestacao_Conta_Contabil_Cartao
  from
    #AuxPrestacaoContabilCartao


  -----------------------------------------------------------------------------------------------------
  --Modificação:
  --Alterado em 24.03.2008, porque esta contabilização está sendo feita na Solicitação de Adiantamento
  --João Carlos/Carlos Fernandes.
  --
 
  --Montagem da Tabela de Prestacao de Conta

--   insert into
--     Prestacao_Conta_Contabil
--   select
--     * 
--   from
--     #Prestacao_Conta_Contabil_Cartao

  drop table #Prestacao_Conta_Contabil_Cartao

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'

  -------------------------------------------------------------------------------
  --Contabilização dos Impostos
  -------------------------------------------------------------------------------

  if @vl_imposto_prestacao > 0 and @cd_tipo_despesa_imposto > 0
  begin

    select
      identity(int,1,1)                                                as cd_contab_prestacao,                
      pc.cd_prestacao,
      pc.dt_prestacao,        
      pc.cd_requisicao_viagem,
    
      0                                                                as cd_conta_credito,
      case when @vl_imposto_prestacao>0 then pcd.cd_conta else 0 end   as cd_conta_debito,
      pcd.cd_mascara_conta,
      pcd.nm_conta,
      isnull(pc.dt_fechamento_prestacao,getdate())                      as dt_fechamento_prestacao,
      0                                                                 as cd_lancamento_padrao,

      cast('CPMF PC N.'+rtrim(ltrim(cast(pc.cd_prestacao as varchar))) as varchar(40))

                                                                        as nm_historico_contabil,
      null                                                              as cd_centro_custo,
      pc.cd_projeto_viagem,
      cast(null as varchar) as nm_projeto_viagem,                
      'N'                   as ic_contabilizado,
      'N'                   as ic_cartao_credito,
      'N'                   as ic_contabilizado_fornecedor,
      null                  as cd_funcionario,
      null                  as cd_item_prestacao

    into
      #AuxImposto

    from
      prestacao_conta             pc   with (nolock) 
      left outer join Tipo_Despesa td  with (nolock) on td.cd_tipo_despesa      = @cd_tipo_despesa_imposto
      left outer join plano_conta pcd  with (nolock) on pcd.cd_conta            = td.cd_conta
    where
      pc.cd_prestacao = case when @cd_prestacao=0 then pc.cd_prestacao else @cd_prestacao end 

    --atualização do controle de lançamento contábil

    set @cd_contab_prestacao = 0

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output
	
    while exists(Select top 1 'x' from prestacao_conta_contabil where cd_contab_prestacao = @cd_contab_prestacao)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_contab_prestacao', @codigo = @cd_contab_prestacao output

      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'
    end

    select
      @cd_contab_prestacao+cd_contab_prestacao  as cd_contab_prestacao,
      dt_fechamento_prestacao                   as dt_contab_prestacao,
      cd_prestacao,
      cd_lancamento_padrao,
      cd_conta_debito,
      cd_conta_credito                          as cd_conta_credito,
      0                                         as cd_historico_contabil,
      nm_historico_contabil,
      'N'                                       as ic_sct_prestacao,
      null                                      as dt_sct_prestacao,
      isnull(@vl_imposto_prestacao,0)           as vl_contab_prestacao,
      0                                         as cd_lote_contabil,
      'N'                                       as ic_manutencao_contabil,
      @cd_usuario                               as cd_usuario,
      getdate()                                 as dt_usuario,
      cd_centro_custo,
      cd_projeto_viagem,
      nm_projeto_viagem,
      ic_contabilizado,
      ic_cartao_credito,
      null                                      as cd_lancamento_contabil,
      ic_contabilizado_fornecedor,
      cd_funcionario,
      cd_item_prestacao
 
    into
      #Prestacao_Conta_Contabil_Imposto
    from
      #AuxImposto

    --Montagem da Tabela de Prestacao de Conta

    insert into
      Prestacao_Conta_Contabil
    select
      * 
    from
      #Prestacao_Conta_Contabil_Imposto

    drop table #AuxImposto
    drop table #Prestacao_Conta_Contabil_Imposto

    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_contab_prestacao, 'D'


  end


end

--select * from projeto_viagem
--select * from requisicao_viagem
--select * from tipo_despesa
--select * from tipo_despesa_viagem
--select * from tipo_prestacao_conta
--select * from plano_conta

