
CREATE PROCEDURE pr_consulta_nota_fiscal_natureza_operacao
  @ic_parametro         int        = 0,
  @cd_mascara_operacao  varchar(6) = '',
  @dt_inicial           datetime,
  @dt_final             datetime,
  @ic_cancelada         char(1) = 'N',
  @cd_operacao_fiscal   int     = 0

as

declare @cd_status_nota int
set @cd_status_nota = 7      --Nota Fiscal Cancelada

-----------------------------------------------------------------------------------------------------
if @ic_parametro = 1 or @ic_parametro = 3 --Selecionado 01 Operação fiscal pelo Código
-----------------------------------------------------------------------------------------------------
begin

  --Operação Fiscal 1

  SELECT
    isnull(ofi.cd_mascara_operacao,0000)      as 'cd_mascara_operacao',
--    ns.cd_nota_saida                          as cd_nota_saida, 

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
    end                                       as cd_nota_saida,

    max(ns.cd_num_formulario_nota)            as cd_num_formulario_nota,
    max(ofi.nm_operacao_fiscal)               as nm_operacao_fiscal,
    max(ofi.cd_operacao_fiscal)               as cd_operacao_fiscal,
    max(tp.nm_tipo_operacao_fiscal)           as nm_tipo_operacao_fiscal, 
    max(td.nm_tipo_destinatario)              as nm_tipo_destinatario,
    max(ns.nm_razao_social_nota)              as nm_fantasia_cliente, 
    max(ns.nm_fantasia_nota_saida)            as nm_fantasia_nota_saida,

    sum(case when isnull(nsri.vl_produto_item_nota,0)>0     then nsri.vl_produto_item_nota     else nsi.vl_total_item           end ) as  vl_total_prod_nota_saida,
    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota   
                                                            else nsi.vl_total_item     
                                                                 +case when isnull(nsi.vl_icms_subst_icms_item,0)>0 then 
                                                                     isnull(nsi.vl_icms_subst_icms_item,0) else 0.00 end  
                                                                 +isnull(nsi.vl_ipi,0)
                                                            end ) as  vl_total_nota_saida,  
    sum(case when isnull(nsri.vl_base_icms_item_nota,0)>0   then nsri.vl_base_icms_item_nota   else nsi.vl_base_icms_item       end ) as  vl_base_icms_nota_saida, 
    sum(case when isnull(nsri.pc_icms_item_nota_saida,0)>0  then nsri.pc_icms_item_nota_saida  else nsi.pc_icms                 end ) as  pc_aliq_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_item_nota_saida,0)>0  then nsri.vl_icms_item_nota_saida  else nsi.vl_icms_item            end ) as  vl_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_isento_item_nota,0)>0 then nsri.vl_icms_isento_item_nota else nsi.vl_icms_isento_item     end ) as  vl_icms_isento_nota_saida,
    sum(case when isnull(nsri.vl_icms_outras_item_nota,0)>0 then nsri.vl_icms_outras_item_nota else nsi.vl_icms_outros_item     end ) as  vl_icms_outras_nota_saida,
    sum(case when isnull(nsri.vl_icms_obs_item_nota,0)>0    then nsri.vl_icms_obs_item_nota    else nsi.vl_icms_obs_item        end ) as  vl_icms_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_ipi_item_nota,0)>0    then nsri.vl_base_ipi_item_nota    else nsi.vl_base_ipi_item        end ) as  vl_base_ipi_nota_saida,
    sum(case when isnull(nsri.pc_ipi_item_nota_saida,0)>0   then nsri.pc_ipi_item_nota_saida   else nsi.pc_ipi                  end ) as  pc_aliq_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_item_nota_saida,0)>0   then nsri.vl_ipi_item_nota_saida   else nsi.vl_ipi                  end ) as  vl_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_isento_item_nota,0)>0  then nsri.vl_ipi_isento_item_nota  else nsi.vl_ipi_isento_item      end ) as  vl_ipi_isento_nota_saida,
    sum(case when isnull(nsri.vl_ipi_outras_item_nota,0)>0  then nsri.vl_ipi_outras_item_nota  else nsi.vl_ipi_outros_item      end ) as  vl_ipi_outras_nota_saida,
    sum(case when isnull(nsri.vl_ipi_obs_item_nota,0)>0     then nsri.vl_ipi_obs_item_nota     else nsi.vl_ipi_obs_item         end ) as  vl_ipi_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_icms_subs_item,0)>0   then nsri.vl_base_icms_subs_item   else nsi.vl_bc_subst_icms_item   end ) as  vl_base_icms_subs_n_saida,
    sum(case when isnull(nsri.vl_icms_subs_item_nota,0)>0   then nsri.vl_icms_subs_item_nota   else nsi.vl_icms_subst_icms_item end ) as  vl_icms_subs_nota_saida,

    max(ns.dt_nota_saida)            as dt_nota_saida,
    max(sd.nm_status_nota)           as nm_status_nota,
    max(ns.dt_saida_nota_saida)      as dt_saida_nota_saida,
    max(cg.nm_cliente_grupo)         as nm_cliente_grupo,
    sum(nsi.vl_irrf_nota_saida)      as vl_irrf_nota_saida,
    sum(nsi.vl_iss_servico)          as vl_iss_servico,
    sum(nsi.vl_inss_nota_saida)      as vl_inss_nota_saida,
    sum(nsi.vl_pis)                  as vl_pis,
    sum(nsi.vl_cofins)               as vl_cofins,
    sum(nsi.vl_csll)                 as vl_csll,
    sum(nsi.vl_ii)                   as vl_ii,
    sum(nsi.vl_desp_aduaneira_item ) as vl_desp_aduaneira_item,
    sum(vl_seguro_item)              as vl_seguro_item,
    sum(vl_frete_item)               as vl_frete_item,
    sum(vl_desp_acess_item)          as vl_desp_acess_item,

    ( select top 1 
         cc.nm_centro_custo
      from Nota_Saida_Parcela nsp inner join
	   Centro_Custo cc on cc.cd_centro_custo = nsp.cd_centro_custo
      where nsp.cd_nota_saida = ns.cd_nota_saida and
            IsNull(cc.nm_centro_custo,'') <> '')  as nm_centro_custo,
    max(dp.nm_destinacao_produto)                 as nm_destinacao_produto

  into
     #Operacao1

  FROM
    Nota_Saida ns                                                                               inner join
    Operacao_Fiscal ofi           ON ofi.cd_operacao_fiscal       = ns.cd_operacao_fiscal       inner join
    Nota_Saida_item nsi           on ns.cd_nota_saida             = nsi.cd_nota_saida and          
                                     ns.cd_operacao_fiscal        = nsi.cd_operacao_fiscal      left outer join
    Cliente c                     ON ns.cd_cliente                = c.cd_cliente                LEFT OUTER JOIN
    Nota_Saida_Registro nsr       ON ns.cd_nota_saida             = nsr.cd_nota_saida and
                                     ns.cd_operacao_fiscal        = nsr.cd_operacao_fiscal      LEFT OUTER JOIN
    Nota_Saida_Item_Registro nsri on nsi.cd_nota_saida            = nsri.cd_nota_saida and
                                     nsi.cd_item_nota_saida       = nsri.cd_item_nota_saida     left outer join 
    Tipo_Destinatario td          on ns.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    Status_Nota sd                on sd.cd_status_nota            = ns.cd_status_nota           LEFT OUTER JOIN
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal LEFT OUTER JOIN
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  LEFT OUTER JOIN
    Cliente_Grupo cg              ON c.cd_cliente_grupo           = cg.cd_cliente_grupo        
    LEFT OUTER JOIN Destinacao_Produto dp         on dp.cd_destinacao_produto     = ns.cd_destinacao_produto

  WHERE
    ns.cd_operacao_fiscal   = case when @cd_operacao_fiscal = 0 then ns.cd_operacao_fiscal  else @cd_operacao_fiscal end and                         
    ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final and
    (isnull(ns.cd_status_nota,0) =  case when isnull(@ic_cancelada,'N')='S' then isnull(ns.cd_status_nota,0) end or 
     isnull(ns.cd_status_nota,0) <> case when isnull(@ic_cancelada,'N')='N' then @cd_status_nota end )
  group by
    ofi.cd_mascara_operacao,ns.cd_nota_saida, ns.cd_identificacao_nota_saida

  order by
    ofi.cd_mascara_operacao, ns.cd_nota_saida

  --Operação Fiscal 2

  SELECT
    isnull(ofi.cd_mascara_operacao,0000)      as 'cd_mascara_operacao',
