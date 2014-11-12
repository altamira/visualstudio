
-------------------------------------------------------------------------------
--sp_helptext pr_migracao_alpha_pedido_venda
-------------------------------------------------------------------------------
--pr_migracao_alpha_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Migração dos Pedidos de Venda
--Data             : 13.12.2007
--Alteração        : 20.12.2007
--
--04.03.2008 - Complemento dos Campos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_migracao_alpha_pedido_venda
as

--select * from egisadmin.dbo.usuario

--Deletar somente a 1a. Vez

-- delete from Pedido_Venda_Item_Historico_Custo
-- delete from Pedido_Venda_Impressao
-- delete from Pedido_Venda_Estrutura_Venda
-- delete from Pedido_Venda_Item_Lote
-- delete from Pedido_Venda_Item_Especial
-- delete from Pedido_Venda_Item_Separacao
-- delete from Pedido_Venda_Item_Observacao
-- delete from Pedido_Venda_Cliente_Origem
-- delete from Pedido_Venda_Parcela
-- delete from Pedido_Venda_Item_SMO
-- delete from Pedido_Venda_Historico
-- delete from Pedido_Venda_Cond_Pagto
-- delete from Pedido_Venda_Item_Embalagem
-- delete from Pedido_Venda_Item_Grade
-- delete from Pedido_Venda_SMO
-- delete from Pedido_Venda_Agrupamento
-- delete from Pedido_Venda_Documento
-- delete from Pedido_Venda_Item_Acessorio
-- delete from Pedido_Venda_Composicao
-- delete from pedido_venda_programacao
-- delete from Pedido_Venda_Item_Desconto
-- delete from Pedido_Venda_Exportacao
-- delete from Pedido_Venda_Item
-- delete from Pedido_Venda

--select * from condicao_pagamento

--montagem de uma tabela auxiliar de produto

select 
  distinct
  cd_cliente_sap,
  max(cd_cliente) as cd_cliente,
  max(cd_pais)    as cd_pais,
  max(cd_estado)  as cd_estado
into
  #clienteAlpha
from
  cliente
where
  isnull(cd_cliente_sap,0)>0

group by
  cd_cliente_sap

-- select
--   *
-- from
--   #clienteAlpha
-- order by
--   cd_cliente_sap


-- select
--   cd_cliente_sap,
--   count(*)
-- from
--   #clienteAlpha
-- group by
--   cd_cliente_sap
-- order by
--   cd_cliente_sap

select
  distinct
  nm_fantasia_antigo,
  0                   as cd_produto
into
  #produto
from
  produto

update
  #produto
set
  cd_produto = x.cd_produto
from
  #produto p 
  inner join produto x on p.nm_fantasia_antigo = x.nm_fantasia_antigo

-- select
--  *
-- from 
--   #produto
-- where
--   nm_fantasia_antigo = 'AW 10/1'  

-- select
--   NRPED,
--   count(*)
-- from
--   migracao.dbo.pd0010
-- group by
--   NRPED

--select * from migracao.dbo.pd0010 order by DTPED DESC
--
--select * from migracao.dbo.pd0011

--select * from pedido_venda_item

--delete from processo_producao_composicao
--delete from processo_producao
--delete from pedido_venda where cd_pedido_venda > 2140
--select * from vendedor

select
  distinct
