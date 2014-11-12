

/****** Object:  Stored Procedure dbo.pr_selecao_pedido_faturamento    Script Date: 13/12/2002 15:08:42 ******/
create procedure dbo.pr_selecao_pedido_faturamento
 ( @dt_inicio datetime, 
   @dt_termino datetime ) as

/*
  Procuedure: pr_selecao_produto_faturamento
  Autor: Alexandre Santos Costa
  Data: 05/03/2002

  Seleciona dados para a tela de Seleção de Pedidos para Faturamento

  exec pr_selecao_produto_faturamento '03/01/2002', '03/31/2002'

*/

begin
  declare
      @cd_pedido int,
      @dt_pedido datetime,
      @nm_fantasia varchar(50),
      @ic_credito_liberado   char(1),
      @ic_desconto_liberado  char(1),
      @qt_item int, 
      @qt_peso_liquido float, 
      @qt_peso_bruto float,
      @ds_status varchar(50)
  
  declare cur_pedidos_abertos cursor local static for
    select pv.cd_pedido_venda, dt_pedido_venda, nm_fantasia_cliente,
           ic_liberado_credito =
             case when dt_credito_pedido_venda is null then 'N' else 'S' end,
           ic_desconto_item_pedido     
      from cliente, pedido_venda pv, pedido_venda_item pvi
     where pv.cd_pedido_venda = pvi.cd_pedido_venda

 begin

   create table #selecao_pedido_faturamento
   (
     cd_pedido_venda int,
     dt_pedido_venda datetime,
     nm_fantasia_cliente varchar(50),
     qt_item int,
     qt_liquido int, qt_bruto int,
     ds_status varchar(50),
     ic_ok bit
   )

   open cur_pedidos_abertos

   fetch next from cur_pedidos_abertos into
     @cd_pedido, @dt_pedido, @nm_fantasia,
     @ic_credito_liberado, @ic_desconto_liberado

   while @@fetch_status = 0
   begin

     select @qt_item = count(*),
            @qt_peso_liquido =
               sum(qt_liquido_item_pedido),
            @qt_peso_bruto = 
               sum(qt_bruto_item_pedido)
       from pedido_venda_item
      where cd_pedido_venda = @cd_pedido
      
     if (@ic_credito_liberado <> 'S')
       set @ds_status = 'Crédito não liberado'
     else
       if (@ic_desconto_liberado <> 'S')
          set @ds_status = 'Desconto não liberado'
       else
         set @ds_status = null
   
     insert into #selecao_pedido_faturamento
       values (
                @cd_pedido, @dt_pedido,
                @nm_fantasia,
                @qt_item,
                @qt_peso_liquido,
                @qt_peso_bruto,
                @ds_status,
                case when @ds_status is null then 1 else 0 end
              )

     fetch next from cur_pedidos_abertos into
       @cd_pedido, @dt_pedido, @nm_fantasia,
       @ic_credito_liberado, @ic_desconto_liberado

   end

   close cur_pedidos_abertos
   deallocate cur_pedidos_abertos

   select * from #selecao_pedido_faturamento
   drop table #selecao_pedido_faturamento

 end
end


