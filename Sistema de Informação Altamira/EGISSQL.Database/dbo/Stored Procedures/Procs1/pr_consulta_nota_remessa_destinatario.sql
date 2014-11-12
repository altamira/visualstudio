
CREATE PROCEDURE pr_consulta_nota_remessa_destinatario

@cd_destinatario int,
@cd_tipo_deestinatario int,
@dt_inicial datetime,
@dt_final datetime

AS

select     
  ns.cd_operacao_fiscal,
  ns.cd_mascara_operacao,
  ns.nm_operacao_fiscal,
--  ns.cd_nota_saida, 

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida
  end                            as cd_nota_saida,

  ns.dt_nota_saida,
  isnull(ns.vl_total,0) as 'vl_total', 
  ns.dt_saida_nota_saida,
  ns.nm_fantasia_nota_saida,
  nv.dt_vencimento_nota,
  nv.dt_baixa_nota,
  nvb.cd_nota_entrada,
  nvb.dt_nota_entrada,
  isnull(nvb.vl_nota_entrada,0) as 'vl_nota_entrada',
  isnull(nv.vl_saldo_nota,0) as 'vl_saldo_nota'
from
  Nota_Saida ns                     with (nolock) 
left outer join Nota_Vencimento nv  on 
  nv.cd_nota_fiscal = ns.cd_nota_saida
left outer join Nota_Vencimento_Baixa nvb on
  nvb.cd_nota_fiscal = ns.cd_nota_saida
left outer join Status_Nota sn  on 
  ns.cd_status_nota = sn.cd_status_nota
where      
  ns.cd_cliente = @cd_destinatario AND
  ns.cd_tipo_destinatario = @cd_tipo_deestinatario AND
  ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final AND
  IsNull(ns.cd_status_nota,6) IN (1,2,5)

