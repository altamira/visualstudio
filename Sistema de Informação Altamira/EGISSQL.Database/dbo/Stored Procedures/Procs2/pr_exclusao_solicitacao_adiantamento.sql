
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_solicitacao_adiantamento
-------------------------------------------------------------------------------
--pr_exclusao_solicitacao_adiantamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Exclusão Completa da Solicitação de Adiantamento - SA
--Data             : 09.11.2007
--Alteração        : 13.09.2010 - Exclusão do contas a pagar - Carlos Fernandes
--------------------------------------------------------------------------------
create procedure pr_exclusao_solicitacao_adiantamento
@cd_requisicao_viagem int = 0,
@cd_solicitacao       int = 0
as	

declare @cd_documento_pagar int

set @cd_documento_pagar = 0

if @cd_requisicao_viagem>0 
begin

  select
    @cd_solicitacao     = isnull(cd_solicitacao,0),
    @cd_documento_pagar = isnull(cd_documento_pagar,0) 
  from
    solicitacao_adiantamento with (nolock)  
  where
    cd_requisicao_viagem = @cd_requisicao_viagem

end


--Adiantamento----------------------------------------------

if @cd_solicitacao>0
begin

  delete from Solicitacao_Adiantamento_Aprovacao where cd_solicitacao = @cd_solicitacao
  delete from Solicitacao_Adiantamento_Moeda     where cd_solicitacao = @cd_solicitacao
  delete from Solicitacao_Adiantamento_Baixa     where cd_solicitacao = @cd_solicitacao
  delete from Solicitacao_Adiantamento_Contabil  where cd_solicitacao = @cd_solicitacao
  delete from Solicitacao_Adiantamento           where cd_solicitacao = @cd_solicitacao
end

if @cd_documento_pagar > 0
begin

  delete from documento_pagar 
  where
    cd_documento_pagar = @cd_documento_pagar and
    isnull(vl_saldo_documento_pagar,0) > 0
 
end

