
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_prestacao_conta_sem_registro
-------------------------------------------------------------------------------
--pr_consulta_prestacao_conta_sem_registro
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--                   Lázaro Cardoso / Márcio Martins
--                  
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta das presta'~oes de Conta sem Registro de Documentos
--
--Data             : 16.10.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_prestacao_conta_sem_registro

--Parâmetros de entrada para a procedure

@dt_inicial datetime = '',
@dt_final  datetime = '' 

as

declare @dt_hoje datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

--select @dt_hoje


select
  pc.cd_prestacao                           as Numero,
  pc.dt_prestacao                           as Emissao,
  cast( @dt_hoje - pc.dt_prestacao as int ) as Dias,
  f.nm_funcionario                          as Funcionario,
  cc.nm_centro_custo                        as CentroCusto,
  d.nm_departamento                         as Departamento,
  isnull(pc.vl_prestacao,0)                 as Valor


from
  prestacao_conta pc              with (nolock) 
  left outer join funcionario f   on f.cd_funcionario = pc.cd_funcionario
  left outer join centro_custo cc on cc.cd_centro_custo = pc.cd_centro_custo
  left outer join departamento d  on d.cd_departamento  = pc.cd_departamento

where
  pc.dt_prestacao between @dt_inicial and @dt_final
  and
  pc.cd_prestacao not in ( select cd_prestacao from prestacao_conta_registro )


order by
  pc.dt_prestacao, pc.cd_prestacao




