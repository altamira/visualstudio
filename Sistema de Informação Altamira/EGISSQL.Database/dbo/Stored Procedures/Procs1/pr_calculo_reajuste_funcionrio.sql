
-------------------------------------------------------------------------------
--pr_calculo_reajuste_funcionrio
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_calculo_reajuste_funcionrio
@ic_parametro         int   = 0,
@cd_departamento      int   = 0,
@cd_centro_custo      int   = 0,
@cd_cargo_funcionario int   = 0,
@cd_tipo_salario      int   = 0,
@cd_evento            int   = 0,
@cd_grupo_salario     int   = 0,
@cd_categoria_salario int   = 0,
@cd_funcionario       int   = 0,
@vl_menor             float = 0,
@vl_maior             float = 0,
@vl_inicial_salario   float = 0,
@vl_final_salario     float = 0,
@vl_arredondamento    float = 0
as

--------------------------------------------------------------------------------------------------
--Limpeza da Tabela temporária de Cálculo do Reajuste
--------------------------------------------------------------------------------------------------

if @ic_parametro = 0
begin

   delete from calculo_reajuste_funcionario

end

--------------------------------------------------------------------------------------------------
--Montagem dos Funcionários para Reajuste conforme os parâmetros
--------------------------------------------------------------------------------------------------

if @ic_parametro = 1
begin
  --select * from funcionario
  --select * from funcionario_evento
  select
    f.cd_registro_funcionario,
    f.nm_funcionario,
    ef.nm_evento,
    fe.vl_funcionario_evento,
    d.nm_departamento,
    cc.nm_centro_custo,
    cf.nm_cargo_funcionario,
    ts.nm_tipo_salario,
    gs.nm_grupo_salario,
    cs.nm_categoria_salario 
  from
    Funcionario f 
    inner join Funcionario_Evento fe     on fe.cd_funcionario       = f.cd_funcionario
    left outer join Evento_Folha  ef     on ef.cd_evento            = fe.cd_evento
    left outer join Departamento  d      on d.cd_departamento       = f.cd_departamento
    left outer join Centro_Custo cc      on cc.cd_centro_custo      = f.cd_centro_custo
    left outer join Cargo_Funcionario cf on cf.cd_cargo_funcionario = f.cd_cargo_funcionario
    left outer join Tipo_Salario ts      on ts.cd_tipo_salario      = f.cd_tipo_salario
    left outer join Categoria_Salario cs on cs.cd_categoria_salario = f.cd_categoria_salario
    left outer join Grupo_Salario gs     on gs.cd_grupo_salario     = cs.cd_grupo_salario
  where 
     isnull(ef.ic_salario_evento,'N')  = 'S' and
     isnull(ef.ic_reajuste_evento,'N') = 'S' 

end

--------------------------------------------------------------------------------------------------
--Efetivação do Cálculo do Reajuste na Tabela Histórico do Funcionário
--------------------------------------------------------------------------------------------------
if @ic_parametro = 2
begin
  print ''
end

