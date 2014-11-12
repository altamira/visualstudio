
-------------------------------------------------------------------------------
--pr_pesquisa_salarial
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Pesquisa Salarial
--Data             : 17/10/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_pesquisa_salarial
@dt_inicial datetime,
@dt_final datetime,
@cd_fonte integer
as
Select
    cs.cd_composicao_salarial,
    fp.nm_fonte_pesquisa_salario,
    gs.nm_grupo_salario,
    csal.nm_categoria_salario,
    cf.nm_cargo_funcionario,
    fs.nm_faixa_salarial,
    cs.vl_composicao_salarial,
    (select cssq.vl_composicao_salarial from Composicao_Salarial cssq
     where cssq.dt_inicial >= @dt_inicial and cssq.dt_final <= @dt_final and cssq.cd_faixa_salarial = 1
     and cssq.cd_cargo_funcionario = cs.cd_cargo_funcionario) as vl_inicial,
    (select cssq.vl_composicao_salarial from Composicao_Salarial cssq
     where cssq.dt_inicial >= @dt_inicial and cssq.dt_final <= @dt_final and cssq.cd_faixa_salarial = 5
     and cssq.cd_cargo_funcionario = cs.cd_cargo_funcionario) as vl_final

into #temp
From
    Composicao_Salarial cs
    left outer join Fonte_Pesquisa_Salario fp on fp.cd_fonte_pesquisa_Salario = cs.cd_fonte_pesquisa
    left outer join Grupo_Salario gs on gs.cd_grupo_salario = cs.cd_grupo_salario
    left outer join Categoria_Salario csal on csal.cd_categoria_salario = cs.cd_categoria_salario
    left outer join Cargo_funcionario cf on cf.cd_cargo_funcionario = cs.cd_cargo_funcionario
    left outer join Faixa_Salarial fs on fs.cd_faixa_salarial = cs.cd_faixa_salarial
where cs.dt_inicial >= @dt_inicial and cs.dt_final <= @dt_final and cs.cd_faixa_salarial = 1 or cs.cd_faixa_salarial = 5
       and cs.cd_fonte_pesquisa = case when isnull(@cd_fonte,0) = 0 then
                                   isnull(cs.cd_fonte_pesquisa,0)
                                 else
                                   isnull(@cd_fonte,0)
                                 end

Select *
From #Temp
Group by
    cd_composicao_salarial,
    nm_fonte_pesquisa_salario,
    nm_grupo_salario,
    nm_categoria_salario,
    nm_cargo_funcionario,
    nm_faixa_salarial,
    vl_composicao_salarial,
    vl_inicial,
    vl_final



