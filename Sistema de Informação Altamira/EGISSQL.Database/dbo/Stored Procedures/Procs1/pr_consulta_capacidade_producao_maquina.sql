
-------------------------------------------------------------------------------
--pr_consulta_capacidade_producao_maquina
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta da Capacidade Produttiva da Máquina
--Data             : 16.01.2006
--Atualizado       : 16.01.2006
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_capacidade_producao_maquina
@dt_inicial datetime,
@dt_final   datetime
as

--select * from maquina

select
  m.nm_fantasia_maquina      as Maquina,
  m.qt_cap_produtiva_maquina as Capacidade,
  m.qt_setup_maquina         as Setup,
  m.vl_custo_maquina         as TaxaHora,
  m.vl_maquina               as ValorCustoMaquina
from
  Maquina m

order by
  m.nm_fantasia_maquina
  
