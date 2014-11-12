
-------------------------------------------------------------------------------
--sp_helptext pr_migracao_pedido_importacao_atlas
-------------------------------------------------------------------------------
--pr_migracao_pedido_importacao_atlas
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Migração de Pedidos de Importação
--Data             : 15.05.2008
--Alteração        : 02.10.2008 - Ajustes Diversos
--
--
------------------------------------------------------------------------------
create procedure pr_migracao_pedido_importacao_atlas
as

--select * from migracao.dbo.L050 WHERE L050_CODIGO = 50228
--select * from migracao.dbo.L055 WHERE L055_L050_CODIGO = 50228
--select * from condicao_pagamento
--select * from migracao.dbo.L050 WHERE 
--select * from migracao.dbo.L015

delete from Pedido_Importacao_CartaCredito
delete from Pedido_Importacao_Documento
delete from Pedido_Importacao_Historico
delete from Pedido_Importacao_Frete
delete from Pedido_Importacao_Item
delete from Pedido_Importacao_Entreposto
delete from Pedido_Importacao_Seguro
delete from Pedido_Importacao_Despesa
delete from Pedido_Importacao_Texto
delete from Pedido_Importacao_Proforma
delete from Pedido_Importacao


select
  L050_CODIGO          as cd_pedido_importacao,
  cast('' as varchar)  as ds_pedido_importacao,
  null                 as cd_notify,
  null                 as cd_transitorio,
  L050_VALOR_MOEDA     as vl_taxa_cambio_fechamento,
  l050_data_solicitada as dt_pedido_importacao,
  2                    as cd_idioma,
  883                  as cd_condicao_pagamento,
  f.cd_fornecedor,
  1                    as cd_origem_pais,
  1                    as cd_destino_pais,
  1                    as cd_transportadora,
  null                 as cd_instrumento_negociacao,
  null                 as nm_emb_ped_imp,
  2                    as cd_moeda,
  4                    as cd_termo_comercial,
  null                 as dt_prev_emb_ped_imp,
  null                 as dt_abertuta_ped_imp,
  null                 as ic_cobertura_cambial,
  null                 as ic_entrepostagem_pedido,
  null                 as cd_conta_banco,
  null                 as nm_ordem_compra_pedido,
  4                    as cd_usuario,
  null                 as dt_usuario,
  1                    as cd_comprador,
  1                    as cd_importador,
  null                 as cd_despachante,
  null                 as cd_fabricante,
  null                 as cd_consignatario,
  null                 as cd_prestador_servico,
  null                 as cd_corretora_cambio,
  cast(L050_CODIGO as varchar) as nm_ref_ped_imp,
  null                 as pc_cusfin_ped_imp,
  cast(0 as float )    as vl_pedido_importacao,
  null                 as dt_entrega_ped_imp,
  1                    as cd_forma_entrega,
  null                 as qt_pesoliq_ped_imp,
  null                 as qt_pesobru_ped_imp,
  1                    as cd_status_pedido,
  null                 as dt_canc_pedido_importacao,
  null                 as nm_canc_pedido_importacao,
  null                 as cd_motivo_canc_ped_imp,
  null                 as pc_desconto_imp_ped,
  null                 as cd_tipo_frete,
  cast('' as varchar)  as ds_obs_ped_imp,
  1                    as cd_porto,
  null                 as ic_conta_frete,
  null                 as ic_fab_desconhecido,
  null                 as cd_despesa_padrao_comex,
  null                 as cd_contato_fornecedor,
