
create procedure pr_consulta_nota_ativo_fixo

@dt_inicial  datetime,
@dt_final    datetime  

as

 select
   tof.nm_tipo_operacao_fiscal    as 'TipoOperacao',
   opf.nm_operacao_fiscal         as 'OperacaoFisca',
   ns.cd_mascara_operacao         as 'CFOP',
--   ns.cd_nota_saida               as 'NotaSaida',
   case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
       ns.cd_identificacao_nota_saida
     else
       ns.cd_nota_saida
   end                            as 'NotaSaida',

   ns.dt_nota_saida               as 'Emissao',
   td.nm_tipo_destinatario        as 'Destinatario',
   ns.nm_fantasia_destinatario    as 'Fantasia',
   ns.vl_total                    as 'ValorTotal'
 from
   Nota_Saida ns, 
   Tipo_Destinatario td,
   Operacao_Fiscal opf,
   Grupo_Operacao_Fiscal gof,
   Tipo_Operacao_Fiscal tof
 where
   ns.dt_nota_saida between @dt_inicial and @dt_final             and
   ns.dt_cancel_nota_saida is null                                and
   td.cd_tipo_destinatario      = ns.cd_tipo_destinatario         and
   ns.cd_operacao_fiscal        = opf.cd_operacao_fiscal          and
   opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal    and
   gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal     and
   isnull(opf.ic_ativo_operacao_fiscal,'N')='S'                  
union all
 select
   tof.nm_tipo_operacao_fiscal    as 'TipoOperacao',
   opf.nm_operacao_fiscal         as 'OperacaoFisca',
   opf.cd_mascara_operacao        as 'CFOP',
   ne.cd_nota_entrada             as 'NotaSaida',
   ne.dt_nota_entrada             as 'Emissao',
   td.nm_tipo_destinatario        as 'Destinatario',
   ne.nm_fantasia_destinatario    as 'Fantasia',
   ne.vl_total_nota_entrada       as 'ValorTotal'
 from
   Nota_Entrada ne, 
   Tipo_Destinatario td,
   Operacao_Fiscal opf,
   Grupo_Operacao_Fiscal gof,
   Tipo_Operacao_Fiscal tof
 where
   ne.dt_nota_entrada between @dt_inicial and @dt_final           and
   td.cd_tipo_destinatario      = ne.cd_tipo_destinatario         and
   ne.cd_operacao_fiscal        = opf.cd_operacao_fiscal          and
   opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal    and
   gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal     and
   isnull(opf.ic_ativo_operacao_fiscal,'N')='S'                  
order by 
  1,2

