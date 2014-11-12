
-------------------------------------------------------------------------------
--sp_helptext pr_controle_multa_veiculo
-------------------------------------------------------------------------------
--pr_controle_multa_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Multa de Veículo
--
--Data             : 24.12.2008
--Alteração        : 07.01.2009 - Ajustes Deiversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_controle_multa_veiculo
@ic_parametro      int      = 0,
@cd_veiculo        int      = 0,
@cd_motorista      int      = 0,
@dt_base           datetime = '',
@dt_inicial        datetime = '',
@dt_final          datetime = '',
@cd_veiculo_multa  int      = 0

as

--Controle de Multa-----------------------------------------------------------

--select * from orgao_multa
--select * from multa_transito
--select * from veiculo_multa
--

--Cadastro

if @ic_parametro = 0
begin

  select 
    vm.*,
    v.nm_veiculo,
    v.aa_veiculo,
    v.cd_placa_veiculo,
    v.cd_chassi_veiculo,
    m.nm_motorista,
    mt.nm_multa_transito,
    om.nm_orgao_multa,
    ( select max(dt_pagamento_documento) from documento_pagar_pagamento with (nolock) 
      where
       cd_documento_pagar = vm.cd_documento_pagar ) as dt_pagamento_documento

--select * from documento_pagar_pagamento
  from
    veiculo_multa vm                  with (nolock) 
    left outer join Veiculo   v       with (nolock) on v.cd_veiculo         = vm.cd_veiculo 
    left outer join Motorista m       with (nolock) on m.cd_motorista       = vm.cd_motorista 
    left outer join Multa_Transito mt with (nolock) on mt.cd_multa_transito = vm.cd_multa_transito
    left outer join Orgao_Multa    om with (nolock) on om.cd_orgao_multa    = vm.cd_orgao_multa
  where
    vm.dt_lancamento_multa between @dt_inicial and @dt_final

  order by
    dt_veiculo_multa  


end