--    ns.cd_nota_saida                          as cd_nota_saida, 
    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
    end                                       as cd_nota_saida,

    max(ns.cd_num_formulario_nota)            as cd_num_formulario_nota,
    max(ofi.nm_operacao_fiscal)               as nm_operacao_fiscal,
    max(ofi.cd_operacao_fiscal)               as cd_operacao_fiscal,
    max(tp.nm_tipo_operacao_fiscal)           as nm_tipo_operacao_fiscal, 
    max(td.nm_tipo_destinatario)              as nm_tipo_destinatario,
    max(ns.nm_razao_social_nota)              as nm_fantasia_cliente, 
    max(ns.nm_fantasia_nota_saida)            as nm_fantasia_nota_saida,
    sum(case when isnull(nsri.vl_produto_item_nota,0)>0     then nsri.vl_produto_item_nota     else nsi.vl_total_item           end ) as  vl_total_prod_nota_saida,
--    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota    else nsi.vl_total_item           end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota   
                                                            else nsi.vl_total_item     
                                                                 +case when isnull(nsi.vl_icms_subst_icms_item,0)>0 then 
                                                                     isnull(nsi.vl_icms_subst_icms_item,0) else 0.00 end  
                                                                 +isnull(nsi.vl_ipi,0)
                                                            end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_base_icms_item_nota,0)>0   then nsri.vl_base_icms_item_nota   else nsi.vl_base_icms_item       end ) as  vl_base_icms_nota_saida, 
    sum(case when isnull(nsri.pc_icms_item_nota_saida,0)>0  then nsri.pc_icms_item_nota_saida  else nsi.pc_icms                 end ) as  pc_aliq_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_item_nota_saida,0)>0  then nsri.vl_icms_item_nota_saida  else nsi.vl_icms_item            end ) as  vl_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_isento_item_nota,0)>0 then nsri.vl_icms_isento_item_nota else nsi.vl_icms_isento_item     end ) as  vl_icms_isento_nota_saida,
    sum(case when isnull(nsri.vl_icms_outras_item_nota,0)>0 then nsri.vl_icms_outras_item_nota else nsi.vl_icms_outros_item     end ) as  vl_icms_outras_nota_saida,
    sum(case when isnull(nsri.vl_icms_obs_item_nota,0)>0    then nsri.vl_icms_obs_item_nota    else nsi.vl_icms_obs_item        end ) as  vl_icms_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_ipi_item_nota,0)>0    then nsri.vl_base_ipi_item_nota    else nsi.vl_base_ipi_item        end ) as  vl_base_ipi_nota_saida,
    sum(case when isnull(nsri.pc_ipi_item_nota_saida,0)>0   then nsri.pc_ipi_item_nota_saida   else nsi.pc_ipi                  end ) as  pc_aliq_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_item_nota_saida,0)>0   then nsri.vl_ipi_item_nota_saida   else nsi.vl_ipi                  end ) as  vl_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_isento_item_nota,0)>0  then nsri.vl_ipi_isento_item_nota  else nsi.vl_ipi_isento_item      end ) as  vl_ipi_isento_nota_saida,
    sum(case when isnull(nsri.vl_ipi_outras_item_nota,0)>0  then nsri.vl_ipi_outras_item_nota  else nsi.vl_ipi_outros_item      end ) as  vl_ipi_outras_nota_saida,
    sum(case when isnull(nsri.vl_ipi_obs_item_nota,0)>0     then nsri.vl_ipi_obs_item_nota     else nsi.vl_ipi_obs_item         end ) as  vl_ipi_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_icms_subs_item,0)>0   then nsri.vl_base_icms_subs_item   else nsi.vl_bc_subst_icms_item   end ) as  vl_base_icms_subs_n_saida,
    sum(case when isnull(nsri.vl_icms_subs_item_nota,0)>0   then nsri.vl_icms_subs_item_nota   else nsi.vl_icms_subst_icms_item end ) as  vl_icms_subs_nota_saida,
    max(ns.dt_nota_saida)            as dt_nota_saida,
    max(sd.nm_status_nota)           as nm_status_nota,
    max(ns.dt_saida_nota_saida)      as dt_saida_nota_saida,
    max(cg.nm_cliente_grupo)         as nm_cliente_grupo,
    sum(nsi.vl_irrf_nota_saida)      as vl_irrf_nota_saida,
    sum(nsi.vl_iss_servico)          as vl_iss_servico,
    sum(nsi.vl_inss_nota_saida)      as vl_inss_nota_saida,
    sum(nsi.vl_pis)                  as vl_pis,
    sum(nsi.vl_cofins)               as vl_cofins,
    sum(nsi.vl_csll)                 as vl_csll,
    sum(nsi.vl_ii)                   as vl_ii,
    sum(nsi.vl_desp_aduaneira_item ) as vl_desp_aduaneira_item,
    sum(vl_seguro_item)              as vl_seguro_item,
    sum(vl_frete_item)               as vl_frete_item,
    sum(vl_desp_acess_item)          as vl_desp_acess_item,
    ( select top 1 
         cc.nm_centro_custo
      from Nota_Saida_Parcela nsp inner join
	   Centro_Custo cc on cc.cd_centro_custo = nsp.cd_centro_custo
      where nsp.cd_nota_saida = ns.cd_nota_saida and
            IsNull(cc.nm_centro_custo,'') <> '')  as nm_centro_custo,
    max(dp.nm_destinacao_produto)                 as nm_destinacao_produto


  into
     #Operacao2

  FROM
    Nota_Saida ns                 with (nolock)                                                  inner join         
    Operacao_Fiscal ofi           ON ofi.cd_operacao_fiscal       = ns.cd_operacao_fiscal2       inner join
    Nota_Saida_item nsi           on ns.cd_nota_saida             = nsi.cd_nota_saida and          
                                     ns.cd_operacao_fiscal2        = nsi.cd_operacao_fiscal      left outer join
    Cliente c                     ON ns.cd_cliente                = c.cd_cliente                LEFT OUTER JOIN
    Nota_Saida_Registro nsr       ON ns.cd_nota_saida             = nsr.cd_nota_saida and
                                     ns.cd_operacao_fiscal2        = nsr.cd_operacao_fiscal      LEFT OUTER JOIN
    Nota_Saida_Item_Registro nsri on nsi.cd_nota_saida            = nsri.cd_nota_saida and
                                     nsi.cd_item_nota_saida       = nsri.cd_item_nota_saida     left outer join 
    Tipo_Destinatario td          on ns.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    Status_Nota sd                on sd.cd_status_nota            = ns.cd_status_nota           LEFT OUTER JOIN
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal LEFT OUTER JOIN
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  LEFT OUTER JOIN
    Cliente_Grupo cg              ON c.cd_cliente_grupo           = cg.cd_cliente_grupo        
    LEFT OUTER JOIN Destinacao_Produto dp         on dp.cd_destinacao_produto     = ns.cd_destinacao_produto

  WHERE
    ns.cd_operacao_fiscal2   = case when @cd_operacao_fiscal = 0 then ns.cd_operacao_fiscal2            else @cd_operacao_fiscal end and                         
    ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final and
    (isnull(ns.cd_status_nota,0) =  case when isnull(@ic_cancelada,'N')='S' then isnull(ns.cd_status_nota,0) end or 
     isnull(ns.cd_status_nota,0) <> case when isnull(@ic_cancelada,'N')='N' then @cd_status_nota end )
  group by
    ofi.cd_mascara_operacao,ns.cd_nota_saida, ns.cd_identificacao_nota_saida


  order by
    ofi.cd_mascara_operacao, ns.cd_nota_saida

  --Operação Fiscal 3

  SELECT
    isnull(ofi.cd_mascara_operacao,0000)      as 'cd_mascara_operacao',
