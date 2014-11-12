
-------------------------------------------------------------------------------
--sp_helptext pr_gera_pedido_venda_nextel
-------------------------------------------------------------------------------
--pr_gera_pedido_venda_nextel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Douglas Lopes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Pedidos de Venda com o movimento de Pedidos de
--                   venda Nextel
--
--Data             : 26.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_pedido_venda_nextel
@cd_usuario int = 0
as

--Criação de uma tabela temporária agrupada
select 
  cd_pedido_venda,
  cd_cliente,
  cd_vendedor,
  dt_pedido_venda_nextel
into
  #Agrupamento_Pedido
from 
  pedido_venda_nextel
group by
  cd_pedido_venda,
  cd_cliente,
  cd_vendedor,
  dt_pedido_venda_nextel


select  
  ap.cd_pedido_venda,
  ap.dt_pedido_venda_nextel  as dt_pedido_venda,
  ap.cd_vendedor             as cd_vendedor_pedido,
  1  as cd_vendedor_interno,
'N'                 as ic_emitido_pedido_venda,
cast('' as varchar) as ds_pedido_venda,
cast('' as varchar) as ds_pedido_venda_fatura,
cast('' as varchar) as ds_cancelamento_pedido,
null                as cd_usuario_credito_pedido,
null                as dt_credito_pedido_venda,
'N'                 as ic_smo_pedido_venda,
null                as vl_total_pedido_venda,
null                as qt_liquido_pedido_venda,
null                as qt_bruto_pedido_venda,
null                as dt_conferido_pedido_venda,
'N'                 as ic_pcp_pedido_venda,
'N'                 as ic_lista_pcp_pedido_venda,
'N'                 as ic_processo_pedido_venda,
'N'                 as ic_lista_processo_pedido,
'N'                 as ic_imed_pedido_venda,
'N'                 as ic_lista_imed_pedido,
null                as nm_alteracao_pedido_venda,
'N'                 as ic_consignacao_pedido,
null                as dt_cambio_pedido_venda,
null                as cd_cliente_entrega,
'N'                 as ic_op_triang_pedido_venda,
'N'                 as ic_nf_op_triang_pedido,
null                as nm_contato_op_triang,
null                as cd_pdcompra_pedido_venda,
null                as cd_processo_exportacao,
ap.cd_cliente,
null                as cd_tipo_frete,
null                as cd_tipo_restricao_pedido,
3                   as cd_destinacao_produto,
1                   as cd_tipo_pedido,
null                as cd_transportadora,
ap.cd_vendedor,
1 as cd_tipo_endereco,
1 as cd_moeda,
null                as cd_contato,
@cd_usuario as cd_usuario,
getdate()   as dt_usuario,
null                as dt_cancelamento_pedido,
--Fazer a Busca da Condição Correta
1 as cd_condicao_pagamento, 
1           as cd_status_pedido,
1           as cd_tipo_entrega_produto,
null                as nm_referencia_consulta,
null                as vl_custo_financeiro,
null                as ic_custo_financeiro,
null                as vl_tx_mensal_cust_fin,
--select * from tipo_pagamento_frete
1                   as cd_tipo_pagamento_frete,
null                as nm_assina_pedido,
'N'                 as ic_fax_pedido,
'N'                 as ic_mail_pedido,
null                as vl_total_pedido_ipi,
null                as vl_total_ipi,
cast('' as varchar) as ds_observacao_pedido,
null                as cd_usuario_atendente,
'N'                 as ic_fechado_pedido,
'N'                 as ic_vendedor_interno,
null                as cd_representante,
'N'                 as ic_transf_matriz,
'N'                 as ic_digitacao,
'S'                 as ic_pedido_venda,
null                as hr_inicial_pedido,
'N'                 as ic_outro_cliente,
'S'                 as ic_fechamento_total,
'N'                 as ic_operacao_triangular,
'N'                 as ic_fatsmo_pedido,
cast('' as varchar) as ds_ativacao_pedido,
null                as dt_ativacao_pedido,
cast('' as varchar) as ds_obs_fat_pedido,
'N'                 as ic_obs_corpo_nf,
getdate()           as dt_fechamento_pedido,
null                as cd_cliente_faturar,
1                   as cd_tipo_local_entrega,
'N'                 as ic_etiq_emb_pedido_venda,
null                as cd_consulta,
null                as dt_alteracao_pedido_venda,
null                 as ic_dt_especifica_ped_vend,
null                 as ic_dt_especifica_consulta,
null                 as ic_fat_pedido_venda,
null                 as ic_fat_total_pedido_venda,
null                as qt_volume_pedido_venda,
null                as qt_fatpbru_pedido_venda,
'N'                 as ic_permite_agrupar_pedido,
null                as qt_fatpliq_pedido_venda,
null                as vl_indice_pedido_venda,
null                as vl_sedex_pedido_venda,
null                as pc_desconto_pedido_venda,
null                as pc_comissao_pedido_venda,
null                as cd_plano_financeiro,
cast('' as varchar) as ds_multa_pedido_venda,
null                as vl_freq_multa_ped_venda,
null                as vl_base_multa_ped_venda,
null                as pc_limite_multa_ped_venda,
null                as pc_multa_pedido_venda,
null                as cd_fase_produto_contrato,
null                as nm_obs_restricao_pedido,
null                as cd_usu_restricao_pedido,
null                as dt_lib_restricao_pedido,
null                as nm_contato_op_triang_ped,
'N'                 as ic_amostra_pedido_venda,
'N'                 as ic_alteracao_pedido_venda,
'N'                 as ic_calcula_sedex,
null                as vl_frete_pedido_venda,
'N'                 as ic_calcula_peso,
'N'                 as ic_subs_trib_pedido_venda,
'N'                 as ic_credito_icms_pedido,
null                as cd_usu_lib_fat_min_pedido,
null                as dt_lib_fat_min_pedido,
null                as cd_identificacao_empresa,
null                as pc_comissao_especifico,
null                as dt_ativacao_pedido_venda,
null                as cd_exportador,
'N'                 as ic_atualizar_valor_cambio_fat,
null                as cd_tipo_documento,
null                as cd_loja,
null                as cd_usuario_alteracao,
'N'                 as ic_garantia_pedido_venda,
null                as cd_aplicacao_produto,
null                as ic_comissao_pedido_venda,
null                as cd_motivo_liberacao,
'N'                 as ic_entrega_futura,
null                as modalidade,
null                as modalidade1,
null                as cd_modalidade,
null                as cd_pedido_venda_origem,
getdate()           AS dt_entrada_pedido,
null                as dt_cond_pagto_pedido,
null                as cd_usuario_cond_pagto_ped,
null                as vl_credito_liberacao,
null                as vl_credito_liberado,
null                as cd_centro_custo,
'N'                 as ic_bloqueio_licenca,
null                as cd_licenca_bloqueada,
null                as nm_bloqueio_licenca,
null                as dt_bloqueio_licenca,
null                as cd_usuario_bloqueio_licenca,
null                as vl_mp_aplicacada_pedido,
null                as vl_mo_aplicada_pedido,
null                as cd_usuario_impressao,
null                as cd_cliente_origem,
null                as cd_situacao_pedido,
null                as qt_total_item_pedido,
'N'                 as ic_bonificacao_pedido_venda

