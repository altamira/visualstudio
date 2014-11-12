
-------------------------------------------------------------------------------
--sp_helptext pr_confirmacao_contabilizacao_baan
-------------------------------------------------------------------------------
--pr_confirmacao_contabilizacao_baan
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Confirmação da Contabilização da Contabilização BAAN
--                   Modifica o flag para SIM e não mais mostra a contabilização
--
--Data             : 27.09.2007
--Alteração        : 02.10.2007 - Acerto dos Tipos - Carlos Fernandes
-- 05.11.2007 - Confirmação do Envio dos Adiantamentos para Banco - Carlos Fernandes
-- 12.11.2007 - Acertos Diveros - Carlos Fernandes
-- 04.04.2008 - Separação do Cartão de Crédito - Carlos Fernandes
-- 28.07.2008 - Criação do novo campo para contabilização do pagto. fornecedor - Carlos Fernandes
---------------------------------------------------------------------------------------------------------
create procedure pr_confirmacao_contabilizacao_baan
@dt_inicial              datetime = '',
@dt_final                datetime = '',
@cd_forma_contabilizacao int      = 0,
@dt_competencia          datetime = '' 

as

--Tipo
--0=Todas
--1=Adto.Moeda Estrang. 
--2=Adto
--3=Acerto Contas 
--4=Cartão Crédito 
--5=Ap
--6=Solicitação de Pagamento
--7=Adto Cartão de Crédito
--8=Fornecedor 
--9=Todas

--Confirmação do Adiantamento

------------------------------------------------------------------------------
--Todas
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 0 OR @cd_forma_contabilizacao = 9
begin

  update
    Solicitacao_Adiantamento_Contabil
  set
    ic_contabilizado = 'S'
  from
    Solicitacao_Adiantamento_Contabil
  where
    dt_contab_adiantamento between @dt_inicial and @dt_final and
    isnull(ic_contabilizado,'N') ='N'

  --Confirmação da Prestação de Contas

  update
    Prestacao_Conta_Contabil 
  set
    ic_contabilizado            = 'S'
  from
    Prestacao_Conta_Contabil a
  where
    a.dt_contab_prestacao between @dt_inicial and @dt_final and
    isnull(a.ic_contabilizado,'N') = 'N'

  --Confirmação da Prestação de Contas do Fornecedor

  update
    Prestacao_Conta_Contabil 
  set
    ic_contabilizado_fornecedor            = 'S'
  from
    Prestacao_Conta_Contabil a
  where
    a.dt_contab_prestacao between @dt_inicial and @dt_final and
    isnull(a.ic_contabilizado_fornecedor,'N') = 'N'

  update
    Autorizacao_Pagamento_Contabil
  set
    ic_contabilizado = 'S'
  from
    Autorizacao_Pagamento_Contabil
  where
    dt_contab_ap between @dt_inicial and @dt_final and
    isnull(ic_contabilizado,'N') = 'N'

  --Data da Confirmação do Adiantamento

  update
    solicitacao_adiantamento
  set
    dt_conf_solicitacao = getdate()
  from
    solicitacao_adiantamento
  where
    dt_conf_solicitacao is null and
    dt_financeiro_solicitacao is not null and
    dt_solicitacao between @dt_inicial and @dt_final

  update
    prestacao_conta
  set
    dt_conf_prestacao        = getdate(),
    ic_status_prestacao      = 'C',
    dt_competencia_prestacao = @dt_competencia

  where
    dt_conf_prestacao is null and
    dt_fechamento_prestacao between @dt_inicial and @dt_final

  update
    prestacao_conta
  set
    dt_conf_fornecedor       = getdate(),
    ic_status_prestacao      = 'C',
    dt_competencia_prestacao = @dt_competencia

  where
    dt_conf_fornecedor is null and
    dt_fechamento_prestacao between @dt_inicial and @dt_final



  update
    solicitacao_pagamento_contabil
  set
    ic_contabilizado='S'
  from
    Solicitacao_Pagamento_Contabil
  where
    dt_contab_pagamento between @dt_inicial and @dt_final and
    isnull(ic_contabilizado,'N') = 'N'

  update
    solicitacao_pagamento
  set
    dt_conf_solicitacao = getdate()
  from
    solicitacao_pagamento
  where
    dt_conf_solicitacao       is null and
    dt_financeiro_solicitacao is not null and
    dt_solicitacao between @dt_inicial and @dt_final

  
  --select * from solicitacao_pagamento_contabil

end

------------------------------------------------------------------------------
--Adiantamento
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 1
begin
  update
    Solicitacao_Adiantamento_Contabil
  set
    ic_contabilizado = 'S'
  from
    Solicitacao_Adiantamento_Contabil sac
    inner join Solicitacao_Adiantamento sa on sa.cd_solicitacao = sac.cd_solicitacao
  where
    sac.dt_contab_adiantamento between @dt_inicial and @dt_final and
    isnull(sac.ic_contabilizado,'N') = 'N' and
    sa.cd_moeda = 1                        and
    isnull(sa.cd_cartao_credito,0)   = 0

  update
    solicitacao_adiantamento
  set
    dt_conf_solicitacao = getdate()
  from
    solicitacao_adiantamento
  where
    dt_conf_solicitacao is null                      and
    dt_financeiro_solicitacao is not null            and
    dt_solicitacao between @dt_inicial and @dt_final and
    cd_moeda = 1                                     and
    isnull(cd_cartao_credito,0) = 0

end

