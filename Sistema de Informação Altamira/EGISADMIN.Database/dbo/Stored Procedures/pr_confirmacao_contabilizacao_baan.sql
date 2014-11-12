
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
---------------------------------------------------------------------------------------------------------
create procedure pr_confirmacao_contabilizacao_baan
@dt_inicial              datetime = '',
@dt_final                datetime = '',
@cd_forma_contabilizacao int = 0 

as

--Tipo
--0=Todas
--1=Adto.Moeda Estrang. 
--2=Adto
--3=Acerto Contas 
--4=Cartão Crédito 
--5=Ap
--6=Todas


--Confirmação do Adiantamento

------------------------------------------------------------------------------
--Totas
------------------------------------------------------------------------------

if @cd_forma_contabilizacao = 0 OR @cd_forma_contabilizacao = 6
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
    ic_contabilizado = 'S'
  from
    Prestacao_Conta_Contabil a
  where
    dt_contab_prestacao between @dt_inicial and @dt_final and
    isnull(ic_contabilizado,'N') = 'N'

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
    dt_solicitacao between @dt_inicial and @dt_final

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
    isnull(sac.ic_contabilizado,'N') ='N' and
    sa.cd_moeda = 1

  update
    solicitacao_adiantamento
  set
    dt_conf_solicitacao = getdate()
  from
    solicitacao_adiantamento
  where
    dt_conf_solicitacao is null and
    dt_solicitacao between @dt_inicial and @dt_final

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
    dt_conf_solicitacao is null and
    dt_solicitacao between @dt_inicial and @dt_final


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


