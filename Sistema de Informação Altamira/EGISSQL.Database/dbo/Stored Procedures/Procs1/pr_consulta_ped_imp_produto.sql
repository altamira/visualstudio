
create procedure pr_consulta_ped_imp_produto
-------------------------------------------------------------------
--pr_consulta_ped_imp_produto
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                	       2004
-------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Daniel C. Neto.
--Banco de Dados          : EgisSql
--Objetivo                : Realizar uma consulta geral sobre Pedido de Importação
--                          por Produto
--Data                    : 17/02/2003
--Atualizado              : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
------------------------------------------------------------------------------------

  @nm_fantasia_produto varchar(40),
  @dt_inicial 			datetime,
  @dt_final 			datetime

AS

SELECT     
  pim.cd_pedido_importacao,
  pim.dt_pedido_importacao,
  c.nm_fantasia_comprador, 
  f.nm_fantasia_fornecedor, 
  i.nm_fantasia as nm_fantasia_importador, 
  pii.cd_item_ped_imp, 
  pii.qt_item_ped_imp, 
  pii.vl_item_ped_imp, 
  pii.pc_desc_item_ped_imp, 
  pii.nm_fantasia_produto, 
  pii.nm_produto_pedido,
  ns.cd_nota_saida, 
  ns.dt_nota_saida,
  pii.dt_entrega_ped_imp,
  pii.qt_saldo_item_ped_imp

FROM         
  Pedido_Importacao pim LEFT OUTER JOIN
  Fornecedor f ON pim.cd_fornecedor = f.cd_fornecedor LEFT OUTER JOIN
  Importador i ON pim.cd_importador = i.cd_importador LEFT OUTER JOIN
  Comprador c ON pim.cd_comprador = c.cd_comprador LEFT OUTER JOIN
  Pedido_Importacao_Item pii ON pim.cd_pedido_importacao = pii.cd_pedido_importacao LEFT OUTER JOIN
  Nota_Saida_Item nsi ON pim.cd_pedido_importacao = nsi.cd_pedido_importacao and
                         pii.cd_item_ped_imp = nsi.cd_item_ped_imp LEFT OUTER JOIN
  Nota_Saida ns ON nsi.cd_nota_saida = ns.cd_nota_saida
where
  pii.nm_fantasia_produto like @nm_fantasia_produto + '%' and
  pim.dt_pedido_importacao between @dt_inicial and @dt_final and
  pii.dt_cancel_item_ped_imp is null



