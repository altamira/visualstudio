

------------------------------------------------------------------------------------------------
--pr_consulta_pedido_compra
------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Igor Gama
--Banco de Dados	: EGISSQL
--Objetivo		: Consultar Pedido Compra
--Data			: 29/05/2002
--Alteração		: Igor - Gama 30/09/2002
--Desc. Alteração	: Troquei de macro subtistuição para um script 
--                        simples e mais rápido
--                      : 25/11/2002 - Adicionado tratamento especial para pedidos em aberto - Daniel C. Neto.
--                      : 05.02.2005 - Acerto do Valor Total 
------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_consulta_pedido_compra
  @cd_pedido_compra		int,
  @cd_fornecedor		int,
  @dt_inicial 			varchar(12),
  @dt_final 			varchar(12),
  @cd_status_pedido		int,
  @cd_requisicao_compra		int,
  @cd_centro_custo		int,
  @nm_referencia 		varchar(40),
  @cd_nota_fiscal		int,
  @cd_pedido_venda      	int
AS

------------------------------------------------------------------------------------
if @cd_status_pedido = 8 -- Tratamento especial para pedidos de status em aberto.
------------------------------------------------------------------------------------

begin

  SELECT
    f.nm_fantasia_fornecedor,
    pc.cd_fornecedor,
    pc.dt_pedido_compra,
    pc.cd_pedido_compra,
    pci.cd_item_pedido_compra,
    pci.qt_item_pedido_compra,
    pci.qt_item_pesliq_ped_compra,
    pci.qt_item_pesbr_ped_compra,
    pci.vl_item_unitario_ped_comp,
    pci.ds_observacao_fabrica,
    pc.ds_pedido_compra,
    pc.nm_ref_pedido_compra,
    pc.dt_cancel_ped_compra,

    --Carlos 05.02.2005
    --Verificar se o pedido possui IPI

--     case when IsNull(pci.pc_ipi,0) > 0 then
--       (pci.qt_item_pedido_compra * pci.vl_item_unitario_ped_comp ) + 
--      ((pci.qt_item_pedido_compra * pci.vl_item_unitario_ped_comp ) * (pci.pc_ipi / 100) )
--     else
--       (pci.qt_item_pedido_compra * pci.vl_item_unitario_ped_comp ) end  as vl_total,

    pci.vl_total_item_pedido_comp as vl_total,
    p.cd_mascara_produto,
    p.nm_produto,
    p.nm_fantasia_produto,
    nei.cd_nota_entrada,
    nei.cd_item_nota_entrada,
    rc.cd_requisicao_compra,
    rc.dt_emissao_req_compra,
    t.nm_transportadora,
    t.cd_transportadora,
    sp.cd_status_pedido,
    sp.nm_status_pedido,
    cc.cd_centro_custo,
    cc.nm_centro_custo,
    pci.cd_pedido_venda,
    co.nm_fantasia_comprador

  FROM
    Pedido_Compra pc
      LEFT OUTER JOIN
    Pedido_Compra_Item pci
      ON pc.cd_pedido_compra = pci.cd_pedido_compra
      LEFT OUTER JOIN
    Produto p
      ON pci.cd_produto = p.cd_produto
      LEFT OUTER JOIN
    Transportadora t
      ON pc.cd_transportadora = t.cd_transportadora 
      LEFT OUTER JOIN
    Nota_Entrada_item nei
      ON pci.cd_pedido_compra = nei.cd_pedido_compra and
         pci.cd_item_pedido_compra = nei.cd_item_pedido_compra
      LEFT OUTER JOIN
    Fornecedor f
      ON pc.cd_fornecedor = f.cd_fornecedor
      LEFT OUTER JOIN
    Requisicao_Compra rc
      ON pci.cd_requisicao_compra = rc.cd_requisicao_compra
      LEFT OUTER JOIN
    Status_Pedido sp
      on pc.cd_status_pedido = sp.cd_status_pedido
      LEFT OUTER JOIN
    Centro_Custo cc
      on pc.cd_centro_custo = cc.cd_centro_custo
      LEFT OUTER JOIN
    Comprador co
      on pc.cd_comprador = co.cd_comprador
    
  Where
    ((@dt_inicial = '') or (pc.dt_pedido_compra between @dt_inicial and @dt_final)) and
    ((@cd_pedido_compra = 0) or (pc.cd_pedido_compra = @cd_pedido_compra)) and
    ((@cd_fornecedor = 0) or (pc.cd_fornecedor = @cd_fornecedor)) and
    (pc.cd_status_pedido = 8) and 
    (pci.qt_saldo_item_ped_compra > 0) and
    ((@cd_requisicao_compra = 0) or (pci.cd_requisicao_compra = @cd_requisicao_compra)) and
    ((@cd_centro_custo = 0) or (pc.cd_centro_custo = @cd_centro_custo)) and
    (( RTrim(LTrim(@nm_referencia)) = '') or ( RTrim(LTrim(pc.nm_ref_pedido_compra)) = RTrim(LTrim(@nm_referencia)) )) and
    ((@cd_nota_fiscal = 0) or (nei.cd_nota_entrada = @cd_nota_fiscal)) and
    ((@cd_pedido_venda = 0) or (pci.cd_pedido_venda = @cd_pedido_venda))


  Order by pc.cd_pedido_compra, pci.cd_item_pedido_compra

