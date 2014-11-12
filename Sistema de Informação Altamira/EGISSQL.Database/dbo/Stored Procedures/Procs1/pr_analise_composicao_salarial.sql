
-------------------------------------------------------------------------------
--pr_analise_composicao_salarial
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Análise de Composição Salarial
--                   
--Data             : 23.09.2005
--Atualizado       : 23.09.2005
--------------------------------------------------------------------------------------------------
create procedure pr_analise_composicao_salarial
@cd_fonte_pesquisa           int,
@cd_grupo_salario            int,
@cd_categoria_salario        int,
@cd_departamento             int,
@cd_centro_custo             int,
@dt_inicial                  datetime,
@dt_final                    datetime

as
--select * from composicao_salarial
select 
  gs.nm_grupo_salario       as Grupo,
  ca.nm_categoria_salario   as Categoria,
  dp.nm_departamento        as Departamento,
  cc.nm_centro_custo        as CentroCusto,
  cf.nm_cargo_funcionario   as CargoFuncionario,
  --fs.nm_faixa_salarial      as FaixaSalarial,
  --cs.vl_composicao_salarial as Valor,
  (case when cs.cd_faixa_salarial = 1 then   
    (select vl_composicao_salarial   
    from composicao_salarial
    where cd_composicao_salarial = cs.cd_composicao_salarial)
  else
    0.00
  end) as 'quartil1',
  (case when cs.cd_faixa_salarial = 2 then
    (select vl_composicao_salarial   
    from composicao_salarial
    where cd_composicao_salarial = cs.cd_composicao_salarial)
  else
    0.00
  end) as 'quartil2',
  (case when cs.cd_faixa_salarial = 3 then
    (select vl_composicao_salarial   
    from composicao_salarial
    where cd_composicao_salarial = cs.cd_composicao_salarial)
  else
    0.00
  end) as 'quartil3',
  (case when cs.cd_faixa_salarial = 4 then
    (select vl_composicao_salarial   
    from composicao_salarial
    where cd_composicao_salarial = cs.cd_composicao_salarial)
  else
    0.00
  end) as 'quartil4',
  (case when cs.cd_faixa_salarial = 5 then
    (select vl_composicao_salarial   
    from composicao_salarial
    where cd_composicao_salarial = cs.cd_composicao_salarial)
  else
    0.00
  end) as 'quartil5'
into #temp
from
  composicao_salarial cs
  left outer join grupo_salario     gs on gs.cd_grupo_salario     = cs.cd_grupo_salario
  left outer join categoria_salario ca on ca.cd_categoria_salario = cs.cd_categoria_salario
  left outer join departamento      dp on dp.cd_departamento      = cs.cd_departamento
  left outer join centro_custo      cc on cc.cd_centro_custo      = cs.cd_centro_custo
  left outer join cargo_funcionario cf on cf.cd_cargo_funcionario = cs.cd_cargo_funcionario
  --left outer join faixa_salarial    fs on fs.cd_faixa_salarial    = cs.cd_faixa_salarial
where
  isnull(cs.cd_fonte_pesquisa,0)          = case when isnull(@cd_fonte_pesquisa,0)=0    then isnull(cs.cd_fonte_pesquisa,0)                else @cd_fonte_pesquisa          end  and 
  isnull(cs.cd_grupo_salario,0)           = case when isnull(@cd_grupo_salario,0)=0     then isnull(cs.cd_grupo_salario,0)                 else @cd_grupo_salario           end  and 
  isnull(cs.cd_categoria_salario,0)       = case when isnull(@cd_categoria_salario,0)=0 then isnull(cs.cd_categoria_salario,0)             else @cd_categoria_salario       end  and 
  isnull(cs.cd_departamento,0)            = case when isnull(@cd_departamento,0)=0      then isnull(cs.cd_departamento,0)                  else @cd_departamento            end  and
  isnull(cs.cd_centro_custo,0)            = case when isnull(@cd_centro_custo,0)=0      then isnull(cs.cd_centro_custo,0)                  else @cd_centro_custo            end  and
  cs.dt_inicial >= @dt_inicial and cs.dt_final <= @dt_final

order by
  gs.nm_grupo_salario,
  ca.nm_categoria_salario,
  dp.nm_departamento,
  cc.nm_centro_custo,
  cf.nm_cargo_funcionario
--  fs.nm_faixa_salarial  



select 
   Grupo,
   Categoria,
   Departamento,
   CentroCusto,
   CargoFuncionario,
   Sum(quartil1) as 'quartil1',
   Sum(quartil2) as 'quartil2',
   Sum(quartil3) as 'quartil3',
   Sum(quartil4) as 'quartil4',
   Sum(quartil5) as 'quartil5'
from #temp
Group By 
   Grupo,
   Categoria,
   Departamento,
   CentroCusto,
   CargoFuncionario

