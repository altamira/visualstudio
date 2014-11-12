
-------------------------------------------------------------------------------
--sp_helptext pr_calculo_desconto_total_pedido_venda
-------------------------------------------------------------------------------
--pr_calculo_desconto_total_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Cálculo Geral do Desconto do Pedido de Venda/Item
--Data             : 27.12.2010 
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_calculo_desconto_total_pedido_venda
@cd_pedido_venda int   = 0,
@vl_desconto     float = 0,
@pc_desconto     float = 0

as

-------------------------------------------------------------------------------------
--Cálculo Pedido de Venda
-------------------------------------------------------------------------------------

if @cd_pedido_venda > 0 and ( @vl_desconto > 0 or @pc_desconto > 0 )
begin

  declare @vl_total_pedido float
  declare @i_arr           int

  select 
    @i_arr = isnull(m.qt_num_digitos,4)
  from
    Moeda m
  where m.cd_moeda = 1
  --select * from moeda 
    
  set @vl_total_pedido = 0

  select
    @vl_total_pedido = isnull(vl_total_pedido_ipi,0.00)
  from
    Pedido_Venda pv with (nolock) 

  where
    pv.cd_pedido_venda = @cd_pedido_venda


  --Calculo do Valor do desconto
  if @pc_desconto > 0
  begin
    set @vl_desconto = 0
    set @vl_desconto = (@vl_total_pedido * @pc_desconto/100) 
  end

--  select @vl_total_pedido,@vl_desconto,(@vl_total_pedido-@vl_desconto)

--select * from pedido_venda

  --Montagem da Tabela de Itens com o Rateio----------------------------------------------

  select
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,
    pvi.qt_item_pedido_venda,
    pc_item_pedido_venda = round(((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/pv.vl_total_pedido_ipi),4)
  into
    #ItemPedidoDesconto

  from
    pedido_venda_item       pvi with (nolock) 
    inner join pedido_venda pv  on pv.cd_pedido_venda = pvi.cd_pedido_venda

  where
    pv.cd_pedido_venda     = @cd_pedido_venda 
    and pv.cd_pedido_venda = pvi.cd_pedido_venda
    and isnull(pv.vl_total_pedido_ipi,0)>0
  
--  select * from   #ItemPedidoDesconto


  --Atualiza os novos valores----------------------------------------

  update
    pedido_venda_item
  set
    vl_unitario_item_pedido =   round(((@vl_total_pedido - @vl_desconto) * d.pc_item_pedido_venda ) / i.qt_item_pedido_venda,@i_arr),
    pc_desconto_item_pedido =   round((((vl_lista_item_pedido - ( ((@vl_total_pedido - @vl_desconto) * d.pc_item_pedido_venda ) / i.qt_item_pedido_venda ) ) * 100) / vl_lista_item_pedido ),4)   


  from
    pedido_venda_item i 
    inner join #ItemPedidoDesconto d on d.cd_pedido_venda      = i.cd_pedido_venda      and
                                        d.cd_item_pedido_venda = i.cd_item_pedido_venda 
  where
    i.cd_pedido_venda = @cd_pedido_venda

  --select * from pedido_venda_item


--  select * from pedido_venda_item where cd_pedido_venda = @cd_pedido_venda 

end

  

