
CREATE VIEW vw_faturamento_cancelado
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2003
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000
--Autor		   : Daniel Duela
--Objetivo	   : Notas Fiscais Canceladas para consultas
--Data             : 23.03.2004
--Atualizado : 26.04.2004 - Inclusão de coluna com o valor de lista do produto. Igor Gama.
--             04.05.2004 - Inclusão da coluna de fase do produto. Igor Gama
--             08/09/2004 - Desconsiderar as notas de entrada - Daniel C. Neto.
--             17/02/2005 - acrescido op.ic_analise_op_fiscal - Clelson Camargo
--             22.03.2007 - Ajuste isnull dos valores - Carlos Fernandes
--             15.05.2007 - Ajuste do Valor do Serviço- Carlos Fernandes
--             24.06.2007 - Valor do Produto - Carlos fernandes
-- 10.01.2008 - Acrescentar os Impostos - Carlos Fernandes
-- 24.03.2008 - Ajuste do cálculo do PIS/COFINS - Carlos Fernandes
-- 08.05.2008 - Destinatário/Cliente - Carlos Fernandes
-- 04.08.2008 - Ajuste da View - Carlos Fernandes
-- 14.10.2008 - Vendedor - Carlos Fernandes
-- 07.02.2009 - Grupo de Cliente - Carlos Fernandes
-- 28.05.2009 - Valor do ICMS Subst. Trib. - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-- 07.12.2010 - Zona Franca - Carlos Fernandes
-------------------------------------------------------------------------------------------

as 

