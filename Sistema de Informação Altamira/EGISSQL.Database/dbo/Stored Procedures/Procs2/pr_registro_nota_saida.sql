
CREATE PROCEDURE pr_registro_nota_saida
@ic_parametro int,
@dt_inicial datetime,
@dt_final   datetime,
@cd_nota_saida int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- consulta das Notas Fiscais do período
-------------------------------------------------------------------------------
  begin

    select
      nr.cd_nota_saida 		as 'Numero',
      ns.dt_nota_saida		as 'DtEmissao',
      opf.nm_operacao_fiscal    as 'CFOP',
      ns.nm_fantasia_nota_saida	as 'Cliente',
      ns.nm_razao_social_nota   as 'RazaoSocial',
      ns.sg_estado_nota_saida   as 'UF',
      nr.vl_contabil_nota_saida as 'VlrContabil',
      cast('NFF' as varchar(25))        	as 'Especie', -- Copiado da pr_livro_registro_saida
      cast((replace(c.cd_mascara_conta, '.', '')+'0') as varchar(20))  as 'CodContabil',
      nr.cd_conta   

    from
      Nota_Saida ns
    inner join Nota_Saida_Registro nr on
      ns.cd_nota_saida = nr.cd_nota_saida
    left outer join Plano_Conta c on
      nr.cd_conta = c.cd_conta and c.cd_empresa = dbo.fn_empresa()
    left outer join Operacao_Fiscal opf on
      opf.cd_operacao_fiscal=nr.cd_operacao_fiscal
    where
      (nr.cd_nota_saida = @cd_nota_saida) or 
      ((@cd_nota_saida = 0) and
       (ns.dt_nota_saida between @dt_inicial and @dt_final))

    group by
      nr.cd_nota_saida, 		
      ns.dt_nota_saida,
      opf.nm_operacao_fiscal,
      ns.nm_fantasia_nota_saida,
      ns.nm_razao_social_nota,
      ns.sg_estado_nota_saida,
      nr.vl_contabil_nota_saida,
      c.cd_mascara_conta,
      nr.cd_conta

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- consulta Operações da Nota de Saída p/ Número
-------------------------------------------------------------------------------
  begin

SELECT     nsr.cd_operacao_fiscal, 
	   nsr.vl_base_icms_nota_saida, 
	   nsr.vl_icms_nota_saida, 
           nsr.vl_icms_isento_nota_saida, 
	   nsr.vl_icms_outras_nota_saida, 
	   nsr.vl_icms_obs_nota_saida, 
	   nsr.vl_base_ipi_nota_saida, 
	   nsr.vl_ipi_nota_saida, 
           nsr.vl_ipi_isento_nota_saida, 
	   nsr.vl_ipi_obs_nota_saida, 
	   nsr.vl_ipi_outras_nota_saida, 
	   nsr.nm_obs_reg_nota_saida, 
           nsr.pc_aliq_icms_nota_saida, 
	   nsr.pc_aliq_ipi_nota_saida, 
	   nsr.cd_item_nota_saida_regist, 
	   nsr.cd_nota_saida,
	   nsr.vl_contabil_nota_saida,
	   nsr.cd_conta,
           /* ELIAS 26/06/2003 */
           nsr.ic_manual_nota_saida_reg,
           nsr.ic_fiscal_nota_saida_reg

FROM       Nota_Saida_Registro nsr 

where      nsr.cd_nota_saida = @cd_nota_saida

  end
else
  return

