
-------------------------------------------------------------------------------
--sp_helptext pr_controle_liberacao_separacao
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Liberação do Pedido de Venda para Separação
--
--Data             : 12.03.2009
--Alteração        : 16.03.2009 - Complemento - Carlos Fernandes
--
-- 21.03.2009 - Verificação para não mostrar pedidos Faturados / sem Saldo - Carlos Fernandes
-- 05.05.2009 - Código do Produto - Carlos Fernandes
---------------------------------------------------------------------------------------------
create procedure pr_controle_liberacao_separacao

@ic_parametro    int,       --1 liberados, 2 não liberados, 3 Todos
@dt_inicial      dateTime,
@dt_final        dateTime,
@cd_pedido_venda int = 0,
@cd_usuario      int = 0

AS

if @cd_pedido_venda is null
begin
  set @cd_pedido_venda = 0
end

--------------------------------------------------------------------------------------------
  If @ic_parametro = 1 or @ic_parametro = 4 -- Somente os Pedidos já Liberados
--------------------------------------------------------------------------------------------  

begin

  select
    'N'                            as ic_liberacao, 
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
    pvi.cd_usuario_lib_desconto,
    u.nm_fantasia_usuario          as nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor        as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor        as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido               as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto,
    pvs.dt_liberacao_separacao,
    pvi.dt_entrega_vendas_pedido,
    tp.sg_tipo_pedido,
    p.cd_mascara_produto

  
--select * from produto

  from
    Pedido_Venda_Item pvi       with (nolock) 
    inner join Pedido_Venda pv  with (nolock)             on pv.cd_pedido_venda = pvi.cd_pedido_venda 
    left outer join EgisAdmin.dbo.Usuario u with (nolock) on pvi.cd_usuario_lib_desconto = u.cd_usuario 
    left outer join Cliente cli                           on pv.cd_cliente = cli.cd_cliente
    left outer join Produto p                             on p.cd_produto = pvi.cd_produto
    Left outer join Vendedor vi                           on pv.cd_vendedor_interno = vi.cd_vendedor
    Left Outer Join Vendedor ve                           on pv.cd_vendedor = ve.cd_vendedor
    left outer join Pedido_Venda_Separacao pvs            on pvs.cd_pedido_venda      = pv.cd_pedido_venda   and
                                                             pvs.cd_item_pedido_venda = pvi.cd_item_pedido_venda
    left outer join Tipo_Pedido tp                        on tp.cd_tipo_pedido = pv.cd_tipo_pedido
		
  where
    pvi.cd_pedido_venda   = case when @cd_pedido_venda = 0 then pvi.cd_pedido_venda else @cd_pedido_venda end and
    pvi.dt_entrega_vendas_pedido between @dt_inicial and @dt_final and
    isnull(pvi.qt_saldo_pedido_venda,0) > 0 and 
    pvi.dt_cancelamento_item    is null     and
    pv.dt_cancelamento_pedido   is null     and
    pv.cd_pedido_venda in ( select cd_pedido_venda from pedido_venda_separacao where cd_item_pedido_venda = pvi.cd_item_pedido_venda )
    and pvs.dt_liberacao_separacao is not null
  order by 
    pvi.dt_entrega_vendas_pedido,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda


end

------------------------------------------------------------------------------------
else  -- Pedidos de Venda Aguardando Liberação.
------------------------------------------------------------------------------------

If @ic_parametro = 2 or @ic_parametro = 5
------------------------------------------------------------------------------------
begin
  select
    'N'                     as ic_liberacao, 
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
    pvi.cd_usuario_lib_desconto,
    cast('' as varchar(15) ) as nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor  as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor  as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido    as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto,
    pvs.dt_liberacao_separacao,
    pvi.dt_entrega_vendas_pedido,
    tp.sg_tipo_pedido,
    p.cd_mascara_produto

--select * from pedido_venda_separacao
  

  from
    Pedido_Venda_Item pvi       with (nolock) 
    inner join Pedido_Venda pv  with (nolock)  on pv.cd_pedido_venda = pvi.cd_pedido_venda 
    left outer join Cliente cli                on pv.cd_cliente = cli.cd_cliente 
    left outer join Produto p                  on p.cd_produto = pvi.cd_produto 
    Left outer join Vendedor vi                on pv.cd_vendedor_interno = vi.cd_vendedor 
    Left Outer Join Vendedor ve                on pv.cd_vendedor = ve.cd_vendedor
    left outer join Pedido_Venda_Separacao pvs            on pvs.cd_pedido_venda      = pv.cd_pedido_venda   and
                                                             pvs.cd_item_pedido_venda = pvi.cd_item_pedido_venda

    left outer join Tipo_Pedido tp                        on tp.cd_tipo_pedido = pv.cd_tipo_pedido
  where
    pvi.cd_pedido_venda   = case when @cd_pedido_venda = 0 then pvi.cd_pedido_venda else @cd_pedido_venda end and
    pvi.dt_entrega_vendas_pedido between @dt_inicial and @dt_final and
    isnull(pvi.qt_saldo_pedido_venda,0) > 0 and 
    pvi.dt_cancelamento_item    is null and
    pv.dt_cancelamento_pedido   is null 
    --pv.cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda_separacao where cd_item_pedido_venda = pvi.cd_item_pedido_venda )
    and isnull(pvs.dt_liberacao_separacao,null) is null

  order by 
    pvi.dt_entrega_vendas_pedido,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda

end

------------------------------------------------------------------------------------
else                 -- Pedidos Aguardando Liberação. Apresenta mesmo os pedidos que foram já faturados totalmente
If @ic_parametro = 3 -- Somente os Liberados
------------------------------------------------------------------------------------
begin

  select 
    ''                           as ic_liberacao,
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
	  pvi.cd_usuario_lib_desconto,
   u.nm_fantasia_usuario as nm_usuario,
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
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto,
    pvs.dt_liberacao_separacao,
    pvi.dt_entrega_vendas_pedido,
    tp.sg_tipo_pedido,
    p.cd_mascara_produto

  from
    Pedido_Venda_Item pvi      with (nolock) 
    inner join Pedido_Venda pv with (nolock) 
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

    left outer join Pedido_Venda_Separacao pvs            on pvs.cd_pedido_venda      = pv.cd_pedido_venda   and
                                                             pvs.cd_item_pedido_venda = pvi.cd_item_pedido_venda

    left outer join Tipo_Pedido tp                        on tp.cd_tipo_pedido = pv.cd_tipo_pedido

		
  where
    pvi.dt_entrega_vendas_pedido between @dt_inicial and @dt_final and
    pvi.qt_saldo_pedido_venda > 0 and 
    pvi.dt_cancelamento_item is null and
    pv.dt_cancelamento_pedido is null 
  order by 
    pvi.dt_entrega_vendas_pedido,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda


end


