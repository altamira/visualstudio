
CREATE PROCEDURE pr_mapa_entrega_carregamento

-------------------------------------------------------------------
--sp_helptext pr_mapa_entrega_carregamento
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Carlos Cardoso Fernandes
--Banco de Dados       : EGISSQL
--Objetivo             : Montagem do Mapa de Entregas - Logística
--Data                 : 04.08.2008
--Atualizado           : 
------------------------------------------------------------------------------------------
@dt_inicial datetime = '',
@dt_final   datetime = ''

AS

--select * from Veiculo
--select * from Motorista
 
  SELECT 
    'N'                          as 'Atrasada',
    'N'                          as 'Realizado',
    'S'                          as 'Aberto', 
    'N'                          as 'Cancelada',
    v.cd_veiculo,                
    v.nm_veiculo                 as Veiculo,
    v.cd_placa_veiculo           as Placa,
    m.cd_motorista,
    m.nm_motorista               as Motorista,
    v.qt_entrega_diaria_veículo  as QtdEntregaDiaria,
    i.nm_itinerario              as Regiao,
    'Posicao'                    as Posicao,
    i.cd_itinerario
   from
     Itinerario i                with (nolock)
     left outer join Veículo   v with (nolock) on v.cd_veiculo   = i.cd_veiculo
     left outer join Motorista m with (nolock) on m.cd_motorista = i.cd_motorista
   where
     isnull(m.ic_ativo_motorista,'N') = 'S'   and
     v.dt_baixa_veiculo is null

--select * from veiculo

