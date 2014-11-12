
-------------------------------------------------------------------------------
--sp_helptext pr_cliente_mais_antigo
-------------------------------------------------------------------------------
--pr_cliente_mais_antigo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Mostrar o cliente mais antigo do Cadastro
--Data             : 04.08.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_cliente_mais_antigo  
@dt_inicial datetime = '',  
@dt_final   datetime = ''  
  
as  

SELECT  
  top 1  
  min(isnull(dt_cadastro_cliente,vw.dt_pedido_venda))     as Data,  
  c.nm_fantasia_cliente                                   as Cliente,  
  min(dt_pedido_venda)                                    as Data_Primeiro_Pedido,
  sum(vw.qt_item_pedido_venda * 
      vl_unitario_item_pedido )                           as Volume_Compra
from  
  Cliente c  
  left outer join vw_venda_bi vw on vw.cd_cliente = c.cd_cliente
where
  c.dt_cadastro_cliente is not null
group by  
  c.nm_fantasia_cliente  
order by
  1

--select * from vw_venda_bi

