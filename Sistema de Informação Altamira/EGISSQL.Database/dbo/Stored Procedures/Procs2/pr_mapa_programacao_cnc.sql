
CREATE PROCEDURE pr_mapa_programacao_cnc
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
 ( select sum(mt.qt_hora_operacao_maquina) 
   from maquina_turno mt where 
        mt.cd_maquina = p.cd_maquina and mt.ic_operacao = 'S'
   group by
         mt.cd_maquina ) as 'qt_hora_operacao_maquina',
  p.cd_maquina,
  maq.nm_fantasia_maquina
FROM
  Programacao p 
  LEFT OUTER JOIN
  Maquina maq ON p.cd_maquina = maq.cd_maquina 
WHERE
  p.dt_programacao between @dt_inicial and @dt_final  and
  isnull(maq.ic_mapa_producao,'N') = 'S' and
  isnull(maq.ic_prog_cnc,'N') = 'S'
GROUP BY
  p.cd_maquina,
  maq.nm_fantasia_maquina


