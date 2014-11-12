
CREATE PROCEDURE pr_orcamento_financeiro


@dt_base datetime,
@cd_plano_financeiro int

AS

declare @vl_total as Float

select     
  pfo.cd_plano_financeiro, 
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  pf.cd_grupo_financeiro, 
  pf.cd_plano_financeiro_pai, 
  pfo.dt_inicio_p_financeiro,
  pfo.dt_final_p_financeiro,
  pfo.cd_usuario,
  pfo.dt_usuario,
  --Calculando valor previsto para recebimento no período
  case 
  when gf.cd_tipo_operacao = 2 then 
  (select 
     sum(vl_documento_receber) 
   from 
     documento_receber
   where
     cd_plano_financeiro = pf.cd_plano_financeiro and
     dt_vencimento_documento between pfo.dt_inicio_p_financeiro and pfo.dt_final_p_financeiro and
     dt_cancelamento_documento is null ) --and 
     --IsNull(pf.ic_conta_analitica,'N') = 'S') 
  when gf.cd_tipo_operacao = 1 then 
  (select
     sum(vl_documento_pagar)
   from
     documento_pagar
   where
     cd_plano_financeiro = pf.cd_plano_financeiro and
     dt_vencimento_documento between pfo.dt_inicio_p_financeiro and pfo.dt_final_p_financeiro and
     dt_cancelamento_documento is null ) --and 
--     IsNull(pf.ic_conta_analitica,'N') = 'S') 
  end as vl_previsto_p_financeiro,

  --Calculando valor realizado no período

  case 
  when gf.cd_tipo_operacao = 2 then 
  (select 
     sum(drp.vl_pagamento_documento) 
   from 
     documento_receber_pagamento drp inner join
     documento_receber dr on drp.cd_documento_receber = dr.cd_documento_receber
   where
     dr.cd_plano_financeiro = pf.cd_plano_financeiro and
     drp.dt_pagamento_documento between pfo.dt_inicio_p_financeiro and pfo.dt_final_p_financeiro and
     dr.dt_cancelamento_documento is null ) -- and 
--     IsNull(pf.ic_conta_analitica,'N') = 'S') 
  when gf.cd_tipo_operacao = 1 then 
  (select 
     sum(dpp.vl_pagamento_documento) 
   from 
     documento_pagar_pagamento dpp inner join
     documento_pagar dp on dpp.cd_documento_pagar = dp.cd_documento_pagar
   where
     dp.cd_plano_financeiro = pf.cd_plano_financeiro and
     dpp.dt_pagamento_documento between pfo.dt_inicio_p_financeiro and pfo.dt_final_p_financeiro and
     dp.dt_cancelamento_documento is null ) --and 
--     IsNull(pf.ic_conta_analitica,'N') = 'S') 
  end as vl_realizado_p_financeiro,
  pf.ic_conta_analitica

into #Orcamento


from         
  Plano_Financeiro_Orcamento pfo inner join
  plano_financeiro pf on pf.cd_plano_financeiro = pfo.cd_plano_financeiro left outer join
  grupo_financeiro gf on pf.cd_grupo_financeiro = gf.cd_grupo_financeiro
where
  (pfo.cd_plano_financeiro = @cd_plano_financeiro) or
  ( pfo.dt_inicio_p_financeiro <= @dt_base AND
    pfo.dt_final_p_financeiro  >= @dt_base and
    @cd_plano_financeiro = 0 ) 
order by 
  pf.cd_mascara_plano_financeiro

 
SET @vl_total = (Select SUM(vl_realizado_p_financeiro) FROM #Orcamento)

SELECT *,
       (vl_previsto_p_financeiro - vl_realizado_p_financeiro ) as 'Diferenca',
       (vl_realizado_p_financeiro / @vl_total) * 100 as 'Perc'
FROM
  #Orcamento

