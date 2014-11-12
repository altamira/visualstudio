
CREATE PROCEDURE pr_config_mensal_folha


AS


Select 
  cd_config_mensal_folha,
  dt_inicio_vigencia,
  dt_final_vigencia,
  dt_base_config_folha,
  vl_minimo_real,
  vl_minimo_base,
  vl_educacao,
  vl_arredondamento_base,
  pc_reajuste_fgts,
  pc_despesa_saude,
  pc_adiantamento_salario,
  pc_vale_transporte,
  vl_teto_maternidade,
  vl_familia_teto,
  vl_familia_acima_teto,
  cd_usuario,
  dt_usuario,
  vl_minimo_trib_ir,
  vl_minimo_ir,
  vl_ir_dependente,
  vl_ir_funcionario_65,  
  vl_inss_prolabore,
  vl_inss_autonomo,
  pc_fgts,
  pc_noturno,
  pc_insalubridade,
  pc_periculosidade,
  pc_inss_prolabore,
  pc_inss_autonomo,
  pc_convenio_medico,
  vl_refeicao_mensal,
  pc_refeicao_funcionario,
  qt_hora_folha_periodo


  from

  Config_mensal_folha cfm with (nolock)

order by
  dt_final_vigencia desc

 
--select * from config_mensal_folha


