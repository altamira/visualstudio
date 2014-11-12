
create procedure pr_apuracao_ciap

@cd_tipo_operacao int,        --2 : Saída
@dt_inicial       datetime,
@dt_final         datetime

as

 select
   gof.nm_grupo_operacao_fiscal       as 'Grupo',
   opf.cd_mascara_operacao            as 'Codificacao',
   opf.nm_operacao_fiscal             as 'Natureza',
--   ns.cd_nota_saida                   as 'NotaSaida',
   case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
     ns.cd_identificacao_nota_saida
   else
     ns.cd_nota_saida                  
  end                                   as 'NotaSaida',

   ns.dt_nota_saida                   as 'DataNota',
   nsr.vl_contabil_nota_saida         as 'ValorContabil',
   nsr.vl_icms_nota_saida             as 'ImpostoICMS',
   nsr.vl_ipi_nota_saida              as 'ImpostoIPI'

 from
   Operacao_Fiscal       opf, 
   Grupo_Operacao_Fiscal gof, 
   Tipo_Operacao_Fiscal  tof,
   Nota_Saida_Registro   nsr,
   Nota_Saida ns
 where
   opf.cd_grupo_operacao_fiscal           =  gof.cd_grupo_operacao_fiscal and
   gof.cd_tipo_operacao_fiscal            =  tof.cd_tipo_operacao_fiscal  and
   tof.cd_tipo_operacao_fiscal            =  @cd_tipo_operacao            and
   isnull(opf.ic_iss_operacao_fiscal,'N') = 'N'                           and
   opf.cd_operacao_fiscal                 = nsr.cd_operacao_fiscal        and
   nsr.cd_nota_saida                      = ns.cd_nota_saida              and
   ns.dt_nota_saida between @dt_inicial and @dt_final                     and
   isnull(opf.ic_ciap_operacao_fiscal,'N')='S'                            and
   isnull(opf.ic_credito_icms_operacao,'N')='S'
order by
  gof.nm_grupo_operacao_fiscal, 
  opf.cd_mascara_operacao

