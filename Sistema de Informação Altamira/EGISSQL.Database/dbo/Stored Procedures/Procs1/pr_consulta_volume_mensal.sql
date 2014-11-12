
CREATE PROCEDURE pr_consulta_volume_mensal
   @cd_ano int, --Ano Desejado
   @cd_categoria_produto int,
   @cd_vendedor int

as


-- Linha abaixo incluída para rodar no ASP
set nocount on

Create table #temp_Select
(
 cd_grupo_categoria  int null,
 nm_categoria_produto varchar(40) null,
 nm_fantasia_vendedor varchar(50) null,
 nm_fantasia_cliente varchar(60) null,
 sg_estado varchar (3) null,
 qt_Jan Float null,
 qt_Fev Float null,
 qt_Mar Float null,
 qt_Abr Float null,
 qt_Mai Float null,
 qt_Jun Float null,
 qt_Jul Float null, 
 qt_Ago Float null,
 qt_Set Float null,
 qt_Out Float null,
 qt_Nov Float null,
 qt_Dez Float null,
 qt_total_geral Float null)


create table #VendaAnualMes
(
      NumeroMes int null,
      Grupo varchar(40) null,      
      Categoria varchar(40) null,
      Vendedor varchar (50) null,
      Cliente varchar (60) null,
      Estado varchar(3) null,
      CodVendedor int null,
      Data datetime null,   
      Pedidos float null
)

begin
    INSERT INTO #VendaAnualMes
    select 
      month(vw.dt_pedido_venda)          as 'NumeroMes',
      vw.cd_grupo_categoria              as 'Grupo',
      vw.nm_categoria_produto            as 'Categoria',
      vw.nm_vendedor_externo             as 'Vendedor',
      vw.nm_fantasia_cliente             as 'Cliente',
      es.sg_estado                       as'Estado',
      vw.cd_vendedor		                 as 'CodVendedor',
      max(vw.dt_pedido_venda)            as 'Data',   
      sum(vw.qt_item_pedido_venda)       as 'Pedidos'
    from
      vw_venda_bi vw left outer join
      Estado es on (vw.cd_estado = es.cd_estado)
    where
      year(vw.dt_pedido_venda) = @cd_ano                    and
      IsNull(vw.cd_categoria_produto,0) = ( case when @cd_categoria_produto = 0 then  
                                              IsNull(vw.cd_categoria_produto,0) else
                                              @cd_categoria_produto end )  and 
      vw.nm_categoria_produto is not null                   and
      IsNull(vw.cd_vendedor,0) = ( case when @cd_vendedor = 0 then 
                                      IsNull(vw.cd_vendedor,0) else
                                      @cd_vendedor end ) 
    group by 
      month(vw.dt_pedido_venda), vw.cd_grupo_categoria, vw.nm_categoria_produto, 
      vw.nm_vendedor_externo, vw.cd_vendedor, vw.nm_fantasia_cliente, es.sg_estado
end

--Muda os registro de linha para coluna
INSERT #temp_Select
( cd_grupo_categoria,
  nm_categoria_produto,
  nm_fantasia_vendedor,
  nm_fantasia_cliente,
  sg_estado,
  qt_Jan,
  qt_Fev,
  qt_Mar,
  qt_Abr,
  qt_Mai,
  qt_Jun,
  qt_Jul, 
  qt_Ago,
  qt_Set,
  qt_Out,
  qt_Nov,
  qt_Dez,
  qt_total_geral)


SELECT 
  Grupo,
  Categoria,
  Vendedor,
  Cliente,
  Estado,
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 1),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 2),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 3),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 4),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 5),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 6),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 7),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 8),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 9),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 10),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 11),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria and
            NumeroMes = 12),0),
  IsNull((Select sum(Pedidos) from #VendaAnualMes 
          where 
            Cliente = a.Cliente and
            IsNull(Vendedor,0) = IsNull(a.Vendedor,0) and
            Categoria = a.Categoria),0) 
FROM #VendaAnualMes a
where Categoria is not null
group by  a.Vendedor, a.Categoria ,a.Grupo, a.Cliente, a.CodVendedor, a.Estado


-- Guarda as Vendas Totais
declare @venda_total float
select
   @venda_total = sum(qt_total_geral)
      
from #temp_select

select distinct--IDENTITY(int,1,1) as 'Posicao',
        b.*,
       (b.qt_total_geral/@venda_total)*100 as 'Perc'
      
Into #VendaCateg

from #temp_select b


select * from #VendaCateg 
Order by nm_fantasia_vendedor, nm_categoria_produto

drop table #VendaCateg
drop table #temp_Select