--  identity(int,1,1)                              as cd_pedido_venda,
  cast( SUBSTRING(p.NRPED,1,4) as int )          as cd_pedido_venda,
  p.DTPED                                        as dt_pedido_venda,
  v.cd_vendedor                                  as cd_vendedor_pedido,
  28                                             as cd_vendedor_interno,
  'S'                                            as ic_emitido_pedido_venda,
  cast(
  rtrim(ltrim(p.ACAB1)) +' '+
  rtrim(ltrim(p.ACAB2)) +' '+
  rtrim(ltrim(p.ACAB3)) +' '+
  rtrim(ltrim(p.ACAB4)) +' '+
  rtrim(ltrim(p.ACAB5)) +' '+
  rtrim(ltrim(p.OB1))   +' '+
  rtrim(ltrim(p.OB2))   +' '+
  rtrim(ltrim(p.OB3))   +' '+
  rtrim(ltrim(p.OB4))   +' '+
  rtrim(ltrim(p.OB5))   +' '+
  rtrim(ltrim(p.OB6))   +' '+
  rtrim(ltrim(p.OB7)) 

  as varchar(8000))                              as ds_pedido_venda,
  cast(null as varchar)                          as ds_pedido_venda_fatura,
  cast(null as varchar)                          as ds_cancelamento_pedido,
  246                                            as cd_usuario_credito_pedido,
  p.DTPED                                        as dt_credito_pedido_venda,
  'N'                                            as ic_smo_pedido_venda,
  0.00                                           as vl_total_pedido_venda,
  null                                           as qt_liquido_pedido_venda,
  null                                           as qt_bruto_pedido_venda,
  null                                           as dt_conferido_pedido_venda,
  'N'                                            as ic_pcp_pedido_venda,
  'N'                                            as ic_lista_pcp_pedido_venda,
  'N'                                            as ic_processo_pedido_venda,
  'N'                                            as ic_lista_processo_pedido,
  'N'                                            as ic_imed_pedido_venda,
  'N'                                            as ic_lista_imed_pedido,
  null                                           as nm_alteracao_pedido_venda,
  'N'                                            as ic_consignacao_pedido,
  null                                           as dt_cambio_pedido_venda,
  null                                           as cd_cliente_entrega,
  p.OPTRIANG                                     as ic_op_triang_pedido_venda,
  null                                           as ic_nf_op_triang_pedido,
  null                                           as nm_contato_op_triang,
  p.NPEDC                                        as cd_pdcompra_pedido_venda,
  null                                           as cd_processo_exportacao,
  c.cd_cliente                                   as cd_cliente,
  null                                           as cd_tipo_frete,
  null                                           as cd_tipo_restricao_pedido,
  case when p.ICM='C' then
   2
  else
   1
  end                                            as cd_destinacao_produto,
  1                                              as cd_tipo_pedido,
  null                                           as cd_transportadora,
  v.cd_vendedor                                  as cd_vendedor,
  1                                              as cd_tipo_endereco,
  1                                              as cd_moeda,
  null                                           as cd_contato,
  246                                            as cd_usuario,
  getdate()                                      as dt_usuario,
  null                                           as dt_cancelamento_pedido,
  2                                              as cd_condicao_pagamento,
  1                                              as cd_status_pedido,
  1                                              as cd_tipo_entrega_produto,
  p.NRPED                                        as nm_referencia_consulta,
  null                                           as vl_custo_financeiro,
  null                                           as ic_custo_financeiro,
  null                                           as vl_tx_mensal_cust_fin,
  2                                              as cd_tipo_pagamento_frete,
  null                                           as nm_assina_pedido,
  null                                           as ic_fax_pedido,
  null                                           as ic_mail_pedido,
  null                                           as vl_total_pedido_ipi,
  null                                           as vl_total_ipi,
  cast(null as varchar)                          as ds_observacao_pedido,
  null                                           as cd_usuario_atendente,
  'N'                                            as ic_fechado_pedido,
  null                                           as ic_vendedor_interno,
  null                                           as cd_representante,
  null                                           as ic_transf_matriz,
  null                                           as ic_digitacao,
  null                                           as ic_pedido_venda,
  null                                           as hr_inicial_pedido,
  null                                           as ic_outro_cliente,
  'N'                                            as ic_fechamento_total,
  'N'                                            as ic_operacao_triangular,
  'N'                                            as ic_fatsmo_pedido,
  cast(null as varchar)                          as ds_ativacao_pedido,
  null                                           as dt_ativacao_pedido,
  cast(null as varchar)                          as ds_obs_fat_pedido,
  null                                           as ic_obs_corpo_nf,
  NULL                                           as dt_fechamento_pedido,
  null                                           as cd_cliente_faturar,
  1                                              as cd_tipo_local_entrega,
  null                                           as ic_etiq_emb_pedido_venda,
  null                                           as cd_consulta,
  null                                           as dt_alteracao_pedido_venda,
  null                                           as ic_dt_especifica_ped_vend,
  null                                           as ic_dt_especifica_consulta,
  null                                           as ic_fat_pedido_venda,
  null                                           as ic_fat_total_pedido_venda,
  null                                           as qt_volume_pedido_venda,
  null                                           as qt_fatpbru_pedido_venda,
  null                                           as ic_permite_agrupar_pedido,
  null                                           as qt_fatpliq_pedido_venda,
  ( select top 1  ep.pc_aliquota_icms_estado 
  from estado_parametro ep
  where ep.cd_pais   = c.cd_pais and
        ep.cd_estado = c.cd_estado )             as vl_indice_pedido_venda, --icms temporário
  null                                           as vl_sedex_pedido_venda,
  null                                           as pc_desconto_pedido_venda,
  null                                           as pc_comissao_pedido_venda,
  null                                           as cd_plano_financeiro,
  cast(null as varchar)                          as ds_multa_pedido_venda,
  null                                           as vl_freq_multa_ped_venda,
  null                                           as vl_base_multa_ped_venda,
  null                                           as pc_limite_multa_ped_venda,
  null                                           as pc_multa_pedido_venda,
  null                                           as cd_fase_produto_contrato,
  null                                           as nm_obs_restricao_pedido,
  null                                           as cd_usu_restricao_pedido,
  null                                           as dt_lib_restricao_pedido,
  null                                           as nm_contato_op_triang_ped,
  null                                           as ic_amostra_pedido_venda,
  null                                           as ic_alteracao_pedido_venda,
  null                                           as ic_calcula_sedex,
  null                                           as vl_frete_pedido_venda,
  null                                           as ic_calcula_peso,
  null                                           as ic_subs_trib_pedido_venda,
  null                                           as ic_credito_icms_pedido,
  null                                           as cd_usu_lib_fat_min_pedido,
  null                                           as dt_lib_fat_min_pedido,
  null                                           as cd_identificacao_empresa,
  null                                           as pc_comissao_especifico,
  null                                           as dt_ativacao_pedido_venda,
  null                                           as cd_exportador,
  null                                           as ic_atualizar_valor_cambio_fat,
  null                                           as cd_tipo_documento,
  null                                           as cd_loja,
  null                                           as cd_usuario_alteracao,
  null                                           as ic_garantia_pedido_venda,
  null                                           as cd_aplicacao_produto,
  null                                           as ic_comissao_pedido_venda,
  null                                           as cd_motivo_liberacao,
  null                                           as ic_entrega_futura,
  null                                           as modalidade,
  null                                           as modalidade1,
  null                                           as cd_modalidade,
  null                                           as cd_pedido_venda_origem,
  p.DTPED                                        as dt_entrada_pedido,
  null                                           as dt_cond_pagto_pedido,
  null                                           as cd_usuario_cond_pagto_ped,
  null                                           as vl_credito_liberacao,
  null                                           as vl_credito_liberado,
  null                                           as cd_centro_custo,
  null                                           as ic_bloqueio_licenca,
  null                                           as cd_licenca_bloqueada,
  null                                           as nm_bloqueio_licenca,
  null                                           as dt_bloqueio_licenca,
  null                                           as cd_usuario_bloqueio_licenca,
  null                                           as vl_mp_aplicacada_pedido,
  null                                           as vl_mo_aplicada_pedido,
  null                                           as cd_usuario_impressao,
  null                                           as cd_cliente_origem,
  null                                           as cd_situacao_pedido,
