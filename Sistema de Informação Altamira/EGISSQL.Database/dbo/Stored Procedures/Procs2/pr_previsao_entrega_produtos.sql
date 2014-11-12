CREATE PROCEDURE pr_previsao_entrega_produtos

@ic_previsao_entrega_atraso Char(1), 
@nm_fantasia_produto VarChar(30),
@nm_fantasia_cliente VarChar(15),
@cd_pedido_venda Int,
@cd_pdcompra_pedido_venda VarChar(40), 
@nm_fantasia_vendedor VarChar(15)

AS

Declare @Sql as VarChar(8000)
/*
select
	   Case 
	     When GetDate() > IsNull(DataComercial, DataPrevisao)
	       Then 'S'
	     Else 'N'
	   End as 'FlagAtrasado',
	   Case 
	     When IsNull(PedidoVenda,0) <> 0 
	       Then 'S'
	     Else 'N'
	   End as 'FlagPedidoVenda',
	   Case 
	     When (IsNull(PedidoVenda,0) <> 0 and IsNull(Documento,0) <> 0 and Forma = 'PC')
	       Then 'S'
	     Else 'N'
	   End as 'FlagCompraNacional',
	   Case 
	     When (IsNull(PedidoVenda,0) <> 0 and Forma = 'OP')
	       Then 'S'
	     Else 'N'
	   End as 'FlagProducao',
	   Case 
	     When (IsNull(PedidoVenda,0) <> 0 and IsNull(Documento,0) <> 0 and Forma = 'PI')
	       Then 'S'
	     Else 'N'
	   End as 'FlagImportacao',
	   Case 
	     When ((DataComercial is not null) and (DataComercial < DataPrevisao))
	       Then 'S'
	     Else 'N'
	   End as 'FlagPrevisaEntregaAtraso',
	   Case 
	     When IsNull(PedidoVenda,0) = 0
	       Then 'S'
	     Else 'N'
	   End as 'FlagDestinoEstoque',
	   Cliente,
	   PedidoVenda,
	   ItemPedidoVenda,
	   Produto,
	   NomeProduto,
	   SaldoPedidoVenda,
	   Quantidade,
	   DataComercial,
	   Case 
	     When DataDi is not null
	       Then DataDI
	     Else
	       Case
	         When DataInvoice is not null
	           Then DataInvoice
	         Else DataPrevisao 
	       End 
	     End as 'DataPrevisao',
	   Forma,
	   Documento,
	   ItemDocumento,
	   Destino,
	   PedidoCliente,
	   Vendedor
from vw_previsao_entrega_produtos
Where IsNull(DataComercial,'') < (Case 
                                   When @ic_previsao_entrega_atraso = 'S'
                                     Then DataPrevisao
                                   Else IsNull(DataComercial,'') + 1
                                 End) and 
      -- Se for informado o produto
--       IsNull(RTrim(Produto),'') Like (Case 
--                                         When RTrim(@nm_fantasia_produto) <> ''
--                                           Then RTrim(@nm_fantasia_produto) + '%'
--                                         Else IsNull(RTrim(Produto),'')
--                                       End) and
      IsNull(RTrim(Produto),'') Like RTrim(@nm_fantasia_produto) + '%' and
      -- Se for informado o cliente
      IsNull(RTrim(Cliente),'') Like RTrim(@nm_fantasia_cliente) + '%' and
      -- Se for informado o pedido de venda
      IsNull(PedidoVenda,0) = (Case  
                                 When @cd_pedido_venda <> 0
                                   Then @cd_pedido_venda
                                 Else IsNull(PedidoVenda,0) 
                               End) and
      -- Se for informado o pedido do cliente
      IsNull(RTrim(PedidoCliente),'') Like RTrim(@cd_pdcompra_pedido_venda) + '%' and
      -- Se for informado o vendedor	
      IsNull(RTrim(Vendedor),'') Like RTrim(@nm_fantasia_vendedor) + '%'
     
Order by Cliente, PedidoVenda, ItemPedidoVenda
*/

Set @Sql = ' select
               Case 
                 When GetDate() > IsNull(DataComercial, DataPrevisao)
                   Then ''S''
                 Else ''N''
               End as ''FlagAtrasado'',
               Case 
                 When IsNull(PedidoVenda,0) <> 0 
                   Then ''S''
                 Else ''N''
               End as ''FlagPedidoVenda'',
               Case 
                 When (IsNull(PedidoVenda,0) <> 0 and IsNull(Documento,0) <> 0 and Forma = ''PC'')
                   Then ''S''
                 Else ''N''
               End as ''FlagCompraNacional'',
               Case 
                 When (IsNull(PedidoVenda,0) <> 0 and Forma = ''OP'')
                   Then ''S''
                 Else ''N''
               End as ''FlagProducao'',
               Case 
                 When (IsNull(PedidoVenda,0) <> 0 and IsNull(Documento,0) <> 0 and Forma = ''PI'')
                   Then ''S''
                 Else ''N''
               End as ''FlagImportacao'',
               Case 
                 When ((DataComercial is not null) and (DataComercial < DataPrevisao))
                   Then ''S''
                 Else ''N''
               End as ''FlagPrevisaEntregaAtraso'',
               Case 
                 When IsNull(PedidoVenda,0) = 0
                   Then ''S''
                 Else ''N''
               End as ''FlagDestinoEstoque'',
               Cliente,
               PedidoVenda,
               ItemPedidoVenda,
               Produto,
               NomeProduto,
               SaldoPedidoVenda,
               Quantidade,
               DataComercial,
               Case 
                 When DataDi is not null
                   Then DataDI
                 Else
                   Case
                     When DataInvoice is not null
                       Then DataInvoice
                     Else DataPrevisao 
                   End 
                 End as ''DataPrevisao'',
               Forma,
               Documento,
               ItemDocumento,
               Destino,
               PedidoCliente,
               Vendedor
           from vw_previsao_entrega_produtos
           Where IsNull(DataComercial,'''') < (Case 
                                               When ' + QuoteName(@ic_previsao_entrega_atraso,'''') + '= ''S''
                                                 Then DataPrevisao
                                               Else IsNull(DataComercial,'''') + 1
                                             End)'

If @nm_fantasia_produto <> ''
  Set @Sql = @Sql + ' and Produto like ' + QuoteName(@nm_fantasia_produto + '%','''')

If @nm_fantasia_cliente <> ''
  Set @Sql = @Sql + ' and Cliente like ' + QuoteName(@nm_fantasia_Cliente + '%','''')


If @cd_pedido_venda <> 0
  Set @Sql = @Sql + ' and PedidoVenda = ' + QuoteName(@cd_pedido_venda + '%','''')

If @cd_pdcompra_pedido_venda <> ''
  Set @Sql = @Sql + ' and PedidoCliente like ' + QuoteName(@cd_pdcompra_pedido_venda + '%','''')

IF @nm_fantasia_vendedor <> ''
  Set @Sql = @Sql + ' and Vendedor like ' + QuoteName(@nm_fantasia_vendedor + '%','''')

--print @sql

exec (@sql)

-- @ic_previsao_entrega_atraso Char(1) 
-- @nm_fantasia_produto VarChar(30)
-- @nm_fantasia_cliente VarChar(15)
-- @cd_pedido_venda Int
-- @cd_pdcompra_pedido_venda VarChar(40) 
-- @nm_fantasia_vendedor VarChar(15)

--Exec pr_previsao_entrega_produtos 'N','','',0,'',''

--select * from vw_previsao_entrega_produtos


