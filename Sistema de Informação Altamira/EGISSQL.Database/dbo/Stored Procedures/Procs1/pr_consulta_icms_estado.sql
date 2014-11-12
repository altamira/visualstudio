

CREATE PROCEDURE pr_consulta_icms_estado
@dt_inicial           datetime,
@dt_final             datetime

as

  select
    ns.sg_estado_nota_saida           							    																	as 'UF',  
    case when o.ic_contribicms_op_fiscal = 'S' then sum(n.vl_contabil_nota_saida)   	end as 'ValorContabil',
    case when o.ic_contribicms_op_fiscal = 'S' then sum(n.vl_base_icms_nota_saida)   	end as 'BaseICMS',
    case when o.ic_contribicms_op_fiscal = 'S' then sum(n.vl_icms_nota_saida)					end as 'ICMS',
    case when o.ic_contribicms_op_fiscal = 'S' then sum(n.vl_icms_isento_nota_saida)  end as 'ICMSIsentas',
    case when o.ic_contribicms_op_fiscal = 'S' then sum(n.vl_icms_outras_nota_saida)  end as 'ICMSOutras',
    case when o.ic_contribicms_op_fiscal = 'S' then sum(n.vl_icms_obs_nota_saida)     end as 'ICMSObservacao',
    case when o.ic_contribicms_op_fiscal = 'N' then sum(n.vl_base_icms_nota_saida)   	end as 'BaseICMSNaoContrib',
    case when o.ic_contribicms_op_fiscal = 'N' then sum(n.vl_icms_nota_saida)					end as 'ICMSNaoContrib',
    case when o.ic_contribicms_op_fiscal = 'N' then sum(n.vl_icms_isento_nota_saida)  end as 'ICMSIsentasNaoContib',
    case when o.ic_contribicms_op_fiscal = 'N' then sum(n.vl_icms_outras_nota_saida)  end as 'ICMSOutrasNaoContrib',
    case when o.ic_contribicms_op_fiscal = 'N' then sum(n.vl_icms_obs_nota_saida)     end as 'ICMSObservacaoNaoContrib'
  from
    Nota_Saida_Registro n 
  inner join
    Nota_Saida ns 
  on 
    ns.cd_nota_saida = n.cd_nota_saida
  left outer join
    Operacao_Fiscal o
  on
    o.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where
    ( ns.dt_nota_saida between @dt_inicial and @dt_final ) and
    isnull(ns.cd_status_nota,0) <> 7
  group by
    ns.sg_estado_nota_saida,
    o.ic_contribicms_op_fiscal
  order by 
    ns.sg_estado_nota_saida 





