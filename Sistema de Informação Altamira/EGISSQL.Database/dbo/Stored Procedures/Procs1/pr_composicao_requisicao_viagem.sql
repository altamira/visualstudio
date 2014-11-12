--USE EGISSQL
-------------------------------------------------------------------------------
--sp_helptext pr_composicao_requisicao_viagem
-------------------------------------------------------------------------------
--pr_composicao_requisicao_viagem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Composição da Requisição de Viagem
--Data             : 12.05.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_composicao_requisicao_viagem
@ic_parametro        int      = 0,
@dt_inicial          datetime = '',
@dt_final            datetime = '',
@cd_funcionario      int      = 0,
@cd_departamento     int      = 0,
@cd_centro_custo     int      = 0,
@cd_categoria_viagem int      = 0

as

--select
  
Select 
  identity(int,1,1)                      as cd_controle,
  rv.cd_requisicao_viagem,
  rv.dt_requisicao_viagem,    
  isnull(cv.nm_categoria_viagem,'')      as nm_categoria_viagem, 
  rvc.cd_item_requisicao_viagem,
  isnull(rvc.nm_obs_item_req_viagem,'')  as nm_obs_item_req_viagem,
  isnull(rvc.qt_item_viagem,0)           as qt_item_viagem,
  isnull(rvc.vl_item_viagem,0)           as vl_item_viagem,
  isnull(rvc.vl_total_viagem,0)          as vl_total_viagem,
  isnull(rvc.nm_item_opcional_viagem,'') as nm_item_opcional_viagem,
  isnull(rvc.nm_item_motivo_viagem,'')   as nm_item_motivo_viagem,
  isnull(cv.ic_servico_categoria,'N')    as ic_servico_categoria,
  f.nm_funcionario,
  d.nm_departamento,
  cc.nm_centro_custo,
  cv.cd_categoria_viagem

into
  #ResumoComposicaoViagem
from
  Requisicao_Viagem            rv             with (nolock)
  inner join Requisicao_Viagem_Composicao rvc with (nolock) on rv.cd_requisicao_viagem = rvc.cd_requisicao_viagem
  left outer join Categoria_Viagem cv         with (nolock) on cv.cd_categoria_viagem  = rvc.cd_categoria_viagem 
  left outer join Funcionario      f          with (nolock) on f.cd_funcionario        = rv.cd_funcionario
  left outer join Departamento     d          with (nolock) on d.cd_departamento       = rv.cd_departamento
  left outer join Centro_Custo     cc         with (nolock) on cc.cd_centro_custo      = rv.cd_centro_custo 
where
  rv.dt_requisicao_viagem between @dt_inicial and @dt_final

if @ic_parametro = 1
begin

  select 
    cd_categoria_viagem,
    nm_categoria_viagem,
    sum ( qt_item_viagem  ) as qt_item_viagem,
    sum ( vl_total_viagem ) as vl_total_viagem
  from 
    #ResumoComposicaoViagem
  group by 
    cd_categoria_viagem,
    nm_categoria_viagem
  order by
    3 desc

end

if @ic_parametro = 2
begin
  select * from #ResumoComposicaoViagem 
  where
    cd_categoria_viagem = case when @cd_categoria_viagem = 0 then cd_categoria_viagem else @cd_categoria_viagem end
  order by 
    dt_requisicao_viagem

end
  
