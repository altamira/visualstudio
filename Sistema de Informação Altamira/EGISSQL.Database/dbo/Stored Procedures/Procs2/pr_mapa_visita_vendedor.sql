
CREATE PROCEDURE pr_mapa_visita_vendedor

-------------------------------------------------------------------
--pr_mapa_visita_vendedor
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardoso Fernandes
--Banco de Dados       : EGISSQL
--Objetivo             : Montar Mapa de Visitas de Vendedores
--Data                 : 15.01.2005
--Atualizado           : 18.01.2005 - Checado se o vendedor está Ativo
-- 20.03.2008          : Verificação do funcionamento da procedure e ajustes diversos - Carlos/Felipe
--                     : 
------------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final   datetime

AS
 
  SELECT 
    'N'                          as 'Atrasada',
    'N'                          as 'Realizado',
    'S'                          as 'Aberto', 
    'N'                          as 'Cancelada',
    'N'                          as 'Negócio',
    'N'                          as 'Perda',
    v.cd_vendedor,                
    v.nm_fantasia_vendedor       as Vendedor,
    v.qt_visita_diaria_vendedor  as QtdVisitaDiaria,
    'Regiao'                     as Regiao,
    'Posicao'                    as Posicao
   from
     Vendedor v with (nolock) 
   where
     isnull(ic_ativo,'N') = 'S'   
