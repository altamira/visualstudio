

CREATE  PROCEDURE pr_consulta_aliquota_ICMS
@dt_inicial           datetime,
@dt_final             datetime

as

  select
    n.pc_aliq_icms_nota_saida         as 'AliqICMS',
    sum(n.vl_base_icms_nota_saida)    as 'BaseICMS',
    sum(n.vl_icms_nota_saida)         as 'ICMS',
    sum(n.vl_icms_isento_nota_saida)  as 'ICMSIsentas',
    sum(n.vl_icms_outras_nota_saida)  as 'ICMSOutras'
  from
    Nota_Saida_Registro n inner join
    Nota_Saida ns on n.cd_nota_saida = ns.cd_nota_saida

  where
    ( ns.dt_nota_saida between @dt_inicial and @dt_final ) 
  group by
    n.pc_aliq_icms_nota_saida
  order by n.pc_aliq_icms_nota_saida




