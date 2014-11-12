
-------------------------------------------------------------------------------
--pr_alteracao_vencimento_automatico_portador
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 07.07.2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_alteracao_vencimento_automatico_portador
@ic_parametro       int = 0,
@cd_portador        int,
@dt_novo_vencimento datetime

as

--Mostra os Documento

if @ic_parametro = 0
begin
  select
    * 
  from
    documento_receber
  where
    cd_portador = @cd_portador     and
    isnull(vl_saldo_documento,0)>0 and
    dt_vencimento_documento<=@dt_novo_vencimento
end

if @ic_parametro = 1
begin

update
  documento_receber
set
  dt_vencimento_documento = @dt_novo_vencimento
where
  cd_portador = @cd_portador     and
  isnull(vl_saldo_documento,0)>0 and
  dt_vencimento_documento<=@dt_novo_vencimento
end

