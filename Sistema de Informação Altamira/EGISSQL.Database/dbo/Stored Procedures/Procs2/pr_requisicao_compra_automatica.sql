

/****** Object:  Stored Procedure dbo.pr_requisicao_compra_automatica    Script Date: 13/12/2002 15:08:41 ******/

CREATE PROCEDURE pr_requisicao_compra_automatica
@ic_parametro           int,
@cd_serie               int,
@nm_fantasia            varchar(30),
@cd_mes			int,
@cd_ano			int,
@cd_fase_produto        int -- Para Filtrar pela Fase de Produto

AS

declare @cont int,
        @SQL varchar(8000),
        @SQL_freq varchar(8000)


set @cont = 0
set @SQL = ' '
set @SQL_freq = ' '
set @cd_mes = @cd_mes - 5 -- Vou pegar apenas dos 4 primeiros meses.
set @nm_fantasia = QuoteName(@nm_fantasia + '%' , '''')

set @SQL = ' select 0 as Gerar, 
             p.cd_produto, 
             p.nm_fantasia_produto, ' +
           ' ps.qt_minimo_imp_produto as QtMinima, ' +
           ' (select sum(x.qt_item_pedido_venda) 
              from Pedido_Venda_Item x' +
           '  where 
                pvi.cd_produto = x.cd_produto and 
                x.dt_cancelamento_item is null and ' +
           '    not EXISTS (SELECT ni.cd_item_pedido_venda 
                            from Nota_Saida_Item ni' +
           '                where 
                              ni.cd_item_pedido_venda = x.cd_item_pedido_venda and ' +
           '                  ni.cd_pedido_venda = x.cd_pedido_venda ) and' +
           '                  not EXISTS (SELECT rci.cd_item_pedido_venda  
                                          from Requisicao_Compra_Item rci ' +
           '                              where 
                                            rci.cd_item_pedido_venda = x.cd_item_pedido_venda and ' +
           '                                rci.cd_pedido_venda = x.cd_pedido_venda ) ) as Quantidade, ' +

           ' IsNull(ps.qt_saldo_reserva_produto, 0.0) as qt_saldo_reserva_produto, ' +
           ' IsNull(p.ic_kogo_produto, ''N'') as Kogo, '

if @cd_mes = 0
  set @cd_mes = -1

if @cd_mes < 0
  begin
    set @cd_ano = @cd_ano - 1
    set @cd_mes = @cd_mes + 13
  end

while @cont < 5 -- Vou pegar apenas dos 4 primeiros meses.
    begin
      if @cd_mes > 12
      begin
        set @cd_ano = @cd_ano + 1
        set @cd_mes = 1
      end

      set @SQL_freq = @SQL_freq + ' case isNull((select count(y.qt_item_nota_saida) 
                                                 from Nota_Saida x '
                                + '              left outer join Nota_Saida_Item y on 
                                                   y.cd_nota_saida=x.cd_nota_saida '
         			+ '              where month(x.dt_nota_saida) = '+ cast(@cd_mes as varchar)+' and
                                                   year(x.dt_nota_saida) = ' + cast(@cd_ano  as varchar) + ' and '
                                + '                y.nm_fantasia_produto = p.nm_fantasia_produto '
  	      			+ '              group by y.nm_fantasia_produto),0) '
                                + '   when 0 then 0 else 1 end '

      if @cont + 1 <  5
	set @SQL_freq = @SQL_freq + ' + '
      else
        set @SQL_freq = '(' + @SQL_freq + ')'

      set @cd_mes = @cd_mes + 1
      set @cont = @cont + 1
   end

set @SQL_freq = ' cast(' + @SQL_freq + ' as varchar) + ''/4'' as Frequencia,  '

-------------------------------------------------------------------------
if @ic_parametro = 1 -- Filtrando pelo número de Série.
-------------------------------------------------------------------------
begin
--print @SQL + @SQL_freq +   ' (select p.nm_pais from  Produto x ' +
  exec ( @SQL + @SQL_freq +  ' (select p.nm_pais from  Produto x ' +
                             ' left outer join Pais p on p.cd_pais =
                               x.cd_origem_produto' +
                             ' where x.cd_produto = pvi.cd_produto) as Origem into
                               #Tabela1' +
                             ' from Produto p, Pedido_Venda_Item pvi ' +
                             ' left outer join  ' +
                             ' Produto_Saldo ps on pvi.cd_produto = ps.cd_produto' +
                             ' where p.cd_produto = pvi.cd_produto and ' + '
                               pvi.dt_cancelamento_item is null and ' +
                             ' not EXISTS (SELECT ni.cd_item_pedido_venda from
                               Nota_Saida_Item ni ' +
                             ' where ni.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' ni.cd_pedido_venda = pvi.cd_pedido_venda ) ' +
                             ' and not EXISTS (SELECT rci.cd_item_pedido_venda from
                               Requisicao_Compra_Item rci ' +
                             ' where rci.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' rci.cd_pedido_venda = pvi.cd_pedido_venda ) and ' +
                             ' p.cd_serie_produto = ' + @cd_serie +
                             ' and ps.cd_fase_produto = ' + @cd_fase_produto +
                             ' group by p.nm_fantasia_produto, p.cd_produto,' +
	                     ' ps.qt_minimo_imp_produto, p.ic_kogo_produto,
                               ps.qt_saldo_reserva_produto, pvi.cd_produto, pvi.dt_item_pedido_venda ' +
                             ' order by pvi.dt_item_pedido_venda '  +
  		             ' select distinct t.* into #Tabela2 from #Tabela1 t  ' +
                             ' select identity(int, 1,1) as Item, ' +
                             '( select max(pvi.dt_item_pedido_venda) ' +
                             ' from Pedido_Venda_Item pvi where t2.cd_produto =
                               pvi.cd_produto and ' +
                             ' pvi.dt_cancelamento_item is null and ' +
                             ' not EXISTS (SELECT ni.cd_item_pedido_venda from
                               Nota_Saida_Item ni ' +
                             ' where ni.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' ni.cd_pedido_venda = pvi.cd_pedido_venda ) ' +
                             ' and not EXISTS (SELECT rci.cd_item_pedido_venda from
                               Requisicao_Compra_Item rci ' +
                             ' where rci.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' rci.cd_pedido_venda = pvi.cd_pedido_venda ) ) as
                               Entrega, ' +
                             ' t2.* into #Tabela3 from #Tabela2 t2 ' +
                             ' select * from #Tabela3')

end
 
-------------------------------------------------------------------------
if @ic_parametro = 2 -- Filtrando somente pelo Nome do Produto
-------------------------------------------------------------------------
begin
  exec ( @SQL + @SQL_freq +  ' (select p.nm_pais from  Produto x ' +
                             ' left outer join Pais p on p.cd_pais =
                               x.cd_origem_produto' +
                             ' where x.cd_produto = pvi.cd_produto) as Origem into
                               #Tabela1' +
                             ' from Produto p, Pedido_Venda_Item pvi ' +
                             ' left outer join  ' +
                             ' Produto_Saldo ps on pvi.cd_produto = ps.cd_produto' +
                             ' where p.cd_produto = pvi.cd_produto and ' + '
                               pvi.dt_cancelamento_item is null and ' +
                             ' not EXISTS (SELECT ni.cd_item_pedido_venda from
                               Nota_Saida_Item ni ' +
                             ' where ni.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' ni.cd_pedido_venda = pvi.cd_pedido_venda ) ' +
                             ' and not EXISTS (SELECT rci.cd_item_pedido_venda from
                               Requisicao_Compra_Item rci ' +
                             ' where rci.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' rci.cd_pedido_venda = pvi.cd_pedido_venda ) ' +
                             ' and p.nm_fantasia_produto like ' + @nm_fantasia  +
                             ' and ps.cd_fase_produto = ' + @cd_fase_produto +
                             ' group by p.nm_fantasia_produto, p.cd_produto,' +
	                     ' ps.qt_minimo_imp_produto, p.ic_kogo_produto,
                               ps.qt_saldo_reserva_produto, pvi.cd_produto, pvi.dt_item_pedido_venda ' +
                             ' order by pvi.dt_item_pedido_venda '  +
  		             ' select distinct t.* into #Tabela2 from #Tabela1 t  ' +
                             ' select identity(int, 1,1) as Item, ' +
                             '( select max(pvi.dt_item_pedido_venda) ' +
                             ' from Pedido_Venda_Item pvi where t2.cd_produto =
                               pvi.cd_produto and ' +
                             ' pvi.dt_cancelamento_item is null and ' +
                             ' not EXISTS (SELECT ni.cd_item_pedido_venda from
                               Nota_Saida_Item ni ' +
                             ' where ni.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' ni.cd_pedido_venda = pvi.cd_pedido_venda ) ' +
                             ' and not EXISTS (SELECT rci.cd_item_pedido_venda from
                               Requisicao_Compra_Item rci ' +
                             ' where rci.cd_item_pedido_venda =
                               pvi.cd_item_pedido_venda and ' +
                             ' rci.cd_pedido_venda = pvi.cd_pedido_venda ) ) as
                               Entrega, ' +
                             ' t2.* into #Tabela3 from #Tabela2 t2 ' +
                             ' select * from #Tabela3')
end

-------------------------------------------------------------------------
if @ic_parametro = 3 -- Zera Procedure
-------------------------------------------------------------------------
begin
  select 
    0         as 'item',
    getdate() as 'entrega',
    0         as 'gerar',
    0         as 'cd_produto',
    ''        as 'nm_fantasia_produto',
    0.00      as 'qtminima',
    0.00      as 'quantidade',
    0.00      as 'qt_saldo_reserva_produto',
    ''        as 'kogo',
    ''        as 'frequencia',
    ''        as 'origem'
  where 1=2

end



