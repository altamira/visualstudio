
-------------------------------------------------------------------------------
--sp_helptext pr_calculo_desconto_total_pedido_compra
-------------------------------------------------------------------------------
--pr_calculo_desconto_total_pedido_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Cálculo Geral do Desconto do Pedido de Compra/Item
--Data             : 27.12.2010 
--Alteração        : 28.12.2010
--
--
------------------------------------------------------------------------------
create procedure pr_calculo_desconto_total_pedido_compra
@cd_pedido_compra int   = 0,
@vl_desconto      float = 0,
@pc_desconto      float = 0

as

-------------------------------------------------------------------------------------
--Cálculo Pedido de Compra
-------------------------------------------------------------------------------------

if @cd_pedido_compra > 0 and ( @vl_desconto > 0 or @pc_desconto > 0 )
begin

  declare @vl_total_pedido float
  declare @i_arr           int

  select 
    @i_arr = isnull(m.qt_num_digitos,4)
  from
    Moeda m with (nolock) 
  where m.cd_moeda = 1

  --select * from moeda 
    
  set @vl_total_pedido = 0

  select
    @vl_total_pedido = isnull(vl_total_pedido_ipi,0.00)
  from
    Pedido_compra pv with (nolock) 

  where
    pv.cd_pedido_compra = @cd_pedido_compra

  --select * from pedido_compra

  --Calculo do Valor do desconto
  if @pc_desconto > 0
  begin
    set @vl_desconto = 0
    set @vl_desconto = (@vl_total_pedido * @pc_desconto/100) 
  end

--  select @vl_total_pedido,@vl_desconto,(@vl_total_pedido-@vl_desconto)

--select * from pedido_compra

  --Montagem da Tabela de Itens com o Rateio----------------------------------------------

  select
    pvi.cd_pedido_compra,
    pvi.cd_item_pedido_compra,
    pvi.qt_item_pedido_compra,
    pc_item_pedido_compra = round(((pvi.qt_item_pedido_compra*pvi.vl_item_unitario_ped_comp)/pv.vl_total_pedido_ipi),4)
  into
    #ItemPedidoDesconto

  from
    pedido_compra_item       pvi with (nolock) 
    inner join pedido_compra pv  on pv.cd_pedido_compra = pvi.cd_pedido_compra

  where
    pv.cd_pedido_compra     = @cd_pedido_compra 
    and pv.cd_pedido_compra = pvi.cd_pedido_compra
    and isnull(pv.vl_total_pedido_ipi,0)>0

-- select * from pedido_compra_item
  
--  select * from   #ItemPedidoDesconto


  --Atualiza os novos valores----------------------------------------

  update
    pedido_compra_item
  set
    vl_item_unitario_ped_comp =   round(((@vl_total_pedido - @vl_desconto) * d.pc_item_pedido_compra ) / i.qt_item_pedido_compra,@i_arr),
    pc_item_descto_ped_compra =   round((((vl_custo_item_ped_compra - ( ((@vl_total_pedido - @vl_desconto) * d.pc_item_pedido_compra ) / i.qt_item_pedido_compra ) ) * 100) / vl_custo_item_ped_compra ),4)   


  from
    pedido_compra_item i 
    inner join #ItemPedidoDesconto d on d.cd_pedido_compra      = i.cd_pedido_compra      and
                                        d.cd_item_pedido_compra = i.cd_item_pedido_compra 
  where
    i.cd_pedido_compra = @cd_pedido_compra

  --select * from pedido_compra_item


--  select * from pedido_compra_item where cd_pedido_compra = @cd_pedido_compra 

end

  

