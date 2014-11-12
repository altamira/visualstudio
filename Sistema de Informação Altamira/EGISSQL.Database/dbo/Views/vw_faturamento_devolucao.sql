
CREATE VIEW vw_faturamento_devolucao

--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2004
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000
--Autor		   : Daniel Duela
--Objetivo	   : Notas Fiscais Devolvidas para Consultas
--Data             : 23.03.2004
--Atualizado : 26.04.2004 - Inclusão de coluna com o valor de lista do produto. Igor Gama.
--             04.05.2004 - Inclusão de campo fase produto. Igor Gama
-- 08/09/2004 - Desconsiderando as notas fiscais de entrada - Daniel C. Neto.
-- 17/02/2005 - acrescido op.ic_analise_op_fiscal - Clelson Camargo
-- 14.03.2006 - Tipo de Mercado - Carlos Fernandes
-- 05.06.2006 - Conceito do Cliente - Carlos Fernandes
-- 22.03.2007 - Verificação do isnull - Carlos Fernandes
-- 09.04.2007 - Serviço - Carlos Fernandes
-- 15.05.2007 - Serviço sem Código não estava entrando na consulta - Carlos Fernandes
-- 24.06.2007 - Valor do Produto - Carlos Fernandes
-- 24.03.2008 - Acerto do Cálculo PIS/COFINS - Carlos Fernandes
-- 09.04.2008 - Ajuste do Segmento de Mercado - Carlos Fernandes
-- 14.10.2008 - Ajuste do Vendedor - Carlos Fernandes
-- 21.11.2008 - Código do Produto - Carlos Fernandes
-- 07.02.2009 - Grupo de Cliente - Carlos Fernandes
-- 28.05.2009 - Valor do ICMS Subst. Tributária - Carlos Fernandes
-- 26.06.2009 - Isnull nos Valores - Carlos Fernandes
-- 12.04.2010 - Ajuste da conversão da Cotação - Carlos Fernandes
-- 25.08.2010 - Ajuste do ICMS Subst. - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-- 07.12.2010 - Zona Franca - Carlos Fernandes
-------------------------------------------------------------------------------------------

as 


-------------------------------------------------------------------------------------------
--Critérios
--3. Considerando apenas as notas fiscais devolvidas parcialmente ou totalmente
--4. Desconsiderando as notas fiscais de entrada
-------------------------------------------------------------------------------------------

  select
    ns.cd_cliente,
    ns.cd_tipo_destinatario,
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,
    ns.dt_nota_saida,    
    ns.dt_saida_nota_saida,
    ns.cd_condicao_pagamento,
    isnull(ns.vl_total,0)                  as vl_total,
    op.cd_mascara_operacao,
    op.nm_operacao_fiscal,
    case when isnull(ns.cd_vendedor,0) <> isnull(c.cd_vendedor,0) and isnull(c.cd_vendedor,0)>0 then
      c.cd_vendedor
    else
      ns.cd_vendedor
    end    as cd_vendedor,

