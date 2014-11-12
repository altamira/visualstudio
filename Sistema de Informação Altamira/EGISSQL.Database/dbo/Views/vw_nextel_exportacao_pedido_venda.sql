
CREATE VIEW vw_nextel_exportacao_pedido_venda
------------------------------------------------------------------------------------
--vw_nextel_exportacao_pedido_venda
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Douglas de Paula Lopes
--Banco de Dados	: EGISSQL
--Objetivo	        : Remessa nextel pedido venda.
--                        com o Status 4 = Pedido Faturado

--Data                  : 22/07/2008  

--Atualização           : 30.03.2009 - Ajustes Diversos - Carlos Fernandes.
--06.05.2009 - Pedidos para Zerar no Rádio
--
------------------------------------------------------------------------------------

as

--select nm_referencia_consulta,* from pedido_venda

select
  distinct 
  pv.cd_pedido_venda,
  pv.dt_pedido_venda,
  cast( dbo.fn_strzero(cast(isnull(pv.nm_referencia_consulta,'') as int(8) ),8) as varchar(8) )
  +'|'+
  cast('' as char(20))
  +'|'+
  '4'                                                       as Linha,


--  cast( dbo.fn_strzero(cast(pv.cd_pedido_venda as int(8) ),8) as varchar(8) )  as NPED,

  cast( dbo.fn_strzero(cast(pv.nm_referencia_consulta as int(8) ),8) as varchar(8) )  as NPED,

  --cast(ns.cd_pedido_venda as int(20)) as COD,

  cast('' as varchar(20))             as COD,
  '4'                                 as IDSTATUS 

  --cast(spn.cd_status_pedido_nextel as int(1)) as IDSTATUS  --/////// Aguardando criação de tabela.

from
  pedido_venda                           pv  with (nolock)
  --left outer join nota_saida             ns  with (nolock) on ns.cd_pedido_venda = pv.cd_pedido_venda
  inner join Pedido_Venda_item          pvi  with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda

where
  (isnull(pvi.qt_saldo_pedido_venda,0) = 0 or
  pvi.dt_cancelamento_item      is not null )
  and pv.nm_referencia_consulta is not null  
  and pv.cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda_status )

  --left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pv.cd_status_pedido_nextel --/////// Aguardando criação de tabela.

