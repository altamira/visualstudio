
CREATE PROCEDURE pr_nota_saida_irrf_sem_retencao
@ic_parametro 			int,
@dt_inicial 			datetime,
@dt_final 			datetime

AS

  select
--    ns.cd_nota_saida	  as 'NF',
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida                              
    end                   as 'NF',

    ns.dt_nota_saida	  as 'DtEmissao',
    vw.nm_fantasia	  as 'Cliente',
    ns.vl_total		  as 'VlTotal',
    ns.vl_servico	  as 'VlServico',
    ns.vl_irrf_nota_saida as 'IRRF'

  from
    Nota_Saida ns,
    vw_Destinatario vw

  where
    isnull(ns.vl_servico,0) <> 0 and
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.vl_irrf_nota_saida < (select vl_irrf_minimo from parametro_faturamento where cd_empresa = dbo.fn_empresa()) and
    vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
    vw.cd_destinatario = ns.cd_cliente

  order by
    vw.nm_fantasia

