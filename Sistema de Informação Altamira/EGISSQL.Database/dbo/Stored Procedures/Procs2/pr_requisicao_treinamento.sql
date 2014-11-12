create procedure pr_requisicao_treinamento
@cd_requisicao_treinamento integer
as
select
    rt.cd_requisicao_treinamento,
    rt.dt_requisicao_treinamento,
    rt.cd_departamento,
    rt.cd_seccao,
    rt.cd_motivo_treinamento,
    rt.ds_requisicao_treinamento,
    rt.cd_usuario_treinamento,
    rt.cd_usuario,
    rt.dt_usuario,
    rt.cd_centro_custo,
    rt.ic_liberacao_requisicao,
    rt.dt_liberacao_requisicao,
    rt.cd_tipo_treinamento,
    rt.dt_necessidade_treinamento,
    d.nm_departamento,
    cc.nm_centro_custo,
    mt.nm_motivo_treinamento,
    u.nm_usuario
from 
    requisicao_treinamento rt
    left outer join Departamento d on d.cd_departamento = rt.cd_departamento
    left outer join Centro_Custo cc on cc.cd_centro_custo = rt.cd_centro_custo
    left outer join Motivo_Treinamento mt on mt.cd_motivo_treinamento = rt.cd_motivo_treinamento
    left outer join Tipo_Treinamento tt on tt.cd_tipo_treinamento = rt.cd_tipo_treinamento
    left outer join EgisAdmin.dbo.Usuario u on u.cd_usuario = rt.cd_usuario 
where
    rt.cd_requisicao_treinamento = case when isnull(@cd_requisicao_treinamento,0) = 0 then
                                     isnull(rt.cd_requisicao_treinamento,0)
                                   else
                                     isnull(@cd_requisicao_treinamento,0)
                                   end
