
CREATE PROCEDURE pr_cofig_mensal_folha
@ic_parametro int

AS


Select 
cd_config_mensal_folha,
dt_base_config_folha,
vl_minimo_real,
vl_minimo_base,
vl_educacao,
pc_reajuste_fgts,
pc_despesa_saude,
pc_adiantamento_salario,
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
vl_inss_autonomo

  from

  Config_mensal_folha



