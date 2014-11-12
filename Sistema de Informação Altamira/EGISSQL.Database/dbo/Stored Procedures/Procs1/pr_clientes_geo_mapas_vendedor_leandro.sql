
--pr_clientes_geo_mapas_vendedor_leandro
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Clientes por Mapa Geográfico por Vendedor
--Data         : 06.12.2000
--Atualizado   : 14.12.2000 - Colocado o Estado do Cliente
-----------------------------------------------------------------------------------
CREATE procedure pr_clientes_geo_mapas_vendedor_leandro

@cd_vendedor    int,
@dt_inicial     datetime,
@dt_final       datetime

AS

--Monta uma tabela com todos os Clientes do Vendedor

select a.fan_cli       as 'cliente',
       max(a.dtc_cli)  as 'cadastro',
       max(a.est_cli)  as 'Estado',
       max(a.cid_cli)  as 'Cidade'
into
   #Cliente_Vendedor 
from
   CADCLI a,CADPED b
where
   @cd_vendedor = a.cv2_cli and
   a.fan_cli   *= b.fan_cli and
   b.dtdel is null          
     
group by a.fan_cli

select b.fan_cli                  as 'Cliente', 
       sum(d.qt*d.preco)          as 'VlrVenda',
       sum(d.qt*d.precolist)      as 'VlrOrcado',
       sum(d.qt)                  as 'Qtd'
into #RegclienteVendAux
from
   CADCLI b, CADPED c,CADIPED d
Where
   @cd_vendedor = b.cv2_cli       and
   b.fan_cli    = c.fan_cli       and
 ( c.dtped between @dt_inicial    and @dt_final ) and
   c.pedido = d.pedidoit          and
   d.item < 80                    and     
 ( d.QT*d.PRECO ) > 0             and
 ( d.DTDEL is null  )             and
   d.fatsmoit = 'N'   

group by b.fan_cli

--Montagem da Tabela final com a posicao do Cliente com o Valor de Venda Maior

select b.cliente,
       a.qtd,
       a.vlrvenda,
       a.vlrorcado,
       b.cidade,
       b.estado,
       b.cadastro
--into #RegClienteVend
from
    #RegclienteVendAux a, #Cliente_Vendedor b
where
  b.cliente *= a.cliente
order by b.cidade