--Critérios
--3. Considerando apenas as notas fiscais canceldas
--4. Desconsiderando as notas fiscais de entrada

  select
    ns.cd_cliente,
    ns.cd_tipo_destinatario,
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,
    ns.dt_saida_nota_saida,
    ns.dt_nota_saida,    
    ns.cd_condicao_pagamento,
    ns.vl_total,
    ns.cd_mascara_operacao,
    ns.nm_operacao_fiscal,
    case when isnull(ns.cd_vendedor,0) <> isnull(c.cd_vendedor,0) and isnull(c.cd_vendedor,0)>0 then
      c.cd_vendedor
    else
      ns.cd_vendedor
    end    as cd_vendedor,
    --ns.cd_vendedor,
    nsi.cd_operacao_fiscal,
    nsi.cd_item_nota_saida,
    nsi.cd_produto,
    nsi.nm_produto_item_nota,
    nsi.qt_item_nota_saida,

    --Valor do Produto

    cast(case when IsNull(nsi.cd_servico,0)=0 and isnull(nsi.vl_servico,0)=0
      then
        (isnull(nsi.vl_unitario_item_nota,0) * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) * 
    	(IsNull(nsi.qt_item_nota_saida,0)))
      else
        0.00
      end as money)                                         as vl_produto,

    --Valor do Serviço

    cast((case when IsNull(nsi.cd_servico,0)=0 and isnull(nsi.vl_servico,0)=0
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
    as money)                                  as vl_servico,

    cast((case when IsNull(nsi.cd_servico,0) = 0 and isnull(nsi.vl_servico,0)=0
      then
        cast((isnull(nsi.vl_unitario_item_nota,0) * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) * 
    		(IsNull(nsi.qt_item_nota_saida,0)))
        --Adiciona o IPI
    		+ isnull(nsi.vl_ipi,0) as money) 
      else
        IsNull(nsi.qt_item_nota_saida,0) * isnull(nsi.vl_servico,0) + 
        (case IsNull(nsi.ic_iss_servico, 'N') 
          when 'S' then
            isnull(vl_iss,0)
          else
            0.00
        end)
    end) +  --Rateio das despesas - Frete/Seguro/Outras

    IsNull(nsi.vl_frete_item,0)  + 
    IsNull(nsi.vl_seguro_item,0) + 
    IsNull(nsi.vl_desp_acess_item,0) as money) as vl_unitario_item_total,
 
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
    end                                             as vl_unitario_item_liquido,


    nsi.qt_devolucao_item_nota, 
 
   cast( (case when IsNull(nsi.cd_servico ,0)=0 and isnull(nsi.vl_servico,0)=0
      then
        cast((nsi.vl_unitario_item_nota * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) * 
    		(IsNull(nsi.qt_item_nota_saida,0)))
        --Adiciona o IPI
    		+ nsi.vl_ipi as money) 
      else
        IsNull(nsi.qt_item_nota_saida,0) * nsi.vl_servico + 
        (case IsNull(nsi.ic_iss_servico, 'N') 
          when 'S' then
            vl_iss
          else
            0.00
        end)
    end) +  --Rateio das despesas - Frete/Seguro/Outras
    IsNull(nsi.vl_frete_item,0)  + 
    IsNull(nsi.vl_seguro_item,0) + 
    IsNull(nsi.vl_desp_acess_item,0) as money ) as vl_unitario_item_atual,

   cast( (case when IsNull(nsi.cd_servico ,0)=0 and isnull(nsi.vl_servico,0)=0
      then
        cast((nsi.vl_unitario_item_nota * ( 1 - IsNull(nsi.pc_desconto_item,0) / 100) * 
    		(IsNull(nsi.qt_item_nota_saida,0)))
        --Adiciona o IPI
    		+ nsi.vl_ipi as money) 
      else
        IsNull(nsi.qt_item_nota_saida,0) * nsi.vl_servico + 
        (case IsNull(nsi.ic_iss_servico, 'N') 
          when 'S' then
            vl_iss
          else
            0.00
        end)
    end) +  --Rateio das despesas - Frete/Seguro/Outras

    IsNull(nsi.vl_frete_item,0)  + 
    IsNull(nsi.vl_seguro_item,0) + 
    IsNull(nsi.vl_desp_acess_item,0) as money ) as vl_unitario_item_nota,


    isnull(nsi.vl_icms_item,0) as vl_icms_item,
    0.00                       as vl_lista_produto,
    isnull(nsi.pc_icms,0)      as pc_icms,
    isnull(nsi.pc_ipi,0)       as pc_ipi,
    isnull(nsi.vl_ipi,0)       as vl_ipi,
    nsi.cd_servico,
    ns.cd_destinacao_produto,
    nsi.cd_grupo_produto,
    nsi.cd_categoria_produto,
    nsi.cd_pedido_venda,
    nsi.cd_item_pedido_venda,
    isnull(op.ic_comercial_operacao,'N')       as ic_comercial_operacao,
    gof.cd_tipo_operacao_fiscal,
    ns.cd_status_nota,
    isnull(nsi.vl_frete_item,0.00)             as vl_frete_item,
    isnull(nsi.vl_seguro_item,0.00)            as vl_seguro_item,
    isnull(nsi.vl_desp_acess_item,0.00)        as vl_desp_acess_item,
    nsi.cd_fase_produto,
    isnull(op.ic_analise_op_fiscal,'N')        as ic_analise_op_fiscal, -- Clelson(17.02.2005),
    isnull(c.cd_tipo_mercado,0)                as cd_tipo_mercado,
    isnull(c.cd_conceito_cliente,0)            as cd_conceito_cliente,
    isnull(nsi.vl_inss_nota_saida,0)           as vl_inss_nota_saida,
    isnull(nsi.vl_csll,0)                      as vl_csll,
    --isnull(nsi.vl_pis,0)                       as vl_pis,
    --isnull(nsi.vl_cofins,0)                    as vl_cofins,

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
    isnull(ns.vl_irrf_nota_saida,0)            as vl_irrf_nota_saida,
    isnull(op.ic_pis_operacao_fiscal,'N')      as ic_pis,
    isnull(op.ic_cofins_operacao_fiscal,'N')   as ic_cofins,
    isnull(ra.nm_ramo_atividade,'')            as nm_ramo_atividade,
    ns.nm_fantasia_nota_saida                  as nm_fantasia,
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
    nota_saida ns       with (nolock) 
      left outer join 
    nota_saida_item nsi with (nolock) 
      on ns.cd_nota_saida = nsi.cd_nota_saida 
      inner join        
    destinacao_produto dp  with (nolock) 
      on ns.cd_destinacao_produto = dp.cd_destinacao_produto
      inner join        
    operacao_fiscal op  with (nolock) 
      on IsNull(nsi.cd_operacao_fiscal, ns.cd_operacao_fiscal) = op.cd_operacao_fiscal
      inner join        
    grupo_operacao_fiscal gof  with (nolock) 
      on op.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
    left outer join cliente c             with (nolock) on c.cd_cliente                = ns.cd_cliente
    left outer join Ramo_Atividade ra     with (nolock) on ra.cd_ramo_atividade        = c.cd_ramo_atividade
    left outer join cliente_grupo cg      with (nolock) on c.cd_cliente_grupo          = cg.cd_cliente_grupo

--     left outer join Vendedor v            with (nolock) on v.cd_vendedor = 
--                                                            case when isnull(ns.cd_vendedor,0) <> isnull(c.cd_vendedor,0) and isnull(c.cd_vendedor,0)>0 then
--                                                                 c.cd_vendedor
--                                                            else
--                                                                 ns.cd_vendedor
--                                                            end

  where
    (ns.cd_status_nota = 7)           and --Considerar apenas notas canceladas
    (gof.cd_tipo_operacao_fiscal = 2)     --Saída


