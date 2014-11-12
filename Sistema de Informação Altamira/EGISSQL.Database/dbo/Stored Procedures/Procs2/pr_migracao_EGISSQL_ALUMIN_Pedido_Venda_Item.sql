
-------------------------------------------------------------------------------
--pr_migracao_EGISSQL_ALUMIN_Pedido_Venda_Item
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Daniel C. Neto.
--Banco de Dados   : EGISSQL_ALUMIN
--Objetivo         : Migração da Tabela de Pedido_Venda_Item
--Data             : 14/09/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_EGISSQL_ALUMIN_Pedido_Venda_Item
as

--Deleta todos os registro da tabela Pedido_Venda_Item
select * into #tabbackup from Pedido_Venda_Item

delete Pedido_Venda_Item

select
 cast(PEDIDO as int)                                        as cd_pedido_venda,

 cast(SEQUENCIA as int)                                     as cd_item_pedido_venda,
 cast(NULL as datetime)                                     as dt_item_pedido_venda,
 cast(QTE_VENDA as float)                                   as qt_item_pedido_venda,
 cast(QTE_VENDA - IsNull(QTE_ENV,0) as float)               as qt_saldo_pedido_venda,
 cast(PRAZO_ENTREGA as datetime)                            as dt_entrega_vendas_pedido,
 cast(DATA_INI_PRODUCAO as datetime)                        as dt_entrega_fabrica_pedido,
 cast(null as text)                                         as ds_produto_pedido_venda,
 cast(PRECO_UN as float)                                    as vl_unitario_item_pedido,
 cast(null as float)                                        as vl_lista_item_pedido,
 cast(null as float)                                        as pc_desconto_item_pedido,
 cast(null as datetime)                                     as dt_cancelamento_item,
 cast(null as datetime)                                     as dt_estoque_item_pedido,
 cast(null as varchar(40))                                  as cd_pdcompra_item_pedido,
 cast(null as datetime)                                     as dt_reprog_item_pedido,
 cast(PESO_LIQ as float)                                    as qt_liquido_item_pedido,
 cast(PESO_BRU as float)                                    as qt_bruto_item_pedido,
 cast(null as char(1))                                      as ic_fatura_item_pedido,
 cast(null as char(1))                                      as ic_reserva_item_pedido,
 cast(null as char(1))                                      as ic_tipo_montagem_item,
 cast(null as char(1))                                      as ic_montagem_g_item_pedido,
 cast(null as char(1))                                      as ic_subs_tributaria_item,
 cast(null as varchar(15))                                  as cd_posicao_item_pedido,
 cast(null as varchar(15))                                  as cd_os_tipo_pedido_venda,
 cast(null as char(1))                                      as ic_desconto_item_pedido,
 cast(null as datetime)                                     as dt_desconto_item_pedido,
 cast(null as float)                                        as vl_indice_item_pedido,
 cast(null as int)                                          as cd_grupo_produto,
 cast(PRODUTO as int)                                       as cd_produto,
 cast(null as int)                                          as cd_grupo_categoria,
 cast(null as int)                                          as cd_categoria_produto,
 cast(null as int)                                          as cd_pedido_rep_pedido,
 cast(null as int)                                          as cd_item_pedidorep_pedido,
 cast(null as int)                                          as cd_ocorrencia,
 cast(null as int)                                          as cd_consulta,
 99                                                         as cd_usuario,
 GetDate()                                                  as dt_usuario,
 cast(null as varchar(60))                                  as nm_mot_canc_item_pedido,
 cast(null as varchar(40))                                  as nm_obs_restricao_pedido,
 cast(null as int)                                          as cd_item_consulta,
 cast(null as char(1))                                      as ic_etiqueta_emb_pedido,
 cast(IPI as float)                                         as pc_ipi_item,
 cast(ICM as float)                                         as pc_icms_item,
 cast(null as float)                                        as pc_reducao_base_item,
 cast(null as datetime)                                     as dt_necessidade_cliente,
 cast(null as int)                                          as qt_dia_entrega_cliente,
 cast(PRAZO_ENTREGA as datetime)                            as dt_entrega_cliente,
 cast(null as char(1))                                      as ic_smo_item_pedido_venda,
 cast(null as int)                                          as cd_om,
 cast(null as char(1))                                      as ic_controle_pcp_pedido,
 cast(null as varchar(40))                                  as nm_mat_canc_item_pedido,
 cast(null as int)                                          as cd_servico,
 cast(null as char(1))                                      as ic_produto_especial,
 cast(null as varchar(30))                                  as cd_produto_concorrente,
 cast(null as char(1))                                      as ic_orcamento_pedido_venda,
 cast(null as text)                                         as ds_produto_pedido,
 ( SELECT TOP 1 NM_PRODUTO
   FROM PRODUTO
   WHERE CD_PRODUTO = PRODUTO )                             as nm_produto_pedido,
 cast(null as int)                                          as cd_serie_produto,
 cast(IPI as float)                                         as pc_ipi,
 cast(ICM as float)                                         as pc_icms,
 cast(null as float)                                        As qt_dia_entrega_pedido,
 cast(null as char(1))                                      as ic_sel_fechamento,
 cast(null as datetime)                                     as dt_ativacao_item,
 cast(null as varchar(60))                                  as nm_mot_ativ_item_pedido,
 ( SELECT TOP 1 NM_FANTASIA_PRODUTO
   FROM PRODUTO
   WHERE CD_PRODUTO = PRODUTO )                             as nm_fantasia_produto,
 cast(null as char(1))                                      as ic_etiqueta_emb_ped_venda,
 cast(DATA_EFE as datetime)                                  as dt_fechamento_pedido,
 cast(null as text)                                         as ds_progfat_pedido_venda,
 cast(null as char(1))                                      as ic_pedido_venda_item,
 cast(null as char(1))                                      as ic_ordsep_pedido_venda,
 cast(null as char(1))                                      as ic_progfat_item_pedido,
 cast(null as float)                                        as qt_progfat_item_pedido,
 cast(null as int)                                          as cd_referencia_produto,
 cast(null as char(1))                                      as ic_libpcp_item_pedido,
 cast(null as text)                                         As ds_observacao_fabrica,
 cast(null as varchar(40))                                  as nm_observacao_fabrica1,
 cast(null as varchar(40))                                  As nm_observacao_fabrica2,
 cast(null as int)                                          as cd_unidade_medida,
 cast(null as float)                                        as pc_reducao_icms,
 cast(null as float)                                        as pc_desconto_sobre_desc,
 cast(null as varchar(40))                                  as nm_desconto_item_pedido,
 cast(null as int)                                          as cd_item_contrato,
 cast(null as int)                                          as cd_contrato_fornecimento,
 cast(null as varchar(30))                                  as nm_kardex_item_ped_venda,
 cast(null as char(1))                                      as ic_gprgcnc_pedido_venda,
 cast(null as int)                                          as cd_pedido_importacao,
 cast(null as int)                                          as cd_item_pedido_importacao,
 cast(null as datetime)                                     as dt_progfat_item_pedido,
 cast(null as float)                                        as qt_cancelado_item_pedido,
 cast(null as float)                                        as qt_ativado_pedido_venda,
 cast(null as int)                                          as cd_mes,
 cast(null as int)                                          as cd_ano,
 cast(null as char(1))                                      as ic_mp66_item_pedido,
 cast(null as char(1))                                      as ic_montagem_item_pedido,
 cast(null as char(1))                                      as ic_reserva_estrutura_item,
 cast(null as char(1))                                      as ic_estrutura_item_pedido,
 cast(null as float)                                        As vl_frete_item_pedido,
 cast(null as int)                                          as cd_usuario_lib_desconto,
 cast(null as datetime)                                     as dt_moeda_cotacao,
 cast(null as float)                                        as vl_moeda_cotacao,
 cast(null as int)                                          as cd_moeda_cotacao,
 cast(null as datetime)                                     as dt_zera_saldo_pedido_item,
 cast(null as int)                                          as cd_lote_produto,
 cast(null as varchar(30))                                  As cd_num_serie_item_pedido,
 cast(null as varchar(25))                                  as cd_lote_item_pedido,
 cast(null as char(1))                                      as ic_controle_mapa_pedido,
 cast(null as int)                                          as cd_tipo_embalagem,
 cast(null as datetime)                                     as dt_validade_item_pedido,
 cast(null as int)                                          as cd_movimento_caixa,
 cast(null as float)                                        as vl_custo_financ_item,
 cast(null as int)                                          as qt_garantia_item_pedido,
 cast(null as int)                                          as cd_tipo_montagem,
 cast(null as int)                                          as cd_montagem,
 cast(null as int)                                          as cd_usuario_ordsep,
 cast(null as char(1))                                       as ic_kit_grupo_produto,
 cast(null as int)                                          as cd_sub_produto_especial,
 cast(null as int)                                          as cd_plano_financeiro,
 cast(null as datetime)                                     as dt_fluxo_caixa,
 cast(null as char(1))                                      as ic_fluxo_caixa,
 cast(null as text)                                         as ds_servico_item_pedido,
 cast(null as datetime)                                     as dt_reservado_montagem,
 cast(null as int)                                          as cd_usuario_montagem,
 cast(null as char(1))                                      as ic_imediato_produto,
 cast(null as char(10))                                     as cd_mascara_classificacao
into
  #Pedido_Venda_Item
from
  Alumin_Interbase.dbo.vritens 
where PEDIDO in ( select cast(cd_pedido_venda as int) from pedido_venda )

insert into
  Pedido_Venda_Item
select
  * 
from
  #Pedido_Venda_Item

drop table #Pedido_Venda_Item

select * from Pedido_Venda_Item

