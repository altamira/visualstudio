
CREATE VIEW vw_nfe_icms_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_icms_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Local da Retirada da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 04.04.2009 - Ajuste da Tributação - Carlos
------------------------------------------------------------------------------------
as


select
  ns.dt_nota_saida,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.cd_produto,
  nsi.nm_fantasia_produto,

  --'N'                                                            as 'icms',

  --Tag de Acordo com a Tributação do Produto
  isnull(ti.sg_tab_nfe_tributacao,'N06')                         as 'icms',

  'N02'                                                          as 'ICMS00',

  rtrim(ltrim(cast(pp.cd_digito_procedencia as varchar(1))))     as 'orig',
  rtrim(ltrim(cast(ti.cd_digito_tributacao_icms as varchar(2)))) as 'CST',
  rtrim(ltrim(cast(mci.cd_digito_modalidade  as varchar(1))))    as 'modBC',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsi.vl_base_icms_item,6,2)),103),'')           as 'vBC',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsi.pc_icms,6,2)),103),'')                     as 'pICMS',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsi.vl_icms_item,6,2)),103),'')                as 'vICMS',
  ltrim(rtrim(cast(mct.cd_digito_modalidade_st as varchar(10))))                                     as 'modBCST',

  --Este campo não tem no Egis
  isnull(CONVERT(varchar, convert(numeric(14,2),round(

  case when isnull(pf.pc_iva_icms_produto,0)>0 then
    pf.pc_iva_icms_produto
  else
    case when isnull(cf.pc_subst_classificacao,0)>0 then
      isnull(cf.pc_subst_classificacao,0)
    else
      cfe.pc_icms_strib_clas_fiscal
      --select * from classificacao_fiscal_estado
    end
  end                                                     ,6,2)),103),'1')                           as 'pMVAST',
  
  --(%) de Redução da Base de Cálculo

  isnull(CONVERT(varchar, convert(numeric(14,2),round(

  isnull(nsi.pc_reducao_icms_st,0)
                                                                              ,6,2)),103),'')          as 'pRedBCST',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsi.vl_bc_subst_icms_item,6,2)),103),'')       as 'vBCST',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsi.pc_subs_trib_item,6,2)),103),'')           as 'pICMSST',
  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsi.vl_icms_subst_icms_item,6,2)),103),'')     as 'vICMSST',


  isnull(CONVERT(varchar, convert(numeric(14,2),round(nsi.pc_reducao_icms,6,2)),103),'')             as 'pREDBC',

  'N03'                                                          as 'ICMS10',
  'N04'                                                          as 'ICMS20',
  'N05' 	                                                 as 'ICMS30',
  'N06'                                                          as 'ICMS40',
  'N07'                                                          as 'ICMS51',
  'N08'                                                          as 'ICMS60',
  'N09'                                                          as 'ICMS70',
  'N10'                                                          as 'ICMS90'
  --isnull(cf.pc_subst_classificacao,0)                            as 'pRedBCST'                  
 
  
from
  nota_saida ns                                     with (nolock)
  left outer join estado e                          with (nolock) on ns.sg_estado_nota_saida     = e.sg_estado
  inner join nota_saida_item nsi                    with (nolock) on nsi.cd_nota_saida           = ns.cd_nota_saida
  left outer join produto        p                  with (nolock) on p.cd_produto                = nsi.cd_produto
  left outer join produto_fiscal pf                 with (nolock) on pf.cd_produto               = p.cd_produto
  left outer join procedencia_produto pp            with (nolock) on pp.cd_procedencia_produto   = pf.cd_procedencia_produto
  left outer join tributacao t                      with (nolock) on t.cd_tributacao             = pf.cd_tributacao
  left outer join tributacao_icms ti                with (nolock) on ti.cd_tributacao_icms       = t.cd_tributacao_icms
  left outer join modalidade_calculo_icms mci       with (nolock) on mci.cd_modalidade_icms      = t.cd_modalidade_icms
  left outer join modalidade_calculo_icms_sTrib mct with (nolock) on mct.cd_modalidade_icms_st   = t.cd_modalidade_icms_st
  left outer join classificacao_fiscal cf           with (nolock) on cf.cd_classificacao_fiscal  = nsi.cd_classificacao_fiscal
  left outer join classificacao_fiscal_estado cfe   with (nolock) on cfe.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal and
                                                                     cfe.cd_estado               = e.cd_estado
           
--select * from classificacao_fiscal_estado

--select * from procedencia_produto
--select * from tributacao_icms
--select * from nota_saida_item where cd_nota_saida = 38
--select cd_estado,* from nota_saida