--    ns.cd_vendedor,
    nsi.cd_operacao_fiscal,
    nsi.cd_item_nota_saida,
    nsi.cd_produto,
    p.cd_mascara_produto,
    nsi.nm_fantasia_produto,
    nsi.nm_produto_item_nota,
    nsi.qt_item_nota_saida,
    cast(nsi.vl_unitario_item_nota as money) as vl_unitario_item_nota,   
    nsi.qt_devolucao_item_nota, 

    cast((case when IsNull(nsi.cd_servico ,0)=0 and isnull(nsi.vl_servico,0)=0
      then
        cast((( nsi.vl_unitario_item_nota * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) ) * 
    		(IsNull(nsi.qt_devolucao_item_nota,0)) 
         + (IsNull(nsi.vl_ipi,0) /  nsi.qt_item_nota_saida) 
         * IsNull(nsi.qt_devolucao_item_nota,0)) as money)
      else
        cast((( nsi.vl_servico * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) ) * 
    		(IsNull(nsi.qt_devolucao_item_nota,0)) 
         + (IsNull(nsi.vl_ipi,0) /  nsi.qt_item_nota_saida) 
         * IsNull(nsi.qt_devolucao_item_nota,0)) as money)
    end) +  --Rateio das despesas - Frete/Seguro/Outras
    (IsNull(nsi.vl_frete_item,0) /  nsi.qt_item_nota_saida) 
     * IsNull(nsi.qt_devolucao_item_nota,0) + --Frete
    (IsNull(nsi.vl_seguro_item,0) /  nsi.qt_item_nota_saida) 
     * IsNull(nsi.qt_devolucao_item_nota,0) + --Seguro
    (IsNull(nsi.vl_desp_acess_item,0) /  nsi.qt_item_nota_saida) 
     * IsNull(nsi.qt_devolucao_item_nota,0) --Despesa Acessória
    as money)                     as vl_unitario_item_total,
    case when isnull(nsi.cd_item_nota_saida,0)>0 then
      cast((case when IsNull(nsi.cd_servico,0)=0 and isnull(nsi.vl_servico,0)=0
      then
        cast(round((isnull(nsi.vl_unitario_item_nota,0) * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) * 
    		(IsNull(nsi.qt_item_nota_saida,0))),2)
        --Adiciona o IPI
    		+ isnull(nsi.vl_ipi,0) as money) 
      else
        round(IsNull(nsi.qt_item_nota_saida,0) * isnull(nsi.vl_servico,0),2) + 
        (case IsNull(nsi.ic_iss_servico, 'N') 
          when 'S' then
            isnull(vl_iss,0)
          else
            0.00
          end)
       end) +  --Rateio das despesas - Frete/Seguro/Outras
       IsNull(nsi.vl_frete_item,0.00) + 
       IsNull(nsi.vl_seguro_item,0.00) + 
       IsNull(nsi.vl_desp_acess_item,0.00) as money)
    else
       isnull(ns.vl_total,0)
    end                     
  
    - 
    isnull(nsi.vl_ipi,0)       --IPI
    -
    isnull(nsi.vl_icms_item,0) -- ICMS
    -
    case when isnull(op.ic_pis_operacao_fiscal,'N')='N' then  --PIS
      0
    else
      nsi.vl_pis
    end
    -
    case when isnull(op.ic_cofins_operacao_fiscal,'N')='N' then --COFINS
      0
    else
      nsi.vl_cofins
    end
                                  as vl_unitario_item_liquido,
    0.00                          as vl_lista_produto,
    isnull(nsi.pc_icms,0.00)      as pc_icms,
    isnull(nsi.pc_ipi,0.00)       as pc_ipi,
    isnull(nsi.vl_ipi,0.00)       as vl_ipi,
    isnull(nsi.vl_icms_item,0.00) as vl_icms_item,
    nsi.cd_servico,
    ns.cd_destinacao_produto,
    nsi.cd_grupo_produto,
    nsi.cd_categoria_produto,
    nsi.cd_pedido_venda,
    nsi.cd_item_pedido_venda,
    isnull(op.ic_comercial_operacao,'N') as ic_comercial_operacao,
    ns.cd_status_nota,
    gof.cd_tipo_operacao_fiscal,
    nsi.dt_restricao_item_nota,
    nsi.ic_tipo_nota_saida_item,
    Cast(nsi.nm_motivo_restricao_item as varchar(255)) as nm_motivo_restricao_item,
    d.nm_fantasia,
    ns.ic_dev_nota_saida,
    ns.cd_nota_dev_nota_saida,
    isnull(nsi.vl_frete_item,0.00)             as vl_frete_item,
    isnull(nsi.vl_seguro_item,0.00)            as vl_seguro_item,
    isnull(nsi.vl_desp_acess_item,0.00)        as vl_desp_acess_item,
    nsi.cd_fase_produto,
    isnull(op.ic_analise_op_fiscal,'S')        as ic_analise_op_fiscal, -- Clelson(17.02.2005),
    isnull(c.cd_tipo_mercado,0)                as cd_tipo_mercado,
    isnull(c.cd_conceito_cliente,0)            as cd_conceito_cliente,
    isnull(nsi.vl_inss_nota_saida,0)           as vl_inss_nota_saida,
    isnull(nsi.vl_csll,0)                      as vl_csll,
