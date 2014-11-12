
-------------------------------------------------------------------------------
--pr_migracao_altamira_Pedido_Compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Autor
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela
--Data             : 08.09.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_Pedido_Compra
as

--Delta os Registros da Tabela Destino
delete from Pedido_Compra_Historico
delete from Pedido_Compra_Item
delete from Pedido_Compra_Aprovacao
delete from Pedido_Compra_Follow
delete from Pedido_Compra

--select * from db_altamira.dbo.CO_PEDIDO

--select * from tipo_pedido

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
cope_Numero 										as cd_pedido_compra,
cope_Data 										as dt_pedido_compra,
(select top 1 cd_fornecedor from fornecedor where cd_cnpj_fornecedor = cope_fornecedor) as cd_fornecedor,
null 											as cd_contato_fornecedor,
1 											as cd_comprador,
null 											as cd_transportadora,
null 											as ic_pedido_compra,
cast(cope_Observacao as varchar(8000))									as ds_pedido_compra,
1  											as cd_destinacao_produto,
3 											as cd_tipo_pedido,
1 											as cd_tipo_endereco,
1 											as cd_moeda,
null 											as dt_cambio_pedido_compra,
1											as cd_condicao_pagamento,
1 											as cd_status_pedido,
null 											as nm_ref_pedido_compra,
null 											as qt_pesoliq_pedido_compra,
null 											as qt_pesobruto_pedido_compra,
cope_ValorTotal										as vl_total_pedido_compra,
null 											as dt_cancel_ped_compra,
cast(null as varchar)									as ds_cancel_ped_compra,
null 											as dt_ativacao_pedido_compra,
cast(null as varchar)									as ds_ativacao_pedido_compra,
cope_Data										as dt_nec_pedido_compra,
null 											as dt_conf_pedido_compra,
null 											as dt_alteracao_ped_compra,
cast(null as varchar)									as ds_alteracao_ped_compra,
null 											as nm_contato_conf_ped_comp,
null 											as cd_plano_compra,
null 											as cd_centro_custo,
null 											as ic_fax_pedido_compra,
null 											as ic_email_pedido_compra,
4											as cd_usuario,
getdate()										as dt_usuario,
1 											as cd_tipo_entrega_produto,
null 											as nm_pedfornec_pedido_compr,
null 											as qt_pesbruto_pedido_compra,
'N' 											as ic_maquina,
null 											as vl_indice_pedido_compra,
null 											as vl_total_ipi_pedido,
NULL 											as vl_frete_pedido_compra,
'S' 											as ic_fechado_pedido_compra,
cope_ValorTotal										as vl_total_pedido_ipi,
1 											as cd_tipo_local_entrega,
null 											as cd_aplicacao_produto,
null 											as qt_pesobruto_pedido_compr,
null 											as cd_plano_financeiro,
null 											as cd_fase_produto_contrato,
null 											as dt_vcto_pedido_compra,
null 											as cd_tipo_comunicacao,
null 											as nm_conf_pedido_compra,
null 											as cd_departamento,
null 											as cd_requisicao_compra,
1 											as cd_local_entrega_empresa,
'S' 											as ic_aprov_comprador_pedido,
null 											as ic_consignacao_pedido,
null 											as pc_frete_pedido_compra,
null 											as pc_custofin_pedido_compra,
'S' 											as ic_aprov_pedido_compra,
null 											as cd_tipo_produto_espessura,
null 											as cd_tipo_alteracao_pedido,
null 											as cd_tipo_envio,
null 											as ic_pedido_gerado_autom,
null 											as vl_desconto_pedido_compra,
null 											as cd_destino_compra,
null 											as cd_opcao_compra,
null 											as cd_loja,
2 											as cd_tipo_pagamento_frete,
null 											as vl_total_pedido_icms,
null 											as cd_motorista
  
into
  #Pedido_Compra
from
  db_altamira.dbo.CO_PEDIDO

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Pedido_Compra
select
  *
from
  #Pedido_Compra

--select top 100 * from produto 

--Mostra os registros migrados

select * from Pedido_Compra


--select * from db_altamira.dbo.CO_ITEMPEDIDO

select
  --Atributos da tabela origem com o nome da tabela destino
