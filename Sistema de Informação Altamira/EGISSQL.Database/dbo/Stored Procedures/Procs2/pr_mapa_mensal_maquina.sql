

CREATE PROCEDURE pr_mapa_mensal_maquina

@dt_programacao datetime,
@cd_maquina     int

AS
 
SELECT 
  'S' as 'Atraso',
  'N' as 'Produzir',
  'S' as 'Produz_OK', 
  'N' as 'Maquina_Produzindo',
  'S' as 'Producao_Suspensa',
  'N' as 'Pedido_Cancelado',
  p.dt_programacao,
  p.qt_hora_operacao_maquina,
  p.qt_hora_disp_simulacao,
  p.cd_maquina,
  maq.nm_fantasia_maquina,
--  maq.nm_fantasia_maquina + ' - Programação ' + cast(prog.qt_hora_operacao_maquina as varchar(20)) + ' H(s)' as 'nm_fantasia_maquina',
  pc.cd_numero_operacao,
  pc.qt_hora_prog_operacao,
  prod.cd_pedido_venda,
  prod.cd_item_pedido_venda,
  pvi.qt_item_pedido_venda,
  pvi.vl_unitario_item_pedido,
  pv.cd_cliente,
  cli.nm_fantasia_cliente,
  pc.dt_fim_prod_operacao,
  pc.dt_canc_prod_operacao,
  pc.dt_susp_prod_operacao,
  pc.cd_operacao

FROM
  Programacao p

INNER JOIN
  Programacao_Composicao pc
ON
  p.cd_programacao = pc.cd_programacao

LEFT OUTER JOIN
  Maquina maq
ON 
  p.cd_maquina = maq.cd_maquina

LEFT OUTER JOIN
  Processo_Producao prod
ON
  pc.cd_processo = Prod.cd_processo

LEFT OUTER JOIN
  Pedido_Venda pv
ON
  Prod.cd_pedido_venda = pv.cd_pedido_venda

LEFT OUTER JOIN
  Pedido_Venda_Item pvi
on
  pvi.cd_pedido_venda = prod.cd_pedido_venda and
  pvi.cd_item_pedido_venda = prod.cd_item_pedido_venda 

LEFT OUTER JOIN
  Cliente cli
ON
  pv.cd_cliente = Cli.cd_cliente
    
WHERE
  p.cd_maquina = @cd_maquina and
  p.dt_programacao = @dt_programacao

ORDER BY
  maq.nm_fantasia_maquina,
  p.qt_hora_operacao_maquina,
  cli.nm_fantasia_cliente,
  pv.cd_pedido_venda,
  pc.cd_operacao


