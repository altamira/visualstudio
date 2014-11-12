
-------------------------------------------------------------------------------
--sp_helptext pr_confirmacao_contabilizacao_aut_pagamento
-------------------------------------------------------------------------------
--pr_confirmacao_contabilizacao_aut_pagamento
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
create procedure pr_confirmacao_contabilizacao_aut_pagamento
@dt_inicial              datetime = '',
@dt_final                datetime = ''
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
--Autorização de Pagamento
------------------------------------------------------------------------------



  update
    Autorizacao_Pagamento_Contabil
  set
    ic_contabilizado = 'S'
  from
    Autorizacao_Pagamento_Contabil
  where
    dt_contab_ap between @dt_inicial and @dt_final and
    isnull(ic_contabilizado,'N') = 'N'



