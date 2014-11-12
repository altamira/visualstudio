
CREATE VIEW vw_status_pedido_venda_nextel
------------------------------------------------------------------------------------
--vw_status_pedido_venda_nextel
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo	        : Mudança do Status do Pedido de Venda
--                        Nextel / XMLINK
--Data                  : 18.11.2008
--Atualização           : 07.04.2009 - Pedido de Venda - Ajustes - Carlos Fernandes
--
------------------------------------------------------------------------------------
as

--select * from pedido_venda

select
  --dbo.fn_strzero(p.cd_pedido_venda,8) as PEDIDO,
  
  p.nm_referencia_consulta              as PEDIDO,
  max(p.dt_pedido_venda)              as dt_pedido_venda,
  max(cast('' as varchar(20)))        as BRANCOS,
  max(4)                              as EVENTO

from
  pedido_venda p                 with (nolock) 
  inner join pedido_venda_item i with (nolock) on i.cd_pedido_venda = p.cd_pedido_venda
where
  isnull(i.qt_saldo_pedido_venda,0)=0

group by
  --p.cd_pedido_venda
  p.nm_referencia_consulta
 
