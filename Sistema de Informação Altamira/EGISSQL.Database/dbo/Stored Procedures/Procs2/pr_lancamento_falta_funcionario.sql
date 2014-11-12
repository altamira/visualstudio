
-------------------------------------------------------------------------------
--sp_helptext pr_lancamento_falta_funcionario
-------------------------------------------------------------------------------
--pr_lancamento_falta_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2011
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Lançamentos de Falta do Funcionário da Folha de Pagamento
--Data             : 08.11.2011
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_lancamento_falta_funcionario
@cd_falta   int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

select 
  fl.cd_falta,
  fl.dt_lancamento_falta,
  fl.dt_falta,
  fl.cd_funcionario,
  fl.cd_motivo_falta,
  fl.ic_justificada_falta,
  fl.ic_desconto_falta,
  fl.ic_ferias_falta,
  fl.nm_obs_falta,
  fl.cd_usuario,
  fl.dt_usuario,
  f.nm_funcionario,
  cc.nm_centro_custo,
  d.nm_departamento

from
  faltas fl with (nolock) 
  inner join funcionario f        with (nolock) on f.cd_funcionario   = fl.cd_funcionario
  left outer join departamento d                on d.cd_departamento  = f.cd_departamento
  left outer join centro_custo cc               on cc.cd_centro_custo = f.cd_centro_custo 

where
  fl.cd_falta = case when @cd_falta = 0 then fl.cd_falta else @cd_falta end and
  fl.dt_falta between @dt_inicial and @dt_final 


order by
  fl.dt_falta desc

