
CREATE PROCEDURE pr_mapa_producao_consultoria
-------------------------------------------------------------------
--pr_mapa_producao_consultoria
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2006
-------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardoso Fernandes
--Banco de Dados       : EGISSQL
--Objetivo             : Montar Mapa de Programação para Produção                                     
--Data                 : 28.04.2006
--Atualizado           : 
--                     : 
-------------------------------------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final   datetime

AS
 
  SELECT 
    'S' as 'Atraso',
    'N' as 'Produzir',
    'S' as 'Produz_OK', 
    'N' as 'Maquina_Produzindo',
    'S' as 'Producao_Suspensa',
    'N' as 'Pedido_Cancelado',
    sum(isnull(c.qt_hora_consultor,0)) as 'qt_hora_operacao_maquina',
    c.cd_consultor                     as cd_maquina,
    c.nm_fantasia_consultor            as nm_fantasia_maquina
  from
    Programacao_Implantacao p 
    left outer join Consultor_Implantacao c ON c.cd_consultor = p.cd_consultor
  where
    p.dt_programacao between @dt_inicial and @dt_final 
	
  group by
    c.cd_consultor,
    c.nm_fantasia_consultor

