
-------------------------------------------------------------------------------
--pr_previsao_aumento_salarial
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Previsão de Aumento Salarial
--Data             : 13/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_previsao_aumento_salarial
@cd_departamento integer
as
Select
   cc.nm_Centro_custo,
   d.nm_departamento,
   f.cd_funcionario,
   f.nm_funcionario,
   f.cd_chapa_funcionario,
   (select fe.vl_funcionario_evento from funcionario_evento fe where fe.cd_funcionario = f.cd_funcionario) as vl_salario_funcionario,  
   f.dt_admissao_funcionario,
   (cast(getdate() - f.dt_admissao_funcionario as integer) / 365) as qt_tempo,
   f.dt_ultimo_reajuste,
   cast(null as datetime) as dt_proximo_reajuste
From
   Funcionario f
   left outer join Centro_Custo cc on cc.cd_centro_custo = f.cd_centro_custo
   left outer join Departamento d on d.cd_departamento = f.cd_departamento
   left outer join Funcionario_Reajuste fr on fr.cd_funcionario = f.cd_funcionario
Where f.cd_departamento = case when isnull(@cd_departamento,0) = 0 then               
                            f.cd_departamento
                          else
                            @cd_departamento  
                          end
Order By f.nm_funcionario
