
CREATE PROCEDURE pr_Consulta_pedido_importacao_canc
------------------------------------------------------------------
--pr_Consulta_pedido_importacao_canc
------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                        2004 
------------------------------------------------------------------
-- Stored Procedure      : Microsoft SQL Server 2000
-- Autor(es)             : Daniel C. Neto.
-- Banco de Dados        : EGISSQL
-- Objetivo              : Consulta de Pedido de Importação Geral
-- Data                  : 20/02/2004
-- Atalização            : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso	
-----------------------------------------------------------------------------
@ic_parametro     int,
@cd_status_pedido int,
@cd_pedido_importacao int,
@dt_inicial       Datetime,
@dt_final         Datetime
as

  if @ic_parametro = 1
  begin 
    Select
	    pim.cd_fornecedor,
	    f.nm_fantasia_fornecedor,
	    pim.cd_pedido_importacao,
	    pim.dt_pedido_importacao,
	    pim.cd_comprador,
	    pim.cd_status_Pedido,
	    cp.nm_fantasia_comprador,
	    pim.nm_canc_pedido_importacao,
	    pim.dt_canc_pedido_importacao,
	    pim.nm_Ativacao_Pedido_importacao,
	    pim.dt_ativacao_Pedido_importacao,
	    pim.cd_contato_fornecedor,
	    fc.nm_contato_fornecedor,
	    pim.vl_pedido_importacao,
	    pim.cd_motivo_ativacao_pedido,
	    pim.cd_motivo_cancel_pedido,
	    imp.nm_fantasia as 'nm_fantasia_importador'
    from 
	    Pedido_Importacao pim Left Join 
	    Comprador cp On pim.cd_comprador = cp.cd_comprador  Left Join 
	    Fornecedor f On pim.cd_fornecedor = f.cd_fornecedor Left Join 
	    Fornecedor_Contato fc On (pim.cd_fornecedor = fc.cd_Fornecedor) and
	                             (pim.cd_Contato_Fornecedor = fc.cd_Contato_Fornecedor) left outer join
	    Importador imp on imp.cd_importador = pim.cd_importador
    where 
			( (pim.dt_pedido_importacao between @dt_inicial and 
			                                   @dt_final ) and
			  (@cd_pedido_importacao = 0) and 
			  (pim.cd_status_pedido = @cd_status_pedido) ) or
			( 
			  (pim.cd_pedido_importacao = @cd_pedido_importacao)
			) 
    order by pim.cd_pedido_importacao desc
  end
    -----------------------------------------------------------------------------------------
  else 
    -----------------------------------------------------------------------------------------
  begin
    Select 
      pii.cd_pedido_importacao,
      p.cd_produto,
      pii.nm_fantasia_produto,
      'CodigoProdutoBaixa' =
        case 
          when p.cd_produto_baixa_estoque is null 
          then p.cd_produto
          else p.cd_produto_baixa_estoque
        end,
      pii.nm_produto_pedido,
      pii.cd_item_ped_imp,
      pii.qt_item_ped_imp,
      pii.vl_item_ped_imp,
      (pii.qt_item_ped_imp * pii.vl_item_ped_imp) as 'Compra',
      pii.pc_desc_item_ped_imp,
      pii.qt_saldo_Item_ped_imp,
      pii.nm_motivo_cancel_item_ped,
      pii.dt_cancel_item_ped_imp,
      pii.nm_motivo_ativ_item_ped,
      pii.dt_ativ_item_Ped_imp,
      pii.dt_entrega_ped_imp,
      ProdCusto.ic_peps_produto,   
      dbo.fn_mascara_produto(pii.cd_produto) as 'cd_mascara_produto',
      pii.cd_motivo_ativacao_pedido,
      pii.cd_motivo_cancel_pedido,
      0 as ic_selecionado 
    from 
      Pedido_Importacao_item pii 
        Left Join 
      Pedido_Importacao pim
        On pim.cd_pedido_importacao = pii.cd_pedido_importacao
        Left Join 
      Produto P
        On P.cd_Produto = pii.cd_Produto
        Left Join 
      Produto_Custo ProdCusto
        On ProdCusto.cd_Produto = pii.cd_Produto
    where
	    pii.cd_pedido_importacao = @cd_pedido_importacao
    order by 
      pii.cd_item_ped_imp
  end