--  null                                           as qt_total_item_pedido

  ( select count(*) 
    from
     migracao.dbo.pd0011 
    where
      NRPED = p.NRPED )                         as qt_total_item_pedido


--select * from pedido_venda

into
  #Pedido_Venda

from
  migracao.dbo.pd0010 p

  left outer join vendedor v            on v.sg_vendedor = cast(p.VEND as varchar)

  --left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = 
  --left outer join migracao.dbo.cl0010 cl on cl.CODIGO = p.
  left outer join #ClienteAlpha c       on c.cd_cliente_sap = p.CDCLIEN

--  left outer join cliente c             on c.cd_cliente_sap = a.cd_cliente_sap
                                           
where
  year(p.dtped)=2008         and
  SUBSTRING(NRPED,6,2)='08'  and
  cast( SUBSTRING(p.NRPED,1,4) as int ) not in ( select cd_pedido_venda from pedido_venda )
--   AND 
--   NRPED = '0842/07'


--select * from estado_parametro
--select * from vendedor order by sg_vendedor

-- SELECT 
-- * FROM #PEDIDO_VENDA order by cd_pedido_venda

-- SELECT 
--   cd_pedido_venda,count(*)
--  FROM #PEDIDO_VENDA 
-- group by cd_pedido_venda
-- order by 
--  2


