
-------------------------------------------------------------------------------
--sp_helptext pr_migracao_altamira_orcamento
-------------------------------------------------------------------------------
--pr_migracao_altamira_orcamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 20.01.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_orcamento
as

--somente a primeira vez

delete from Consulta_Cond_Pagto
delete from Consulta_Item_Perda
delete from Consulta_Item_Observacao
delete from Consulta_Item_Orcamento
delete from Consulta_Parcela
delete from Consulta_Itens_Grade
delete from Consulta_Itens_Desconto
delete from Consulta_Itens_Acessorio
delete from Consulta_Caract_Tecnica_CQ
delete from Consulta_Item_Orcamento_Categoria
delete from Consulta_Item_Componente
delete from Consulta_Item_Servico_Externo
delete from Consulta_Documento
delete from Consulta_Item_Composicao
delete from Consulta_Negociacao
delete from Consulta_Item_Embalagem
delete from Consulta_Item_Orcamento_Bucha_Coluna
delete from Consulta_Item_Orcamento_Furo
delete from Consulta_Item_Orcamento_Furo_Adicional
delete from Consulta_Item_Orcamento_Refrigeracao
delete from Consulta_Item_Orcamento_Servico_Manual
delete from Consulta_Item_Orcamento_Alojamento
delete from Consulta_Item_Texto
delete from Consulta_Contato
delete from Consulta_Item_Lote
delete from Consulta_Historico
delete from Consulta_Exportacao
delete from Consulta_Item_REPNET
delete from Consulta_Item_Orcamento_Proposta
delete from Consulta_Item_Estampo
delete from Consulta_Cliente_Origem
delete from Consulta_Revisao
delete from Consulta_Item_Montagem
delete from Consulta_Etapa_Proposta
delete from Consulta_Itens
delete from Consulta

--SELECT * FROM WBCCAD.dbo.orccab where cast(orcnum as int ) = 55960
--SELECT * FROM WBCCAD.dbo.orccab where orcnum = '00055960'

--select * from vendedor
--select * from cliente

select
  identity(int,1,1)          as cd_consulta,
  --cast(ORCNUM as int )     as cd_consulta,
--  w.ORCALTDTH                as dt_consulta,
  convert(datetime,left(convert(varchar,w.ORCALTDTH,121),10)+' 00:00:00',121) as dt_consulta,
  c.cd_cliente,
  1                        as cd_vendedor_interno,
  cast(REPCOD as int)      as cd_vendedor,
  null                     as cd_contato,
  1                        as cd_tipo_local_entrega,
  ORCVALVND                as vl_total_consulta,
  'N'                      as ic_operacao_triangular,
  getdate()                as dt_alteracao_consulta,
  1                        as cd_tipo_endereco,
  null                     as cd_pedido_compra_consulta,
  'N'                      as ic_fax_consulta,
  'N'                      as ic_email_consulta,
  c.cd_transportadora,
  c.cd_destinacao_produto,

  cast( CLINOM+' '+CLICON+' '+TIPMONCOD as varchar)+' '+
  cast(PGTCOD as varchar(8000))  as ds_observacao_consulta,

  'N'                      as ic_fatsmo_consulta,
  null                     as hr_inicial_consulta,
  null                     as hr_final_consulta,
  cast(null as varchar)    as ds_obs_fat_consulta,
  null                     as cd_consulta_assinatura,
  null                     as cd_consulta_representante,
  1                        as cd_moeda,
  getdate()                as dt_cambio_consulta,
  4                        as cd_usuario,
  getdate()                as dt_usuario,
  1                        as cd_tipo_pagamento_frete,
  null                     as vl_custo_financeiro,
  'N'                      as ic_custo_financeiro,
  null                     as cd_cliente_fatura,
  null                     as cd_cliente_entrega,
  isnull(c.cd_condicao_pagamento,1)  as cd_condicao_pagamento,
  null                     as cd_usuario_atendente,
  'S'                      as ic_vendedor_interno,
  null                     as vl_tx_mensal_cust_fin,
  'N'                      as ic_fechada_consulta,
  'N'                      as ic_fechamento_total,
  'N'                      as ic_outro_cliente,
  'N'                      as ic_pedido_venda,
  'N'                      as ic_digitacao,
  'N'                      as ic_transf_matriz,
  null                     as cd_representante,
   1                       as cd_status_proposta,
  null                     as nm_assina_consulta,
  null                     as vl_total_ipi,
  'N'                      as ic_obs_corpo_nf,
