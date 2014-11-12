-------------------------------------------------------------------------------  
--pr_lista_preco_tipo_pedido
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2005  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server       2000  
--Autor(es)        : Wilder Mendes  
--Banco de Dados   : EgisSQL  
--Objetivo         :   
--Data             : 18/03/2005  
--------------------------------------------------------------------------------------------------  


create procedure pr_lista_preco_tipo_pedido
@dt_inicial datetime,  
@dt_final   datetime  
as  
select   
p.nm_fantasia_produto as Codigo, 
p.nm_produto as Descricao,
e.nm_tipo_embalagem as Embalagem,
v.vl_produto as Valor,
s.nm_tipo_pedido as Tipo
from produto p
left outer join tipo_embalagem e on p.cd_tipo_embalagem=e.cd_tipo_embalagem
left outer join produto_venda_tipo_pedido v on v.cd_produto=p.cd_produto
left outer join tipo_pedido s on s.cd_tipo_pedido=v.cd_tipo_pedido



