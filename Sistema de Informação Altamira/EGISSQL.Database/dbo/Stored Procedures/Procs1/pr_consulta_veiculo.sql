
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Veículos
--Data             : 19.12.2008
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_veiculo

@cd_veiculo int = 0

as

--select * from veiculo
--select * from motorista

select 
  v.cd_veiculo,
  v.nm_veiculo                           as Veiculo,
  v.nm_modelo_veiculo                    as Modelo,
  v.aa_veiculo                           as Ano,
  v.aa_modelo_veiculo                    as Ano_Modelo,
  v.cd_placa_veiculo                     as Placa,
  v.cd_chassi_veiculo                    as Chassi,
  v.cd_renavam_veiculo                   as Renavam,
  gv.nm_grupo_veiculo                    as GrupoVeiculo,
  tc.nm_tipo_combustivel                 as Combustivel,
  mv.nm_marca_veiculo                    as Marca,
  v.qt_consumo_veiculo                   as Consumo,
  e.sg_estado                            as Estado,
  cid.nm_cidade                          as Cidade,
  c.nm_cor                               as Cor,
  tv.nm_tipo_veiculo                     as TipoVeiculo,
  v.cd_tag_veiculo                       as Tag,
  v.dt_aquisicao_veiculo                 as Aquisicao,
  cast( getdate() - 
        v.dt_aquisicao_veiculo  as int ) as Tempo
 
from 
  veiculo v                           with (nolock) 
  left outer join Tipo_Combustivel tc with (nolock) on tc.cd_tipo_combustivel = v.cd_tipo_combustivel
  left outer join Grupo_Veiculo gv    with (nolock) on gv.cd_grupo_veiculo    = v.cd_grupo_veiculo
  left outer join Marca_Veiculo mv    with (nolock) on mv.cd_marca_veiculo    = v.cd_marca_veiculo
  left outer join Estado e            with (nolock) on e.cd_estado            = v.cd_estado
  left outer join Cidade cid          with (nolock) on cid.cd_cidade          = v.cd_cidade
  left outer join Cor c               with (nolock) on c.cd_cor               = v.cd_cor
  left outer join Tipo_Veiculo tv     with (nolock) on tv.cd_tipo_veiculo     = v.cd_tipo_veiculo

where
  v.cd_veiculo = case when @cd_veiculo = 0 then v.cd_veiculo else @cd_veiculo end

order by
  v.nm_veiculo

--select * from veiculo

