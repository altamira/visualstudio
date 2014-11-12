
CREATE PROCEDURE pr_rel_mapa_producao

@dt_inicial datetime,
@dt_final datetime

AS
 
SELECT 
  'S' as 'Atraso',
  'N' as 'Produzir',
  'S' as 'Produz_OK', 
  'N' as 'Maquina_Produzindo',
  'S' as 'Producao_Suspensa',
  'N' as 'Pedido_Cancelado',
  p.dt_programacao,
  Day(p.dt_programacao)as 'dia',
  p.qt_hora_operacao_maquina,
  p.qt_hora_disp_simulacao,
  p.cd_maquina,
  maq.nm_fantasia_maquina,
--  maq.nm_fantasia_maquina + ' - Programação ' + cast(prog.qt_hora_operacao_maquina as varchar(20)) + ' H(s)' as 'nm_fantasia_maquina',
  pc.cd_numero_operacao,
  pc.qt_hora_prog_operacao,
  prod.cd_pedido_venda,
  pv.cd_cliente,
  cli.nm_fantasia_cliente,
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
  Cliente cli
ON
  pv.cd_cliente = Cli.cd_cliente
    
WHERE
  p.dt_programacao between @dt_inicial and @dt_final and
  cli.nm_fantasia_cliente is not null and
  prod.cd_pedido_venda is not null


ORDER BY
  Day(p.dt_programacao),
  maq.nm_fantasia_maquina,
  p.qt_hora_operacao_maquina,
  cli.nm_fantasia_cliente,
  pv.cd_pedido_venda,
  pc.cd_operacao

