
-------------------------------------------------------------------------------
--sp_helptext pr_confirmacao_contabilizacao_baan_prestacao_conta
-------------------------------------------------------------------------------
--pr_confirmacao_contabilizacao_baan_prestacao_conta
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
---------------------------------------------------------------------------------------------------------
create procedure pr_confirmacao_contabilizacao_baan_prestacao_conta
@dt_inicial              datetime = '',
@dt_final                datetime = '',
@dt_competencia          datetime = ''

--@cd_forma_contabilizacao int = 0 

as

--Tipo
--0=Todas
--1=Adto.Moeda Estrang. 
--2=Adto
--3=Acerto Contas 
--4=Cartão Crédito 
--5=Ap
--6=Solicitação de Pagamento
--7=Todas



------------------------------------------------------------------------------
--Prestação de Conta
------------------------------------------------------------------------------

--if @cd_forma_contabilizacao = 3
--begin

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

--end