end

---------------------------------
else
---------------------------------
begin

  SELECT
    f.nm_fantasia_fornecedor,
    pc.cd_fornecedor,
    pc.dt_pedido_compra,
    pc.cd_pedido_compra,
    pci.cd_item_pedido_compra,
    pci.qt_item_pedido_compra,
    pci.qt_item_pesliq_ped_compra,
    pci.qt_item_pesbr_ped_compra,
    pci.vl_item_unitario_ped_comp,
    pci.ds_observacao_fabrica,
    pc.ds_pedido_compra,
    pc.nm_ref_pedido_compra,
    pc.dt_cancel_ped_compra,

    --Carlos 05.02.2005
    --Verificar se o pedido possui IPI

--     case when IsNull(pci.pc_ipi,0) > 0 then
--       (pci.qt_item_pedido_compra * pci.vl_item_unitario_ped_comp ) + 
--      ((pci.qt_item_pedido_compra * pci.vl_item_unitario_ped_comp ) * (pci.pc_ipi / 100) )
--     else
--       (pci.qt_item_pedido_compra * pci.vl_item_unitario_ped_comp ) end  as vl_total,

    pci.vl_total_item_pedido_comp as vl_total,
    p.cd_mascara_produto,
    p.nm_produto,
    p.nm_fantasia_produto,
    nei.cd_nota_entrada,
    nei.cd_item_nota_entrada,
    rc.cd_requisicao_compra,
    rc.dt_emissao_req_compra,
    t.nm_transportadora,
    t.cd_transportadora,
    sp.cd_status_pedido,
    sp.nm_status_pedido,
    cc.cd_centro_custo,
    cc.nm_centro_custo,
    pci.cd_pedido_venda,
    co.nm_fantasia_comprador
  FROM
    Pedido_Compra pc
      LEFT OUTER JOIN
    Pedido_Compra_Item pci
      ON pc.cd_pedido_compra = pci.cd_pedido_compra
      LEFT OUTER JOIN
    Produto p
      ON pci.cd_produto = p.cd_produto
      LEFT OUTER JOIN
    Transportadora t
      ON pc.cd_transportadora = t.cd_transportadora 
      LEFT OUTER JOIN
    Nota_Entrada_item nei
      ON pci.cd_pedido_compra = nei.cd_pedido_compra and
         pci.cd_item_pedido_compra = nei.cd_item_pedido_compra
      LEFT OUTER JOIN
    Fornecedor f
      ON pc.cd_fornecedor = f.cd_fornecedor
      LEFT OUTER JOIN
    Requisicao_Compra rc
      ON pci.cd_requisicao_compra = rc.cd_requisicao_compra
      LEFT OUTER JOIN
    Status_Pedido sp
      on pc.cd_status_pedido = sp.cd_status_pedido
      LEFT OUTER JOIN
    Centro_Custo cc
      on pc.cd_centro_custo = cc.cd_centro_custo
      LEFT OUTER JOIN
    Comprador co
      on pc.cd_comprador = co.cd_comprador
  Where
--     pc.dt_pedido_compra between '2002-09-01' and '2002-09-30'
    ((@dt_inicial = '') or (pc.dt_pedido_compra between @dt_inicial and @dt_final)) and
    ((@cd_pedido_compra = 0) or (pc.cd_pedido_compra = @cd_pedido_compra)) and
    ((@cd_fornecedor = 0) or (pc.cd_fornecedor = @cd_fornecedor)) and
    ((@cd_status_pedido = 0) or (pc.cd_status_pedido = @cd_status_pedido)) and
    ((@cd_requisicao_compra = 0) or (pci.cd_requisicao_compra = @cd_requisicao_compra)) and
    ((@cd_centro_custo = 0) or (pc.cd_centro_custo = @cd_centro_custo)) and
    (( RTrim(LTrim(@nm_referencia)) = '') or ( RTrim(LTrim(pc.nm_ref_pedido_compra)) = RTrim(LTrim(@nm_referencia)) )) and
    ((@cd_nota_fiscal = 0) or (nei.cd_nota_entrada = @cd_nota_fiscal)) and
    ((@cd_pedido_venda = 0) or (pci.cd_pedido_venda = @cd_pedido_venda))


  Order by pc.cd_pedido_compra, pci.cd_item_pedido_compra

end


-- GO
-- SET QUOTED_IDENTIFIER OFF 
-- GO
-- SET ANSI_NULLS ON 
-- GO

-- exec pr_consulta_pedido_compra
--   @cd_pedido_compra = 0,
--   @cd_fornecedor    = 0,
--   @dt_inicial       = '2002-09-01',
--   @dt_final         = '2002-09-30',
--   @cd_status_pedido = 0,
--   @cd_requisicao_compra	= 0, --72612,
--   @cd_centro_custo  = 0,
--   @nm_referencia    = '',--MUITA CAIXAS ESPECIAL.
--   @cd_nota_fiscal   = 0, --54017,
--   @cd_pedido_venda  = 0 --232245
