

/****** Object:  Stored Procedure dbo.pr_gerar_nota_saida_registro    Script Date: 13/12/2002 15:08:32 ******/

CREATE PROCEDURE pr_gerar_nota_saida_registro
@ic_parametro int,
-- CÓDIGOS
@cd_nota_saida int,
@cd_item_nota_saida_regist int,
@cd_operacao_fiscal int,
@cd_conta int,
-- ICMS
@vl_base_icms_nota_saida float,
@pc_aliq_icms_nota_saida float,
@vl_icms_nota_saida float,
@vl_icms_isento_nota_saida float,
@vl_icms_outras_nota_saida float,
@vl_icms_obs_nota_saida	float,
-- ICMS SUBSTITUIÇÃO
@vl_base_icms_subs_n_saida float,
@vl_icms_subs_nota_saida float,
-- IPI
@vl_base_ipi_nota_saida	float,
@pc_aliq_ipi_nota_saida	float,
@vl_ipi_nota_saida float,
@vl_ipi_isento_nota_saida float,
@vl_ipi_outras_nota_saida float,
@vl_ipi_obs_nota_saida float,
-- ISS
@pc_aliq_iss_nota_saida	float,
@vl_iss_nota_saida float,
-- TOTAL DA NOTA
@vl_total_prod_nota_saida float,
@vl_frete_nota_saida float,
@vl_seguro_nota_saida float,
@vl_desp_acess_nota_saida float,
@vl_total_serv_nota_saida float,
@vl_total_nota_saida float,
-- VALOR CONTÁBIL
@vl_contabil_nota_saida	float,
-- OBSERVAÇÕES
@nm_obs_reg_nota_saida varchar,
@nm_obs_livro_saida varchar,
-- USUÁRIO
@cd_usuario int,
@dt_usuario datetime
as

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- gravação do registro fiscal da nota de saída
-------------------------------------------------------------------------------
  begin

    begin tran

    insert into Nota_Saida_Registro (
      cd_nota_saida,
      cd_item_nota_saida_regist,
      cd_operacao_fiscal,
      vl_total_nota_saida,
      vl_base_icms_nota_saida,
      vl_icms_nota_saida,
      vl_icms_isento_nota_saida,
      vl_icms_outras_nota_saida,
      vl_icms_obs_nota_saida,
      vl_base_ipi_nota_saida,
      vl_ipi_nota_saida,
      vl_ipi_isento_nota_saida,
      vl_ipi_outras_nota_saida,
      vl_ipi_obs_nota_saida,
      vl_frete_nota_saida,
      vl_seguro_nota_saida,
      vl_desp_acess_nota_saida,
      vl_total_prod_nota_saida,
      vl_base_icms_subs_n_saida,
      vl_icms_subs_nota_saida,
      vl_iss_nota_saida,
      vl_total_serv_nota_saida,
      nm_obs_reg_nota_saida,
      cd_conta,
      pc_aliq_ipi_nota_saida,
      vl_contabil_nota_saida,
      pc_aliq_icms_nota_saida,
      pc_aliq_iss_nota_saida,
      nm_obs_livro_saida,
      cd_usuario,
      dt_usuario )
    values (
      @cd_nota_saida,
      @cd_item_nota_saida_regist,
      @cd_operacao_fiscal,
      @vl_total_nota_saida,
      @vl_base_icms_nota_saida,
      @vl_icms_nota_saida,
      @vl_icms_isento_nota_saida,
      @vl_icms_outras_nota_saida,
      @vl_icms_obs_nota_saida,
      @vl_base_ipi_nota_saida,
      @vl_ipi_nota_saida,
      @vl_ipi_isento_nota_saida,
      @vl_ipi_outras_nota_saida,
      @vl_ipi_obs_nota_saida,
      @vl_frete_nota_saida,
      @vl_seguro_nota_saida,
      @vl_desp_acess_nota_saida,
      @vl_total_prod_nota_saida,
      @vl_base_icms_subs_n_saida,
      @vl_icms_subs_nota_saida,
      @vl_iss_nota_saida,
      @vl_total_serv_nota_saida,
      @nm_obs_reg_nota_saida,
      @cd_conta,
      @pc_aliq_ipi_nota_saida,
      @vl_contabil_nota_saida,
      @pc_aliq_icms_nota_saida,
      @pc_aliq_iss_nota_saida,
      @nm_obs_livro_saida,
      @cd_usuario,
      @dt_usuario )

    if @@error = 0 
      commit tran
    else
      rollback tran

  end
else
  return


 