coit_Numero 											as cd_pedido_compra,
coit_Item 											as cd_item_pedido_compra,
null 												as cd_medida_retifica,
null 												as nm_medacab_mat_prima,
null 												as nm_medbruta_mat_prima,
null 												as cd_requisicao_compra_item,
null 												as cd_requisicao_compra,
cast(null as varchar)										as ds_item_prodesp_ped_compr,
null 												as dt_item_pedido_compra,
coit_Quantidade 										as qt_item_pedido_compra,
null 												as qt_saldo_item_ped_compra,
null 												as dt_entrega_item_ped_compr,
null 												as vl_custo_item_ped_compra,
coit_PrecoUnit											as vl_item_unitario_ped_comp,
cast(null as varchar)										as ds_item_pedido_compra,
null 												as pc_item_descto_ped_compra,
(select top 1 cd_produto from produto where cd_mascara_produto = coit_produto)		 	as cd_produto,
null 												as cd_servico,
null 												as cd_plano_compra,
null 												as cd_categoria_produto,
null 												as cd_ocorrencia,
null 												as cd_cotacao,
null 												as cd_item_cotacao,
null 												as dt_item_nec_ped_compra,
null 												as vl_cambio_item_ped_compra,
null 												as dt_item_cambio_ped_compra,
null 												as cd_moeda,
null 												as dt_item_canc_ped_compra,
null 												as nm_item_motcanc_ped_compr,
null 												as qt_item_pesliq_ped_compra,
null 												as qt_item_pesbr_ped_compra,
null 												as cd_pedido_venda,
null 												as cd_item_pedido_venda,
null 												as qt_item_entrada_ped_compr,
null 												as cd_centro_custo,
4 												as cd_usuario,
getdate() 											as dt_usuario,
null 												as nm_item_prodesp_ped_compr,
isnull((select top 1 cd_unidade_medida from Unidade_Medida where sg_unidade_medida = coit_Unidade),12) 	as cd_unidade_medida,
null 												as nm_item_ativ_ped_compra,
null 												as dt_item_ativ_ped_compra,
null 												as cd_maquina,
'N' 												as ic_produto_especial,
'P' 												as ic_pedido_compra_item,
cast(coit_Discriminacao as varchar(30))								as nm_fantasia_produto,
cast(coit_Discriminacao as varchar(50))								as nm_produto,
null 												as pc_ipi,
null 												as qt_dia_entrega_item_ped,
null 												as cd_os_pedido_compra,
null 												as cd_posicao_pedido_compra,
cast(null as varchar)										as ds_observacao_fabrica,
null 												as nm_marca_item_pedido,
null 												as cd_mascara_produto,
cast(null as varchar)										as ds_obs_pedido_compra,
null 												as ic_aprov_comprador_pedido,
null 												as cd_plano_financeiro,
null 												as cd_materia_prima,
null 												as cd_mascara_classificacao,
null 												as cd_classificacao_fiscal,
null 												as pc_icms,
null 												as pc_red_icms,
null 												as vl_total_item_pedido_comp,
null 												as nm_placa,
null 												as qt_espesbruta_Mat_prima,
null 												as qt_largbruta_Mat_prima,
null 												as qt_compbruta_Mat_prima,
null 												as ic_redondo_Mat_prima,
null 												as cd_tipo_placa,
null 												as qt_espesacab_mat_prima,
null 												as qt_largacab_mat_prima,
null 												as qt_compacab_mat_prima,
null 												as qt_tolespesacab_mat_prima,
null 												as qt_tolcompacab_mat_prima,
null 												as vl_fornecedor_moeda,
null 												as vl_convertido_moeda,
null 												as cd_veiculo,
null 												as ic_fluxo_caixa,
null 												as dt_fluxo_caixa,
null 												as dt_zera_saldo_pedido_item,
null 												as cd_desenho_item_pedido,
null 												as cd_rev_des_item_pedido,
null 												as qt_area_produto,
null 												as cd_lote_item_pedido,
null 												as cd_contrato_compra,
null 												as vl_ipi_item_pedido_compra,
null 												as vl_icms_item_pedido_compra,
null 												as vl_unitario_ipi_produto,
null 												as ic_item_bonificacao,
null 												as ic_ordrec_pedido_compra

into
  #Pedido_Compra_Item
from
  db_altamira.dbo.CO_ITEMPEDIDO

insert into
  pedido_compra_item
select
  *
from
  #Pedido_Compra_Item


--Mostra os registros migrados

select * from Pedido_Compra_Item

--Deleção da Tabela Temporária

drop table #Pedido_Compra
drop table #Pedido_Compra_Item