--  convert(datetime,left(convert(varchar,w.ORCALTDTH,121),10)+' 00:00:00',121) as dt_fechamento_consulta,
  null                     as dt_fechamento_consulta,
  1                        as cd_tipo_entrega_produto,
  cast(w.ORCNUM as varchar)  as nm_referencia_consulta,
  null                     as cd_tipo_atendimento,
  1                        as cd_tipo_proposta,
  null                     as cd_tipo_restricao_pedido,
  'N'                      as ic_permite_agrupar_pedido,
  null                     as vl_sedex_consulta,
  null                     as pc_desconto_consulta,
  'N'                      as ic_consignacao_consulta,
  'N'                      as ic_amostra_consulta,
  null                     as nm_contato_op_triang_con,
  'N'                      as ic_credito_icms_consulta,
  null                     as dt_validade_consulta,
  null                     as vl_cambio_consulta,
  null                     as cd_exportador,
  null                     as nm_titulo_consulta,
  null                     as cd_loja,
  1                        as cd_idioma,
  null                     as cd_aplicacao_produto,
  'N'                      as ic_bloqueio_credito,
  'N'                      as ic_entrega_futura,
  convert(datetime,left(convert(varchar,w.ORCALTDTH,121),10)+' 00:00:00',121) as dt_entrada_consulta,
  'N'                      as ic_bloqueio_licenca,
  null                     as cd_licenca_bloqueada,
  null                     as cd_cliente_origem,
  null                     as cd_projeto_mercado,
  null                     as cd_fase_proposta,
  'N'                      as ic_bonificacao_consulta,
  ORCPERCOM                as pc_comissao_consulta

into
  #Consulta

from
  WBCCAD.dbo.ORCCAB w
  inner join WBCCAD.dbo.ORCSIT s on s.ORCNUM = w.ORCNUM
  left outer join cliente c      on  c.nm_razao_social_cliente = cast(w.CLINOM as varchar(45))

where
--  s.ORCNUM not in ( select nm_referencia_consulta from consulta )
--  and
  s.SITCOD = '60'
  or
  s.SITCOD = '61'
 
insert into
  consulta
select
  *
from
  #Consulta

--select * from WBCCAD.dbo.ORCPRD 
--select * from WBCCAD.dbo.ORCITM
-- select GRPCOD from WBCCAD.dbo.ORCITM
-- group by
--  GRPCOD
-- order by
--   GRPCOD

