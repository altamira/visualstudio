

/****** Object:  Stored Procedure dbo.pr_cancelamento_liberacao_credito    Script Date: 13/12/2002 15:08:14 ******/

CREATE PROCEDURE pr_cancelamento_liberacao_credito
@ic_parametro as int,
@cd_pedido_venda as int,
@dt_inicial as DateTime,
@dt_final   as DateTime
AS

------------------------------------------------------------------------------
--  @ic_paramentro = 1 - Retorno de todos os pedidos do periodo em analise
------------------------------------------------------------------------------
  If @ic_parametro = 1 
  begin

  Select 
    ped.cd_pedido_venda, 
    ped.dt_pedido_venda, 
    ped.vl_total_pedido_venda, 
    ped.qt_bruto_pedido_venda, 
    cli.cd_cliente, 
    cli.nm_fantasia_cliente,
    cli.nm_razao_social_cliente,
    cic.ic_credito_suspenso,
    Case cic.ic_credito_suspenso When 'S' then 'Crédito Suspenso' Else '' end as 'nm_observacao',
    ved.cd_vendedor, 
    ved.nm_fantasia_vendedor,
    ved.sg_vendedor,
    ped.dt_cancelamento_pedido,
    ped.ds_cancelamento_pedido,
    cp.sg_condicao_pagamento,
    cp.nm_condicao_pagamento,
    ped.dt_credito_pedido_venda,
    (Select nm_usuario from EgisAdmin.dbo.Usuario where cd_usuario = ped.cd_usuario_credito_pedido) as 'nm_usuario_liberacao_credito',
    ped.cd_usuario_credito_pedido,
    ped.cd_usuario,
    ped.dt_usuario,
    Case When ISNULL(ped.dt_credito_pedido_venda, 0) = 0 then 'N' else 'S' end as 'ic_liberado'
  from 
    Pedido_Venda ped inner join Cliente cli 
      on ped.cd_cliente = cli.cd_cliente 
    Left Join Cliente_Informacao_Credito cic
      on cli.cd_cliente = cic.cd_cliente
    Inner Join Vendedor ved
      on ped.cd_vendedor = ved.cd_vendedor
    Left outer join Condicao_Pagamento cp 
      on ped.cd_condicao_pagamento = cp.cd_condicao_pagamento
  where 
    ped.dt_pedido_venda between @dt_inicial and @dt_final and
    ped.dt_credito_pedido_venda is not null and 
    ped.cd_usuario_credito_pedido is not null and
    ped.dt_cancelamento_pedido is null
  Order by
    ped.cd_pedido_venda

  End

------------------------------------------------------------------------------
--  @ic_paramentro = 2 - Consulta de um único Pedido
------------------------------------------------------------------------------
  If @ic_parametro = 2
  begin

  Select 
    ped.cd_pedido_venda, 
    ped.dt_pedido_venda, 
    ped.vl_total_pedido_venda, 
    ped.qt_bruto_pedido_venda, 
    cli.cd_cliente, 
    cli.nm_fantasia_cliente,
    cli.nm_razao_social_cliente,
    cic.ic_credito_suspenso,
    Case cic.ic_credito_suspenso When 'S' then 'Crédito Suspenso' Else '' end as 'nm_observacao',
    ved.cd_vendedor, 
    ved.nm_fantasia_vendedor,
    ved.sg_vendedor,
    ped.dt_cancelamento_pedido,
    ped.ds_cancelamento_pedido,
    cp.sg_condicao_pagamento,
    cp.nm_condicao_pagamento,
    ped.dt_credito_pedido_venda,
    (Select nm_usuario from EgisAdmin.dbo.Usuario where cd_usuario = ped.cd_usuario_credito_pedido) as 'nm_usuario_liberacao_credito',
    ped.cd_usuario_credito_pedido,
    ped.cd_usuario,
    ped.dt_usuario,
    Case When ISNULL(ped.dt_credito_pedido_venda, 0) = 0 then 'N' else 'S' end as 'ic_liberado'
  from 
    Pedido_Venda ped inner join Cliente cli 
      on ped.cd_cliente = cli.cd_cliente 
    Left Join Cliente_Informacao_Credito cic
      on cli.cd_cliente = cic.cd_cliente
    Inner Join Vendedor ved
      on ped.cd_vendedor = ved.cd_vendedor
    Left outer join Condicao_Pagamento cp 
      on ped.cd_condicao_pagamento = cp.cd_condicao_pagamento
  where 
    ped.dt_pedido_venda between @dt_inicial and @dt_final and
    ped.cd_pedido_venda = @cd_pedido_venda and
    ped.dt_credito_pedido_venda is not null and 
    ped.cd_usuario_credito_pedido is not null and
    ped.dt_cancelamento_pedido is null
  Order by
    ped.cd_pedido_venda

  End



