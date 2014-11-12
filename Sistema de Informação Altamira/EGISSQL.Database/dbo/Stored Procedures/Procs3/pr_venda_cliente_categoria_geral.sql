

/****** Object:  Stored Procedure dbo.pr_venda_cliente_categoria_geral    Script Date: 13/12/2002 15:08:44 ******/
--pr_venda_cliente_categoria_geral
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Vendas por Cliente e Categorias
--Data        : 21.03.2000
--Atualizado  : 21.03.2000
--            : 06.06.2000 Inclusao campo NcMapa
-----------------------------------------------------------------------------------
CREATE procedure pr_venda_cliente_categoria_geral
@ano int,
@nm_fantasia_cliente varchar(15)
as
-- Geraçao da Tabela Auxiliar de Vendas por Cliente
select c.ncmapa,
       sum(c.qt)              as 'qtd',
       sum(c.qt * c.preco)    as 'Compra'
into #VendaClienteCategoriaAuxGeral
from
  CADPED a,CADIPED c
Where
    a.fan_cli = @nm_fantasia_cliente           and
  ( a.DTDEL is null or YEAR(a.DTDEL)>@ano )    and 
    a.totalped>0                               and 
  year(a.DTPED)=@ano                           and
   a.pedido        = c.pedidoit                and 
  (c.QT*c.PRECO) > 0                           and
  (c.DTDEL is null or year(c.DTDEL)>@ano )     and
   c.FATSMOIT = 'N'                            and
   c.item         < 80                         and
   year(c.DTPEDIT)=@ano
Group by c.ncmapa
order by 3 desc 
declare @qt_total_cliente int
declare @vl_total_cliente float
-- Total de Cliente
set @qt_total_cliente = @@rowcount
-- Total de Vendas Geral
set     @vl_total_cliente = 0
select @vl_total_cliente = @vl_total_cliente + compra
from
  #VendaClienteCategoriaAuxGeral
select IDENTITY(int, 1,1) AS 'Posicao', b.ncmapa, b.sgmapa as 'Categoria',a.qtd,a.Compra, (a.compra/@vl_total_cliente)*100 as 'Perc'
Into #VendaClienteCategoriaGeral
from #VendaClienteCategoriaAuxGeral a,CADMAPA b
Where
   a.ncmapa = b.ncmapa
Order by Compra desc
--Mostra tabela ao usuário
select * from #VendaClienteCategoriaGeral
order by Posicao


