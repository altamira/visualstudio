
--sp_helptext pr_exclusao_total_autorizacao_pagamento
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2007
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Cancelamento Total da Autorização de Pagamento
--Data           : 26.05.2007
--Atualizado     : 
--               : 
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_exclusao_total_autorizacao_pagamento
@cd_ap        int = 0,
@ic_parametro int = 0
as


-----------------------------------------------------------------------------------------
--Exclusão Total
-----------------------------------------------------------------------------------------

if @cd_ap>0 and @ic_parametro = 1
begin

  delete from autorizacao_pagto_composicao where cd_ap = @cd_ap
  delete from autorizacao_pagamento        where cd_ap = @cd_ap
  
  --Cheque Pagar

  update 
    cheque_pagar
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap


  --Documento a Pagar

  update 
    documento_pagar
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap

  --Requisição de Viagem

  update
    requisicao_viagem
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap

 
  --Solicitação de Adiantamento
  update
    solicitacao_adiantamento
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap

  --Adiantamento de Fornecedor
  update
    fornecedor_adiantamento
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap

  --Prestação de Conta

  update
    prestacao_conta
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap


end

-----------------------------------------------------------------------------------------
--Retorn da Aprovação
-----------------------------------------------------------------------------------------

if @cd_ap>0 and @ic_parametro = 2
begin

  update
    ap
  set
    dt_aprovacao_ap      = null,
    cd_usuario_aprovacao = null
  where
    cd_ap = @cd_ap

end

