
create procedure pr_controle_di

@dt_inicial  		 datetime,
@dt_final    		 datetime,
@cd_pedido_importacao	 int,
@nm_identificacao_pedido VarChar(20),
@ic_tipo_consulta        int, -- Define se a consulta é (1) DI, 
                       -- (2) itens da DI
@nm_fantasia_produto     VarChar(30),
@nm_fantasia_fornecedor  Char(15),
@nm_fantasia_cliente     VarChar(15),
@nm_DI                   VarChar(30),
@nm_fantasia_importador  VarChar(15),
@cd_di                   Int,
@ic_data_filtro          int,
@nm_invoice              VarChar(30)

as

Begin

  If @ic_tipo_consulta = 1     -- Pesquisa controle DI
    Select Distinct
          Di.cd_di                 as 'CodigoDI',
          imp.nm_fantasia          as 'Importador',
          f.nm_fantasia_fornecedor as 'Fornecedor',
          d.nm_fantasia            as 'Despachante',
          di.nm_di                 as 'Identificacao',
          sd.nm_status_di          as 'Status',
          di.nm_ref_despachante_di as 'NumeroRegistro',
          di.nm_bl_awb as 'Mawb',
          di.nm_h_bl_awb as 'Hawb',
          di.dt_desembaraco as 'Emissao',
          di.dt_embarque as 'Embarque',
          IsNull(di.dt_chegada, di.dt_previsao_chegada_di) as 'ChegadaPais',
          isnull(di.dt_prev_desembaraco, di.dt_desembaraco) as 'Liberacao',
          IsNull(di.dt_chegada_fabrica, di.dt_prev_chegada_fabrica) as 'ChegadaEmpresa',
          po.nm_porto as 'Origem',
          pd.nm_porto as 'Destino',
          IsNull(di.vl_mercadoria_di_moeda,0) as 'TotalMoeda',
          IsNull(di.vl_moeda_di,0) as 'Cotacao',
       	  di.vl_paridade_moeda_di as 'Paridade',	
---          (IsNull(di.vl_mercadoria_di_moeda,0) * IsNull(di.vl_moeda_di,0)) as 'Total',
          IsNull(di.vl_mercadoria_di,0) as 'Total',
          IsNull(di.qt_peso_bruto_di,0) as 'Peso',
          Cast(di.ds_observacao_di as VarChar(1000)) as 'Observacao',
          m.sg_moeda as 'Moeda',
          pi.cd_licenca_importacao as 'LicencaImportacao',
          pi.dt_registro_licenca as 'DataLicenca',
          pi.dt_validade_licenca as 'ValidadeLicenca'
