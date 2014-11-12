
CREATE PROCEDURE pr_mapa_producao
-------------------------------------------------------------------
--pr_mapa_producao
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Wagner Sguerri Junior                                                       
--Banco de Dados       : EGISSQL
--Objetivo             : Montar Mapa de Programação para Produção                                     
--Data                 : 13/12/2002                                                                      
--Atualizado           : 18/12/2002 - Incluído campo de Operação - Daniel C. Neto.                 
--                     : 15/06/2004 - Refeita procedure de Mapa de Programação.
--                                    lógica para preenchimento agora ficará na query da própria tela.
--                                  - Daniel C. Neto.
--                     : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 05.11.2005 - Hora Final de Programação - Carlos Fernandes
--                     : 21.09.2007 - Ordem Alfabética de Máquina - Carlos Fernandes
------------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final datetime

AS

declare @ic_alfa_maquina_programacao char(1) 

select
  @ic_alfa_maquina_programacao = isnull(ic_alfa_maquina_programacao,'N')
from
  parametro_programacao
where
  cd_empresa = dbo.fn_empresa()

  SELECT 
    'S' as 'Atraso',
    'N' as 'Produzir',
    'S' as 'Produz_OK', 
    'N' as 'Maquina_Produzindo',
    'S' as 'Producao_Suspensa',
    'N' as 'Pedido_Cancelado',
	--p.dt_programacao,
   ( select sum(mt.qt_hora_operacao_maquina) 
     from maquina_turno mt where 
	        mt.cd_maquina = p.cd_maquina and mt.ic_operacao = 'S'
     group by
	         mt.cd_maquina ) as 'qt_hora_operacao_maquina',
    p.cd_maquina,
    max(maq.qt_ordem_mapa)       as qt_ordem_mapa,
    maq.nm_fantasia_maquina
	--  maq.nm_fantasia_maquina + ' - Programação ' + cast(prog.qt_hora_operacao_maquina as varchar(20)) + ' H(s)' as 'nm_fantasia_maquina',
	--  pc.cd_numero_operacao,
	--  pc.qt_hora_prog_operacao,
	--  prod.cd_pedido_venda,
	--  pv.cd_cliente,
	--  cli.nm_fantasia_cliente,
	--  pc.cd_operacao,
	--  pc.dt_fim_prod_operacao
  into
    #MapaProducao
  from
    Programacao p --INNER JOIN
	--  Programacao_Composicao pc ON p.cd_programacao = pc.cd_programacao  
      LEFT OUTER JOIN
    Maquina maq ON p.cd_maquina = maq.cd_maquina --LEFT OUTER JOIN
	--  Processo_Producao prod ON pc.cd_processo = Prod.cd_processo LEFT OUTER JOIN
	--  Pedido_Venda pv ON Prod.cd_pedido_venda = pv.cd_pedido_venda LEFT OUTER JOIN
	--  Cliente cli ON pv.cd_cliente = Cli.cd_cliente
  where
    p.dt_programacao between @dt_inicial and @dt_final  and
    isnull(maq.ic_mapa_producao,'N') = 'S'
	--  prod.cd_pedido_venda is not null
	
  group by
    p.cd_maquina,
    maq.nm_fantasia_maquina--,
	--  p.qt_hora_operacao_maquina--,
	--  cli.nm_fantasia_cliente,
	--  pv.cd_pedido_venda,
	--  pc.cd_operacao
--   order by
--     case when @ic_alfa_maquina_programacao='S' then 0 else maq.qt_ordem_mapa end,
--     maq.nm_fantasia_maquina--,


select
  m.*
from
  #MapaProducao m
order by
  case when @ic_alfa_maquina_programacao='S' then 0 else m.qt_ordem_mapa end,
   m.nm_fantasia_maquina


