
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2006
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Consulta do Resumo por Companhia Aarea
--Data           : 25.04.2006
--Atualizado     : 25.04.2006
--               : 
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_resumo_viagem_companhia_area
@dt_inicial              datetime = '',
@dt_final                datetime = ''

AS

--select * from requisicao_viagem_composicao
--select * from cia_aerea

select
  ca.nm_fantasia_cia_aerea              as CompanhiaAerea,
  count(*)                              as Qtd,
  sum(isnull(rv.vl_total_viagem,0))     as Total

from
  Requisicao_Viagem rv 
  left outer join Requisicao_Viagem_Composicao rvc on rvc.cd_requisicao_viagem = rv.cd_requisicao_viagem
  left outer join Cia_Aerea ca on ca.cd_cia_aerea = rvc.cd_cia_aerea
where
  isnull(rvc.cd_cia_aerea,0)>0
Group by
  ca.nm_fantasia_cia_aerea