--          pimp.cd_part_number_produto
    from Di              with (nolock)   
         Left outer join Di_Item dii    with (nolock)   on (dii.cd_di = Di.cd_di)
         Left outer join Importador imp with (nolock)   on (imp.cd_importador = di.cd_importador)
         Left outer join Fornecedor f   with (nolock)   on (f.cd_fornecedor = di.cd_fornecedor)
         Left outer join Despachante d  with (nolock)   on (d.cd_despachante = di.cd_despachante)
         Left outer join Status_Di sd   with (nolock)   on (sd.cd_status_di = di.cd_status_di)
         Left outer join Porto po       with (nolock)   on (po.cd_porto = di.cd_porto)
         Left outer join Porto pd       with (nolock)   on (pd.cd_porto = di.cd_porto_destino)
         Left outer join Moeda m        with (nolock)   on (m.cd_moeda = di.cd_moeda_di)
         Left outer join Pedido_Importacao_Item pii with (nolock)   on (pii.cd_pedido_importacao = dii.cd_pedido_importacao and
                                                        pii.cd_item_ped_imp = dii.cd_item_ped_imp)
         Left outer join Pedido_Importacao pi    with (nolock)  on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
         Left outer join Pedido_Venda_item pvi with (nolock)   on (pvi.cd_pedido_venda = pii.cd_pedido_venda and 
                                                   pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
         Left outer join Pedido_Venda pv       with (nolock)   on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
         Left outer join Cliente c             with (nolock)   on (c.cd_cliente = pv.cd_cliente) 
         Left outer join Produto p             with (nolock)   on (p.cd_produto = dii.cd_produto)
         Left outer join Invoice_Item ii       with (nolock)   on (ii.cd_invoice_item = dii.cd_invoice_item and
                                                                   ii.cd_invoice      = dii.cd_invoice)
         Left outer join Invoice i               with (nolock)   on (i.cd_invoice = ii.cd_invoice)
--         left outer join Produto_Importacao pimp with (nolock)   on pimp.cd_produto = p.cd_produto

    where
      -- Definir se filtra por data do pedido ou data entrega itens
	Case when @ic_data_filtro=0
	     then @dt_inicial
	     else di.dt_desembaraco 
        end between @dt_inicial and @dt_final and
      -- Se for infomado a identificacao da invoice
      IsNull(di.nm_di,'') Like (Case
                                  When @nm_di <> ''
                                    Then @nm_di + '%'
                                  Else IsNull(di.nm_di,'')
                                End) and
      -- Se for informado o importador
      IsNull(imp.nm_fantasia,'') Like (Case
                                         When @nm_fantasia_importador <> ''
                                           Then @nm_fantasia_importador + '%'
                                         Else IsNull(imp.nm_fantasia,'')
                                       End) and

      IsNull(RTrim(f.nm_fantasia_fornecedor),'') Like (Case
                                                         When RTrim(@nm_fantasia_fornecedor) <> ''
                                                           Then RTrim(@nm_fantasia_fornecedor) + '%'
                                                         Else IsNull(RTrim(f.nm_fantasia_fornecedor),'')
                                                       End) and
      -- Se for informado o produto
      IsNull(RTrim(p.nm_fantasia_produto),'') Like (Case 
                                                      When RTrim(@nm_fantasia_produto) <> ''
                                                        Then RTrim(@nm_fantasia_produto) + '%'
                                                      Else IsNull(RTrim(p.nm_fantasia_produto),'')
                                                    End) and
      -- Se for informado o pedido
      IsNull(pi.cd_pedido_importacao,0) = (Case 
                                             When IsNull(@cd_pedido_importacao,0) <> 0 
                                               Then IsNull(@cd_pedido_importacao,0)
                                             Else IsNull(pi.cd_pedido_importacao,0)
                                           End) and
      -- Se for informado a identificacao do pedido
      IsNull(pi.cd_identificacao_pedido,'') Like (Case
                                                    When @nm_identificacao_pedido <> ''
                                                      Then @nm_identificacao_pedido + '%'
                                                    Else IsNull(pi.cd_identificacao_pedido,'')
                                                  End) and
      -- Se for informado o cliente
      IsNull(RTrim(c.nm_fantasia_cliente),'') Like (Case  
                                                      When RTrim(@nm_fantasia_cliente) <> ''
                                                        Then RTrim(@nm_fantasia_cliente) + '%'
                                                      Else IsNull(RTrim(c.nm_fantasia_cliente),'') 
                                                    End) and
      IsNull(RTrim(i.nm_invoice),'') Like (Case  
                                             When RTrim(@nm_invoice) <> ''
                                               Then RTrim(@nm_invoice) + '%'
                                             Else IsNull(RTrim(i.nm_invoice),'') 
                                           End) 
    Order By di.dt_desembaraco desc

  Else If @ic_tipo_consulta = 2         -- Pesquisa controle de DI (Itens)
    select 
          dii.cd_di as 'CodigoDI',
          dii.cd_di_item as 'Item',
          pi.cd_identificacao_pedido as 'IdentificacaoPedido',
          pi.cd_pedido_importacao as 'PI',
          pii.cd_item_ped_imp as 'ItemPI',
          p.nm_fantasia_produto as 'Produto',
          IsNull(dii.qt_embarque,0) as 'QtdEmbarque', 
          IsNull(dii.qt_efetiva_chegada,0) as 'QtdChegou',
          IsNull(dii.vl_produto_moeda_origem,0) as 'UnitMoeda',
--          (IsNull(dii.qt_efetiva_chegada,0) * IsNull(dii.vl_produto_moeda_origem,0)) as 'TotalMoeda',
          IsNull(dii.vl_total_moeda_origem,0) as 'TotalMoeda',
          IsNull(dii.vl_produto_moeda_destino,0) as 'Unit',
--          (IsNull(dii.qt_efetiva_chegada,0) * IsNull(dii.vl_produto_moeda_destino,0)) as 'Total',
          IsNull(dii.vl_total_moeda_destino,0) as 'Total',
          oi.nm_origem_importacao as 'Origem',
          dii.nm_obs_item_di as 'Observacao',
          i.nm_invoice as 'Invoice',
          dii.cd_invoice_item as 'ItemInvoice',
          pv.cd_pedido_venda as 'PV',
          c.nm_fantasia_cliente as 'Cliente',
          pimp.cd_part_number_produto

    from Di_Item dii
         Left outer join Di on (di.cd_di = dii.cd_di)
         Left outer join Pedido_Importacao_Item pii on (pii.cd_pedido_importacao = dii.cd_pedido_importacao and
                                                        pii.cd_item_ped_imp = dii.cd_item_ped_imp)
         Left outer join Pedido_Importacao pi on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
         Left outer join Pedido_Venda_item pvi on (pvi.cd_pedido_venda = pii.cd_pedido_venda and 
                                                   pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
         Left outer join Pedido_Venda pv on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
         Left outer join Cliente c on (c.cd_cliente = pv.cd_cliente) 
         Left outer join Produto p on (p.cd_produto = dii.cd_produto)
         Left outer join Origem_Importacao oi on (oi.cd_origem_importacao = dii.cd_origem_importacao)
--         Left outer join Invoice_Item ii on (ii.cd_pedido_importacao = pii.cd_pedido_importacao and
--                                             ii.cd_item_ped_imp = pii.cd_item_ped_imp)
--         Left outer join Invoice i on (i.cd_invoice = ii.cd_invoice)
--         Left outer join Invoice i on (i.cd_invoice = dii.cd_invoice)
         Left outer join Invoice_Item ii on (ii.cd_invoice_item = dii.cd_invoice_item and
                                             ii.cd_invoice = dii.cd_invoice)
         Left outer join Invoice i on (i.cd_invoice = ii.cd_invoice)
         left outer join Produto_Importacao pimp on pimp.cd_produto = p.cd_produto

    where dii.cd_di = @cd_di and
          -- Se for informado o produto
          IsNull(RTrim(p.nm_fantasia_produto),'') Like (Case 
                                                          When RTrim(@nm_fantasia_produto) <> ''
                                                            Then RTrim(@nm_fantasia_produto) + '%'
                                                          Else IsNull(RTrim(p.nm_fantasia_produto),'')
                                                        End) and
          -- Se for informado o pedido
          IsNull(pi.cd_pedido_importacao,0) = (Case 
                                                 When IsNull(@cd_pedido_importacao,0) <> 0 
                                                   Then IsNull(@cd_pedido_importacao,0)
                                                 Else IsNull(pi.cd_pedido_importacao,0)
                                               End) and
          -- Se for informado a identificacao do pedido
          IsNull(pi.cd_identificacao_pedido,'') Like (Case
                                                        When @nm_identificacao_pedido <> ''
                                                          Then @nm_identificacao_pedido + '%'
                                                        Else IsNull(pi.cd_identificacao_pedido,'')
                                                      End) and
          -- Se for informado o cliente
          IsNull(c.nm_fantasia_cliente,'') Like (Case  
                                                   When RTrim(@nm_fantasia_cliente) <> ''
                                                     Then RTrim(@nm_fantasia_cliente) + '%'
                                                   Else IsNull(RTrim(c.nm_fantasia_cliente),'') 
                                                 End) and
          IsNull(RTrim(i.nm_invoice),'') Like (Case  
                                                 When RTrim(@nm_invoice) <> ''
                                                   Then RTrim(@nm_invoice) + '%'
                                                 Else IsNull(RTrim(i.nm_invoice),'') 
                                               End) 
    Order By dii.cd_di, dii.cd_di_item
End
