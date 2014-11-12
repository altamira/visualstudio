
CREATE VIEW vw_faturamento_entrada

--------------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                          
--------------------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000
--Autor		   : Carlos Cardoso Fernandes
--Objetivo	   : Notas Fiscais para Consultas
--Data             : 08.11.2009
--Atualizado       : 08.11.2009
--                 : 
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
--------------------------------------------------------------------------------------------

as 

--------------------------------------------------------------------------------------------
--Critérios
--------------------------------------------------------------------------------------------
--1. Faturamento Bruto - Todas as notas fiscais
--2. Considerando apenas as notas fiscais que possuem valor comercial
--------------------------------------------------------------------------------------------

  select
    ns.cd_cliente,
    ns.cd_tipo_destinatario,
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,
    ns.dt_nota_saida,    
    ns.dt_saida_nota_saida,
    ns.cd_condicao_pagamento,
    isnull(ns.vl_total,0)                                as vl_total,
    op.cd_mascara_operacao,
    op.nm_operacao_fiscal,

    --Vendedor Externo

    case when isnull(ns.cd_vendedor,0)=0 then
      c.cd_vendedor
    else
      ns.cd_vendedor
    end                                                as cd_vendedor,

--     case when isnull(ns.cd_vendedor,0) <> isnull(c.cd_vendedor,0) and isnull(c.cd_vendedor,0)>0 then
--       c.cd_vendedor
--     else
--       ns.cd_vendedor
--     end                                                  as cd_vendedor,

    isnull(nsi.cd_operacao_fiscal,ns.cd_operacao_fiscal) as cd_operacao_fiscal,
    nsi.cd_item_nota_saida,
    nsi.cd_produto, 
    nsi.nm_produto_item_nota,

    case when isnull(nsi.qt_item_nota_saida,0)>0 
    then
      isnull(nsi.qt_item_nota_saida,0)
    else
      0
    end                                                  as qt_item_nota_saida,
     
    --Valor Unitário
  
    case when IsNull(nsi.cd_servico,0)>0 
    then cast(isnull(nsi.vl_servico,0) as money) 
    else
     cast(isnull(nsi.vl_unitario_item_nota,0) as money)
    end                                                  as vl_unitario_item_nota,

    isnull(nsi.qt_devolucao_item_nota,0)                 as qt_devolucao_item_nota, 


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
    end                                           as vl_unitario_item_total,

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
    isnull(nsi.vl_icms_item,0)                                -- ICMS
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

    0.00                                          as vl_lista_produto,

    ns.cd_destinacao_produto,
    isnull(nsi.pc_icms,0)                         as pc_icms,
    isnull(nsi.pc_ipi,0)                          as pc_ipi,
    isnull(nsi.vl_ipi,0)                          as vl_ipi,
    isnull(nsi.vl_icms_item,0)                    as vl_icms_item,
    nsi.cd_servico,
    nsi.cd_grupo_produto,
    nsi.cd_categoria_produto,
    nsi.cd_pedido_venda,
    nsi.cd_item_pedido_venda,
    isnull(op.ic_comercial_operacao,'N')          as ic_comercial_operacao,
    gof.cd_tipo_operacao_fiscal,

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

    ns.cd_status_nota,
    isnull(ns.vl_irrf_nota_saida,0)            as vl_irrf_nota_saida,
    ns.cd_num_formulario_nota,
    ns.nm_razao_social_nota,
    ns.nm_fantasia_destinatario,
    isnull(nsi.vl_frete_item,0)                as vl_frete_item,
    isnull(nsi.vl_seguro_item,0)               as vl_seguro_item,
    isnull(nsi.vl_desp_acess_item,0)           as vl_desp_acess_item,
    nsi.cd_fase_produto,
    --Verifica se a Operação Fiscal deve ser filtrada na Análise do BI
    isnull(op.ic_analise_op_fiscal,'N')        as ic_analise_op_fiscal,
    isnull(nsi.vl_inss_nota_saida,0)           as vl_inss_nota_saida,
    isnull(nsi.vl_csll,0)                      as vl_csll,
    isnull(nsi.vl_pis,0)                       as vl_pis,
    isnull(nsi.vl_cofins,0)                    as vl_cofins,
    isnull(ns.vl_iss,0)                        as vl_iss,
    isnull(c.cd_tipo_mercado,0)                as cd_tipo_mercado,
    isnull(tm.nm_tipo_mercado,'Sem Definição') as nm_tipo_mercado,
    v.nm_fantasia_vendedor                     as nm_vendedor_externo,
    c.cd_conceito_cliente,
    isnull(op.ic_pis_operacao_fiscal,'N')      as ic_pis,
    isnull(op.ic_cofins_operacao_fiscal,'N')   as ic_cofins,
    isnull(ra.nm_ramo_atividade,'')            as nm_ramo_atividade,    
    isnull(p.nm_pais,'')                       as nm_pais,
    isnull(e.nm_estado,'')                     as nm_estado,
    isnull(cid.nm_cidade,'')                   as nm_cidade,
    isnull(cr.nm_cliente_regiao,'')            as nm_cliente_regiao,      
    isnull(c.cd_cliente_grupo,0)               as cd_cliente_grupo,
    isnull(cg.nm_cliente_grupo,'')             as nm_cliente_grupo,
    c.cd_pais,
    c.cd_estado,
    c.cd_cidade,
    isnull(tp.ic_imposto_tipo_pedido,'S')      as ic_imposto_tipo_pedido,
    isnull(nsi.vl_icms_subst_icms_item,0)      as vl_icms_subst,

    case when isnull(pv.cd_pedido_venda,0)>0 and isnull(pv.cd_vendedor_interno,0)>0 then
      pv.cd_vendedor_interno
    else
      c.cd_vendedor_interno
    end                                        as cd_vendedor_interno,
    vi.nm_fantasia_vendedor                    as nm_vendedor_interno,
    nsi.cd_pedido_importacao,
    nsi.cd_item_ped_imp,
    nsi.cd_di,
    nsi.nm_di,
    nsi.nm_invoice

