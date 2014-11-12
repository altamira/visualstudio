
-------------------------------------------------------------------------------
--pr_evolucao_salarial
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Evolução Salarial
--Data             : 27.09.2005
--Atualizado       : 27.09.2005
--------------------------------------------------------------------------------------------------
create procedure pr_evolucao_salarial
@cd_fonte_pesquisa           int,
@cd_grupo_salario            int,
@cd_categoria_salario        int,
@cd_departamento             int,
@cd_centro_custo             int,
@dt_inicial                  datetime,
@dt_final                    datetime
as

declare @agosto   int
declare @setembro int

--select * from composicao_salarial
select 
  gs.nm_grupo_salario       as Grupo,
  ca.nm_categoria_salario   as Categoria,
  dp.nm_departamento        as Departamento,
  cc.nm_centro_custo        as CentroCusto,
  cf.nm_cargo_funcionario   as CargoFuncionario,
  fs.nm_faixa_salarial      as FaixaSalarial,
  --cs.vl_composicao_salarial as Valor, 
  sum(isnull(case when month(cs.dt_usuario) = 1 then vl_composicao_salarial end,0)) as 'Janeiro',
  sum(isnull(case when month(cs.dt_usuario) = 2 then vl_composicao_salarial end,0)) as 'Fevereiro',
  sum(isnull(case when month(cs.dt_usuario) = 3 then vl_composicao_salarial end,0)) as 'Marco',
  sum(isnull(case when month(cs.dt_usuario) = 4 then vl_composicao_salarial end,0)) as 'Abril',
  sum(isnull(case when month(cs.dt_usuario) = 5 then vl_composicao_salarial end,0)) as 'Maio',
  sum(isnull(case when month(cs.dt_usuario) = 6 then vl_composicao_salarial end,0)) as 'Junho',
  sum(isnull(case when month(cs.dt_usuario) = 7 then vl_composicao_salarial end,0)) as 'Julho',
  sum(isnull(case when month(cs.dt_usuario) = 8 then vl_composicao_salarial end,0)) as 'Agosto',
  sum(isnull(case when month(cs.dt_usuario) = 9 then vl_composicao_salarial end,0)) as 'Setembro',
  sum(isnull(case when month(cs.dt_usuario) = 10 then vl_composicao_salarial end,0)) as 'Outubro',
  sum(isnull(case when month(cs.dt_usuario) = 11 then vl_composicao_salarial end,0)) as 'Novembro',
  sum(isnull(case when month(cs.dt_usuario) = 12 then vl_composicao_salarial end,0)) as 'Dezembro'
into #temp
from
  composicao_salarial cs
  left outer join grupo_salario     gs on gs.cd_grupo_salario     = cs.cd_grupo_salario
  left outer join categoria_salario ca on ca.cd_categoria_salario = cs.cd_categoria_salario
  left outer join departamento      dp on dp.cd_departamento      = cs.cd_departamento
  left outer join centro_custo      cc on cc.cd_centro_custo      = cs.cd_centro_custo
  left outer join cargo_funcionario cf on cf.cd_cargo_funcionario = cs.cd_cargo_funcionario
  left outer join faixa_salarial    fs on fs.cd_faixa_salarial    = cs.cd_faixa_salarial
where
  isnull(cs.cd_fonte_pesquisa,0)          = case when isnull(@cd_fonte_pesquisa,0)=0    then isnull(cs.cd_fonte_pesquisa,0)                else @cd_fonte_pesquisa          end  and 
  isnull(cs.cd_grupo_salario,0)           = case when isnull(@cd_grupo_salario,0)=0     then isnull(cs.cd_grupo_salario,0)                 else @cd_grupo_salario           end  and 
  isnull(cs.cd_categoria_salario,0)       = case when isnull(@cd_categoria_salario,0)=0 then isnull(cs.cd_categoria_salario,0)             else @cd_categoria_salario       end  and 
  isnull(cs.cd_departamento,0)            = case when isnull(@cd_departamento,0)=0      then isnull(cs.cd_departamento,0)                  else @cd_departamento            end  and
  isnull(cs.cd_centro_custo,0)            = case when isnull(@cd_centro_custo,0)=0      then isnull(cs.cd_centro_custo,0)                  else @cd_centro_custo            end  and
  cs.dt_inicial >= @dt_inicial and cs.dt_final <= @dt_final

group by
  gs.nm_grupo_salario,
  ca.nm_categoria_salario,
  dp.nm_departamento,
  cc.nm_centro_custo,
  cf.nm_cargo_funcionario,
  cs.cd_composicao_salarial,
  cs.dt_usuario,
  fs.nm_faixa_salarial
order by
  gs.nm_grupo_salario,
  ca.nm_categoria_salario,
  dp.nm_departamento,
  cc.nm_centro_custo,
  cf.nm_cargo_funcionario,
  fs.nm_faixa_salarial  

select 
  FaixaSalarial,
  grupo,
  categoria,
  departamento,
  centrocusto,
  cargofuncionario,
  sum(janeiro) as janeiro,
  sum(fevereiro) as fevereiro,
  sum(marco) as marco,
  sum(abril) as abril,
  sum(maio) as maio,
  sum(junho) as junho,
  sum(julho) as julho,
  sum(agosto) as agosto,
  sum(setembro) as setembro,
  sum(outubro) as outubro,
  sum(novembro) as novembro,
  sum(dezembro) as dezembro
--into #Temp2
from #temp
group by 
  Grupo,
  Categoria,
  Departamento,
  CentroCusto,
  CargoFuncionario,
  FaixaSalarial  