-- AND
--   NRPED = '2092/07'

--select * from migracao.dbo.cl0010 order by codigo

insert into
  Pedido_Venda
select
  *
from
  #Pedido_Venda
where
  cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda )
order by
  cd_pedido_venda


--select * from transportadora
--select * from cliente where cd_cliente_sap = 391
--select * from cliente where cd_cliente = 4339
--select * from migracao.dbo.cl0010 where codigo = 5336
--select * from condicao_pagamento
--select * from condicao_pagamento_parcela order by qt_dia_cond_parcela_pgto,pc_condicao_parcela_pgto


select
  p.cd_pedido_venda                              as cd_pedido_venda,
  identity(int,1,1)                              as cd_item_pedido,
  --0                                              as cd_item_pedido_venda,
  p.dt_pedido_venda                              as dt_item_pedido_venda,
  i.QTD                                          as qt_item_pedido_venda,
  i.QTD                                          as qt_saldo_pedido_venda,
  x.DTPRZ                                        as dt_entrega_vendas_pedido,
  x.DTPRZ                                        as dt_entrega_fabrica_pedido,
  cast( COD +' '+DESCR2+' '+DESCRN   as varchar) as ds_produto_pedido_venda,
  i.PRVEN                                        as vl_unitario_item_pedido,
  i.PRVEN                                        as vl_lista_item_pedido,
  null                                           as pc_desconto_item_pedido,
  null                                           as dt_cancelamento_item,
  p.dt_pedido_venda                              as dt_estoque_item_pedido,
  p.cd_pdcompra_pedido_venda                     as cd_pdcompra_item_pedido,
  null                                           as dt_reprog_item_pedido,
  null                                           as qt_liquido_item_pedido,
  null                                           as qt_bruto_item_pedido,
  null                                           as ic_fatura_item_pedido,
  null                                           as ic_reserva_item_pedido,
  null                                           as ic_tipo_montagem_item,
  null                                           as ic_montagem_g_item_pedido,
  null                                           as ic_subs_tributaria_item,
  null                                           as cd_posicao_item_pedido,
  null                                           as cd_os_tipo_pedido_venda,
  null                                           as ic_desconto_item_pedido,
  null                                           as dt_desconto_item_pedido,
  null                                           as vl_indice_item_pedido,
  prod.cd_grupo_produto,
  prod.cd_produto,
  prod.cd_grupo_categoria,
  prod.cd_categoria_produto,
  null                                           as cd_pedido_rep_pedido,
  null                                           as cd_item_pedidorep_pedido,
  null                                           as cd_ocorrencia,
  null                                           as cd_consulta,
  246       as cd_usuario,
  getdate() as dt_usuario,
  null                                           as nm_mot_canc_item_pedido,
  null                                           as nm_obs_restricao_pedido,
  null                                           as cd_item_consulta,
  null                                           as ic_etiqueta_emb_pedido,
  i.IPI     as pc_ipi_item,
  p.vl_indice_pedido_venda                       as pc_icms_item,
  null                                           as pc_reducao_base_item,
  null                                           as dt_necessidade_cliente,
  null                                           as qt_dia_entrega_cliente,
  null                                           as dt_entrega_cliente,
  null                                           as ic_smo_item_pedido_venda,
  null                                           as cd_om,
  null                                           as ic_controle_pcp_pedido,
  null                                           as nm_mat_canc_item_pedido,
  null                                           as cd_servico,
  'N' as ic_produto_especial,
  null                                           as cd_produto_concorrente,
  null                                           as ic_orcamento_pedido_venda,
  cast(null as varchar)                          as ds_produto_pedido,
  i.DESCRN                                       as nm_produto_pedido,
  null                                           as cd_serie_produto,
  i.IPI                                          as pc_ipi,
  p.vl_indice_pedido_venda                       as pc_icms,
  null                                           as qt_dia_entrega_pedido,
  null                                           as ic_sel_fechamento,
  null                                           as dt_ativacao_item,
  null                                           as nm_mot_ativ_item_pedido,
  i.COD                                          as nm_fantasia_produto,
  null                                           as ic_etiqueta_emb_ped_venda,
  p.dt_pedido_venda                              as dt_fechamento_pedido,
  cast('' as varchar)                            as ds_progfat_pedido_venda,
  'P'                                            as ic_pedido_venda_item,
  null                                           as ic_ordsep_pedido_venda,
  null                                           as ic_progfat_item_pedido,
  null                                           as qt_progfat_item_pedido,
  null                                           as cd_referencia_produto,
  null                                           as ic_libpcp_item_pedido,
  cast('' as varchar)                            as ds_observacao_fabrica,
  null                                           as nm_observacao_fabrica1,
  null                                           as nm_observacao_fabrica2,
  prod.cd_unidade_medida,
  null                                           as pc_reducao_icms,
  null                                           as pc_desconto_sobre_desc,
  null                                           as nm_desconto_item_pedido,
  null                                           as cd_item_contrato,
  null                                           as cd_contrato_fornecimento,
  null                                           as nm_kardex_item_ped_venda,
  null                                           as ic_gprgcnc_pedido_venda,
  null                                           as cd_pedido_importacao,
  null                                           as cd_item_pedido_importacao,
  null                                           as dt_progfat_item_pedido,
  null                                           as qt_cancelado_item_pedido,
  null                                           as qt_ativado_pedido_venda,
  null                                           as cd_mes,
  null                                           as cd_ano,
  null                                           as ic_mp66_item_pedido,
  null                                           as ic_montagem_item_pedido,
  null                                           as ic_reserva_estrutura_item,
  null                                           as ic_estrutura_item_pedido,
  null                                           as vl_frete_item_pedido,
  null                                           as cd_usuario_lib_desconto,
  null                                           as dt_moeda_cotacao,
  null                                           as vl_moeda_cotacao,
  null                                           as cd_moeda_cotacao,
  null                                           as dt_zera_saldo_pedido_item,
  null                                           as cd_lote_produto,
  null                                           as cd_num_serie_item_pedido,
  null                                           as cd_lote_item_pedido,
  null                                           as ic_controle_mapa_pedido,
  null                                           as cd_tipo_embalagem,
  null                                           as dt_validade_item_pedido,
  null                                           as cd_movimento_caixa,
  null                                           as vl_custo_financ_item,
  null                                           as qt_garantia_item_pedido,
  null                                           as cd_tipo_montagem,
