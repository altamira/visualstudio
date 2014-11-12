-----------------------------------------------------------------------------------
--pr_recomposicao_saldo_contabil
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2005                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Paulo Santos         
--Banco Dados      : EGISSQL
--Objetivo         : Recomposição de Saldos Contábeis
--Data             : 21.01.2005
-----------------------------------------------------------------------------------
create procedure pr_recomposicao_saldo_contabil

as

declare @cd_exercicio int
declare @dt_inicial_exercicio datetime
declare @dt_final_exercicio datetime
declare @cd_empresa int
declare @cd_usuario int

set @cd_empresa = dbo.fn_empresa()
set @cd_usuario = 0 

-- Pega Exercício Ativo
  select @cd_exercicio         = cd_exercicio, 
         @dt_inicial_exercicio = dt_inicial_exercicio, 
         @dt_final_exercicio   = dt_final_exercicio 
	  from parametro_contabil
	 where cd_empresa = @cd_empresa and
         ic_exercicio_ativo = 'S'

-- Apaga saldo conta
delete from saldo_conta
 where dt_saldo_conta = @dt_final_exercicio and cd_empresa = @cd_empresa

-- Pega Movimento Contábil e Alimenta Tabela Temporária #MovimentoContabilAux
select 
	pc.cd_conta as conta_debito,
	--pcx.cd_conta as conta_credito,
	sum(mc.vl_lancamento_contabil) as vl_lancamento_contabil
into 
  #MovimentoContabilAux
from
  Movimento_contabil mc
left outer join plano_conta pc
  on mc.cd_reduzido_debito = pc.cd_conta_reduzido
--left outer join plano_conta pcx
--  on mc.cd_reduzido_credito = pcx.cd_conta_reduzido
where 
  mc.cd_empresa = @cd_empresa and 
  mc.cd_exercicio = @cd_exercicio and 
 (case when Isnull(cd_reduzido_debito,0) <> 0  then
    Isnull(cd_reduzido_debito,0) end) <> 0 
  --else
    --isnull(cd_reduzido_credito,0) end) <> 0
group by pc.cd_conta--, pcx.cd_conta


select * from saldo_conta

select conta_debito, sum(vl_lancamento_contabil) 
 from #MovimentoContabilAux
group by conta_debito


-- Insere novo saldo conta

-- insert saldo_conta
--  (cd_empresa,
--   cd_conta,
--   dt_saldo_conta,
--   vl_saldo_conta,
--   ic_saldo_conta,
--   vl_inicial_saldo_conta,
--   ic_inicial_saldo_conta,
--   vl_debito_saldo_conta,
--   vl_credito_saldo_conta,    
--   cd_usuario,
--   dt_usuario)
select
  pc.cd_empresa,
  pc.cd_conta,
  @dt_final_exercicio,

	case when ic_saldo_atual_conta = 'D' and 
	(vl_saldo_inicial_conta = vl_saldo_atual_conta) then 
	pc.vl_saldo_inicial_conta + Isnull(md.vl_lancamento_contabil,0)-- - Isnull(mc.vl_lancamento_contabil,0) 
	
	when ic_saldo_atual_conta = 'D' and 
	(vl_saldo_inicial_conta <> vl_saldo_atual_conta) then           
	pc.vl_saldo_atual_conta + Isnull(md.vl_lancamento_contabil,0)-- - Isnull(mc.vl_lancamento_contabil,0) 
	
-- 	when ic_saldo_atual_conta = 'C' and 
-- 	(vl_saldo_inicial_conta = vl_saldo_atual_conta) then 
-- 	pc.vl_saldo_inicial_conta + Isnull(mc.vl_lancamento_contabil,0) - Isnull(md.vl_lancamento_contabil,0)
-- 	
-- 	when ic_saldo_atual_conta = 'C' and 
-- 	(vl_saldo_inicial_conta <> vl_saldo_atual_conta) then 
-- 	pc.vl_saldo_atual_conta + Isnull(mc.vl_lancamento_contabil,0) - Isnull(md.vl_lancamento_contabil,0)
	
	else
	isnull(vl_saldo_atual_conta,0)
	end as vl_saldo_atual_conta,

  isnull(pc.ic_saldo_atual_conta,0),
  isnull(pc.vl_saldo_inicial_conta,0),
  isnull(pc.ic_saldo_inicial_conta,''),
  isnull(pc.vl_debito_conta,0),
  isnull(pc.vl_credito_conta,0),   
  @cd_usuario,
  getdate()
from 
  plano_conta pc 
--left outer join #MovimentoContabilAux mc 
 -- on mc.conta_credito = pc.cd_conta and pc.ic_saldo_atual_conta = 'C' 
left outer join #MovimentoContabilAux md 
  on md.conta_debito = pc.cd_conta and pc.ic_saldo_atual_conta = 'D'
where pc.cd_empresa = @cd_empresa

-- Apaga tabela temporária
drop table #MovimentoContabilAux


