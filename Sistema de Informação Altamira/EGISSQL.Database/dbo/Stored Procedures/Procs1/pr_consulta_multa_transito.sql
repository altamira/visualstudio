
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_multa_transito
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Multa de Trânsito 
--Data             : 19.01.2009
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_multa_transito

@cd_veiculo        int      = 0,
@cd_motorista      int      = 0,
@cd_multa_transito int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = '',
@dt_infracaoDe       datetime = '',
@dt_infracaoAte       datetime = '',
@dt_pagamentoDe      datetime = '',
@dt_pagamentoAte      datetime = '',
@ic_condutor       char(1)  = 'N',
@ic_empresa        char(1)  = 'N'

as

--select * from veiculo
--select * from motorista
--select * from multa_transito
--select * from veiculo_multa

select 
  vm.*,
  v.nm_veiculo                           as Veiculo,
  v.aa_veiculo                           as Ano,
  m.nm_motorista,
  v.cd_placa_veiculo                     as Placa,
  v.cd_chassi_veiculo                    as Chassi,
  v.cd_renavam_veiculo                   as Renavam,
  gv.nm_grupo_veiculo                    as GrupoVeiculo,
  tc.nm_tipo_combustivel                 as Combustivel,
  mv.nm_marca_veiculo                    as Marca,
  mt.nm_multa_transito,
  em.sg_estado,
  cid.nm_cidade,
  ( select max(dt_pagamento_documento)
    from 
      documento_pagar_pagamento with (nolock) 
    where
      cd_documento_pagar = vm.cd_documento_pagar ) as dt_pagamento_documento
into 
  #veiculo_multa
from 
  Veiculo_Multa vm                    with (nolock) 
  left outer join veiculo v           with (nolock) on v.cd_veiculo           = vm.cd_veiculo
  left outer join motorista m         with (nolock) on m.cd_motorista         = vm.cd_motorista 
  left outer join Tipo_Combustivel tc with (nolock) on tc.cd_tipo_combustivel = v.cd_tipo_combustivel
  left outer join Grupo_Veiculo gv    with (nolock) on gv.cd_grupo_veiculo    = v.cd_grupo_veiculo
  left outer join Marca_Veiculo mv    with (nolock) on mv.cd_marca_veiculo    = v.cd_marca_veiculo
  left outer join Multa_Transito mt   with (nolock) on mt.cd_multa_transito   = vm.cd_multa_transito
  left outer join Orgao_Multa    om   with (nolock) on om.cd_orgao_multa      = vm.cd_orgao_multa
  left outer join Estado         em   with (nolock) on em.cd_estado           = vm.cd_estado
  left outer join Cidade        cid   with (nolock) on cid.cd_cidade          = vm.cd_cidade

where
  vm.cd_veiculo        = case when @cd_veiculo = 0 then vm.cd_veiculo else @cd_veiculo end and

  vm.dt_veiculo_multa between case when ((not @dt_infracaoDe is null) or (not @dt_pagamentoDe is null)) then
                                vm.dt_veiculo_multa 
                              else
                                @dt_inicial 
                              end and 
                              case when ((not @dt_infracaoDe is null) or (not @dt_pagamentoDe is null)) then
                                vm.dt_veiculo_multa
                              else
                                @dt_final
                              end and

  vm.dt_veiculo_multa between case when @dt_infracaoDe is null then 
                                 vm.dt_veiculo_multa
                               else
                                 @dt_infracaoDe 
                               end and
                               case when @dt_infracaoAte is null then 
                                 vm.dt_veiculo_multa
                               else
                                 @dt_infracaoAte 
                               end and                               
                                 
  vm.cd_motorista            = case when @cd_motorista      = 0 then vm.cd_motorista      else @cd_motorista      end and
  vm.cd_multa_transito       = case when @cd_multa_transito = 0 then vm.cd_multa_transito else @cd_multa_transito end

order by
  v.nm_veiculo

if @dt_pagamentoDe is null 
  select 
    * 
  from 
    #veiculo_multa
else
  select
    *
  from
    #veiculo_multa
  where
    dt_pagamento_documento between @dt_pagamentoDe and @dt_pagamentoAte

--select * from veiculo_multa


