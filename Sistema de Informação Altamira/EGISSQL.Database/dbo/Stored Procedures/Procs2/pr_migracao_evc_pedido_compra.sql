
-------------------------------------------------------------------------------
--pr_migracao_evc_pedido_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes 
--                   Daniel Carrasco
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Pedido de Compra
--Data             : 29.08.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_evc_pedido_compra
as

--select * from evc.dbo.pedcom
--select * from tipo_pagamento_frete
--select * from tipo_pedido
--select * from status_pedido
--select * from tipo_entrega_produto


delete from pedido_compra_item
delete from pedido_compra

select
  p.Pedido                             as cd_pedido_compra,
  p.Emissao                            as dt_pedido_compra,
  p.Fornecedor                         as cd_fornecedor,
  null                                 as cd_contato_fornecedor,
  p.Comprador                          as cd_comprador,
  null                                 as cd_transportadora,
  'S'                                  as ic_pedido_compra,
  cast(Observacao as varchar)          as ds_pedido_compra,
  2                                    as cd_destinacao_produto,
  3                                    as cd_tipo_pedido,
  1                                    as cd_tipo_endereco,
  1                                    as cd_moeda,
  null                                 as dt_cambio_pedido_compra,
  p.Condicao                           as cd_condicao_pagamento,
  case when p.RECEBIDO='RECEBIDO' 
       then 9
       else 8 end                      as cd_status_pedido,
  null                                 as nm_ref_pedido_compra,
  null                                 as qt_pesoliq_pedido_compra,
  null                                 as qt_pesobruto_pedido_compra,
  p.TotalPed                           as vl_total_pedido_compra,
  null                                 as dt_cancel_ped_compra,
  null                                 as ds_cancel_ped_compra,
  null                                 as dt_ativacao_pedido_compra,
  cast(null as varchar)                as ds_ativacao_pedido_compra,
  p.Emissao                            as dt_nec_pedido_compra,
  null                                 as dt_conf_pedido_compra,
  null                                 as dt_alteracao_ped_compra,
  cast(null as varchar)                as ds_alteracao_ped_compra,
  null                                 as nm_contato_conf_ped_comp,
  null                                 as cd_plano_compra,
  null                                 as cd_centro_custo,
  null                                 as ic_fax_pedido_compra,
  null                                 as ic_email_pedido_compra,
  99                                   as cd_usuario,
  getdate()                            as dt_usuario,
  1                                    as cd_tipo_entrega_produto,
  null                                 as nm_pedfornec_pedido_compr,
  null                                 as qt_pesbruto_pedido_compra,
  null                                 as ic_maquina,
  null                                 as vl_indice_pedido_compra,
  p.TotalPed                           as vl_total_ipi_pedido,
  null                                 as vl_frete_pedido_compra,
  'S'                                  as ic_fechado_pedido_compra,
  p.TotalIPI                           as vl_total_pedido_ipi,
  1                                    as cd_tipo_local_entrega,
  null                                 as cd_aplicacao_produto,
  null                                 as qt_pesobruto_pedido_compr,
  null                                 as cd_plano_financeiro,
  null                                 as cd_fase_produto_contrato,
  null                                 as dt_vcto_pedido_compra,
  null                                 as cd_tipo_comunicacao,
  null                                 as nm_conf_pedido_compra,
  null                                 as cd_departamento,
  null                                 as cd_requisicao_compra,
  1                                    as cd_local_entrega_empresa,
  'S'                                  as ic_aprov_comprador_pedido,
  'N'                                  as ic_consignacao_pedido,
  null                                 as pc_frete_pedido_compra,
  null                                 as pc_custofin_pedido_compra,
  'S'                                  as ic_aprov_pedido_compra,
  null                                 as cd_tipo_produto_espessura,
  null                                 as cd_tipo_alteracao_pedido,
  null                                 as cd_tipo_envio,
  'N'                                  as ic_pedido_gerado_autom,
  null                                 as vl_desconto_pedido_compra,
  null                                 as cd_destino_compra,
  null                                 as cd_opcao_compra,
  null                                 as cd_loja,
  1                                    as cd_tipo_pagamento_frete

into
  #PedidoCompra
from
  evc.dbo.pedcom p

insert into
  Pedido_Compra
select
  *
from
  #PedidoCompra

drop table #PedidoCompra

select * from Pedido_Compra

