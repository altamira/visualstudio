

create procedure pr_teste_admissao_1

@cd_anos int

as

select * from funcionario
--where datediff(YYYY,dt_admissao_funcionario,GetDate()) > 20
--where (GetDate()-dt_admissao_funcionario) > (20*365)
where (cast((getdate() - dt_admissao_funcionario) as int) / 360) > @cd_anos


