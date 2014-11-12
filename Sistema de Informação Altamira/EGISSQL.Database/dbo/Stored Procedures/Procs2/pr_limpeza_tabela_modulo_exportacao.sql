
-------------------------------------------------------------------------------
--pr_limpeza_tabela_modulo_exportacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Limpeza da Tabela para Utilização do Módulo de Exportação
--                   
--Data             : 29.11.2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_limpeza_tabela_modulo_exportacao

as

--Pedido de Venda Exportação

--Item do Pedido de Venda
delete from pedido_venda_item
delete from pedido_venda_item_acessorio
delete from pedido_venda_item_desconto
delete from pedido_venda_item_embalagem
delete from pedido_venda_item_grade
delete from pedido_venda_item_historico_custo
delete from pedido_venda_item_lote
delete from pedido_venda_item_observacao
delete from pedido_venda_item_smo
delete from pedido_venda_parcela
delete from pedido_venda_programacao
delete from pedido_venda_smo

--Pedido de Venda
delete from pedido_venda
delete from pedido_venda_agrupamento
delete from pedido_venda_comissao
delete from pedido_venda_composicao
delete from pedido_venda_cond_pagto
delete from pedido_venda_documento
delete from pedido_venda_exportacao
delete from pedido_venda_historico
delete from pedido_venda_impressao

--Pedido Exportação

delete from pedido_exportacao_contabil
delete from pedido_exportacao_documento
delete from pedido_exportacao_financeiro


--Embarque Exportação

delete from embarque_comissao
delete from embarque_contabil
delete from embarque_despesa
delete from embarque_financeiro
delete from embarque_item
delete from embarque_parcela
delete from embarque

--Documentos a Receber

delete from documento_receber_centro_custo
delete from documento_receber_contabil
delete from documento_receber_desconto
delete from documento_receber_historico
delete from documento_receber_pagamento
delete from documento_receber_plano_financ
delete from documento_receber


