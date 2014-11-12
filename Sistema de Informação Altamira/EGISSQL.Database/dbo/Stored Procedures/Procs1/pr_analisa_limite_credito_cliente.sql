
CREATE PROCEDURE pr_analisa_limite_credito_cliente
-------------------------------------------------------------------
--pr_analisa_limite_credito_cliente
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Analisar limite de crédito do cliente
--              
--Data			: 09/01/2003
--Desc. Alteração	: 19/03/2003 - Colocado para ordenar por ordem alfabetica - RAFAEL 
--                : 05/01/2005 - Acerto do Cabeçalho  - Sérgio Cardoso        
--                : 05/10/2006 - Paulo Souza
--                               Acrescentar as mesmas colunas da tela de aviso de crédito no pedido de venda
-- 08.11.2008 - Verificação do Status do Cliente - Carlos Fernandes
------------------------------------------------------------------------------------------
@nm_fantasia_cliente varchar(20) = '' 

as
  select 
    c.cd_cliente,
    c.nm_fantasia_cliente,
    c.dt_cadastro_cliente,
    ci.vl_limite_credito_cliente,

    -- Data da Ultima Compra
    ( select max(dt_pedido_venda) from Pedido_Venda with (nolock) 
      where cd_cliente = c.cd_cliente and dt_cancelamento_pedido is null) as 'DataUltimaCompra',
    
    -- Valor da Maior Compra
    ( select max(vl_total_pedido_venda) from Pedido_Venda with (nolock) 
      where cd_cliente = c.cd_cliente and dt_cancelamento_pedido is null) as 'ValorMaiorCompra',

    -- Data do Ultimo Faturamento
    ( select max(dt_nota_saida) from Nota_Saida with (nolock) 
      where cd_cliente = c.cd_cliente and dt_cancel_nota_saida is null) as 'DataUltimoFaturamento',

    -- Valor Maior Faturamento
    ( select max(vl_total) from Nota_Saida with (nolock) 
      where cd_cliente = c.cd_cliente and dt_cancel_nota_saida is null) as 'ValorMaiorFaturamento',
    IsNull(cc.nm_conceito_cliente,'') as nm_conceito_cliente,
    IsNull((select Sum(IsNull(vl_saldo_documento,0))
            from documento_receber with (nolock)
            where cd_cliente = c.cd_cliente and
                  vl_saldo_documento > 0 and
                  dt_cancelamento_documento is null
            group by cd_cliente),0) as Titulo_Aberto,
    IsNull((select (Sum( (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0))
                 * (1 + IsNull(pvi.pc_ipi,0) / 100) ) )
            from pedido_venda_item pvi with (nolock)
                 inner join pedido_venda pv with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
            where pv.cd_cliente = c.cd_cliente and
                  pvi.qt_saldo_pedido_venda > 0 and
                  pvi.dt_cancelamento_item is null and
                  pv.dt_fechamento_pedido is not null
            group by pv.cd_cliente),0) as Pedido_Aberto,
     Cast(0 as Float) as Saldo_Limite,
  sc.nm_status_cliente,
  gc.nm_cliente_grupo

  Into #LimiteCredito
  from
    Cliente c                                with (nolock)
    Inner Join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente          = c.cd_cliente
    Left Outer Join Cliente_Conceito cc      with (nolock) on cc.cd_conceito_cliente = c.cd_conceito_cliente
    left outer join Status_Cliente sc        with (nolock) on sc.cd_status_cliente   = c.cd_status_cliente
    left outer join Cliente_Grupo  gc        with (nolock) on gc.cd_cliente_grupo    = c.cd_cliente_grupo

--select * from Cliente_grupo
--select * from status_cliente

  where
    c.cd_cliente = ci.cd_cliente and
    c.nm_fantasia_cliente like @nm_fantasia_cliente +'%' and
    isnull(sc.ic_operacao_status_cliente,'S') = 'S' 

  order by
    c.nm_fantasia_cliente

update #LimiteCredito set Saldo_Limite = isnull(vl_limite_credito_cliente,0) - (Titulo_Aberto + Pedido_Aberto)

Select * from #LimiteCredito

----------------------------------------------------------------------------------
--Testando a Stored Procedure
----------------------------------------------------------------------------------
--exec pr_analisa_limite_credito_cliente 'toyota'
----------------------------------------------------------------------------------


