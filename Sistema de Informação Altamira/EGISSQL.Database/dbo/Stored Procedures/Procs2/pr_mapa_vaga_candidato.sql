
CREATE PROCEDURE pr_mapa_vaga_candidato
@cd_departamento int,
@cd_cargo int
AS
select
    rv.cd_requisicao_vaga,
    d.nm_departamento,
    cf.nm_cargo_funcionario,
    c.nm_candidato,
    (case when isnull(c.ic_trabalhando_candidato,'N') = 'S' then
      'Não'
    else
      'Sim'
    end) as ic_trabalhando_candidato, 
    (cast(getdate() - c.dt_nascimento_candidato as int) / 365) as Idade,
    c.vl_salario_candidato,
    p.nm_pais,
    e.sg_estado,
    cid.nm_cidade,
    cast(c.cd_ddd_candidato + '-' + c.cd_fone_candidato as varchar(20)) as telefone,
    cast(c.cd_ddd_cel_candidato + '-' + c.cd_celular_candidato as varchar(20)) as celular
from
    Requisicao_Vaga rv
    left outer join Requisicao_Vaga_Composicao rvc on rvc.cd_requisicao_vaga = rv.cd_requisicao_vaga
    left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = rvc.cd_cargo_funcionario
    left outer join Candidato c on c.cd_cargo_funcionario = rvc.cd_cargo_funcionario
    left outer join Departamento d on d.cd_departamento = rv.cd_departamento
    left outer join Cidade cid on cid.cd_cidade = c.cd_cidade
    left outer join Estado e on e.cd_estado = c.cd_estado
    left outer join Pais p on p.cd_pais = c.cd_pais
where
    rv.cd_departamento = case when isnull(@cd_departamento,0) = 0 then
                           isnull(rv.cd_departamento,0)
                         else
                           isnull(@cd_departamento,0)
                         end and
    rvc.cd_cargo_funcionario = case when isnull(@cd_cargo,0) =0 then
                                 isnull(rvc.cd_cargo_funcionario,0)
                               else
                                 isnull(@cd_cargo,0)
                               end

