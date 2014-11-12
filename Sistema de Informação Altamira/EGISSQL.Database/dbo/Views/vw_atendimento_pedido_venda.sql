
CREATE VIEW vw_atendimento_pedido_venda
------------------------------------------------------------------------------------
--sp_helptext vw_atendimento_pedido_venda
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra os Pedidos de Vendas que são Atendidos
--                        Somente 
--                        Pedido de Compra
--                        Pedido de Importação
--                        Ordem  de Produção
--Data                  : 04.10.2009
--Atualização           : 04.10.2009
------------------------------------------------------------------------------------
as
 

--select * from atendimento_pedido_venda

select
  pvi.cd_pedido_venda,
  pvi.cd_item_pedido_venda,
  isnull(pvi.qt_atendimento,0)    as qt_atendimento
from
  pedido_venda_item pvi
where
  pvi.qt_atendimento>0
  
