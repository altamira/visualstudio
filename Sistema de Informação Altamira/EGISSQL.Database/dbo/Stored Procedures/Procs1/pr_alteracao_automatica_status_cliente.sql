
-----------------------------------------------------------------------------------
--pr_alteracao_automatica_status_cliente
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo
--                   Alteração de Status do Cliente
--Data             : 02.09.2003
--Atualizado       : 
--                 : 
-----------------------------------------------------------------------------------
create procedure pr_alteracao_automatica_status_cliente
@dt_ultima_compra_cliente datetime,
@cd_status_cliente_atual  int,
@cd_status_cliente_novo   int
as

   print('Seleção inicial')
   select 
      max(pv.dt_pedido_venda ) as dt_ultima_compra_cliente,
       c.cd_cliente,
       c.nm_fantasia_cliente as 'Nome',
       c.cd_telefone as 'Telefone',
       ( select top 1 x.nm_fantasia_contato 
         from Cliente_Contato x 
         where x.cd_cliente = c.cd_cliente ) as 'Contato',
       e.nm_vendedor as 'Vendedor'
   into #tabela
   from 
       Cliente c left outer join
       Pedido_Venda pv on pv.cd_cliente = c.cd_cliente left outer join
       Vendedor e on  e.cd_vendedor = pv.cd_vendedor
   where
       c.cd_status_cliente = @cd_status_cliente_atual and      
       pv.dt_cancelamento_pedido is null
   group by
      c.cd_cliente,
      c.nm_fantasia_cliente,
      c.cd_telefone,
      e.nm_vendedor

          
  print('Seleção final')
  select * from #tabela
   where
     dt_ultima_compra_cliente <= @dt_ultima_compra_cliente          
   order by
     dt_ultima_compra_cliente desc
 