--    ns.cd_nota_saida                          as cd_nota_saida, 

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
    end                                       as cd_nota_saida,

    max(ns.cd_num_formulario_nota)            as cd_num_formulario_nota,
    max(ofi.nm_operacao_fiscal)               as nm_operacao_fiscal,
    max(ofi.cd_operacao_fiscal)               as cd_operacao_fiscal,
    max(tp.nm_tipo_operacao_fiscal)           as nm_tipo_operacao_fiscal, 
    max(td.nm_tipo_destinatario)              as nm_tipo_destinatario,
    max(ns.nm_razao_social_nota)              as nm_fantasia_cliente, 
    max(ns.nm_fantasia_nota_saida)            as nm_fantasia_nota_saida,
    sum(case when isnull(nsri.vl_produto_item_nota,0)>0     then nsri.vl_produto_item_nota     else nsi.vl_total_item           end ) as  vl_total_prod_nota_saida,

--    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota    else nsi.vl_total_item           end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota   
                                                            else nsi.vl_total_item     
                                                                 +case when isnull(nsi.vl_icms_subst_icms_item,0)>0 then 
                                                                     isnull(nsi.vl_icms_subst_icms_item,0) else 0.00 end  
                                                                 +isnull(nsi.vl_ipi,0)
                                                            end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_base_icms_item_nota,0)>0   then nsri.vl_base_icms_item_nota   else nsi.vl_base_icms_item       end ) as  vl_base_icms_nota_saida, 
    sum(case when isnull(nsri.pc_icms_item_nota_saida,0)>0  then nsri.pc_icms_item_nota_saida  else nsi.pc_icms                 end ) as  pc_aliq_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_item_nota_saida,0)>0  then nsri.vl_icms_item_nota_saida  else nsi.vl_icms_item            end ) as  vl_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_isento_item_nota,0)>0 then nsri.vl_icms_isento_item_nota else nsi.vl_icms_isento_item     end ) as  vl_icms_isento_nota_saida,
    sum(case when isnull(nsri.vl_icms_outras_item_nota,0)>0 then nsri.vl_icms_outras_item_nota else nsi.vl_icms_outros_item     end ) as  vl_icms_outras_nota_saida,
    sum(case when isnull(nsri.vl_icms_obs_item_nota,0)>0    then nsri.vl_icms_obs_item_nota    else nsi.vl_icms_obs_item        end ) as  vl_icms_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_ipi_item_nota,0)>0    then nsri.vl_base_ipi_item_nota    else nsi.vl_base_ipi_item        end ) as  vl_base_ipi_nota_saida,
    sum(case when isnull(nsri.pc_ipi_item_nota_saida,0)>0   then nsri.pc_ipi_item_nota_saida   else nsi.pc_ipi                  end ) as  pc_aliq_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_item_nota_saida,0)>0   then nsri.vl_ipi_item_nota_saida   else nsi.vl_ipi                  end ) as  vl_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_isento_item_nota,0)>0  then nsri.vl_ipi_isento_item_nota  else nsi.vl_ipi_isento_item      end ) as  vl_ipi_isento_nota_saida,
    sum(case when isnull(nsri.vl_ipi_outras_item_nota,0)>0  then nsri.vl_ipi_outras_item_nota  else nsi.vl_ipi_outros_item      end ) as  vl_ipi_outras_nota_saida,
    sum(case when isnull(nsri.vl_ipi_obs_item_nota,0)>0     then nsri.vl_ipi_obs_item_nota     else nsi.vl_ipi_obs_item         end ) as  vl_ipi_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_icms_subs_item,0)>0   then nsri.vl_base_icms_subs_item   else nsi.vl_bc_subst_icms_item   end ) as  vl_base_icms_subs_n_saida,
    sum(case when isnull(nsri.vl_icms_subs_item_nota,0)>0   then nsri.vl_icms_subs_item_nota   else nsi.vl_icms_subst_icms_item end ) as  vl_icms_subs_nota_saida,
    max(ns.dt_nota_saida)            as dt_nota_saida,
    max(sd.nm_status_nota)           as nm_status_nota,
    max(ns.dt_saida_nota_saida)      as dt_saida_nota_saida,
    max(cg.nm_cliente_grupo)         as nm_cliente_grupo,
    sum(nsi.vl_irrf_nota_saida)      as vl_irrf_nota_saida,
    sum(nsi.vl_iss_servico)          as vl_iss_servico,
    sum(nsi.vl_inss_nota_saida)      as vl_inss_nota_saida,
    sum(nsi.vl_pis)                  as vl_pis,
    sum(nsi.vl_cofins)               as vl_cofins,
    sum(nsi.vl_csll)                 as vl_csll,
    sum(nsi.vl_ii)                   as vl_ii,
    sum(nsi.vl_desp_aduaneira_item ) as vl_desp_aduaneira_item,
    sum(vl_seguro_item)              as vl_seguro_item,
    sum(vl_frete_item)               as vl_frete_item,
    sum(vl_desp_acess_item)          as vl_desp_acess_item,
    ( select top 1 
         cc.nm_centro_custo
      from Nota_Saida_Parcela nsp inner join
	   Centro_Custo cc on cc.cd_centro_custo = nsp.cd_centro_custo
      where nsp.cd_nota_saida = ns.cd_nota_saida and
            IsNull(cc.nm_centro_custo,'') <> '')  as nm_centro_custo,
    max(dp.nm_destinacao_produto)                 as nm_destinacao_produto

  into
     #Operacao3

  FROM
    Nota_Saida ns                                                                                inner join
    Operacao_Fiscal ofi           ON ofi.cd_operacao_fiscal       = ns.cd_operacao_fiscal3       inner join
    Nota_Saida_item nsi           on ns.cd_nota_saida             = nsi.cd_nota_saida and          
                                     ns.cd_operacao_fiscal3        = nsi.cd_operacao_fiscal     left outer join
    Cliente c                     ON ns.cd_cliente                = c.cd_cliente                LEFT OUTER JOIN
    Nota_Saida_Registro nsr       ON ns.cd_nota_saida             = nsr.cd_nota_saida and
                                     ns.cd_operacao_fiscal3        = nsr.cd_operacao_fiscal      LEFT OUTER JOIN
    Nota_Saida_Item_Registro nsri on nsi.cd_nota_saida            = nsri.cd_nota_saida and
                                     nsi.cd_item_nota_saida       = nsri.cd_item_nota_saida     left outer join 
    Tipo_Destinatario td          on ns.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    Status_Nota sd                on sd.cd_status_nota            = ns.cd_status_nota           LEFT OUTER JOIN
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal LEFT OUTER JOIN
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  LEFT OUTER JOIN
    Cliente_Grupo cg              ON c.cd_cliente_grupo           = cg.cd_cliente_grupo        
    LEFT OUTER JOIN Destinacao_Produto dp         on dp.cd_destinacao_produto     = ns.cd_destinacao_produto

  WHERE
    ns.cd_operacao_fiscal3   = case when @cd_operacao_fiscal = 0 then ns.cd_operacao_fiscal3            else @cd_operacao_fiscal end and                         
    ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final and
    (isnull(ns.cd_status_nota,0) =  case when isnull(@ic_cancelada,'N')='S' then isnull(ns.cd_status_nota,0) end or 
     isnull(ns.cd_status_nota,0) <> case when isnull(@ic_cancelada,'N')='N' then @cd_status_nota end )
  group by
    ofi.cd_mascara_operacao,ns.cd_nota_saida, ns.cd_identificacao_nota_saida


  order by
    ofi.cd_mascara_operacao, ns.cd_nota_saida


  --Operação Fiscal de Notas de Entrada

  select 
    isnull(ofi.cd_mascara_operacao,0000) as 'cd_mascara_operacao',        
    ne.cd_nota_entrada                   as cd_nota_saida,
    0                                    as cd_formulario_nota_entrada,
    ofi.nm_operacao_fiscal               as nm_operacao_fiscal,
    ofi.cd_operacao_fiscal               as cd_operacao_fiscal,
    tp.nm_tipo_operacao_fiscal           as nm_tipo_operacao_fiscal, 
    td.nm_tipo_destinatario              as nm_tipo_destinatario,
    vw.nm_razao_social                   as nm_fantasia_cliente,
    vw.nm_fantasia                       as nm_fantasia_nota_saida,
    ine.vl_total_nota_entr_item          as vl_total_prod_nota_saida,
    ine.vl_total_nota_entr_item          as vl_total_nota_saida,  
    ine.vl_bicms_nota_entrada            as vl_base_icms_nota_saida, 
    ine.pc_icms_nota_entrada             as pc_aliq_icms_nota_saida,
    ine.vl_icms_nota_entrada             as vl_icms_nota_saida,
    ine.vl_icmsisen_nota_entrada         as vl_icms_isento_nota_saida,
    ine.vl_icmout_nota_entrada           as vl_icms_outras_nota_saida,
    ine.vl_icmobs_nota_entrada           as vl_icms_obs_nota_saida,
    ine.vl_bipi_nota_entrada             as vl_base_ipi_nota_saida,
    ine.pc_ipi_nota_entrada              as pc_aliq_ipi_nota_saida,
    ine.vl_ipi_nota_entrada              as vl_ipi_nota_saida,
    ine.vl_ipiisen_nota_entrada          as vl_ipi_isento_nota_saida,
    ine.vl_ipiout_nota_entrada           as vl_ipi_outras_nota_saida, 
    ine.vl_ipiobs_nota_entrada           as vl_ipi_obs_nota_saida, 
    0.00                                 as vl_base_icms_subs_n_saida, 
    0.00                                 as vl_icms_subs_nota_saida,        
    ne.dt_nota_entrada                   as dt_nota_saida,
    cast('' as varchar(30))              as nm_status_nota,
    ne.dt_receb_nota_entrada             as dt_saida_nota_saida,            
    cg.nm_cliente_grupo,
    ine.vl_irrf_servico                  as vl_irrf_nota_saida,
    ine.vl_iss_servico                   as vl_iss_servico,
    0.00                                 as vl_inss_nota_saida,
    ine.vl_cofins_item_nota              as vl_pis,
    ine.vl_pis_item_nota                 as vl_cofins,
    0.00                                 as vl_csll,
    0.00                                 as vl_ii,
    0.00                                 as vl_desp_aduaneira_item,
    0.00                                 as vl_seguro_item,
    0.00                                 as vl_frete_item,
    0.00                                 as vl_desp_acess_item,
    ' '                                  as nm_centro_custo,
    dp.nm_destinacao_produto             as nm_destinacao_produto

  into
     #Operacao4

  FROM

