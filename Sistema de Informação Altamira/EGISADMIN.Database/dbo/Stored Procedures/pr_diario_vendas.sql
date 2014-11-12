
create procedure pr_diario_vendas

------------------------------------------------------------------------
--pr_diario_vendas
------------------------------------------------------------------------
--GBS - Global Business Solution Ltda 	                            2004
------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Diário de Vendas
--Data			: 19/02/2003
--Alteração             : Fabio - 30.09.2003 - Mudança de definição a data a ser utilizada
--                                   para filtragem deve ser a data base
--                      : 18/11/2003 - Permitir mostrar um período - Dudu
--                      : 23/11/2004 - Fazer filtragem por loja. - Daniel C. Neto.
--                      : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso 
--			: 22/01/2005 - Acerto da condição cd_loja - Clelson Camargo
--                      : 11.07.2005 - Tipo de Mercado - Carlos Fernandes
------------------------------------------------------------------------------------------

@dt_base         datetime,
@cd_vendedor     int = 0,
@dt_final        datetime = null,
@cd_tipo_mercado int = 0,
@cd_loja         int = 0 

as

set @cd_vendedor = isnull(@cd_vendedor, 0)
set @dt_final = isnull(@dt_final, @dt_base)


declare @qt_dia_imediato as integer

set @qt_dia_imediato = ( select qt_dia_imediato_empresa 
			 from Parametro_Comercial
			 where cd_empresa = dbo.fn_empresa())

  --Diário Analítico
  select
    qt_item_pedido_venda              as 'Qtde',
    nm_fantasia_cliente               as 'Cliente',
    dt_pedido_venda                   as 'Data',
    nm_categoria_produto              as 'Produto',
    isnull(qt_item_pedido_venda * 
           vl_unitario_item_pedido,0) as 'Total',
    pg.nm_condicao_pagamento          as 'CondicaoPagamento',
    case 
      when
        (vw.dt_entrega_vendas_pedido - vw.dt_pedido_venda) <= @qt_dia_imediato
      then 'Imediato'
      else convert( varchar(10),vw.dt_entrega_vendas_pedido,103 ) end as 'Entrega',
    Interno = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = vw.cd_vendedor_interno ),
    Externo = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = vw.cd_vendedor )
  from
    vw_venda_bi vw left outer join
    Condicao_Pagamento pg on vw.cd_condicao_pagamento = pg.cd_condicao_pagamento
  where
    ( vw.dt_pedido_venda between @dt_base and @dt_final ) and
    vw.cd_vendedor = ( case IsNull(@cd_vendedor,0) when 0
                      then vw.cd_vendedor
                      else @cd_vendedor
                    end ) and
    --Carlos 11.07.2005
    vw.cd_tipo_mercado = ( case isnull(@cd_tipo_mercado,0) when 0 then vw.cd_tipo_mercado
                                                                  else @cd_tipo_mercado end ) and
                        
    ((@cd_loja = 0) or (vw.cd_loja = @cd_loja))
 order by
   4 desc


