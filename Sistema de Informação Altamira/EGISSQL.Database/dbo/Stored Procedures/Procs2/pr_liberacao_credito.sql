
CREATE PROCEDURE pr_liberacao_credito
----------------------------------------------------------------
--pr_liberacao_credito
----------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
----------------------------------------------------------------
--Stored Procedure   : Microsoft SQL Server 2000
--Autor(es)          : Igor Gama
--Banco de Dados     : SapSql
--Objetivo           : Listar os pedidos com liberação de 
--                     crédito em aberto
--Data               : 01/03/2002
--Atualizado         : 07/03/2002 - Igor Gama
--                   : 08/03/2002 - Igor Gama
--                   : 02/04/2002 - Migração p/ EGISSQL - Elias
--                   : 06/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                   : 28.04.2007 - Verificação do Total do Pedido Venda - Carlos Fernandes
----------------------------------------------------------------------------------
@ic_parametro as int,
@dt_inicial   as DateTime,
@dt_final     as DateTime

as

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
    cic.ic_credito_suspenso,
    Case cic.ic_credito_suspenso When 'S' then 'Crédito Suspenso' Else '' end as 'nm_observacao',
    ved.cd_vendedor, 
    ved.nm_fantasia_vendedor,
    ved.sg_vendedor,
    ped.dt_credito_pedido_venda,
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
  where 
    ped.dt_pedido_venda between @dt_inicial and @dt_final and
    ped.dt_credito_pedido_venda is null and 
    ped.dt_cancelamento_pedido  is null and
    isnull(ped.vl_total_pedido_venda,0)>0

--select * from pedido_venda

  Order by
    ped.cd_pedido_venda

  End