--    isnull(nsi.vl_pis,0)                       as vl_pis,
--    isnull(nsi.vl_cofins,0)                    as vl_cofins,

    case when isnull(op.ic_pis_operacao_fiscal,'N')='N' then  --PIS
      0.00
    else
      isnull(nsi.vl_pis,0)   
    end                                        as vl_pis,


    case when isnull(op.ic_cofins_operacao_fiscal,'N')='N' then --COFINS
     0.00
    else
      isnull(nsi.vl_cofins,0)                  
    end                                        as vl_cofins,

    isnull(ns.vl_iss,0)                        as vl_iss,

    --Valor do Produto

    isnull(cast(case when IsNull(nsi.cd_servico,0)=0 and isnull(nsi.vl_servico,0)=0
      then
        (isnull(nsi.vl_unitario_item_nota,0) * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) * 
    	(IsNull(nsi.qt_item_nota_saida,0)))
      else
        0.00
      end as money),0.00)                      as vl_produto,


    --Valor do Serviço

    isnull(cast((case when IsNull(nsi.cd_servico,0)=0 and isnull(nsi.vl_servico,0)=0
      then
			 cast( 0 as Float)
      else
        IsNull(nsi.qt_item_nota_saida,0) * isnull(nsi.vl_servico,0) + 
        (case IsNull(nsi.ic_iss_servico, 'N') 
          when 'S' then
            isnull(vl_iss,0)
          else
            0.00
        end)
    end) 
--    +  --Rateio das despesas - Frete/Seguro/Outras
--    IsNull(nsi.vl_frete_item,0) + 
--    IsNull(nsi.vl_seguro_item,0) + 
--    IsNull(nsi.vl_desp_acess_item,0) 
    as money),0)                               as vl_servico,

    isnull(ns.vl_irrf_nota_saida,0)            as vl_irrf_nota_saida,
    isnull(op.ic_pis_operacao_fiscal,'N')      as ic_pis,
    isnull(op.ic_cofins_operacao_fiscal,'N')   as ic_cofins,
    isnull(ra.nm_ramo_atividade,'')            as nm_ramo_atividade,
    isnull(c.cd_regiao,0)                      as cd_cliente_regiao,
    isnull(cr.nm_cliente_regiao,'')            as nm_cliente_regiao,
    isnull(c.cd_cliente_grupo,0)               as cd_cliente_grupo,
    isnull(cg.nm_cliente_grupo,'')             as nm_cliente_grupo,
    c.cd_pais,
    c.cd_estado,
    c.cd_cidade,
--    isnull(nsi.vl_icms_subst_icms_item,0)      as vl_icms_subst,

    case when isnull(op.ic_subst_tributaria,'N') = 'S'
    then
      isnull(nsi.vl_icms_subst_icms_item,0)  
    else
      0.00
    end                                        as vl_icms_subst,

    nsi.cd_moeda_cotacao,
    isnull(nsi.vl_moeda_cotacao,0)             as vl_moeda_cotacao,
    nsi.dt_moeda_cotacao,
    isnull(op.ic_zfm_operacao_fiscal,'N')                             as 'ZFM',

    case when isnull(op.ic_zfm_operacao_fiscal,'N')='S' and 
              ns.cd_status_nota <> 7                    and
              nsi.cd_item_nota_saida = 1                --Soma no 1o. Item
    then
      ns.vl_produto - ns.vl_total
    else
      0.00
    end                                                                as 'Desconto_ZFM'

   

  from
    nota_saida ns                         with (nolock)      
    inner join nota_saida_item nsi        with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida 
    left outer join produto p             with (nolock) on p.cd_produto     = nsi.cd_produto
    inner join destinacao_produto dp      with (nolock) on ns.cd_destinacao_produto = dp.cd_destinacao_produto
    inner join operacao_fiscal op         with (nolock) on IsNull(nsi.cd_operacao_fiscal, ns.cd_operacao_fiscal) = op.cd_operacao_fiscal
    inner join grupo_operacao_fiscal gof  with (nolock) on op.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
    inner join  vw_destinatario d         with (nolock) on ns.cd_tipo_destinatario = d.cd_tipo_destinatario and
                                                                  ns.cd_cliente = d.cd_destinatario 
    left outer join cliente c             with (nolock) on c.cd_cliente = ns.cd_cliente
    left outer join cliente_regiao cr     with (nolock) on cr.cd_cliente_regiao = c.cd_regiao
    left outer join Ramo_Atividade ra     with (nolock) on ra.cd_ramo_atividade        = c.cd_ramo_atividade
    left outer join cliente_grupo cg      with (nolock) on c.cd_cliente_grupo          = cg.cd_cliente_grupo

--     left outer join Vendedor v            with (nolock) on v.cd_vendedor = 
--                                                            case when isnull(ns.cd_vendedor,0) <> isnull(c.cd_vendedor,0) and isnull(c.cd_vendedor,0)>0 then
--                                                                 c.cd_vendedor
--                                                            else
--                                                                 ns.cd_vendedor
--                                                            end

  where
    (ns.cd_status_nota in (3,4)) and         --Considerar apenas notas devolvidas parcialmente/totalmente
    month(nsi.dt_restricao_item_nota) = month(ns.dt_nota_saida) and --Considera apenas as notas devolvidas no mesmo mês
    year(nsi.dt_restricao_item_nota)  = year(ns.dt_nota_saida)  and --Considera apenas as notas devolvidas no mesmo ano
    gof.cd_tipo_operacao_fiscal       = 2    

