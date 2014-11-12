
-------------------------------------------------------------------------------
--pr_consulta_frota_veiculo_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Frotas de Veículo por Cliente
--Data             : 06.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_frota_veiculo_cliente

@cd_frota int = 0

as


select 
  fc.*,
  c.nm_fantasia_cliente  as Cliente,
  v.nm_veiculo           as Veiculo,
  v.aa_veiculo           as Ano,
  v.cd_placa_veiculo     as Placa,
  gv.nm_grupo_veiculo    as GrupoVeiculo,
  tc.nm_tipo_combustivel as Combustivel,
  m.nm_motorista         as Motorista
 
from 
  frota_cliente fc
  left outer join cliente c           on c.cd_cliente           = fc.cd_cliente
  left outer join Veiculo v           on v.cd_veiculo           = fc.cd_veiculo
  left outer join Tipo_Combustivel tc on tc.cd_tipo_combustivel = v.cd_tipo_combustivel
  left outer join Grupo_Veiculo gv    on gv.cd_grupo_veiculo    = v.cd_grupo_veiculo
  left outer join Motorista m         on m.cd_motorista         = fc.cd_motorista

where
  fc.cd_frota = case when @cd_frota = 0 then fc.cd_frota else @cd_frota end 


--select * from veiculo