--select * from nota_entrada_item

    Nota_Entrada ne                                                                             inner join
    Operacao_Fiscal ofi           on ofi.cd_operacao_fiscal       = ne.cd_operacao_fiscal       inner join 
    vw_destinatario vw            on vw.cd_tipo_destinatario      = ne.cd_tipo_destinatario and
                                     vw.cd_destinatario           = ne.cd_fornecedor            inner join
    Nota_Entrada_Item ine         on ine.cd_fornecedor            = ne.cd_fornecedor   and
                                     ine.cd_nota_entrada          = ne.cd_nota_entrada and
                                     ine.cd_operacao_fiscal       = ne.cd_operacao_fiscal       left outer join
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal left outer join
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  left outer join
    Tipo_Destinatario td          on ne.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    cliente cl                    ON vw.cd_destinatario = cl.cd_cliente                         left outer join
    cliente_grupo cg              ON cl.cd_cliente_grupo = cg.cd_cliente_grupo                  left outer join
    Destinacao_Produto dp         on dp.cd_destinacao_produto = ne.cd_destinacao_produto

  WHERE
    ne.dt_receb_nota_entrada BETWEEN @dt_inicial AND @dt_final AND 
    ofi.cd_operacao_fiscal = case when @cd_operacao_fiscal = 0 then ofi.cd_operacao_fiscal else @cd_operacao_fiscal end 


  --Mostra as Tabelas de Operação Fiscal

  select
    *
  from 
    #Operacao1

  union all

  select
    *
  from 
    #Operacao2

  union all

  select
    *
  from 
    #Operacao3

  union all

  select
    *
  from 
    #Operacao4

  order by
    cd_mascara_operacao, cd_nota_saida
   

end

else

-----------------------------------------------------------------------------------------------------
if @ic_parametro = 2 --Selecionado todas as Operações Fiscais com a Mesma Máscara
-----------------------------------------------------------------------------------------------------
 begin

  --Operação Fiscal 1

  SELECT
    isnull(ofi.cd_mascara_operacao,'0000')             as 'cd_mascara_operacao',