--select * from tipo_pedido
  20                   as cd_tipo_pedido,
  null                 as dt_alteracao_pedido_imp,
  null                 as nm_alteracao_pedido_imp,
  1                    as cd_modalidade_pagamento,
  null                 as vl_outra_despesa_ped_imp,
  null                 as cd_representante_com_ext,
  null                 as ic_fax_pedido_importacao,
  null                 as cd_tipo_embalagem,
  null                 as ic_email_pedido_imp,
  null                 as ic_fechado_ped_importacao,
  null                 as dt_fechado_ped_importacao,
  f.cd_porto           as cd_porto_origem,
  2                    as cd_tipo_importacao,
  null                 as nm_local_embarque,
  null                 as cd_motivo_canc_mot_ped_imp,
  null                 as cd_motivo_canc_mot_pedimp,
  null                 as cd_banco,
  15                   as cd_usuario_requisitante,
  null                 as dt_ativacao_pedido_importacao,
  null                 as nm_ativacao_pedido_importacao,
  null                 as cd_motivo_ativacao_pedido,
  null                 as cd_motivo_cancel_pedido,
  f.cd_pais            as cd_pais_procedencia,
  null                 as cd_motivo_requisicao,
  2                    as cd_tipo_pagamento_frete,
  null                 as vl_moeda_ped_imp,
  null                 as dt_moeda_ped_imp,
  null                 as vl_desp_frete_ped_imp,
  null                 as vl_frete_int_ped_imp,
  1                    as cd_moeda_frete,
  null                 as cd_identificacao_pedido,
  1                    as cd_destino_compra,
  null                 as cd_motivo_alteracao,
  null                 as ic_ident_pedido_compl,
  null                 as cd_tipo_container,
  null                 as cd_tipo_containerx,
  null                 as cd_plano_compra,
  null                 as cd_licenca_importacao,
  null                 as dt_registro_licenca,
  null                 as dt_validade_licenca,
  null                 as ic_frete_prop_importacao,
  null                 as ic_seguro_prop_importacao,
  null                 as cd_aux_termo_comercial


into
  #pedido_importacao
from
  migracao.dbo.L050
  left join migracao.dbo.l015 on L015_CGC=L050_L015_CGC and l015_l130_CODIGO = 'IT'
  left join fornecedor f      on f.cd_cnpj_fornecedor = substring(L015_CGC,2,14)
-- WHERE
--   L050_CODIGO = 50228

insert into
  pedido_importacao
select
  *
from
  #pedido_importacao

select * from #pedido_importacao

--Itens do Pedido de Compra

select
  L055_L050_CODIGO as cd_pedido_importacao,
  L055_ITEM        as cd_item_ped_imp,
  p.cd_produto,
  L055_QTD         as qt_item_ped_imp,
  L055_VALOR       AS vl_item_ped_imp,
  l055_PESO        as qt_pesliq_item_ped_imp,
  L055_PESO               as qt_pesbruto_item_ped_imp,
  p.cd_tipo_embalagem,
  p.qt_multiplo_embalagem as qt_emb_item_ped_imp,
  null                    as cd_fabricante,
  null                    as nm_ordem_compra_ped_imp,
  4                       as cd_usuario,
  getdate()               as dt_usuario,
  null                    as pc_desc_item_ped_imp,
  null                    as nm_item_obs_ped_imp,
  L055_DATA_EMBARQUE      as dt_entrega_ped_imp,
  L055_QTD                as qt_real_item_ped_imp,
  null                    as pc_iimp_ped_imp,
  null                    as vl_moeda_ped_imp,
  L055_VALOR              AS vl_produto_ped_imp,
  null                    as cd_pedido_venda,
  null                    as cd_item_pedido_venda,
  L055_QTD                as qt_saldo_item_ped_imp,
  L055_DATA_PREVISAO_ENTREGA as dt_prev_embarque_ped_imp,
  null                       as dt_cancel_item_ped_imp,
  null                       as cd_motivo_cancel_pedido,
  null                       as nm_motivo_cancel_item_ped,
  null                       as cd_pedido_compra,
  null                       as cd_item_pedido_compra,
  null                       as dt_moeda_ped_importacao,
  p.nm_produto               as nm_produto_pedido,
  p.nm_fantasia_produto,
  null                       as qt_dia_entrega_ped_imp,
  null                       as dt_fechamento_ped_imp,
  p.cd_unidade_medida,
  null                       as nm_marca_item_ped_imp,
  null                       as cd_item_requisicao_compra,
  null                       as cd_requisicao_compra,
  null                       as nm_motivo_ativ_item_ped,
  null                       as dt_ativ_item_ped_imp,
  null                       as cd_motivo_ativacao_pedido,
  null                       as qt_dia_embarque_ped_imp

into
  #pedido_importacao_item
from
  migracao.dbo.L055
  inner join produto p on p.cd_mascara_produto = L055_L010_CODIGO
  
insert into
  pedido_importacao_item
select
  *
from
  #pedido_importacao_item

select * from #pedido_importacao_item

drop table #pedido_importacao
drop table #pedido_importacao_item

