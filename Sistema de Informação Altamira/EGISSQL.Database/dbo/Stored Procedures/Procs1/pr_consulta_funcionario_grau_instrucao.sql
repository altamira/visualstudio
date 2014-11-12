
-------------------------------------------------------------------------------
--pr_consulta_funcionario_grau_instrucao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : COnsulta de Funcionários por Grau de Instrução
--Data             : 17/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_funcionario_grau_instrucao
@cd_grau integer
as
Select
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_chapa_funcionario,
    gi.nm_grau_instrucao,
    f.dt_admissao_funcionario,
    d.nm_departamento,
    cc.nm_centro_custo,
    (select fe.vl_funcionario_evento from Funcionario_Evento fe where fe.cd_funcionario = f.cd_funcionario and
    fe.cd_evento = 1) as vl_funcionario_evento
From
    Funcionario f
    left outer join Grau_Instrucao gi on gi.cd_grau_instrucao = f.cd_grau_instrucao
    left outer join Departamento d on d.cd_departamento = f.cd_departamento
    left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
Where 
    f.cd_grau_instrucao = case when isnull(@cd_grau,0) = 0 then
                            isnull(f.cd_grau_instrucao,0)
                          else
                            isnull(@cd_grau,0)
                          end