--    ns.cd_nota_saida                                   as cd_nota_saida, 

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
    end                                       as cd_nota_saida,

    max(ns.cd_num_formulario_nota)                     as cd_num_formulario_nota,
    cast(max(ofi.nm_operacao_fiscal)    as varchar)    as nm_operacao_fiscal,
    max(ofi.cd_operacao_fiscal)                        as cd_operacao_fiscal,
    cast(max(tp.nm_tipo_operacao_fiscal) as varchar)   as nm_tipo_operacao_fiscal, 
    cast(max(td.nm_tipo_destinatario)    as varchar)   as nm_tipo_destinatario,
    cast(max(ns.nm_razao_social_nota)    as varchar)   as nm_fantasia_cliente, 
    cast(max(ns.nm_fantasia_nota_saida)  as varchar)   as nm_fantasia_nota_saida,
    sum(case when isnull(nsri.vl_produto_item_nota,0)>0     then nsri.vl_produto_item_nota     else nsi.vl_total_item           end ) as  vl_total_prod_nota_saida,
--    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota    else nsi.vl_total_item           end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota   
                                                            else nsi.vl_total_item     
                                                                 +case when isnull(nsi.vl_icms_subst_icms_item,0)>0 then 
                                                                     isnull(nsi.vl_icms_subst_icms_item,0) else 0.00 end  
                                                                 +isnull(nsi.vl_ipi,0)
                                                            end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_base_icms_item_nota,0)>0   then nsri.vl_base_icms_item_nota   else nsi.vl_base_icms_item       end ) as  vl_base_icms_nota_saida, 
    sum(case when isnull(nsri.pc_icms_item_nota_saida,0)>0  then nsri.pc_icms_item_nota_saida  else nsi.pc_icms                 end ) as  pc_aliq_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_item_nota_saida,0)>0  then nsri.vl_icms_item_nota_saida  else nsi.vl_icms_item            end ) as  vl_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_isento_item_nota,0)>0 then nsri.vl_icms_isento_item_nota else nsi.vl_icms_isento_item     end ) as  vl_icms_isento_nota_saida,
    sum(case when isnull(nsri.vl_icms_outras_item_nota,0)>0 then nsri.vl_icms_outras_item_nota else nsi.vl_icms_outros_item     end ) as  vl_icms_outras_nota_saida,
    sum(case when isnull(nsri.vl_icms_obs_item_nota,0)>0    then nsri.vl_icms_obs_item_nota    else nsi.vl_icms_obs_item        end ) as  vl_icms_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_ipi_item_nota,0)>0    then nsri.vl_base_ipi_item_nota    else nsi.vl_base_ipi_item        end ) as  vl_base_ipi_nota_saida,
    sum(case when isnull(nsri.pc_ipi_item_nota_saida,0)>0   then nsri.pc_ipi_item_nota_saida   else nsi.pc_ipi                  end ) as  pc_aliq_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_item_nota_saida,0)>0   then nsri.vl_ipi_item_nota_saida   else nsi.vl_ipi                  end ) as  vl_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_isento_item_nota,0)>0  then nsri.vl_ipi_isento_item_nota  else nsi.vl_ipi_isento_item      end ) as  vl_ipi_isento_nota_saida,
    sum(case when isnull(nsri.vl_ipi_outras_item_nota,0)>0  then nsri.vl_ipi_outras_item_nota  else nsi.vl_ipi_outros_item      end ) as  vl_ipi_outras_nota_saida,
    sum(case when isnull(nsri.vl_ipi_obs_item_nota,0)>0     then nsri.vl_ipi_obs_item_nota     else nsi.vl_ipi_obs_item         end ) as  vl_ipi_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_icms_subs_item,0)>0   then nsri.vl_base_icms_subs_item   else nsi.vl_bc_subst_icms_item   end ) as  vl_base_icms_subs_n_saida,
    sum(case when isnull(nsri.vl_icms_subs_item_nota,0)>0   then nsri.vl_icms_subs_item_nota   else nsi.vl_icms_subst_icms_item end ) as  vl_icms_subs_nota_saida,
    max(ns.dt_nota_saida)                              as dt_nota_saida,
    cast(max(sd.nm_status_nota) as varchar)          as nm_status_nota,
    max(ns.dt_saida_nota_saida)                        as dt_saida_nota_saida,
    cast(max(cg.nm_cliente_grupo) as varchar)         as nm_cliente_grupo,
    sum(nsi.vl_irrf_nota_saida)      as vl_irrf_nota_saida,
    sum(nsi.vl_iss_servico)          as vl_iss_servico,
    sum(nsi.vl_inss_nota_saida)      as vl_inss_nota_saida,
    sum(nsi.vl_pis)                  as vl_pis,
    sum(nsi.vl_cofins)               as vl_cofins,
    sum(nsi.vl_csll)                 as vl_csll,
    sum(nsi.vl_ii)                   as vl_ii,
    sum(nsi.vl_desp_aduaneira_item ) as vl_desp_aduaneira_item,
    sum(vl_seguro_item)              as vl_seguro_item,
    sum(vl_frete_item)               as vl_frete_item,
    sum(vl_desp_acess_item)          as vl_desp_acess_item,
    ( select top 1 
         cc.nm_centro_custo
      from Nota_Saida_Parcela nsp inner join
	   Centro_Custo cc on cc.cd_centro_custo = nsp.cd_centro_custo
      where nsp.cd_nota_saida = ns.cd_nota_saida and
            IsNull(cc.nm_centro_custo,'') <> '')  as nm_centro_custo,
    max(dp.nm_destinacao_produto)                 as nm_destinacao_produto

  into
     #OperacaoM1

  FROM
    Nota_Saida ns                                                                               inner join
    Operacao_Fiscal ofi           ON ofi.cd_mascara_operacao      = ns.cd_mascara_operacao      inner join
    Nota_Saida_item nsi           on ns.cd_nota_saida             = nsi.cd_nota_saida and          
                                     ofi.cd_operacao_fiscal       = nsi.cd_operacao_fiscal      left outer join
    Cliente c                     ON ns.cd_cliente                = c.cd_cliente                LEFT OUTER JOIN
    Nota_Saida_Registro nsr       ON ns.cd_nota_saida             = nsr.cd_nota_saida and
                                     ofi.cd_operacao_fiscal       = nsr.cd_operacao_fiscal      LEFT OUTER JOIN
    Nota_Saida_Item_Registro nsri on nsi.cd_nota_saida            = nsri.cd_nota_saida and
                                     nsi.cd_item_nota_saida       = nsri.cd_item_nota_saida     left outer join 
    Tipo_Destinatario td          on ns.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    Status_Nota sd                on sd.cd_status_nota            = ns.cd_status_nota           LEFT OUTER JOIN
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal LEFT OUTER JOIN
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  LEFT OUTER JOIN
    Cliente_Grupo cg              ON c.cd_cliente_grupo           = cg.cd_cliente_grupo        
    LEFT OUTER JOIN Destinacao_Produto dp         on dp.cd_destinacao_produto     = ns.cd_destinacao_produto

  WHERE
    ns.cd_mascara_operacao   = case when @cd_mascara_operacao = '' then ns.cd_mascara_operacao else @cd_mascara_operacao end and                         
    ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final and
    (isnull(ns.cd_status_nota,0) =  case when isnull(@ic_cancelada,'N')='S' then isnull(ns.cd_status_nota,0) end or 
     isnull(ns.cd_status_nota,0) <> case when isnull(@ic_cancelada,'N')='N' then @cd_status_nota end )
  group by
    ofi.cd_mascara_operacao,ns.cd_nota_saida, ns.cd_identificacao_nota_saida
  order by
    ofi.cd_mascara_operacao, ns.cd_nota_saida


  --Operação Fiscal 2

  SELECT
    isnull(ofi.cd_mascara_operacao,'0000')             as 'cd_mascara_operacao',
