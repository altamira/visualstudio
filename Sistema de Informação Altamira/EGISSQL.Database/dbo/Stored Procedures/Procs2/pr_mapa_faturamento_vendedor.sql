
CREATE  PROCEDURE pr_mapa_faturamento_vendedor
---------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel Carrasco Neto
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta Mapa Faturamento Analítico de SMO
--Data			: 07/06/2002
--Desc. Alteração	: ALteração de Campo do cd_grupo_produto da tabela
-- grupo_produto para o cd_grupo_produto da tabela produto
-- 12/07/2002 - Alterado para pegar o cd_grupo_categoria da tabela Categoria_Produto
-- Daniel C. Neto.
-- 11/07/2003 - Fabio - Alterado o ICMS para pegar do Item.                      
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes
----------------------------------------------------------------------------------------------
  @cd_vendedor           int      = 0,
  @dt_inicial            datetime = '', --Data Inicial
  @dt_final              datetime = '', --Data Final
  @Operacao              int      = 2,  --Operação (E-1/S-2)
  @Comercial             Char(1)  = 'S' --Valor Comercial (S/N)

AS

-- Consulta do Faturamento por vendedor

SELECT 
   (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = ns.cd_vendedor)nm_fantasia_vendedor, 
   nsi.cd_pedido_venda, 
   nsi.cd_item_pedido_venda, 
   IsNull(nsi.vl_frete_item,0) as 'vl_frete_item', 
   IsNull(nsi.vl_seguro_item,0) as 'vl_seguro_item', 
   IsNull(nsi.vl_desp_acess_item,0) as 'vl_desp_acess_item', 
   IsNull(nsi.vl_ipi,0) as 'vl_ipi', 
   ns.dt_nota_saida, 
--   ns.cd_nota_saida, 

   case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
      ns.cd_identificacao_nota_saida
   else
      ns.cd_nota_saida                  
   end                              as 'cd_nota_saida',

   ns.nm_fantasia_destinatario as nm_fantasia_cliente,

   (Select top 1 nm_destinacao_produto from Destinacao_produto where cd_destinacao_produto = ns.cd_destinacao_produto) as nm_destinacao_produto, 
   (Select top 1 dt_item_pedido_venda  from Pedido_Venda_Item where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda) as dt_item_pedido_venda, 
   nsi.nm_fantasia_produto,
   (Select top 1 qt_item_pedido_venda  from Pedido_Venda_Item where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda) as qt_item_pedido_venda, 
   (Select top 1 IsNull(ic_smo_item_pedido_venda,'N') from Pedido_Venda_Item where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda) as FatSMO, 
   (Select top 1 IsNull(qt_item_pedido_venda,0) * IsNull(vl_unitario_item_pedido,0) from Pedido_Venda_Item where cd_pedido_venda = nsi.cd_pedido_venda and cd_item_pedido_venda = nsi.cd_item_pedido_venda) as vl_venda, 
   case 
     when (ns.vl_produto = ns.vl_total) then
		nsi.vl_unitario_item_nota * IsNull(nsi.qt_item_nota_saida,0)
     else
		nsi.vl_ipi + (nsi.vl_unitario_item_nota * IsNull(nsi.qt_item_nota_saida,0))
   end AS vl_faturado,
   cast(ds_item_nota_saida as varchar(50)) as nm_produto,
   (Select top 1 IsNull(vl_produto,0) from Produto where cd_produto = nsi.cd_produto) as vl_produto,
   IsNull(nsi.vl_icms_item,0) as vl_icms,
   case
     when (ns.vl_produto = ns.vl_total) then
		nsi.vl_unitario_item_nota * IsNull(nsi.qt_devolucao_item_nota,0)
     else
		IsNull((Select vl_ipi + (vl_unitario_item_nota * IsNull(qt_devolucao_item_nota,0)) from Nota_saida_item where cd_nota_saida = ns.cd_nota_saida and cd_item_nota_saida = nsi. cd_item_nota_saida and IsNull(qt_devolucao_item_nota,0)>0),0)
   end AS devolucao,

   'F'                   as 'status',

   ns.dt_entrega_nota_saida, 
   (Select top 1 nm_categoria_produto from Categoria_Produto where cd_categoria_produto = nsi.cd_categoria_produto) as nm_categoria_produto,
   ns.cd_operacao_fiscal,
   op.cd_mascara_operacao
FROM 
      Nota_Saida ns          with (nolock) 
      Left Outer join
      Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida
        Left Outer join
      Operacao_Fiscal op on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
        Left Outer Join
      Grupo_Operacao_Fiscal gop on op.cd_grupo_operacao_fiscal = gop.cd_grupo_operacao_fiscal
WHERE                 
  ((ns.cd_vendedor = @cd_vendedor) or (@cd_vendedor = 0))  and
   ns.dt_nota_saida between @dt_inicial and @dt_final and 
   ns.cd_status_nota not in(4,7)        and --Desconsidera as notas devolvidas totalmente e canceladas
   isnull(op.ic_comercial_operacao,'N') = @Comercial and
   gop.cd_tipo_operacao_fiscal          = @Operacao

ORDER BY
   v.nm_fantasia_vendedor, ns.dt_nota_saida, ns.cd_nota_saida


