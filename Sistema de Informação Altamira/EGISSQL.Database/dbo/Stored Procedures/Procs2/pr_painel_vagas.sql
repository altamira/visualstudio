

create procedure pr_painel_vagas
@cd_departamento integer
as

select 
   rv.cd_requisicao_vaga, 
   d.nm_departamento,
   cf.nm_cargo_funcionario,
   rvc.qt_item_requisicao,
   rv.dt_necessidade_vaga,
   rv.ds_requisicao_vaga
from
   requisicao_vaga rv
   left outer join requisicao_vaga_composicao rvc on rvc.cd_requisicao_vaga = rv.cd_requisicao_vaga
   left outer join Departamento d on d.cd_departamento = rv.cd_departamento
   left outer join seccao s on s.cd_seccao = rv.cd_seccao
   left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = rvc.cd_cargo_funcionario
where
   rv.cd_departamento = case when isnull(@cd_departamento,0) = 0 then
                          isnull(rv.cd_departamento,0)
                        else
                          isnull(@cd_departamento,0)
                        end  