--    ns.cd_nota_saida                                   as cd_nota_saida, 

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
    end                                       as cd_nota_saida,

    max(ns.cd_num_formulario_nota)                     as cd_num_formulario_nota,
    cast(max(ofi.nm_operacao_fiscal)    as varchar)    as nm_operacao_fiscal,
    max(ofi.cd_operacao_fiscal)                        as cd_operacao_fiscal,
    cast(max(tp.nm_tipo_operacao_fiscal) as varchar)   as nm_tipo_operacao_fiscal, 
    cast(max(td.nm_tipo_destinatario)  as varchar)     as nm_tipo_destinatario,
    cast(max(ns.nm_razao_social_nota)  as varchar)     as nm_fantasia_cliente, 
    cast(max(ns.nm_fantasia_nota_saida) as varchar)    as nm_fantasia_nota_saida,
    sum(case when isnull(nsri.vl_produto_item_nota,0)>0     then nsri.vl_produto_item_nota     else nsi.vl_total_item           end ) as  vl_total_prod_nota_saida,
--    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota    else nsi.vl_total_item           end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota   
                                                            else nsi.vl_total_item     
                                                                 +case when isnull(nsi.vl_icms_subst_icms_item,0)>0 then 
                                                                     isnull(nsi.vl_icms_subst_icms_item,0) else 0.00 end  
                                                                 +isnull(nsi.vl_ipi,0)
                                                            end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_base_icms_item_nota,0)>0   then nsri.vl_base_icms_item_nota   else nsi.vl_base_icms_item       end ) as  vl_base_icms_nota_saida, 
    sum(case when isnull(nsri.pc_icms_item_nota_saida,0)>0  then nsri.pc_icms_item_nota_saida  else nsi.pc_icms                 end ) as  pc_aliq_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_item_nota_saida,0)>0  then nsri.vl_icms_item_nota_saida  else nsi.vl_icms_item            end ) as  vl_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_isento_item_nota,0)>0 then nsri.vl_icms_isento_item_nota else nsi.vl_icms_isento_item     end ) as  vl_icms_isento_nota_saida,
    sum(case when isnull(nsri.vl_icms_outras_item_nota,0)>0 then nsri.vl_icms_outras_item_nota else nsi.vl_icms_outros_item     end ) as  vl_icms_outras_nota_saida,
    sum(case when isnull(nsri.vl_icms_obs_item_nota,0)>0    then nsri.vl_icms_obs_item_nota    else nsi.vl_icms_obs_item        end ) as  vl_icms_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_ipi_item_nota,0)>0    then nsri.vl_base_ipi_item_nota    else nsi.vl_base_ipi_item        end ) as  vl_base_ipi_nota_saida,
    sum(case when isnull(nsri.pc_ipi_item_nota_saida,0)>0   then nsri.pc_ipi_item_nota_saida   else nsi.pc_ipi                  end ) as  pc_aliq_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_item_nota_saida,0)>0   then nsri.vl_ipi_item_nota_saida   else nsi.vl_ipi                  end ) as  vl_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_isento_item_nota,0)>0  then nsri.vl_ipi_isento_item_nota  else nsi.vl_ipi_isento_item      end ) as  vl_ipi_isento_nota_saida,
    sum(case when isnull(nsri.vl_ipi_outras_item_nota,0)>0  then nsri.vl_ipi_outras_item_nota  else nsi.vl_ipi_outros_item      end ) as  vl_ipi_outras_nota_saida,
    sum(case when isnull(nsri.vl_ipi_obs_item_nota,0)>0     then nsri.vl_ipi_obs_item_nota     else nsi.vl_ipi_obs_item         end ) as  vl_ipi_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_icms_subs_item,0)>0   then nsri.vl_base_icms_subs_item   else nsi.vl_bc_subst_icms_item   end ) as  vl_base_icms_subs_n_saida,
    sum(case when isnull(nsri.vl_icms_subs_item_nota,0)>0   then nsri.vl_icms_subs_item_nota   else nsi.vl_icms_subst_icms_item end ) as  vl_icms_subs_nota_saida,
    max(ns.dt_nota_saida)                              as dt_nota_saida,
    cast(max(sd.nm_status_nota) as varchar)          as nm_status_nota,
    max(ns.dt_saida_nota_saida)                        as dt_saida_nota_saida,
    cast(max(cg.nm_cliente_grupo) as varchar)         as nm_cliente_grupo,
    sum(nsi.vl_irrf_nota_saida)      as vl_irrf_nota_saida,
    sum(nsi.vl_iss_servico)          as vl_iss_servico,
    sum(nsi.vl_inss_nota_saida)      as vl_inss_nota_saida,
    sum(nsi.vl_pis)                  as vl_pis,
    sum(nsi.vl_cofins)               as vl_cofins,
    sum(nsi.vl_csll)                 as vl_csll,
    sum(nsi.vl_ii)                   as vl_ii,
    sum(nsi.vl_desp_aduaneira_item ) as vl_desp_aduaneira_item,
    sum(vl_seguro_item)              as vl_seguro_item,
    sum(vl_frete_item)               as vl_frete_item,
    sum(vl_desp_acess_item)          as vl_desp_acess_item,
    ( select top 1 
         cc.nm_centro_custo
      from Nota_Saida_Parcela nsp inner join
	   Centro_Custo cc on cc.cd_centro_custo = nsp.cd_centro_custo
      where nsp.cd_nota_saida = ns.cd_nota_saida and
            IsNull(cc.nm_centro_custo,'') <> '')  as nm_centro_custo,
    max(dp.nm_destinacao_produto)                 as nm_destinacao_produto

  into
     #OperacaoM2

  FROM
    Nota_Saida ns                                                                               inner join
    Operacao_Fiscal ofi           ON ofi.cd_mascara_operacao      = ns.cd_mascara_operacao2      inner join
    Nota_Saida_item nsi           on ns.cd_nota_saida             = nsi.cd_nota_saida and          
                                     ofi.cd_operacao_fiscal       = nsi.cd_operacao_fiscal      left outer join
    Cliente c                     ON ns.cd_cliente                = c.cd_cliente                LEFT OUTER JOIN
    Nota_Saida_Registro nsr       ON ns.cd_nota_saida             = nsr.cd_nota_saida and
                                     ofi.cd_operacao_fiscal       = nsr.cd_operacao_fiscal      LEFT OUTER JOIN
    Nota_Saida_Item_Registro nsri on nsi.cd_nota_saida            = nsri.cd_nota_saida and
                                     nsi.cd_item_nota_saida       = nsri.cd_item_nota_saida     left outer join 
    Tipo_Destinatario td          on ns.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    Status_Nota sd                on sd.cd_status_nota            = ns.cd_status_nota           LEFT OUTER JOIN
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal LEFT OUTER JOIN
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  LEFT OUTER JOIN
    Cliente_Grupo cg              ON c.cd_cliente_grupo           = cg.cd_cliente_grupo        
    LEFT OUTER JOIN Destinacao_Produto dp         on dp.cd_destinacao_produto     = ns.cd_destinacao_produto

  WHERE
    ns.cd_mascara_operacao2   = case when @cd_mascara_operacao = '' then ns.cd_mascara_operacao2 else @cd_mascara_operacao end and                         
    ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final and
    (isnull(ns.cd_status_nota,0) =  case when isnull(@ic_cancelada,'N')='S' then isnull(ns.cd_status_nota,0) end or 
     isnull(ns.cd_status_nota,0) <> case when isnull(@ic_cancelada,'N')='N' then @cd_status_nota end )
  group by
    ofi.cd_mascara_operacao,ns.cd_nota_saida, ns.cd_identificacao_nota_saida
  order by
    ofi.cd_mascara_operacao, ns.cd_nota_saida

  --Operação Fiscal 3

  SELECT
    isnull(ofi.cd_mascara_operacao,'0000')             as 'cd_mascara_operacao',