--select * from operacao_fiscal
--select * from pedido_venda

  from
    nota_saida ns                         with (nolock)       
    left outer join nota_saida_item nsi   with (nolock) on ns.cd_nota_saida            = nsi.cd_nota_saida 
    left outer join destinacao_produto dp with (nolock) on ns.cd_destinacao_produto    = dp.cd_destinacao_produto
    inner join operacao_fiscal op         with (nolock) on case when isnull(nsi.cd_operacao_fiscal,0)=0 then
                                                             ns.cd_operacao_fiscal
                                                           else
                                                             nsi.cd_operacao_fiscal
                                                           end = op.cd_operacao_fiscal
    inner join grupo_operacao_fiscal gof  with (nolock) on op.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal 
    left outer join cliente c             with (nolock) on c.cd_cliente                = ns.cd_cliente
    left outer join Tipo_Mercado tm       with (nolock) on tm.cd_tipo_mercado          = c.cd_tipo_mercado
--    left outer join Vendedor v            with (nolock) on v.cd_vendedor               = ns.cd_vendedor
    left outer join Vendedor v            with (nolock) on v.cd_vendedor = 
                                                           case when isnull(ns.cd_vendedor,0) <> isnull(c.cd_vendedor,0) and isnull(c.cd_vendedor,0)>0 then
                                                                c.cd_vendedor
                                                           else
                                                                ns.cd_vendedor
                                                           end

    left outer join Ramo_Atividade ra     with (nolock) on ra.cd_ramo_atividade        = c.cd_ramo_atividade
    left outer join Pais           p      with (nolock) on p.cd_pais                   = c.cd_pais
    left outer join Estado         e      with (nolock) on e.cd_estado                 = c.cd_estado and
                                                           e.cd_pais                   = c.cd_pais
    left outer join Cidade         cid    with (nolock) on cid.cd_pais                 = c.cd_pais   and
                                                           cid.cd_estado               = c.cd_estado and
                                                           cid.cd_cidade               = c.cd_cidade 
    left outer join Cliente_Regiao cr     with (nolock) on cr.cd_cliente_regiao        = c.cd_regiao
    left outer join Cliente_Grupo  cg     with (nolock) on cg.cd_cliente_grupo         = c.cd_cliente_grupo
    left outer join Pedido_Venda   pv     with (nolock) on pv.cd_pedido_venda          = nsi.cd_pedido_venda
    left outer join Tipo_Pedido    tp     with (nolock) on tp.cd_tipo_pedido           = pv.cd_tipo_pedido
    left outer join Vendedor vi           with (nolock) on vi.cd_vendedor = 
                                                           case when isnull(pv.cd_vendedor_interno,0) <> isnull(c.cd_vendedor,0) and isnull(c.cd_vendedor_interno,0)>0 then
                                                                pv.cd_vendedor_interno
                                                           else
                                                                c.cd_vendedor_interno
                                                           end
 
  where
    gof.cd_tipo_operacao_fiscal = 1     --ENTRADAS 


--select * from nota_saida_item

