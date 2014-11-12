

/****** Object:  Stored Procedure dbo.pr_calculo_peso_pedido    Script Date: 13/12/2002 15:08:14 ******/
--pr_calculo_peso_pedido
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Cálculo do Peso do Pedido
--Data       : 23.2.2001
--Atualizado : 
-----------------------------------------------------------------------------------
create procedure pr_calculo_peso_pedido
@cd_pedido_venda int
as
select a.fan_cli,       
       a.pedido,
       a.dtped as 'emissao',
       b.item,
       b.qt as 'qtdprod',
       b.descricao,
       c.cod_item,
       c.qt,
       d.pesoliq,
       d.pesobruto,
       c.qt * d.pesoliq   as 'pesoliqitem',
       c.qt * d.pesobruto as 'pesobruitem'
--into #tab_auxiliar
from
   CADPED a,CADIPED b,CADEPE c,FTPROD d
where
   @cd_pedido_venda = a.pedido   and
   a.pedido = b.pedidoit         and
   b.pedidoit = c.pedido         and
   b.item     = c.item           and
   c.cod_item = d.almox+d.codigo 
order by b.item
/*
select 
     pedido,
     max(emissao),    
     sum(pesoliqitem) as 'pesoliq_total',
     sum(pesobruitem) as 'pesobru_total'
from
   #tab_auxiliar
group by pedido            
*/


