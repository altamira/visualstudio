
create procedure pr_apuracao_pis 

@cd_tipo_operacao int,        --2 : Saída
@dt_inicial       datetime,
@dt_final         datetime

as

 select
   max(gof.nm_grupo_operacao_fiscal)  as 'Grupo',
   opf.cd_mascara_operacao            as 'Codificacao',
   max(opf.nm_operacao_fiscal)        as 'Natureza',
   sum(nsr.vl_contabil_nota_saida)    as 'ValorContabil',
   sum(nsr.vl_icms_nota_saida)        as 'ImpostoICMS',
   sum(nsr.vl_ipi_nota_saida)         as 'ImpostoIPI'

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
   ns.dt_nota_saida between @dt_inicial and @dt_final                     --and
   --isnull(opf.ic_pis.operacao_fiscal,'N')='S'  
group by
  opf.cd_mascara_operacao,
	gof.nm_grupo_operacao_fiscal
order by
  gof.nm_grupo_operacao_fiscal, 
	opf.cd_mascara_operacao

--sp_help nota_saida
--sp_help nota_saida_registro
--sp_help operacao_fiscal
--sp_help grupo_operacao_fiscal
--sp_help tipo_operacao_fiscal

--select cd_grupo_operacao_fiscal from operacao_fiscal

--sp_help nota_saida
--sp_help nota_saida_registro
--sp_help operacao_fiscal
--sp_help grupo_operacao_fiscal
--sp_help tipo_operacao_fiscal

--select cd_grupo_operacao_fiscal from operacao_fiscal
