
CREATE PROCEDURE pr_verifica_saldo_item_faturar

@cd_pedido_venda int

as

--select * from produto

declare  
  @cd_fase_venda_produto   int,  
  @cd_item_pedido_venda    int,  
  @qt_saldo_item           decimal(15,4),  
  @cd_produto              int,  
  @qt_saldo_pedido_venda   decimal(15,4),  
  @qt_saldo_faturar        decimal(15,4),  
  @nm_fantasia_produto     VarChar(50),   
  @cd_id_item_pedido_venda int,  
  @ItemPedidoVenda         int
     
declare @SaldoItem table   
  ( cd_pedido_venda         int,  
    cd_item_pedido_venda    int,  
    ItemPedidoVenda         int,  
    cd_id_item_pedido_venda int,  
    cd_produto              int,  
    qt_saldo_pedido_venda   decimal(15,4),  
    saldo_estoque           decimal(15,4),  
    saldo_faturar           decimal(15,4),   
    nm_fantasia_produto     varchar(50) )  
  
declare @PedidoItem table   
  ( cd_pedido_venda         int,  
    cd_item_pedido_venda    int,  
    ItemPedidoVenda         int,  
    cd_id_item_pedido_venda int,  
    cd_produto              int,  
    nm_fantasia_produto     varchar(50),  
    qt_saldo_pedido_venda   decimal(15,4),  
    saldo_estoque           decimal(15,4))  
  
select   
  @cd_fase_venda_produto = cd_fase_produto  
from   
  Parametro_Comercial   
where   
  cd_empresa = dbo.fn_empresa()  
  
Insert into @PedidoItem  
Select  
  pvi.cd_pedido_venda,  
  pvi.cd_item_pedido_venda,  
  pvi.cd_item_pedido_venda            as ItemPedidoVenda,  
  0                                   as cd_id_item_pedido_venda,  
  case when isnull(p.cd_produto_baixa_estoque,0)=0 
  then pvi.cd_produto
  else p.cd_produto_baixa_estoque end as cd_produto,  
  pvi.nm_fantasia_produto,  
  IsNull(pvi.qt_saldo_pedido_venda,0) as qt_saldo_pedido_venda,  

  case when (IsNull(pvi.ic_pedido_venda_item,'P') = 'P')   
       then isnull((select isnull(ps.qt_saldo_atual_produto,0)   
                    from Produto_Saldo ps  
                     where isnull(ps.cd_produto,0) = 
                                                 case when isnull(p.cd_produto_baixa_estoque,0)=0
                                                 then pvi.cd_produto else p.cd_produto_baixa_estoque end and
                         isnull(ps.cd_fase_produto,0) = IsNull(p.cd_fase_produto_baixa, @cd_fase_venda_produto)),0)  
    else  
       IsNull(pvi.qt_saldo_pedido_venda,0)  
  end                                           as saldo_estoque  

--Into #PedidoITem  

From pedido_venda_item pvi with (nolock)  
     left outer join produto p on p.cd_produto = pvi.cd_produto  

where pvi.cd_pedido_venda = @cd_pedido_venda and  
      isnull(pvi.cd_produto,0) <> 0  and
      pvi.dt_cancelamento_item is null
order by 
      pvi.cd_produto, pvi.cd_item_pedido_venda  

--select * from @PedidoItem
 
-- Componentes  
  
If exists(select 'x' from pedido_venda_item where IsNull(cd_produto,0) = 0)  
Begin  
  insert into @PedidoItem  
 Select  
   pvi.cd_pedido_venda,  
   Cast('100' + Cast(pvi.cd_item_pedido_venda as VarChar) + Cast(pvc.cd_id_item_pedido_venda as Varchar) as Int) as cd_item_pedido_venda,  
    pvi.cd_item_pedido_venda as ItemPedidoVenda,  
    pvc.cd_id_item_pedido_venda,  
    case when isnull(p.cd_produto_baixa_estoque,0)=0 
    then pvc.cd_produto
    else p.cd_produto_baixa_estoque end as cd_produto,  
   pvc.nm_fantasia_produto,  
   (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0)) as qt_saldo_pedido_venda,  
   case when (IsNull(pvi.ic_pedido_venda_item,'P') = 'P')   
       then isnull((select isnull(qt_saldo_atual_produto,0)   
                    from Produto_Saldo   
                    where cd_produto = case when isnull(p.cd_produto_baixa_estoque,0)=0
                                           then p.cd_produto else p.cd_produto_baixa_estoque end and
 --                         cd_fase_produto = IsNull(p.cd_fase_produto_baixa,6)),0)  
                          cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_venda_produto)),0)  
     else  
        (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvc.qt_item_produto_comp,0))  
   end as saldo_estoque  
