
CREATE PROCEDURE pr_consulta_movto_centro_custo

-----------------------------------------------------------------------------------------
--GBS Global Business Solution                 2003
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.
--Banco de Dados: EGISSQL
--Objetivo: Consulta de Movimentação de Plano Financeiro por Centro de Custo.
--Data: 29/07/2003
--Atualizado: 29/10/2004 - Multiplicar por -1 quando for movimento de saída. 
--                       - Daniel C. Neto.
--          : 22.03.2006 - Revisão Geral da Procudure - Carlos Fernandes
-- 27.05.2009 - Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------------------------

@cd_centro_custo                int = 0,
@cd_tipo_operacao               int = 0,
@dt_inicial 			datetime,
@dt_final 			datetime

AS

SELECT     pf.nm_conta_plano_financeiro, 
           pfm.dt_movto_plano_financeiro, 
           ( case when tof.cd_tipo_operacao = 2 then
               pfm.vl_plano_financeiro
             else 
               pfm.vl_plano_financeiro * -1 end ) as vl_plano_financeiro, 
           hf.nm_historico_financeiro, 
           pfm.nm_historico_movimento, 
           m.nm_fantasia_moeda, 
           cc.nm_centro_custo, 
           tof.nm_tipo_operacao

FROM       Plano_Financeiro pf            with (nolock) 
           INNER JOIN
           Plano_Financeiro_Movimento pfm ON pf.cd_plano_financeiro      = pfm.cd_plano_financeiro left outer join
           Centro_Custo cc                ON pfm.cd_centro_custo         = cc.cd_centro_custo left outer join
           Tipo_Operacao_Financeira tof   ON pfm.cd_tipo_operacao        = tof.cd_tipo_operacao left outer join
           Historico_Financeiro hf        ON pfm.cd_historico_financeiro = hf.cd_historico_financeiro left outer join
           Moeda m                        ON pfm.cd_moeda                = m.cd_moeda

WHERE      ( pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final) and
           ( pfm.cd_centro_custo   = @cd_centro_custo or @cd_centro_custo = 0 ) and
           ( pfm.cd_tipo_operacao  = @cd_tipo_operacao or @cd_tipo_operacao = 0 )


