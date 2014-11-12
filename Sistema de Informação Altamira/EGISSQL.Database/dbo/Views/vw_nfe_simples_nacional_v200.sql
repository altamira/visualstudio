
------------------------------------------------------------------------------------ 
--sp_helptext vw_nfe_simples_nacional_v200
 ------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                        2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Simples Nacional
--                        
--
--Data                  : 27.09.2010 
--Atualização           : 
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes

------------------------------------------------------------------------------------

CREATE VIEW vw_nfe_simples_nacional_v200
as

--select * from nota_saida_item
-- select
--    pfi.*,
--    i.*
--    
-- from
--   Parametro_Faturamento_Imposto pfi
--   left outer join Imposto_Simples i with (nolock) on i.cd_imposto_simples = pfi.cd_imposto_simples
-- where
--   pfi.cd_empresa = dbo.fn_empresa()



select
  ns.cd_identificacao_nota_saida,
  ns.cd_nota_saida,  
  nsi.cd_item_nota_saida,
  ns.dt_nota_saida,
  rtrim(ltrim(cast(isnull(pp.cd_digito_procedencia,0) as varchar(1))))                                as 'orig',
  cast(so.cd_identificacao_situacao as varchar(03))                                                   as 'CSOSN',
  isnull(i.pc_icms,0)                                                                                 as 'pCredSN',
  isnull(ns.vl_total,0) * isnull(i.pc_icms,0)                                                         as 'vCredICMSSN',
  so.cd_situacao_operacao,

  --201 --> Substituição Tributária---------------------------------------------------------------------

  case when ti.cd_digito_tributacao_icms = '10' then           
     ltrim(rtrim(cast(isnull(mct.cd_digito_modalidade_st,0) as varchar(10))))                                         
  else          
     cast('0' as varchar(10))          
  end                                                                                               as 'modBCST',          
          
  case when ti.cd_digito_tributacao_icms = '10' then           
    case when isnull(cfe.pc_icms_strib_clas_fiscal,0)>0 then
        dbo.fn_mascara_valor_duas_casas(cfe.pc_icms_strib_clas_fiscal)           
    else
        case when nsi.pc_subs_trib_item > 0 then           
           dbo.fn_mascara_valor_duas_casas(nsi.pc_subs_trib_item)               
        else
           dbo.fn_mascara_valor_duas_casas(0.00)           
        end
 
    end

  else          
    dbo.fn_mascara_valor_duas_casas(0.00)           
  end                                                                                               as 'pMVAST',          
          
  case when ti.cd_digito_tributacao_icms = '10' and cfe.pc_red_icms_clas_fiscal > 0 then           
    dbo.fn_mascara_valor_duas_casas(cfe.pc_red_icms_clas_fiscal)           
  else          
    dbo.fn_mascara_valor_duas_casas(0.00)           
  end                                                                                               as 'pRedBCST',          
          
  case when ti.cd_digito_tributacao_icms = '10' then           
--    dbo.fn_mascara_valor_duas_casas(nsi.vl_bc_subst_icms_item)               
    dbo.fn_mascara_valor_duas_casas(case when isnull(opf.ic_subst_tributaria,'N')='S' and  
                                    nsi.vl_bc_subst_icms_item>0 
                                    then vl_bc_subst_icms_item
                                    else 0.00 end)

  else          
    dbo.fn_mascara_valor_duas_casas(0.00)           
  end                                                                                               as 'vBCST',          
          
  --% ICMS Interna
  case when isnull(cfe.pc_interna_icms_clas_fis,0)<>0 then
     dbo.fn_mascara_valor_duas_casas(isnull(cfe.pc_interna_icms_clas_fis,0))                                            
  else        
     dbo.fn_mascara_valor_duas_casas(isnull(nsi.pc_icms,0))                                             
  end                                                                                                  as 'pICMSST',

  case when ti.cd_digito_tributacao_icms = '10' then           
