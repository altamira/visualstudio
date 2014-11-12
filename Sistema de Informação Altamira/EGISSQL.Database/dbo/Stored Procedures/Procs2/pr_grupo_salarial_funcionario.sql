
-------------------------------------------------------------------------------
--pr_grupo_salarial_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Funcionários X Grupo Salarial
--Data             : 13/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_grupo_salarial_funcionario
@cd_grupo_salario integer
as
Select
   gs.nm_grupo_salario,
   cs.nm_categoria_salario,
   d.nm_departamento,
   cc.nm_centro_custo,
   f.cd_chapa_funcionario,
   f.cd_funcionario,
   f.nm_funcionario,
   ef.vl_fator_evento,
   (select fs.nm_faixa_salarial from faixa_salarial fs),
    case when ef.vl_fator_evento >= (select cs.cd_faixa_salarial from composicao_salarial cs where cd_faixa_salarial = 1)   
    and ef.vl_fator_evento < (select cs.cd_faixa_salarial from composicao_salarial cs where cd_faixa_salarial = 2) then
        (select fs.nm_faixa_salarial from faixa_salarial fs where fs.cd_faixa_salarial = 1)
    else
        0
    end
From
   Funcionario f 
   left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
   left outer join Departamento d on d.cd_departamento = f.cd_departamento
   left outer join Categoria_Salario cs on cs.cd_categoria_salario = f.cd_categoria_salario
   left outer join Grupo_Salario gs on gs.cd_grupo_salario = cs.cd_grupo_salario
   left outer join Funcionario_Evento fe on fe.cd_funcionario = f.cd_funcionario
   left outer join Evento_Folha ef on ef.cd_evento = fe.cd_evento
Where cs.cd_grupo_salario = case when isnull(@cd_grupo_salario,0) = 0 then
                              isnull(cs.cd_grupo_salario,0)
                            else
                              isnull(@cd_grupo_salario,0)
                            end 
Order By f.nm_funcionario