-- Into #PedidoITem  
 From pedido_venda_item pvi with (nolock)  
      inner join pedido_venda_composicao pvc on pvc.cd_pedido_venda = pvi.cd_pedido_venda and  
                                                pvc.cd_item_pedido_venda = pvi.cd_item_pedido_venda  
      left outer join produto p on p.cd_produto = pvc.cd_produto  
 where pvi.cd_pedido_venda = @cd_pedido_venda and  
       IsNull(pvi.cd_produto,0) = 0  and
       pvi.dt_cancelamento_item is null
 order by pvc.cd_produto, pvi.cd_item_pedido_venda  

End  
  

--select * from #PedidoItem  
  
while exists(select 'x' from @PedidoItem)  
begin  
  set @cd_item_pedido_venda = (select top 1 cd_item_pedido_venda  
                               from @PedidoItem)  
  
  set @cd_id_item_pedido_venda = (select cd_id_item_pedido_venda  
                                  from @PedidoItem  
                                  where cd_item_pedido_venda = @cd_item_pedido_venda)  
  
  set @ItemPedidoVenda = (select ItemPedidoVenda  
                          from @PedidoItem  
                          where cd_item_pedido_venda = @cd_item_pedido_venda)  
  
  set @cd_produto = (select cd_produto   
                     from @PedidoItem  
                     where cd_item_pedido_venda = @cd_item_pedido_venda)  
  
--  select @cd_produto

  set @nm_fantasia_produto = (select top 1 nm_fantasia_produto  
                              from @PedidoItem  
                              where cd_produto = @cd_produto)  
  
  set @qt_saldo_pedido_venda = (select sum(IsNull(qt_saldo_pedido_venda,0))  
                                from @PedidoItem  
                                where cd_produto = @cd_produto)  
  
  set @qt_saldo_item = (select sum(saldo_estoque)  
                        from @PedidoItem  
                        where cd_produto = @cd_produto)  

  If Exists(Select cd_produto from @SaldoItem where cd_produto = @cd_produto)  
  Begin  
    set @qt_saldo_item = (select Top 1 sum(IsNull(saldo_estoque,0))  
                          from @PedidoItem  
                          where cd_produto = @cd_produto )  
    set @qt_saldo_item = @qt_saldo_item - @qt_saldo_pedido_venda  
  End  
  
  If Exists(Select cd_produto from @SaldoItem where cd_produto = @cd_produto)  
  Begin  
    set @qt_saldo_faturar = (select sum(IsNull(saldo_estoque,0))  
                             from @PedidoItem  
                             where cd_produto = @cd_produto ) 
    set @qt_saldo_faturar = @qt_saldo_item - @qt_saldo_pedido_venda  
  End  
  Else    
    set @qt_saldo_faturar = @qt_saldo_item - @qt_saldo_pedido_venda  
  
  Insert into @SaldoItem (cd_pedido_venda,  
                          cd_item_pedido_venda,  
                          ItemPedidoVenda,   
                          cd_id_item_pedido_venda,  
                          cd_produto,  
                          qt_saldo_pedido_venda,  
                          saldo_estoque,  
                          saldo_faturar,  
                          nm_fantasia_produto)  
                  Values (@cd_pedido_venda,  
                          @cd_item_pedido_venda,  
                          @ItemPedidoVenda,  
                          @cd_id_item_pedido_venda,  
                          @cd_produto,  
                          @qt_saldo_pedido_venda,  
                          @qt_saldo_item,  
                          @qt_saldo_faturar,  
                          @nm_fantasia_produto)  

--  select * from @saldoitem
  
  delete from @PedidoItem where cd_produto = @cd_produto  

  print ( @qt_saldo_pedido_venda)  
  print ( @qt_saldo_item) 
  print ( @qt_saldo_faturar)

end  

--Drop table #PedidoItem

Select * 
from @SaldoItem
where isnull(saldo_faturar,0) < 0
order by cd_item_pedido_venda

