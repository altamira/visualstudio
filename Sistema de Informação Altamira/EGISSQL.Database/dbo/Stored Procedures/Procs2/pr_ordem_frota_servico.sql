
-------------------------------------------------------------------------------
--sp_helptext pr_ordem_frota_servico
-------------------------------------------------------------------------------
--pr_ordem_frota_servico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ordem de Serviço
--                   Para Veículos da Frota
--
--Data             : 20.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ordem_frota_servico
@cd_ordem      int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = ''

as

--select * from ordem_frota_servico
--select * from veiculo
 
select
  os.*,
  v.nm_veiculo,
  v.aa_veiculo,
  v.cd_placa_veiculo,
  v.cd_chassi_veiculo,
  o.nm_oficina,
  f.nm_fantasia_fornecedor,
  tof.nm_tipo_ordem,
  u.nm_fantasia_usuario,
  cp.nm_condicao_pagamento,
  cp.sg_condicao_pagamento,
  tm.nm_tipo_manutencao, 
  tp.nm_tipo_prioridade

from
  ordem_frota_servico os                  with (nolock) 
  left outer join veiculo v               with (nolock) on v.cd_veiculo             = os.cd_veiculo
  left outer join tipo_prioridade      tp with (nolock) on tp.cd_tipo_prioridade   = os.cd_tipo_prioridade
  left outer join oficina o               with (nolock) on o.cd_oficina             = os.cd_oficina
  left outer join fornecedor f            with (nolock) on f.cd_fornecedor          = os.cd_fornecedor
  left outer join tipo_ordem_frota tof    with (nolock) on tof.cd_tipo_ordem        = os.cd_tipo_ordem
  left outer join condicao_pagamento cp   with (nolock) on cp.cd_condicao_pagamento = os.cd_condicao_pagamento
  left outer join egisadmin.dbo.usuario u with (nolock) on u.cd_usuario             = os.cd_usuario
  left outer join Tipo_Manutencao      tm with (nolock) on tm.cd_tipo_manutencao    = os.cd_tipo_manutencao

where
  os.cd_ordem = case when @cd_ordem = 0 then os.cd_ordem else @cd_ordem end and
  os.dt_ordem between @dt_inicial and @dt_final   

order by
  os.dt_ordem

