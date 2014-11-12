
CREATE PROCEDURE pr_reembolso_despesa
@ic_parametro int,
@dt_inicio_despesa datetime,
@dt_final_despesa datetime,
@cd_reembolso_despesa int

as
   if @ic_parametro = 1
   begin
      select     
         RD.cd_reembolso_despesa, 
         RD.dt_reembolso_despesa, 
         RD.cd_centro_custo, 
         RD.cd_departamento, 
         RD.dt_inicio_despesa, 
         RD.dt_final_despesa, 
         RD.cd_finalidade_despesa, 
         RD.cd_funcionario, 
         RD.cd_moeda, 
         RD.cd_vendedor, 
         RD.dt_base_moeda_reembolso,  
         RD.vl_total_reembolso, 
         RD.vl_adto_reembolso, 
         RD.vl_saldo_reembolso, 
         RD.dt_autorizacao_reembolso, 
         RD.cd_usu_auto_reembolso, 
         RD.nm_obs_reembolso_despesa, 
         RD.cd_usuario, 
         RD.dt_usuario, 
         RDI.cd_reembolso_despesa_item, 
         RDI.cd_tipo_despesa, 
         RDI.vl_reembolso_despesa_item, 
         RDI.nm_obs_item_despesa, 
         RDI.cd_usuario, 
         RDI.dt_usuario, 
         (select X.nm_departamento from departamento X where X.cd_departamento = RD.cd_departamento) as nm_departamento_02,
         (select X.nm_centro_custo from centro_custo X where X.cd_centro_custo = RD.cd_centro_custo) as nm_centro_custo_02,
         (select X.nm_finalidade_despesa from finalidade_despesa X where X.cd_finalidade_despesa = RD.cd_finalidade_despesa) as nm_finalidade_despesa_02,
         (select X.nm_funcionario from funcionario X where X.cd_funcionario = RD.cd_funcionario) as nm_funcionario_02,
         (select X.nm_vendedor from vendedor X where X.cd_vendedor = RD.cd_vendedor) as nm_vendedor_02,
         (select X.nm_moeda from moeda X where X.cd_moeda = RD.cd_moeda) as nm_moeda_02 
      from         
         Reembolso_Despesa RD 
      left join
         Reembolso_Despesa_Item RDI 
      on 
         RDI.cd_reembolso_despesa = RD.cd_reembolso_despesa
      where
         (RD.cd_reembolso_despesa = @cd_reembolso_despesa) or 
         (RD.dt_reembolso_despesa between @dt_inicio_despesa and @dt_final_despesa) 
   end         
