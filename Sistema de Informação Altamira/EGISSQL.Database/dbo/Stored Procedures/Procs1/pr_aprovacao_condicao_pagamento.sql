CREATE   PROCEDURE pr_aprovacao_condicao_pagamento

-------------------------------------------------------------------------------
--pr_aprovacao_condicao_pagamento
-------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                           	   2004
-------------------------------------------------------------------------------
--Stored Procedure          : Microsoft SQL Server 2000
--Autor(es)                 : Daniel Carrasco Neto
--Banco de Dados            : Egissql
--Objetivo                  : Listar as Propostas com Desconto para
--                            Liberação
--Data                      : 01/04/2002
--Atualizado                : 11/07/2002 - Igor Gama
--                          : 10/05/2004 - Anderson Cunha
--                          : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------
@ic_parametro as int, --1 liberados, 2 não liberados, 3 Todos
@dt_inicial as DateTime,
@dt_final   as DateTime,
@cd_pedido_venda as int

AS

declare @cd_condicao_pagamento int
declare @ic_mostrar_item char(1)


if @ic_parametro = 3
  set @ic_mostrar_item = 'S'
else
  set @ic_mostrar_item = 'N'

select
    @cd_condicao_pagamento = cd_condicao_pagamento
from
    Parametro_Comercial
where
   cd_empresa = dbo.fn_empresa()

--------------------------------------------------------------------------------------------
  If @ic_mostrar_item = 'N' 
--------------------------------------------------------------------------------------------  

-- Pra não precisar mais passar o Parâmetro empresa. Apenas abra a query e pronto.
begin
  select
    'N' as ic_desconto, 
    u.nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pv.dt_pedido_venda,
    pv.cd_pedido_venda,
    pv.cd_usuario,
    pv.dt_usuario,
    cp.nm_condicao_pagamento,
    pv.dt_cond_pagto_pedido,
    pv.cd_usuario_cond_pagto_ped,
    pv.vl_total_pedido_venda

  from
    Pedido_Venda pv left outer join
    EgisAdmin.dbo.Usuario u on pv.cd_usuario_cond_pagto_ped = u.cd_usuario left outer join
    Cliente cli on pv.cd_cliente = cli.cd_cliente left outer join
    Vendedor vi on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve on pv.cd_vendedor = ve.cd_vendedor left outer join
    Condicao_Pagamento CP on (cp.cd_condicao_pagamento = pv.cd_condicao_pagamento)
   where
     pv.dt_pedido_venda between (case @cd_pedido_venda when 0 then @dt_inicial else pv.dt_pedido_venda end)  and 
                                (case @cd_pedido_venda when 0 then @dt_final else pv.dt_pedido_venda end) 
	  and
     pv.dt_cancelamento_pedido is null and 
     pv.cd_condicao_pagamento <> @cd_condicao_pagamento and 
     (case when (pv.dt_cond_pagto_pedido is not null) and
                (@ic_parametro = 1 or @ic_parametro = 4) then 1
           when (pv.dt_cond_pagto_pedido is null) and
                (@ic_parametro = 2 or @ic_parametro = 5) then 1
           else 0 end ) = 1 and
     pv.cd_pedido_venda = (case @cd_pedido_venda when 0 then pv.cd_pedido_venda else @cd_pedido_venda end) 
  order by 
    pv.dt_pedido_venda,
    pv.cd_pedido_venda


end
------------------------------------------
else  -- Pedidos Aguardando Liberação. Apresenta mesmo os pedidos que foram já faturados totalmente
------------------------------------------
begin
  select 
    '' as ic_desconto,
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
	  pvi.cd_usuario_lib_desconto,
		u.nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario
  from
    Pedido_Venda_Item pvi inner join
    Pedido_Venda pv
      on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join
		EgisAdmin.dbo.Usuario u
			on pvi.cd_usuario_lib_desconto = u.cd_usuario left outer join
    Cliente cli
      on pv.cd_cliente = cli.cd_cliente left outer join
    Produto p
      on p.cd_produto = pvi.cd_produto Left outer join
    Vendedor vi --vendedor interno
      on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve --vendedor externo
      on pv.cd_vendedor = ve.cd_vendedor
  where
    pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and
--     pvi.qt_saldo_pedido_venda > 0 and 
    pvi.dt_cancelamento_item is null and
    pv.dt_cancelamento_pedido is null and 
    pvi.ic_desconto_item_pedido = 'S' and pvi.pc_desconto_item_pedido > 0
  order by 
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda

end

-------------------------------------------------------------------------------
--Testando a Stored Procedure
-------------------------------------------------------------------------------

/*
exec pr_aprovacao_condicao_pagamento
@ic_parametro =2,
@dt_inicial ='05/01/2006',
@dt_final   ='05/31/2006',
@cd_pedido_venda =0
*/

