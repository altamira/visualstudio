
create procedure pr_calculo_comissao_documento_receber
@cd_vendedor integer,
@dt_inicial  datetime,
@dt_final    datetime
as

declare @pc_comissao_cliente  float

--Busca o (%) de Comissão do Cadastro do Vendedor

declare @pc_comissao_vendedor float

if @cd_vendedor>0 
   begin

     select @pc_comissao_vendedor = pc_comissao_vendedor
     from
            Vendedor
     Where
            @cd_vendedor = cd_vendedor

   end

--Cálculo da Comissão


select
     nm_fantasia_vendedor                                   as 'Vendedor',
     c.nm_fantasia_cliente                                  as 'Cliente',
     pv.dt_pedido_venda,
     tp.sg_tipo_pedido,
     pv.cd_pedido_venda,
     pv.vl_total_pedido_venda                                as 'Valor',
     @pc_comissao_vendedor                                   as 'PercComissao',
     pv.vl_total_pedido_venda * ( @pc_comissao_vendedor/100) as 'Comissao',
     d.dt_emissao_documento                                  as 'DataFat',
     dp.dt_pagamento_documento                               as 'DataPagto'
from
     Pedido_Venda pv, Tipo_Pedido tp, Cliente C, Pedido_Venda_Item pvi, Nota_Saida_Item nsi,
     Documento_receber d, Documento_Receber_Pagamento dp, Vendedor v
Where
    ((v.cd_vendedor      = @cd_vendedor)     or (@cd_vendedor = 0)) and 
    v.cd_vendedor      = pv.cd_vendedor      and
    pv.cd_tipo_pedido  = tp.cd_tipo_pedido   and  
    pv.dt_pedido_venda between @dt_inicial   and @dt_final and
    pv.cd_cliente      = c.cd_cliente        and
    pv.cd_pedido_venda = pvi.cd_pedido_venda and
    pvi.dt_cancelamento_item is null         and
    pvi.cd_pedido_venda      = nsi.cd_pedido_venda      and
    pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda and
    nsi.dt_restricao_item_nota is null                  and
    nsi.cd_nota_saida        = d.cd_nota_saida          and
    d.dt_cancelamento_documento is null                 and
    d.cd_documento_receber   = dp.cd_documento_receber  and
    dp.dt_pagamento_documento is not null

