
CREATE PROCEDURE pr_logistica_produto_importacao
-------------------------------------------------------------------
--pr_logistica_produto_importacao
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                          2004
-------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)		     : Paulo Souza
--Banco de Dados	 : EGISSQL
--Objetivo		     : Consulta para logistica armazenar produtos de 
--                   importacao
--Data             : 11/03/2005
-------------------------------------------------------------------
@nm_di VarChar(20),
@nm_invoice VarChar(30),
@cd_pedido_venda Int,
@cd_identificacao_pedido VarChar(20)

AS
Begin
	declare @cd_fase_venda int
	declare @nm_fase_produto VarChar(30)
	
	select @cd_fase_venda = cd_fase_produto 
	from parametro_comercial with (nolock)
  where cd_empresa = dbo.fn_empresa()
	
	Select @nm_fase_produto = nm_fase_produto
	From fase_produto with (nolock)
	Where cd_fase_produto = @cd_fase_venda
	
	Select 
	     Case
	       When (pvi.dt_entrega_vendas_pedido > GetDate())
	         Then 'S'
	       Else 'N' 
	     End as 'Atrasado',
	     di.nm_di,
	     dii.cd_di_item,
	     pi.cd_identificacao_pedido,
	     pii.cd_item_ped_imp,
	     i.nm_invoice,
	     ii.cd_invoice_item,
	     p.nm_fantasia_produto,
	     p.nm_produto,
	     dii.qt_efetiva_chegada,
	     pi.dt_pedido_importacao,
	     di.dt_chegada_fabrica,
	     DateDiff(dd, pi.dt_pedido_importacao, di.dt_chegada_fabrica) as 'Dias',
	     ns.cd_nota_saida,
	     nsi.cd_item_nota_saida,
	     IsNull(fp.nm_fase_produto, @nm_fase_produto) as nm_fase_produto,
	     IsNull(ps.qt_saldo_reserva_produto,0) as 'SaldoDisponivel',
	     IsNull(ps.qt_saldo_atual_produto,0) as 'SaldoFisico',
	     dbo.fn_getlocalizacao_produto(p.cd_produto) as 'Endereco',
	     c.nm_fantasia_cliente, 
	     pv.cd_pedido_venda,
	     pvi.cd_item_pedido_venda,
	     pvi.dt_entrega_vendas_pedido,
	     pvi.qt_saldo_pedido_venda,
       ii.sg_tipo_embalagem,
       ii.cd_embalagem
	From Di with (nolock)
	     Left Outer Join Di_Item dii with (nolock) on dii.cd_di = di.cd_di
	     Left Outer Join Produto p with (nolock) on p.cd_produto = dii.cd_produto
	     Left Outer Join Pedido_Importacao_Item pii with (nolock) on pii.cd_pedido_importacao = dii.cd_pedido_importacao and
	                                                                 pii.cd_item_ped_imp = dii.cd_item_ped_imp
	     Left Outer Join Pedido_Importacao pi with (nolock) on pii.cd_pedido_importacao = pi.cd_pedido_importacao
	     Left Outer Join Invoice_Item ii with (nolock) on ii.cd_invoice = dii.cd_invoice and
	                                                      ii.cd_invoice_item = dii.cd_invoice_item
	     Left Outer Join Invoice i with (nolock) on i.cd_invoice = ii.cd_invoice 
	     Left Outer Join Nota_Saida_Item nsi with (nolock) on nsi.cd_di = dii.cd_di and
	                                                          nsi.cd_di_item = dii.cd_di_item
	     Left Outer Join Nota_Saida ns with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
	     Left Outer Join Fase_Produto fp with (nolock) on fp.cd_fase_produto = p.cd_fase_produto_baixa
	     Left Outer Join Produto_Saldo ps  with (nolock) on (p.cd_produto = ps.cd_produto) and
                                                 (ps.cd_fase_produto = IsNull(p.cd_fase_produto_baixa, @cd_fase_venda))
	     Left Outer Join Pedido_Venda_Item pvi with (nolock) on pvi.cd_pedido_venda = pii.cd_pedido_venda and
	                                                            pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda
	     Left Outer Join Pedido_Venda pv with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
	     Left Outer Join Cliente c with (nolock) on c.cd_cliente = pv.cd_cliente
	Where 
        IsNull(RTrim(di.nm_di),'') Like (Case
                                    When RTRim(@nm_di) <> ''
                                      Then RTrim(@nm_di) + '%'
                                    Else IsNull(RTrim(di.nm_di),'')
                                  End) and
        IsNull(RTrim(i.nm_invoice),'') Like (Case  
                                               When RTrim(@nm_invoice) <> ''
                                                 Then RTrim(@nm_invoice) + '%'
                                               Else IsNull(RTrim(i.nm_invoice),'') 
                                             End) and
        IsNull(pv.cd_pedido_venda,0) = (Case
                                          When @cd_pedido_venda <> 0
                                            Then @cd_pedido_venda
                                          Else IsNull(pv.cd_pedido_venda,0)
                                        End) and
        IsNull(pi.cd_identificacao_pedido,'') Like (Case
                                                      When @cd_identificacao_pedido <> ''
                                                        Then @cd_identificacao_pedido + '%'
                                                      Else IsNull(pi.cd_identificacao_pedido,'')
                                                    End)
	Order by di.nm_di, dii.cd_di_item
End

--@nm_di VarChar(20),
--@nm_invoice VarChar(30),
--@cd_pedido_venda Int,
--@cd_identificao_pedido VarChar(20)

--exec pr_logistica_produto_importacao '06/1194740-9','',0,''