--    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_subst_icms_item)          
    dbo.fn_mascara_valor_duas_casas(case when isnull(opf.ic_subst_tributaria,'N')='S' and  
                                    nsi.vl_bc_subst_icms_item>0 
                                    then nsi.vl_icms_subst_icms_item
                                    else 0.00 end)

  else          
    dbo.fn_mascara_valor_duas_casas(0.00)           
  end                                                                                               as 'vICMSST',

  case when ti.cd_digito_tributacao_icms = '20' then           
    rtrim(ltrim(cast(ti.cd_digito_tributacao_icms as varchar(2))))                                            
  else          
    cast('20' as varchar(2))          
  end                                                                                               as 'CST20',          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    rtrim(ltrim(cast(isnull(mci.cd_digito_modalidade,0)  as varchar(1))))                                            
  else          
    cast('0' as varchar(1))          
  end                                                                                               as 'modBC20',          
          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_reducao_icms)                  
  else          
    dbo.fn_mascara_valor_duas_casas(0.00)                  
  end                                                                                               as 'pREDBC20',          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_base_icms_item)                 
  else          
    dbo.fn_mascara_valor_duas_casas(0.00)                  
  end           as 'vBC20',          
          
  case when ti.cd_digito_tributacao_icms = '20' then           
    dbo.fn_mascara_valor_duas_casas(nsi.pc_icms)                        
  else          
    dbo.fn_mascara_valor_duas_casas(0.00)                        
  end                                                                                               as 'pICMS20',          
            
  case when ti.cd_digito_tributacao_icms = '20' then           
    dbo.fn_mascara_valor_duas_casas(nsi.vl_icms_item)          
  else          
    dbo.fn_mascara_valor_duas_casas(0.00)          
  end                                                                                               as 'vICMS20'


--select vl_total,* from nota_saida

--   modBC,
--   pRedBC,
--   vBC,
--   pICMS,
--   vICMS,
--   modBCST,
--   pMVAST,
--   pRedBCST,
--   vBCST,
--   pICMSST,
--   vICMSST,
--   pCredSN,
--   vCredICMSSN


from
  nota_saida ns                                     with (nolock) 
  inner join nota_saida_item nsi                    with (nolock) on nsi.cd_nota_saida             = ns.cd_nota_saida
  left outer join vw_destinatario vw                with (nolock) on vw.cd_destinatario            = ns.cd_cliente and
                                                                     vw.cd_tipo_destinatario       = ns.cd_tipo_destinatario
  left outer join produto                       p   with (nolock) on p.cd_produto                  = nsi.cd_produto
  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto                 = nsi.cd_produto
  left outer join procedencia_produto pp            with (nolock) on pp.cd_procedencia_produto     = pf.cd_procedencia_produto
  left outer join tributacao t                      with (nolock) on t.cd_tributacao               = nsi.cd_tributacao
  left outer join tributacao_icms ti                with (nolock) on ti.cd_tributacao_icms         = t.cd_tributacao_icms
  left outer join egisadmin.dbo.empresa         e   with (nolock) on e.cd_empresa                  = dbo.fn_empresa()
  left outer join Parametro_Faturamento_Imposto pfi with (nolock) on pfi.cd_empresa                = e.cd_empresa
  left outer join Imposto_Simples i                 with (nolock) on i.cd_imposto_simples          = pfi.cd_imposto_simples
  left outer join Situacao_Operacao_Simples so      with (nolock) on so.cd_situacao_operacao       = pfi.cd_situacao_operacao
  left outer join operacao_fiscal opf               with (nolock) on opf.cd_operacao_fiscal        = nsi.cd_operacao_fiscal
  left outer join modalidade_calculo_icms mci       with (nolock) on mci.cd_modalidade_icms        = t.cd_modalidade_icms
  left outer join modalidade_calculo_icms_sTrib mct with (nolock) on mct.cd_modalidade_icms_st     = t.cd_modalidade_icms_st
  left outer join classificacao_fiscal_estado cfe   with (nolock) on cfe.cd_classificacao_fiscal   = nsi.cd_classificacao_fiscal and
                                                                     cfe.cd_estado                 = vw.cd_estado


