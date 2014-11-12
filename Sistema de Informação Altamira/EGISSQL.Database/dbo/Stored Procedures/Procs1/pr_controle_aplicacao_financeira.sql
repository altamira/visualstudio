
CREATE PROCEDURE pr_controle_aplicacao_financeira

-----------------------------------------------------------------------------------------
--GBS Global Business Solution                 2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EGISSQL
--Objetivo: Fazer o controle de aplicações financeiras.
--Data: 30/07/2003
--Atualizado: 
-- 31/07/20003 - Daniel C. Neto.
-----------------------------------------------------------------------------------------

@ic_parametro                   int,
@nm_aplicacao_financeira        varchar(60),
@dt_inicial 			datetime,
@dt_final 			datetime

AS

--------------------------------------------------------------------
if @ic_parametro = 1 -- Consulta Aplicações financeiras num período.
--------------------------------------------------------------------
begin

SELECT     af.cd_aplicacao_financeira, 
           af.dt_aplicacao_financeira, 
           af.vl_resgate_aplicacao, 
           af.nm_aplicacao_financeira, 
           b.nm_fantasia_banco, 
           ca.nm_conta_banco, 
           taf.nm_tipo_aplicacao_finan, 
           af.vl_rendimento_aplicacao, 
           af.vl_aplicacao_financeira, 
           af.vl_atual_aplicacao, 
           af.ds_aplicacao_financeira

FROM       Aplicacao_Financeira af left outer join
           Banco b ON af.cd_banco = b.cd_banco left outer join
           Conta_Agencia_Banco ca ON af.cd_conta_banco = ca.cd_conta_banco left outer join
           Tipo_Aplicacao_Financeira taf ON af.cd_tipo_aplicacao_finan = taf.cd_tipo_aplicacao_finan
where
           af.dt_aplicacao_financeira between @dt_inicial and @dt_final and
           IsNull(af.nm_aplicacao_financeira,'') like @nm_aplicacao_financeira + '%'
order by
  af.dt_aplicacao_financeira desc

end

--------------------------------------------------------------------
if @ic_parametro = 2 -- Dados para o relatório
--------------------------------------------------------------------
begin

SELECT     af.cd_aplicacao_financeira, 
           af.dt_aplicacao_financeira, 
           af.vl_resgate_aplicacao, 
           af.nm_aplicacao_financeira, 
           b.nm_fantasia_banco, 
           taf.nm_tipo_aplicacao_finan, 
           af.vl_rendimento_aplicacao, 
           af.vl_aplicacao_financeira, 
           af.vl_atual_aplicacao,
           cast(0 as Float) as Periodo, -- Definir
           0 as Dias, -- Definir
           cast(0 as Float) as perc_Diaria,
           cast(0 as Float) as perc_mensal,
           cast(0 as Float) as perc_liq

FROM       Aplicacao_Financeira af left outer join
           Banco b ON af.cd_banco = b.cd_banco left outer join
           Tipo_Aplicacao_Financeira taf ON af.cd_tipo_aplicacao_finan = taf.cd_tipo_aplicacao_finan
where
           af.dt_aplicacao_financeira between @dt_inicial and @dt_final and
           IsNull(af.nm_aplicacao_financeira,'') like @nm_aplicacao_financeira + '%'

order by
  b.nm_fantasia_banco

end