into
  #Pedido_Venda
from
  #Agrupamento_Pedido ap

insert into
  pedido_venda
select
  *
from
  #Pedido_Venda  
where
  cd_pedido_venda not in ( select cd_pedido_venda from Pedido_Venda )
  

------------------------------------------------------------------------------
-- itens do pedido de venda
------------------------------------------------------------------------------
--       select
--         @cd_pedido_venda                as cd_pedido_venda,
--         identity(int,1,1)               as cd_item_pedido_venda,
--         @dt_pedido_venda                as dt_item_pedido_venda,
--         pe.qt_programacao_entrega       as qt_item_pedido_venda,
--         pe.qt_programacao_entrega       as qt_saldo_pedido_venda,
--         pe.dt_necessidade_entrega       as dt_entrega_vendas_pedido,
--         @dt_entrega                     as dt_entrega_fabrica_pedido,
--         cast('' as varchar)             as ds_produto_pedido_venda,
--         p.vl_produto                    as vl_unitario_item_pedido,
--         p.vl_produto                    as vl_lista_item_pedido,
--         0.00                            as pc_desconto_item_pedido,
--         null                            as dt_cancelamento_item,
--         pe.dt_usuario                   as dt_estoque_item_pedido,
--         pe.cd_pedido_compra_programacao as cd_pdcompra_item_pedido,
--         null                            as dt_reprog_item_pedido,
--         p.qt_peso_liquido               as qt_liquido_item_pedido,
--         p.qt_peso_bruto                 as qt_bruto_item_pedido,
--        'N'                              as ic_fatura_item_pedido,
--         case when isnull(pe.cd_movimento_estoque,0)>0
--         then 'S'
--         else 'N' end                      as ic_reserva_item_pedido,
--         null                              as ic_tipo_montagem_item,
--         null                              as ic_montagem_g_item_pedido,
--         null                              as ic_subs_tributaria_item,
--         null                              as cd_posicao_item_pedido,
--         null                              as cd_os_tipo_pedido_venda,
--         null                              as ic_desconto_item_pedido,
--         null                              as dt_desconto_item_pedido,
--         null                              as vl_indice_item_pedido,
--         p.cd_grupo_produto,
--         p.cd_produto,
--         p.cd_grupo_categoria,
--         p.cd_categoria_produto,
--         null                                  as cd_pedido_rep_pedido,
--         null                                  as cd_item_pedidorep_pedido,
--         null                                  as cd_ocorrencia,
--         null                                  as cd_consulta,
--         @cd_usuario                           as cd_usuario,
--         getdate()                             as dt_usuario,
--         null                                  as nm_mot_canc_item_pedido,
--         null                                  as nm_obs_restricao_pedido,
--         null                                  as cd_item_consulta,
--         null                                  as ic_etiqueta_emb_pedido,
-- --select * from classificacao_fiscal
--         isnull(cf.pc_ipi_classificacao,0)     as pc_ipi_item,
--         isnull(@pc_icms_estado_cliente,0)     as pc_icms_item,
--         0.00                                  as pc_reducao_base_item,
--         @dt_entrega                           as dt_necessidade_cliente,
--         cast(@dt_entrega - pe.dt_programacao_entrega as int ) as qt_dia_entrega_cliente,
--         @dt_entrega                                           as dt_entrega_cliente,
--         'N'                                                   as ic_smo_item_pedido_venda,
--         null                                                  as cd_om,
--        'S'                                                    as ic_controle_pcp_pedido,
--         null                                                  as nm_mat_canc_item_pedido,
--         null                                                  as cd_servico,
--         'N'                                                   as ic_produto_especial,
--         null                                                  as cd_produto_concorrente,
--         null                                                  as ic_orcamento_pedido_venda,
--         cast('' as varchar)                                   as ds_produto_pedido,
--         p.nm_produto                                          as nm_produto_pedido,
--         p.cd_serie_produto,
--         isnull(cf.pc_ipi_classificacao,0)                     as pc_ipi,
--         isnull(@pc_icms_estado_cliente,0)                     as pc_icms,
--         cast(@dt_entrega - pe.dt_programacao_entrega as int ) as qt_dia_entrega_pedido,
--         'S'                                                   as ic_sel_fechamento,
--         null                                                  as dt_ativacao_item,
--         null                                                  as nm_mot_ativ_item_pedido,
--         p.nm_fantasia_produto,
--         'N'                                                   as ic_etiqueta_emb_ped_venda,
--         getdate()                                             as dt_fechamento_pedido,
--         cast('' as varchar)                                   as ds_progfat_pedido_venda,
--         'P'                                                   as ic_pedido_venda_item,
--         null                                                  as ic_ordsep_pedido_venda,
--         null                                                  as ic_progfat_item_pedido,
--         null                                                  as qt_progfat_item_pedido,
--         null                                                  as cd_referencia_produto,
--         'S'                                                   as ic_libpcp_item_pedido,
--         cast('' as varchar)                                   as ds_observacao_fabrica,
--         null                                                  as nm_observacao_fabrica1,
--         null                                                  as nm_observacao_fabrica2,
--         p.cd_unidade_medida,
--         null                                                  as pc_reducao_icms,
--         null                                                  as pc_desconto_sobre_desc,
--         null                                                  as nm_desconto_item_pedido,
--         null                                                  as cd_item_contrato,
--         null                                                  as cd_contrato_fornecimento,
--         null                                                  as nm_kardex_item_ped_venda,
--         null                                                  as ic_gprgcnc_pedido_venda,
--         null                                                  as cd_pedido_importacao,
--         null                                                  as cd_item_pedido_importacao,
--         null                                                  as dt_progfat_item_pedido,
--         null                                                  as qt_cancelado_item_pedido,
--         null                                                  as qt_ativado_pedido_venda,
--         null                                                  as cd_mes,
--         null                                                  as cd_ano,
--         null                                                  as ic_mp66_item_pedido,
--         null                                                  as ic_montagem_item_pedido,
--         null                                                  as ic_reserva_estrutura_item,
--         null                                                  as ic_estrutura_item_pedido,
--         null                                                  as vl_frete_item_pedido,
--         null                                                  as cd_usuario_lib_desconto,
--         null                                                  as dt_moeda_cotacao,
--         null                                                  as vl_moeda_cotacao,
--         null                                                  as cd_moeda_cotacao,
--         null                                                  as dt_zera_saldo_pedido_item,
--         null                                                  as cd_lote_produto,
--         null                                                  as cd_num_serie_item_pedido,
--         null                                                  as cd_lote_item_pedido,
--         'S'                                                   as ic_controle_mapa_pedido,
--         null                                                  as cd_tipo_embalagem,
--         null                                                  as dt_validade_item_pedido,
--         null                                                  as cd_movimento_caixa,
--         null                                                  as vl_custo_financ_item,
--         null                                                  as qt_garantia_item_pedido,
--         null                                                  as cd_tipo_montagem,
--         null                                                  as cd_montagem,
--         null                                                  as cd_usuario_ordsep,
--         null                                                  as ic_kit_grupo_produto,
--         null                                                  as cd_sub_produto_especial,
--         null                                                  as cd_plano_financeiro,
--         null                                                  as dt_fluxo_caixa,
--         null                                                  as ic_fluxo_caixa,
--         cast('' as varchar)                                   as ds_servico_item_pedido,
--         null                                                  as dt_reservado_montagem,
--         null                                                  as cd_usuario_montagem,
--         null                                                  as ic_imediato_produto,
--         cf.cd_mascara_classificacao,
--         null                                                  as cd_desenho_item_pedido,
--         null                                                  as cd_rev_des_item_pedido,
--         null                                                  as cd_centro_custo,
--         null                                                  as qt_area_produto,
--         null                                                  as cd_produto_estampo,
--         null                                                  as vl_digitado_item_desconto,
--         null                                                  as cd_lote_Item_anterior,
--         pe.cd_programacao_entrega,
--         isnull(pc.ic_estoque_fatura_produto,'N')              as ic_estoque_fatura,
--         isnull(pc.ic_estoque_venda_produto,'N')               as ic_estoque_venda,
--         null                                                  as ic_manut_mapa_producao,
--         null                                                  as pc_comissao_item_pedido,
--         null                                                  as cd_produto_servico         
-- 
-- --select * from pedido_venda_item
-- --select * from produto_custo
-- 
--       into
--         #Pedido_Venda_Item
--       from
--         #ItemAgrupado pe                        with (nolock)
--         inner join Produto p                    with (nolock) on p.cd_produto               = pe.cd_produto 
--         left outer join Produto_Fiscal       pf with (nolock) on pf.cd_produto              = p.cd_produto
--         left outer join Classificacao_Fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
--         left outer join Produto_Custo        pc with (nolock) on p.cd_produto               = pc.cd_produto
-- 
-- --       where
-- --         pe.cd_cliente = @cd_cliente and
-- --         isnull(pe.cd_pedido_venda,0)=0
--   
-- 
--       insert into pedido_venda_item
--       select * from #pedido_venda_item
--       
--       --Calculo do Pedido de Venda
--  
--       --1.Pedido
--   
--       select
--          pv.cd_pedido_venda,
--          vl_total_pedido_venda = sum( isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0) ),
--          vl_total_pedido_ipi   = sum((isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0)) + 
--                                      (isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0)  * isnull(pvi.pc_ipi,0)/100 ) ),
--          vl_total_ipi          = sum( isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.vl_unitario_item_pedido,0)  * isnull(pvi.pc_ipi,0)/100 )
--        into
--          #CalculoPV
--        from
--          Pedido_Venda pv
--          inner join pedido_venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
--        where
--          pv.cd_pedido_venda = @cd_pedido_venda    
--        group by
--          pv.cd_pedido_venda
-- 
--        update
--          Pedido_Venda
--        set
--          vl_total_pedido_venda = x.vl_total_pedido_venda,
--          vl_total_pedido_ipi   = x.vl_total_pedido_ipi,
--          vl_total_ipi          = x.vl_total_ipi
--        from
--          pedido_venda pv
--          inner join #calculopv x on x.cd_pedido_venda = pv.cd_pedido_venda
--        where
--          @cd_pedido_venda = pv.cd_pedido_venda
-- 


------------------------------------------------------------------------------
--Calculo do Pedido de Venda
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--Consistências Financeiras 
------------------------------------------------------------------------------
--Cliente, Crédito, Pendências Financeiras, Estoque
------------------------------------------------------------------------------



