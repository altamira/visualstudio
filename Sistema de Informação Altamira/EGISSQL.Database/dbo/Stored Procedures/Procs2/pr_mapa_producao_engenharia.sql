
CREATE PROCEDURE pr_mapa_producao_engenharia
-------------------------------------------------------------------
--pr_mapa_producao_engenharia
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
--                     : 02.10.2005 - Alteração para utilização da Programação da Engenharia GBS - Carlos Fernandes
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
     8.00                 as 'qt_hora_operacao_maquina',
    u.cd_usuario          as cd_maquina,
    u.nm_fantasia_usuario as nm_fantasia_maquina
  from
    Menu_Historico mh 
    LEFT OUTER JOIN
    Usuario u ON u.cd_usuario = mh.cd_analista
  where
    mh.dt_previsao_desenv between @dt_inicial and @dt_final 
	
  group by
    u.cd_usuario,
    u.nm_fantasia_usuario