select

  c.cd_consulta,
  --o.ORCITM                 as cd_item_consulta,
  identity(int,1,1)        as cd_item_consulta,
  c.dt_consulta            as dt_item_consulta,
  p.cd_grupo_produto,
  p.nm_fantasia_produto,
  null                     as cd_produto_concorrente,
  p.nm_produto             as nm_produto_consulta,
  ORCTXT                   as ds_produto_consulta,
  1                        as qt_item_consulta,
  ORCVAL                   as vl_unitario_item_consulta,
  ORCVAL                   as vl_lista_item_consulta,
  null                     as pc_desconto_item_consulta,
  w.PRZENT                 as qt_dia_entrega_consulta,
  c.dt_consulta + w.PRZENT as dt_entrega_consulta,
  null                     as ic_orcamento_consulta,
  null                     as cd_consulta_matriz,
  null                     as cd_item_consulta_matriz,
  --c.dt_consulta            as dt_fechamento_consulta,
  null                     as dt_fechamento_consulta,
  null                     as dt_orcamento_liberado_con,
  null                     as cd_consulta_representante,
  null                     as cd_item_consulta_represe,
  null                     as cd_pedido_compra_consulta,
  null                     as cd_os_consulta,
  null                     as cd_posicao_consulta,
  null                     as ic_tipo_montagem_consulta,
  null                     as ic_montagem_g_consulta,
  null                     as ic_subs_tributaria_cons,
  null                     as ic_alt_obs_consulta,
  null                     as ic_transmitindo_base,
  null                     as ic_sel_fax_consulta,
  null                     as ic_sel_email_consulta,
  null                     as ic_email_rep_consulta,
  null                     as ic_email_ven_consulta,
  4                        as cd_usuario,
  getdate()                as dt_usuario,
  ORCIPI * 100             as pc_ipi,
  ORCICM * 100             as pc_icms,
  null                     as cd_item_pedido_venda,
  null                     as cd_pedido_venda,
  null                     as cd_motivo_perda,
  'N'                      as ic_produto_especial,
  null                     as dt_perda_consulta_itens,
  'N'                      as ic_sel_fechamento,
  null                     as cd_serie_produto,
  null                     as qt_peso_bruto,
  null                     as qt_peso_liquido,
  null                     as cd_om,
  null                     as ic_item_perda_consulta,
  null                     as cd_servico,
  'P'                      as ic_consulta_item,
  null                     as ic_desconto_consulta_item,
  cast('' as varchar)      as ds_observacao_fabrica,
  p.cd_unidade_medida,
  p.cd_produto,
  null                     as pc_reducao_icms,
  null                     as pc_desconto_sobre_desc,
  cp.cd_grupo_categoria,
  p.cd_categoria_produto,
  null                     as nm_desconto_consulta_item,
  null                     as cd_usuario_liberacao_orc,
  null                     as nm_kardex_item_consulta,
  null                     as ic_orcamento_comercial,
  null                     as ic_orcamento_status,
  null                     as ic_mp66_item_consulta,
  null                     as ic_montagem_item_consulta,
  null                     as cd_produto_padrao_orcam,
  null                     as cd_tipo_serie_produto,
  null                     as ic_ajuste_coord_proporc,
  null                     as ic_coordenada_especial,
  null                     as ic_grupo_maquina_especial,
  null                     as cd_tipo_montagem,
  null                     as cd_montagem,
  null                     as ic_considera_mp_orcamento,
  null                     as vl_frete_item_consulta,
  null                     as vl_orcado_item_consulta,
  null                     as cd_serie_produto_padrao,
  null                     as dt_moeda_cotacao,
  null                     as vl_moeda_cotacao,
  null                     as cd_moeda_cotacao,
  'S'                      as ic_ativo_item,
  null                     as dt_validade_item_consulta,
  null                     as cd_usuario_lib_desconto,
  null                     as dt_desconto_item_consulta,
  null                     as ic_desconto_item_consulta,
  null                     as vl_custo_financ_item,
  null                     as vl_indice_item_consulta,
  w.PRZENT                 as qt_dia_entrega_padrao,
  null                     as cd_lote_item_consulta,
  1                        as cd_idioma,
  'N'                      as ic_kit_grupo_produto,
  null                     as cd_sub_produto_especial,
  'N'                      as ic_imediato_produto,
  null                     as cd_mascara_classificacao,
  null                     as cd_desenho_item_consulta,
  null                     as cd_rev_des_item_consulta,
  null                     as qt_area_produto,
  null                     as vl_digitado_item_desconto,
  null                     as vl_custo_ferramenta,
  null                     as cd_item_cliente,
  null                     as cd_ref_item_cliente,
  null                     as cd_projeto,
  null                     as ic_estoque_fatura,
  null                     as ic_estoque_venda,
  null                     as cd_fase_proposta,
  null                     as ic_status_ativo_item_consulta,
  null                     as cd_produto_servico,
  null                     as ic_baixa_composicao_item

into
  #Consulta_Itens

from

  #Consulta c
  inner join WBCCAD.dbo.ORCCAB w       on w.ORCNUM = c.nm_referencia_consulta
  inner join WBCCAD.dbo.ORCITM o       on o.ORCNUM = w.ORCNUM
  inner join WBCCAD.dbo.ORCSIT s       on s.ORCNUM = w.ORCNUM
  left outer join Produto p            on p.cd_produto              = 
  Case when
    o.GRPCOD = 1 then 2618
  else
    0
  end

  left outer join categoria_produto cp on cp.cd_categoria_produto = p.cd_categoria_produto

  --left outer join cliente c on c.nm_razao_social_cliente = w.CLINOM

where
--  s.ORCNUM not in ( select nm_referencia_consulta from consulta )
--  and
  s.SITCOD = '60'
  or
  s.SITCOD = '61'
  
insert into
  consulta_itens
select
  *
from
  #Consulta_Itens


drop table #Consulta
drop table #Consulta_Itens


select * from consulta
select * from consulta_itens

--select * from consulta where nm_referencia_consulta = '00058108'
--SELECT * FROM WBCCAD.dbo.orccab where cast(orcnum as int ) = 58108
