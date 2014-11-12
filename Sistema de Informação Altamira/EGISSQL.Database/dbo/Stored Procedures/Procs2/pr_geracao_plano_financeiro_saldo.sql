
CREATE PROCEDURE pr_geracao_plano_financeiro_saldo
-------------------------------------------------------------------------
--pr_geracao_plano_financeiro_saldo
-------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                  2004
-------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardoso Fernandes
--Banco de Dados       : EgisSQL
--Objetivo             : Geração do Plano Financeiro Saldo 
--                       cliente_informacao_credito
--Data                 : 21.10.2005
--Atualizado           : 21.10.2005
--------------------------------------------------------------------------------------
@dt_base    datetime,
@cd_usuario int=0
as
------------------------------------------------------------------------------------------------------------------
-- Atualização de Toda a Tabela Plano_Financeiro_Saldo
------------------------------------------------------------------------------------------------------------------

select
  cd_plano_financeiro
into
  #Plano
from
  Plano_Financeiro


declare @cd_plano_financeiro      int
declare @cd_tipo_lancamento_fluxo int

while exists ( select top 1 cd_plano_financeiro from #Plano)
begin
  select
    top 1
    @cd_plano_financeiro = cd_plano_financeiro
  from
    #Plano

  set @cd_tipo_lancamento_fluxo = 1

   EXECUTE pr_atualiza_plano_financeiro_saldo
    @cd_plano_financeiro,         
    @cd_tipo_lancamento_fluxo,
    @dt_base,                
    @cd_usuario

  set @cd_tipo_lancamento_fluxo = 2

   EXECUTE pr_atualiza_plano_financeiro_saldo
    @cd_plano_financeiro,
    @cd_tipo_lancamento_fluxo,
    @dt_base,
    @cd_usuario


  delete from #Plano where @cd_plano_financeiro = cd_plano_financeiro

end