--    ns.cd_nota_saida                                   as cd_nota_saida, 

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
    end                                       as cd_nota_saida,

    max(ns.cd_num_formulario_nota)                     as cd_num_formulario_nota,
    cast(max(ofi.nm_operacao_fiscal)    as varchar)    as nm_operacao_fiscal,
    max(ofi.cd_operacao_fiscal)                        as cd_operacao_fiscal,
    cast(max(tp.nm_tipo_operacao_fiscal) as varchar)   as nm_tipo_operacao_fiscal, 
    cast(max(td.nm_tipo_destinatario)  as varchar)     as nm_tipo_destinatario,
    cast(max(ns.nm_razao_social_nota)  as varchar)     as nm_fantasia_cliente, 
    cast(max(ns.nm_fantasia_nota_saida) as varchar)    as nm_fantasia_nota_saida,
    sum(case when isnull(nsri.vl_produto_item_nota,0)>0     then nsri.vl_produto_item_nota     else nsi.vl_total_item           end ) as  vl_total_prod_nota_saida,
--    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota    else nsi.vl_total_item           end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_contabil_item_nota,0)>0    then nsri.vl_contabil_item_nota   
                                                            else nsi.vl_total_item     
                                                                 +case when isnull(nsi.vl_icms_subst_icms_item,0)>0 then 
                                                                     isnull(nsi.vl_icms_subst_icms_item,0) else 0.00 end  
                                                                 +isnull(nsi.vl_ipi,0)
                                                            end ) as  vl_total_nota_saida,  

    sum(case when isnull(nsri.vl_base_icms_item_nota,0)>0   then nsri.vl_base_icms_item_nota   else nsi.vl_base_icms_item       end ) as  vl_base_icms_nota_saida, 
    sum(case when isnull(nsri.pc_icms_item_nota_saida,0)>0  then nsri.pc_icms_item_nota_saida  else nsi.pc_icms                 end ) as  pc_aliq_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_item_nota_saida,0)>0  then nsri.vl_icms_item_nota_saida  else nsi.vl_icms_item            end ) as  vl_icms_nota_saida,
    sum(case when isnull(nsri.vl_icms_isento_item_nota,0)>0 then nsri.vl_icms_isento_item_nota else nsi.vl_icms_isento_item     end ) as  vl_icms_isento_nota_saida,
    sum(case when isnull(nsri.vl_icms_outras_item_nota,0)>0 then nsri.vl_icms_outras_item_nota else nsi.vl_icms_outros_item     end ) as  vl_icms_outras_nota_saida,
    sum(case when isnull(nsri.vl_icms_obs_item_nota,0)>0    then nsri.vl_icms_obs_item_nota    else nsi.vl_icms_obs_item        end ) as  vl_icms_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_ipi_item_nota,0)>0    then nsri.vl_base_ipi_item_nota    else nsi.vl_base_ipi_item        end ) as  vl_base_ipi_nota_saida,
    sum(case when isnull(nsri.pc_ipi_item_nota_saida,0)>0   then nsri.pc_ipi_item_nota_saida   else nsi.pc_ipi                  end ) as  pc_aliq_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_item_nota_saida,0)>0   then nsri.vl_ipi_item_nota_saida   else nsi.vl_ipi                  end ) as  vl_ipi_nota_saida,
    sum(case when isnull(nsri.vl_ipi_isento_item_nota,0)>0  then nsri.vl_ipi_isento_item_nota  else nsi.vl_ipi_isento_item      end ) as  vl_ipi_isento_nota_saida,
    sum(case when isnull(nsri.vl_ipi_outras_item_nota,0)>0  then nsri.vl_ipi_outras_item_nota  else nsi.vl_ipi_outros_item      end ) as  vl_ipi_outras_nota_saida,
    sum(case when isnull(nsri.vl_ipi_obs_item_nota,0)>0     then nsri.vl_ipi_obs_item_nota     else nsi.vl_ipi_obs_item         end ) as  vl_ipi_obs_nota_saida,
    sum(case when isnull(nsri.vl_base_icms_subs_item,0)>0   then nsri.vl_base_icms_subs_item   else nsi.vl_bc_subst_icms_item   end ) as  vl_base_icms_subs_n_saida,
    sum(case when isnull(nsri.vl_icms_subs_item_nota,0)>0   then nsri.vl_icms_subs_item_nota   else nsi.vl_icms_subst_icms_item end ) as  vl_icms_subs_nota_saida,
    max(ns.dt_nota_saida)                              as dt_nota_saida,
    cast(max(sd.nm_status_nota) as varchar)          as nm_status_nota,
    max(ns.dt_saida_nota_saida)                        as dt_saida_nota_saida,
    cast(max(cg.nm_cliente_grupo) as varchar)         as nm_cliente_grupo,
    sum(nsi.vl_irrf_nota_saida)      as vl_irrf_nota_saida,
    sum(nsi.vl_iss_servico)          as vl_iss_servico,
    sum(nsi.vl_inss_nota_saida)      as vl_inss_nota_saida,
    sum(nsi.vl_pis)                  as vl_pis,
    sum(nsi.vl_cofins)               as vl_cofins,
    sum(nsi.vl_csll)                 as vl_csll,
    sum(nsi.vl_ii)                   as vl_ii,
    sum(nsi.vl_desp_aduaneira_item ) as vl_desp_aduaneira_item,
    sum(vl_seguro_item)              as vl_seguro_item,
    sum(vl_frete_item)               as vl_frete_item,
    sum(vl_desp_acess_item)          as vl_desp_acess_item,
    ( select top 1 
         cc.nm_centro_custo
      from Nota_Saida_Parcela nsp inner join
	   Centro_Custo cc on cc.cd_centro_custo = nsp.cd_centro_custo
      where nsp.cd_nota_saida = ns.cd_nota_saida and
            IsNull(cc.nm_centro_custo,'') <> '')  as nm_centro_custo,
    max(dp.nm_destinacao_produto)                 as nm_destinacao_produto

  into
     #OperacaoM3

  FROM
    Nota_Saida ns                                                                               inner join
    Operacao_Fiscal ofi           ON ofi.cd_mascara_operacao      = ns.cd_mascara_operacao3     inner join
    Nota_Saida_item nsi           on ns.cd_nota_saida             = nsi.cd_nota_saida and          
                                     ofi.cd_operacao_fiscal       = nsi.cd_operacao_fiscal      left outer join
    Cliente c                     ON ns.cd_cliente                = c.cd_cliente                LEFT OUTER JOIN
    Nota_Saida_Registro nsr       ON ns.cd_nota_saida             = nsr.cd_nota_saida and
                                     ofi.cd_operacao_fiscal       = nsr.cd_operacao_fiscal      LEFT OUTER JOIN
    Nota_Saida_Item_Registro nsri on nsi.cd_nota_saida            = nsri.cd_nota_saida and
                                     nsi.cd_item_nota_saida       = nsri.cd_item_nota_saida     left outer join 
    Tipo_Destinatario td          on ns.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    Status_Nota sd                on sd.cd_status_nota            = ns.cd_status_nota           LEFT OUTER JOIN
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal LEFT OUTER JOIN
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  LEFT OUTER JOIN
    Cliente_Grupo cg              ON c.cd_cliente_grupo           = cg.cd_cliente_grupo        
    LEFT OUTER JOIN Destinacao_Produto dp         on dp.cd_destinacao_produto     = ns.cd_destinacao_produto

  WHERE
    ns.cd_mascara_operacao3   = case when @cd_mascara_operacao = '' then ns.cd_mascara_operacao3 else @cd_mascara_operacao end and                         
    ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final and
    (isnull(ns.cd_status_nota,0) =  case when isnull(@ic_cancelada,'N')='S' then isnull(ns.cd_status_nota,0) end or 
     isnull(ns.cd_status_nota,0) <> case when isnull(@ic_cancelada,'N')='N' then @cd_status_nota end )
  group by
    ofi.cd_mascara_operacao,ns.cd_nota_saida, ns.cd_identificacao_nota_saida
  order by
    ofi.cd_mascara_operacao, ns.cd_nota_saida

  --Operação Fiscal de Notas de Entrada

  select 
    isnull(ofi.cd_mascara_operacao,'0000')  as 'cd_mascara_operacao',        
    ne.cd_nota_entrada                      as cd_nota_saida,
    max(cast(0 as int) )                    as cd_formulario_nota_entrada,
    max(ofi.nm_operacao_fiscal)                  as nm_operacao_fiscal,
    max(ofi.cd_operacao_fiscal)                  as cd_operacao_fiscal,
    max(tp.nm_tipo_operacao_fiscal)              as nm_tipo_operacao_fiscal, 
    max(td.nm_tipo_destinatario)                 as nm_tipo_destinatario,
    max(vw.nm_razao_social)                      as nm_fantasia_cliente,
    max(vw.nm_fantasia)                          as nm_fantasia_nota_saida,
    sum(ine.vl_total_nota_entr_item)             as vl_total_prod_nota_saida,
    sum(ine.vl_total_nota_entr_item)             as vl_total_nota_saida,  
    sum(ine.vl_bicms_nota_entrada)               as vl_base_icms_nota_saida, 
    sum(ine.pc_icms_nota_entrada)                as pc_aliq_icms_nota_saida,
    sum(ine.vl_icms_nota_entrada)                as vl_icms_nota_saida,
    sum(ine.vl_icmsisen_nota_entrada)            as vl_icms_isento_nota_saida,
    sum(ine.vl_icmout_nota_entrada)              as vl_icms_outras_nota_saida,
    sum(ine.vl_icmobs_nota_entrada)              as vl_icms_obs_nota_saida,
    sum(ine.vl_bipi_nota_entrada)                as vl_base_ipi_nota_saida,
    sum(ine.pc_ipi_nota_entrada)                 as pc_aliq_ipi_nota_saida,
    sum(ine.vl_ipi_nota_entrada)                 as vl_ipi_nota_saida,
    sum(ine.vl_ipiisen_nota_entrada)             as vl_ipi_isento_nota_saida,
    sum(ine.vl_ipiout_nota_entrada)              as vl_ipi_outras_nota_saida, 
    sum(ine.vl_ipiobs_nota_entrada)              as vl_ipi_obs_nota_saida, 
    sum(0.00)                                    as vl_base_icms_subs_n_saida, 
    sum(0.00)                                    as vl_icms_subs_nota_saida,        
    max(ne.dt_nota_entrada)                      as dt_nota_saida,
    max(cast('' as varchar(30)))                 as nm_status_nota,
    max(ne.dt_receb_nota_entrada)                as dt_saida_nota_saida,            
    max(cg.nm_cliente_grupo)                     as nm_cliente_grupo,
    sum(ine.vl_irrf_servico)                     as vl_irrf_nota_saida,
    sum(ine.vl_iss_servico)                      as vl_iss_servico,
    sum(0.00)                                    as vl_inss_nota_saida,
    sum(ine.vl_cofins_item_nota)                 as vl_pis,
    sum(ine.vl_pis_item_nota)                    as vl_cofins,
    sum(0.00)                                    as vl_csll,
    sum(0.00)                                    as vl_ii,
    sum(0.00)                                    as vl_desp_aduaneira_item,
    sum(0.00)                                    as vl_seguro_item,
    sum(0.00)                                    as vl_frete_item,
    sum(0.00)                                    as vl_desp_acess_item,
    ' '                                          as nm_centro_custo,
    max(dp.nm_destinacao_produto)                as nm_destinacao_produto

  into
     #OperacaoM4

  FROM

    Nota_Entrada ne                                                                             inner join
    Operacao_Fiscal ofi           on ofi.cd_mascara_operacao      = @cd_mascara_operacao        inner join 
    vw_destinatario vw            on vw.cd_tipo_destinatario      = ne.cd_tipo_destinatario and
                                     vw.cd_destinatario           = ne.cd_fornecedor            inner join
    Nota_Entrada_Item ine         on ine.cd_fornecedor            = ne.cd_fornecedor   and
                                     ine.cd_nota_entrada          = ne.cd_nota_entrada and
                                     ine.cd_operacao_fiscal       = ofi.cd_operacao_fiscal      left outer join
    Grupo_Operacao_Fiscal tg      ON ofi.cd_grupo_operacao_fiscal = tg.cd_grupo_operacao_fiscal left outer join
    Tipo_Operacao_Fiscal tp       ON tg.cd_tipo_operacao_fiscal   = tp.cd_tipo_operacao_fiscal  left outer join
    Tipo_Destinatario td          on ne.cd_tipo_destinatario      = td.cd_tipo_destinatario     left outer join
    cliente cl                    ON vw.cd_destinatario = cl.cd_cliente                         left outer join
    cliente_grupo cg              ON cl.cd_cliente_grupo = cg.cd_cliente_grupo                  left outer join
    destinacao_produto dp         on dp.cd_destinacao_produto = ne.cd_destinacao_produto

  WHERE
    ne.dt_receb_nota_entrada BETWEEN @dt_inicial AND @dt_final AND 
    ne.cd_operacao_fiscal   = ofi.cd_operacao_fiscal and
    ofi.cd_mascara_operacao = case when @cd_mascara_operacao = '' then ofi.cd_mascara_operacao else @cd_mascara_operacao end 
  group by
    ofi.cd_mascara_operacao,ne.cd_nota_entrada

 -- select * from #OperacaoM4

  --Mostra as Tabelas de Operação Fiscal

  select
    *
  from 
    #OperacaoM1

  union all

  select
    *
  from 
    #OperacaoM2

  union all

  select
    *
  from 
    #OperacaoM3

  union all

  select
    *
  from 
    #OperacaoM4

  order by
    cd_mascara_operacao, cd_nota_saida

end

