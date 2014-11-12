
-------------------------------------------------------------------------------
--pr_importacao_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_importacao_cliente
@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime,
@cd_cliente int,
@cd_moeda int,
@cd_mapa int,
@cd_ano int
as

declare @vl_moeda float,
        @nm_empresa varchar(50),
        @qt_total_cliente float,
  		  @vl_total_cliente float

set @nm_empresa =( select 
                         nm_fantasia_empresa
                      from 
                         EgisAdmin.dbo.Empresa
                      where
                         nm_banco_empresa = DB_NAME() )

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da Tabela Auxiliar de Vendas por Cliente
--------------------------------------------------------------------
if @ic_parametro = 1  -- Mostra os Clientes
--------------------------------------------------------------------
begin
   select 
      vw.nm_fantasia_cliente as 'Cliente', 
      isNull(vw.cd_cliente,0) as cd_cliente,
      sum(vw.qt_item_ped_imp * (vw.vl_item_ped_imp / @vl_moeda)) as 'Compra' ,
      sum(vw.qt_item_ped_imp * (vw.vl_item_ped_imp / @vl_moeda)) as 'TotalLiquido',
      cast(sum((qt_item_ped_imp * (vl_item_ped_imp / @vl_moeda))) as decimal(25,2)) as 'TotalLista',
      cast(sum((vw.vl_item_ped_imp  * ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',
      0 as 'MargemContribuicao',
      cast(sum((qt_item_ped_imp * ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',
      max(dt_pedido_Importacao)                                as 'UltimaCompra', 
      count(distinct cd_pedido_venda)                              as 'pedidos',
      (select max(v.nm_fantasia_vendedor)
      from Cliente c inner join 
      vendedor v on c.cd_vendedor = v.cd_vendedor
      where c.cd_cliente = vw.cd_cliente)                 as 'setor'
   into 
      #VendaClienteAux1
   from 
      vw_importacao_bi vw left outer join  
      Produto_Custo ps on vw.cd_produto = ps.cd_produto 

   where
      (vw.dt_pedido_Importacao between @dt_inicial and @dt_final) and
      vw.cd_cliente is not null
   group by 
 	   nm_fantasia_cliente, vw.cd_cliente
   order by 
 	   Compra desc


   -- Total de Vendas Geral
   set @vl_total_cliente = 0
   select @vl_total_cliente = @vl_total_cliente + compra
   from
     #VendaClienteAux1

   --Define tabela com Total Geral de Venda Ano
   --select @vl_total_cliente as 'TOTALANO' 
   --into ##TotalVendaAno

   --Cria a Tabela Final de Vendas por Cliente
   -- Define a posição de Compra do Cliente - IDENTITY

   select IDENTITY(int, 1,1) as 'Posicao',
       cd_cliente,
       coalesce(Cliente,@nm_empresa) as Cliente, 
       Compra, 
       TotalLiquido,
       TotalLista,
       CustoContabil,
       MargemContribuicao,
       BNS,
       cast(((Compra / @vl_total_cliente ) * 100) as decimal (25,2)) as 'Perc',
       UltimaCompra,
       setor, 
       pedidos,
       cast((( TotalLista / Compra ) * 100) - 100 as decimal (15,2)) as 'Desc'
   Into 
      #VendaCliente1
   from 
      #VendaClienteAux1
   Order by
      Compra desc

--Mostra tabela ao usuário
   select * 
   from 
      #VendaCliente1
   order by 
      posicao

   drop table #VendaClienteAux1
   drop table #VendaCliente1
end
--------------------------------------------------------------------
if @ic_parametro = 2  -- Mostra os Categoria
--------------------------------------------------------------------
begin
   ----------------------------------------------------
   -- Faturamento Bruto
   ----------------------------------------------------
   Select 
	   isNull(vw.cd_categoria_produto,0) as cd_categoria_produto,
	   isNull(cp.nm_categoria_produto,'Produto s/ Categoria') as Categoria,
      sum(vw.vl_item_ped_imp) / @vl_moeda as Compra,
 	   sum(vw.qt_item_ped_imp)	as Qtd
   into 
      #FaturaResultado
   from
     vw_importacao_bi vw
     left outer join Categoria_Produto cp
     on vw.cd_categoria_produto = cp.cd_categoria_produto 
   where 
	   vw.dt_pedido_Importacao between @dt_inicial and @dt_final
	   and isnull(vw.cd_cliente,0) = @cd_cliente
   group by 
	   vw.cd_categoria_produto,
	   cp.nm_categoria_produto
   order by 2 desc

   ------------------------------------
   -- Total de Cliente
   ------------------------------------
   set @qt_total_cliente = @@rowcount

   ------------------------------------
   -- Total de Vendas Geral
   ------------------------------------
   set @vl_total_cliente = 0

   select 
	   @vl_total_cliente = sum(IsNull(Compra,0))
   from
     #FaturaResultado

   select IDENTITY(int, 1,1) as Posicao, 
       cd_categoria_produto, 
       Categoria,
       Qtd,
       cast(Compra as money) as Compra,
       cast(((compra / @vl_total_cliente)*100) as money) as Perc

   Into 
	   #FaturaResultadoFinal
   from 
	   #FaturaResultado
   Order by 
	   Compra desc

   ------------------------------------
   --Mostra tabela ao usuário
   ------------------------------------
   select 	
	   * 
   from 
	   #FaturaResultadoFinal
   order by 
	   Posicao

end
--------------------------------------------------------------------
if @ic_parametro = 3  -- Mostra os Pedidos
--------------------------------------------------------------------
begin
   select distinct a.cd_pedido_venda, 
       a.dt_pedido_venda, 
       b.cd_item_pedido_venda, 
       b.qt_item_pedido_venda, 
       b.nm_produto_pedido,
       b.qt_item_pedido_venda*b.vl_unitario_item_pedido / @vl_moeda as 'total',
       b.dt_entrega_fabrica_pedido,
       b.qt_saldo_pedido_venda
   from
      pedido_venda a inner join
      pedido_venda_item b on a.cd_pedido_venda = b.cd_pedido_venda inner join
      vw_importacao_bi vw on a.cd_pedido_Venda = vw.cd_pedido_Venda inner join
      Cliente cli on cli.cd_cliente = a.cd_cliente
   where
      isNull(cli.cd_cliente,0) = @cd_cliente and
      isnull(b.cd_categoria_produto,0) = @cd_mapa  and
      (a.dt_pedido_venda between @dt_inicial and @dt_final) and
      (b.qt_item_pedido_venda * b.vl_unitario_item_pedido / @vl_moeda) > 0 and
      b.dt_cancelamento_item is Null
   order by 
      total desc
end
--------------------------------------------------------------------
if @ic_parametro = 4  -- Mostra os Anual
--------------------------------------------------------------------
begin

   select c.nm_fantasia_cliente       as 'Cliente',
      month(a.dt_pedido_venda)    as 'Mes', 
      cast(sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda) as decimal(25,2)) as 'Total'
   into 
      #VendaClienteMes
   from
      pedido_venda a inner join
      vw_importacao_bi vw on a.cd_pedido_Venda = vw.cd_pedido_Venda left outer join 
      pedido_venda_item b on b.cd_pedido_venda = a.cd_pedido_venda left outer join 
      Cliente c on c.cd_cliente = a.cd_cliente
   Where
      isNull(a.cd_cliente,0) = @cd_cliente and
      year(a.dt_pedido_venda)=@cd_ano  and
      (b.qt_item_pedido_venda*b.vl_unitario_item_pedido / @vl_moeda) > 0      and
      isnull(a.ic_consignacao_pedido,'N') <> 'S'            and
      IsNull(year(b.dt_cancelamento_item),@cd_ano + 1) > @cd_ano and --Desconsidera itens cancelados depois da data final
      IsNull(year(a.dt_cancelamento_pedido),@cd_ano+1) > @cd_ano --Desconsider pedidos de venda cancelados                

   Group by 
      a.cd_cliente,month(a.dt_pedido_venda), c.nm_fantasia_cliente
   order by 2 desc

   --Mostra tabela ao usuário com Resumo Mensal

   select a.Cliente,
       sum( a.total )                                    as 'TotalVenda', 
       sum( case a.mes when 1  then a.total else 0 end ) as 'Jan',
       sum( case a.mes when 2  then a.total else 0 end ) as 'Fev',
       sum( case a.mes when 3  then a.total else 0 end ) as 'Mar',
       sum( case a.mes when 4  then a.total else 0 end ) as 'Abr',
       sum( case a.mes when 5  then a.total else 0 end ) as 'Mai',
       sum( case a.mes when 6  then a.total else 0 end ) as 'Jun',
       sum( case a.mes when 7  then a.total else 0 end ) as 'Jul',
       sum( case a.mes when 8  then a.total else 0 end ) as 'Ago',
       sum( case a.mes when 9  then a.total else 0 end ) as 'Set',
       sum( case a.mes when 10 then a.total else 0 end ) as 'Out',
       sum( case a.mes when 11 then a.total else 0 end ) as 'Nov',
       sum( case a.mes when 12 then a.total else 0 end ) as 'Dez' 
       
   from 
      #VendaClienteMes a
   group by a.cliente
end