--  identity(int,1,1)                              as cd_montagem,
  null as cd_montagem,
  null                                           as cd_usuario_ordsep,
  null                                           as ic_kit_grupo_produto,
  null                                           as cd_sub_produto_especial,
  null                                           as cd_plano_financeiro,
  null                                           as dt_fluxo_caixa,
  null                                           as ic_fluxo_caixa,
  cast('' as varchar)                            as ds_servico_item_pedido,
  null                                           as dt_reservado_montagem,
  null                                           as cd_usuario_montagem,
  null                                           as ic_imediato_produto,
  null                                           as cd_mascara_classificacao,
  null                                           as cd_desenho_item_pedido,
  null                                           as cd_rev_des_item_pedido,
  null                                           as cd_centro_custo,
  null                                           as qt_area_produto,
  null                                           as cd_produto_estampo,
  null                                           as vl_digitado_item_desconto,
  null                                           as cd_lote_Item_anterior,
  null                                           as cd_programacao_entrega,
  null                                           as ic_estoque_fatura,
  null                                           as ic_estoque_venda,
  null                                           as ic_manut_mapa_producao,
  null                                           as pc_comissao_item_pedido,
  null                                           as cd_produto_servico

--select * from pedido_venda_item

into
  #pedido_venda_item
from
  migracao.dbo.pd0011 i
  inner join pedido_venda p        on SUBSTRING(p.nm_referencia_consulta,1,7) = SUBSTRING(i.NRPED,1,7)
  inner join migracao.dbo.pd0010 x on SUBSTRING(x.NRPED,1,7)                  = SUBSTRING(i.NRPED,1,7)
  left outer join #produto px      on px.nm_fantasia_antigo                 = i.COD
  left outer join produto prod     on prod.cd_produto = px.cd_produto
