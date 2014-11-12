
create procedure pr_consulta_nota_saida_ativo_fixo

@dt_inicial  datetime,--varchar(12)
@dt_final    datetime--varchar(12)  

as

 select
   tof.nm_tipo_operacao_fiscal    as 'TipoOperacao',
   opf.nm_operacao_fiscal         as 'OperacaoFisca',
   ns.cd_mascara_operacao         as 'CFOP',
   ns.cd_nota_saida               as 'NotaSaida',
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
   ns.cd_operacao_fiscal        = opf.cd_operacao_fiscal          and
   ns.cd_tipo_destinatario      = td.cd_tipo_destinatario         and
   opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal    and
   gof.cd_tipo_operacao_fiscal  = tof.cd_tipo_operacao_fiscal     and
   isnull(opf.ic_ativo_operacao_fiscal,'N')='S'                  

order by 
  1,2