------------------------------------------------------------------------------
--Adiantamento Moeda Estrangeira
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 2
begin

  update
    Solicitacao_Adiantamento_Contabil
  set
    ic_contabilizado = 'S'
  from
    Solicitacao_Adiantamento_Contabil sac
    inner join Solicitacao_Adiantamento sa on sa.cd_solicitacao = sac.cd_solicitacao
  where
    sac.dt_contab_adiantamento between @dt_inicial and @dt_final and
    isnull(sac.ic_contabilizado,'N') ='N' and
    sa.cd_moeda <> 1

  --Data da Confirmação do Adiantamento

  update
    solicitacao_adiantamento
  set
    dt_conf_solicitacao = getdate()
  from
    solicitacao_adiantamento
  where
    dt_conf_solicitacao       is null     and
    dt_financeiro_solicitacao is not null and
    dt_solicitacao between @dt_inicial and @dt_final and
    cd_moeda<>1


end

------------------------------------------------------------------------------
--Prestação de Conta
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 3
begin

  update
    Prestacao_Conta_Contabil 
  set
    ic_contabilizado = 'S'
  from
    Prestacao_Conta_Contabil p
    inner join Prestacao_Conta pc on pc.cd_prestacao = p.cd_prestacao
  where
    p.dt_contab_prestacao between @dt_inicial and @dt_final and
    isnull(p.ic_contabilizado,'N') = 'N' and
    isnull(pc.cd_cartao_credito,0) = 0

  update
    prestacao_conta
  set
    dt_conf_prestacao        = getdate(),
    ic_status_prestacao      = 'C',
    dt_competencia_prestacao = @dt_competencia


  where
    dt_conf_prestacao is null and
    dt_fechamento_prestacao between @dt_inicial and @dt_final

end

------------------------------------------------------------------------------
--Cartão de Crédito
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 4
begin

  update
    Prestacao_Conta_Contabil 
  set
    ic_contabilizado = 'S'
  from
    Prestacao_Conta_Contabil p
    inner join Prestacao_Conta pc on pc.cd_prestacao = p.cd_prestacao
  where
    p.dt_contab_prestacao between @dt_inicial and @dt_final and
    isnull(p.ic_contabilizado,'N') = 'N' and
    isnull(pc.cd_cartao_credito,0)<>0

  update
    prestacao_conta
  set
    dt_conf_prestacao        = getdate(),
    ic_status_prestacao      = 'C',
    dt_competencia_prestacao = @dt_competencia

  where
    dt_conf_prestacao is null and
    dt_fechamento_prestacao between @dt_inicial and @dt_final AND
    isnull(cd_cartao_credito,0)<>0


end

------------------------------------------------------------------------------
--Autorização de Pagamento
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 5
begin


  update
    Autorizacao_Pagamento_Contabil
  set
    ic_contabilizado = 'S'
  from
    Autorizacao_Pagamento_Contabil
  where
    dt_contab_ap between @dt_inicial and @dt_final and
    isnull(ic_contabilizado,'N') = 'N'

end

------------------------------------------------------------------------------
--Solicitação de Pagamento
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 6
begin


  update
    solicitacao_pagamento_contabil
  set
    ic_contabilizado='S'
  from
    Solicitacao_Pagamento_Contabil
  where
    dt_contab_pagamento between @dt_inicial and @dt_final and
    isnull(ic_contabilizado,'N') = 'N'

  update
    solicitacao_pagamento
  set
    dt_conf_solicitacao = getdate()
  from
    solicitacao_pagamento
  where
    dt_conf_solicitacao is null and
    dt_financeiro_solicitacao is not null and
    dt_solicitacao between @dt_inicial and @dt_final

end

------------------------------------------------------------------------------
--Adiantamento de Cartão de Crédito
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 7
begin
  update
    Solicitacao_Adiantamento_Contabil
  set
    ic_contabilizado = 'S'
  from
    Solicitacao_Adiantamento_Contabil sac
    inner join Solicitacao_Adiantamento sa on sa.cd_solicitacao = sac.cd_solicitacao
  where
    sac.dt_contab_adiantamento between @dt_inicial and @dt_final and
    isnull(sac.ic_contabilizado,'N') = 'N' and
    sa.cd_moeda = 1                        and
    isnull(sa.cd_cartao_credito,0)   <> 0

  update
    solicitacao_adiantamento
  set
    dt_conf_solicitacao = getdate()
  from
    solicitacao_adiantamento
  where
    dt_conf_solicitacao is null                      and
    dt_financeiro_solicitacao is not null            and
    dt_solicitacao between @dt_inicial and @dt_final and
    cd_moeda = 1                                     and
    isnull(cd_cartao_credito,0) <> 0

end


--Fornecedor

if @cd_forma_contabilizacao = 8
begin

  update
    Prestacao_Conta_Contabil 
  set
    ic_contabilizado_fornecedor = 'S'
  from
    Prestacao_Conta_Contabil p
    inner join Prestacao_Conta pc on pc.cd_prestacao  = p.cd_prestacao
    inner join Funcionario     f  on f.cd_funcionario = pc.cd_funcionario
  where
    p.dt_contab_prestacao between @dt_inicial and @dt_final and
    isnull(p.ic_contabilizado_fornecedor,'N') = 'N' and
    isnull(pc.cd_cartao_credito,0) = 0   and
    --Fornecedor
    isnull(f.cd_conta,0)>0

  update
    prestacao_conta
  set
    dt_conf_fornecedor       = getdate(),
    ic_status_prestacao      = 'C',
    dt_competencia_prestacao = @dt_competencia
  from
    Prestacao_Conta pc
    inner join Funcionario     f  on f.cd_funcionario = pc.cd_funcionario
  where
    pc.dt_conf_prestacao is null and
    pc.dt_fechamento_prestacao between @dt_inicial and @dt_final and
    --Fornecedor
    isnull(f.cd_conta,0)>0

end