where
  p.cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda_item )

--  where
--   SUBSTRING(p.nm_referencia_consulta,1,7)  = '2092/07'


--select * from #pedido_venda      

--numera os itens do pedido de venda

declare @cd_pedido_venda         int
declare @cd_item_pedido_venda    int

-- select
--   *
-- into
--   #auxitempedido 
-- from
--  #pedido_venda_item
-- 
-- declare @qt_total_item int
-- 
-- while exists ( select top 1 cd_pedido_venda from #auxitempedido )
-- begin
-- 
--   select top 1
--     @cd_pedido_venda      = cd_pedido_venda
--   from
--     #Auxitempedido
-- 
--   print @cd_pedido_venda
-- 
--   set @qt_total_item = 1
-- 
--   while exists( select top 1 cd_pedido_venda from #auxitempedido where cd_pedido_venda = @cd_pedido_venda )
--   begin
-- 
--     select top 1
--       @cd_pedido_venda      = cd_pedido_venda,
--       @cd_item_pedido_venda = cd_montagem
--     from
--       #Auxitempedido
-- 
--     update
--       #pedido_venda_item
--     set
--       cd_item_pedido_venda = @qt_total_item
--     where
--       cd_pedido_venda      = @cd_pedido_venda and
--       cd_item_pedido_venda = @cd_item_pedido_venda
-- 
--     set @qt_total_item     = @qt_total_item + 1
-- 
--     delete from #auxitempedido where       cd_pedido_venda      = @cd_pedido_venda and
--                                            cd_montagem          = @cd_item_pedido_venda
-- 
--   end
--   
-- end

--select * from #pedido_venda_item


-- Declare @cd_pedido_venda      int
-- Declare @cd_pedido_venda_item int
-- 
-- while exists(Select top 1 * from #pedido_venda_item)
-- begin
--   Select top 1  
--     @cd_pedido_venda      = cd_pedido_venda, 
--     @cd_pedido_venda_item = cd_item_pedido_venda 
--   from
--     #pedido_venda_item
-- 
--    print 'Pedido: ' + cast(@cd_pedido_venda as varchar)
-- 
-- 	insert into
-- 	  Pedido_Venda_Item
-- 	select
-- 	top 1  * 
-- 	from
-- 	  #pedido_venda_item
-- 	where @cd_pedido_venda = cd_pedido_venda and @cd_pedido_venda_item = cd_item_pedido_venda
-- 
-- 	Print 'Delete->'	+ cast(@cd_pedido_venda as varchar)
-- 
-- 	Delete from #pedido_venda_item where @cd_pedido_venda = cd_pedido_venda and @cd_pedido_venda_item = cd_item_pedido_venda
-- 
-- end
-- 
                              
insert into
  pedido_venda_item
select
  *
from
  #pedido_venda_item

update 
  pedido_venda 
set 
  vl_total_pedido_venda = ( 
    Select 
      isnull( Sum( isnull(qt_item_pedido_venda,0) * isnull(vl_unitario_item_pedido,0) ),0) 
    from
      Pedido_Venda Pv
      inner join Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
    where
      pv.cd_pedido_venda = pvA.cd_pedido_venda
   )
From
  Pedido_venda PVA

--select * from pedido_venda_item where cd_pedido_venda = 1768

update 
  pedido_venda_item
set
  dt_entrega_vendas_pedido = dt_item_pedido_venda
from
  pedido_venda_item
where
  dt_entrega_vendas_pedido is null


