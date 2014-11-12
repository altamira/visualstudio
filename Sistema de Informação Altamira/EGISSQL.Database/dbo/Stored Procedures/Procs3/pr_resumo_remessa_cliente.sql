
create procedure pr_resumo_remessa_cliente

------------------------------------------------------------------------
--pr_resumo_remessa_cliente
------------------------------------------------------------------------
--GBS - Global Business Solution	               2004
--Stored Procedure	: Microsoft SQL Server         2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Resumo de Remessa por Cliente
--Data			: 04.12.2004
--Alteração             : 
------------------------------------------------------------------------
@dt_inicial as datetime,
@dt_final   as datetime
as

--select * from remessa

select
  c.nm_fantasia_cliente as Cliente,
  count(*)              as Remessa
from
  Cliente c,
  Remessa r
where
  c.cd_cliente = r.cd_cliente
group by
  c.nm_fantasia_cliente
  
