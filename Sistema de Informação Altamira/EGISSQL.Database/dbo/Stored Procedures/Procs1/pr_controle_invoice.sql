
create procedure pr_controle_invoice

@dt_inicial  		datetime,
@dt_final    		datetime,
@cd_pedido_importacao	int,
@nm_identificacao_pedido VarChar(20),
@ic_tipo_consulta        int, -- Define se a consulta é (1) Invoice, 
                       -- (2) itens da invoice 
@nm_fantasia_produto     VarChar(30),
@nm_fantasia_fornecedor Char(15),
@nm_fantasia_cliente VarChar(15),
@nm_invoice VarChar(30),
@nm_fantasia_importador VarChar(15),
@cd_invoice int,
@ic_data_filtro int

as
Begin

  If @ic_tipo_consulta = 1     -- Pesquisa controle invoice
       Select 
         Distinct
          pi.cd_pedido_importacao,
          pi.cd_identificacao_pedido,
	       c.nm_fantasia_cliente,
          i.cd_invoice                  as 'CodigoInvoice',
          imp.nm_fantasia               as 'Importador',
          f.nm_fantasia_fornecedor      as 'Fornecedor',
          i.nm_invoice as 'Identificacao',
          si.nm_status_invoice as 'Status',
          tf.nm_tipo_frete as 'TipoFrete',
          tc.sg_termo_comercial as 'Incoterm',
          i.dt_invoice as 'Emissao',
          i.dt_embarque as 'Embarque',
          i.dt_chegada_pais_prev as 'ChegadaPais',
          i.dt_liberacao_prev as 'Liberacao',
          i.dt_chegada_empresa_prev as 'ChegadaEmpresa',
          po.nm_porto as 'Origem',
          pd.nm_porto as 'Destino',
          IsNull(i.vl_total_invoice,0) as 'TotalMoeda',
          IsNull(i.vl_moeda,0) as 'Cotacao',
          (IsNull(i.vl_total_invoice,0) * IsNull(i.vl_moeda,0)) as 'Total',
          IsNull(i.qt_peso_bruto,0) as 'Peso',
          Cast(i.ds_invoice_observacao as VarChar(1000)) as 'Observacao',
          m.sg_moeda as 'Moeda',
          IsNull(i.vl_total_frete,0) as 'FreteMoeda',
          (IsNull(i.vl_total_frete,0) * IsNull(i.vl_moeda_frete,0)) as 'TotalFrete'
       from Invoice i                       with (nolock) 
         Left outer join Invoice_Item ii    with (nolock) on (ii.cd_invoice = i.cd_invoice)
         Left outer join Importador imp     with (nolock) on (imp.cd_importador = i.cd_importador)
         Left outer join Fornecedor f       with (nolock) on (f.cd_fornecedor = i.cd_fornecedor)
         Left outer join Status_Invoice si  with (nolock) on (si.cd_status_invoice = i.cd_status_invoice)
         Left outer join Tipo_Frete tf      with (nolock) on (tf.cd_tipo_frete = i.cd_tipo_frete)
         Left outer join Termo_Comercial tc with (nolock) on (tc.cd_termo_comercial = i.cd_termo_comercial)
         Left outer join Porto po           with (nolock) on (po.cd_porto = i.cd_porto_origem)
         Left outer join Porto pd           with (nolock) on (pd.cd_porto = i.cd_porto_destino)
         Left outer join Pedido_Importacao_Item pii with (nolock) on (pii.cd_pedido_importacao = ii.cd_pedido_importacao and
                                                                       pii.cd_item_ped_imp = ii.cd_item_ped_imp)
          Left outer join Pedido_Importacao pi  with (nolock) on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
          Left outer join Pedido_Venda_item pvi with (nolock) on (pvi.cd_pedido_venda = pii.cd_pedido_venda and 
                                                                  pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
          Left outer join Pedido_Venda pv       with (nolock) on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
          Left outer join Cliente c             with (nolock) on (c.cd_cliente = pv.cd_cliente) 
         Left outer join Produto p             with (nolock) on (p.cd_produto = ii.cd_produto)
         Left outer join Moeda m               with (nolock) on (m.cd_moeda = i.cd_moeda)

--select * from invoice

    where
      -- Definir se filtra por data do pedido ou data entrega itens
      case when @ic_data_filtro = 0 
	   then	@dt_inicial
	   else i.dt_invoice
	end  between @dt_inicial and @dt_final  and
      -- Se for infomado a identificacao da invoice
      IsNull(i.nm_invoice,'') Like (Case
                                       When @nm_invoice <> ''
                                         Then @nm_invoice + '%'
                                       Else IsNull(i.nm_invoice,'')
                                    End) and
      -- Se for informado o importador
      IsNull(imp.nm_fantasia,'') Like (Case
                                         When @nm_fantasia_importador <> ''
                                           Then @nm_fantasia_importador + '%'
                                         Else IsNull(imp.nm_fantasia,'')
                                       End) and
      -- Se for informado o fornecedor
      IsNull(RTrim(f.nm_fantasia_fornecedor),'') Like (Case
                                                         When RTrim(@nm_fantasia_fornecedor) <> ''
                                                           Then RTrim(@nm_fantasia_fornecedor) + '%'
                                                         Else IsNull(RTrim(f.nm_fantasia_fornecedor),'')
                                                       End) and
      -- Se for informado o produto
      IsNull(p.nm_fantasia_produto,'') Like (Case 
                                               When @nm_fantasia_produto <> ''
                                                 Then @nm_fantasia_produto + '%'
                                               Else IsNull(p.nm_fantasia_produto,'')
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
      IsNull(c.nm_fantasia_cliente,'') = (Case  
                                            When @nm_fantasia_cliente <> ''
                                              Then @nm_fantasia_cliente
                                            Else IsNull(c.nm_fantasia_cliente,'') 
                                          End) 
    Order By i.nm_invoice

  Else If @ic_tipo_consulta = 2         -- Pesquisa controle de importação (Itens)
    select 
          ii.cd_invoice as 'CodigoInvoice',
          ii.cd_invoice_item as 'Item',
          p.nm_fantasia_produto as 'Produto',
          ii.nm_produto_invoice as 'NomeProduto',
          IsNull(ii.qt_invoice_item,0) as 'Qtd',
          IsNull(ii.vl_invoice_item,0) as 'Unit',
          IsNull(ii.pc_invoice_item_desconto,0) as 'Desc',
          IsNull(ii.vl_invoice_item_total,0) as 'TotalMoeda',
          (IsNull(ii.vl_invoice_item_total,0) * IsNull(i.vl_moeda,0)) as 'Total',
          IsNull(ii.qt_peso_bruto,0) as 'Peso',   
          oi.nm_origem_importacao as 'Origem',
          ii.nm_obs_invoice_item as 'Observacao',
          pi.cd_pedido_importacao as 'PI',
          pi.cd_identificacao_pedido as 'IdentificacaoPedido',
          pv.cd_pedido_venda as 'PV',
          c.nm_fantasia_cliente as 'Cliente',
          m.sg_moeda as 'Moeda',
          pimp.cd_part_number_produto

    from Invoice_Item ii
         Left outer join Invoice i on (i.cd_invoice = ii.cd_invoice)
         Left outer join Pedido_Importacao_Item pii on (pii.cd_pedido_importacao = ii.cd_pedido_importacao and
                                                        pii.cd_item_ped_imp = ii.cd_item_ped_imp)
         Left outer join Pedido_Importacao pi on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
         Left outer join Pedido_Venda_item pvi on (pvi.cd_pedido_venda = pii.cd_pedido_venda and 
                                                   pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
         Left outer join Pedido_Venda pv on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
         Left outer join Cliente c on (c.cd_cliente = pv.cd_cliente) 
         Left outer join Produto p on (p.cd_produto = ii.cd_produto)
         Left outer join Origem_Importacao oi on (oi.cd_origem_importacao = ii.cd_origem_importacao)
         Left outer join Moeda m on (m.cd_moeda = i.cd_moeda)
         left outer join Produto_Importacao pimp on pimp.cd_produto = p.cd_produto

    where ii.cd_invoice = @cd_invoice and
          -- Se for informado o produto
          IsNull(p.nm_fantasia_produto,'') Like (Case 
                                                   When @nm_fantasia_produto <> ''
                                                     Then @nm_fantasia_produto + '%'
                                                   Else IsNull(p.nm_fantasia_produto,'')
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
          IsNull(c.nm_fantasia_cliente,'') = (Case  
                                                When @nm_fantasia_cliente <> ''
                                                  Then @nm_fantasia_cliente
                                                Else IsNull(c.nm_fantasia_cliente,'') 
                                              End) 
    Order By ii.cd_invoice, ii.cd_invoice_item
End
  If @ic_tipo_consulta = 3     -- Sem linhas duplicadas pelo cd_pedido_importação
       Select
          Distinct
          i.cd_invoice              as 'CodigoInvoice',
          imp.nm_fantasia           as 'Importador',
          f.nm_fantasia_fornecedor  as 'Fornecedor',
          i.nm_invoice              as 'Identificacao',
          si.nm_status_invoice      as 'Status',
          tf.nm_tipo_frete          as 'TipoFrete',
          tc.sg_termo_comercial     as 'Incoterm',
          i.dt_invoice              as 'Emissao',
          i.dt_embarque             as 'Embarque',
          i.dt_chegada_pais_prev    as 'ChegadaPais',
          i.dt_liberacao_prev       as 'Liberacao',
          i.dt_chegada_empresa_prev as 'ChegadaEmpresa',
          po.nm_porto                  as 'Origem',
          pd.nm_porto                  as 'Destino',
          IsNull(i.vl_total_invoice,0) as 'TotalMoeda',
          IsNull(i.vl_moeda,0)         as 'Cotacao',
          (IsNull(i.vl_total_invoice,0) * IsNull(i.vl_moeda,0)) as 'Total',
          IsNull(i.qt_peso_bruto,0)    as 'Peso',
          Cast(i.ds_invoice_observacao as VarChar(1000)) as 'Observacao',
          m.sg_moeda as 'Moeda',
          IsNull(i.vl_total_frete,0) as 'FreteMoeda',
          (IsNull(i.vl_total_frete,0) * IsNull(i.vl_moeda_frete,0)) as 'TotalFrete',
          pi.cd_licenca_importacao as 'LicencaImportacao',
          pi.dt_registro_licenca as 'DataLicenca',
          pi.dt_validade_licenca as 'ValidadeLicenca',
          de.nm_fantasia as 'Despachante'
          --pimp.cd_part_number_produto
  
       from Invoice i
         Left outer join Invoice_Item ii    on (ii.cd_invoice = i.cd_invoice)
         Left outer join Importador imp     on (imp.cd_importador = i.cd_importador)
         Left outer join Fornecedor f       on (f.cd_fornecedor = i.cd_fornecedor)
         Left outer join Status_Invoice si  on (si.cd_status_invoice = i.cd_status_invoice)
         Left outer join Tipo_Frete tf      on (tf.cd_tipo_frete = i.cd_tipo_frete)
         Left outer join Termo_Comercial tc on (tc.cd_termo_comercial = i.cd_termo_comercial)
         Left outer join Porto po                   on (po.cd_porto = i.cd_porto_origem)
         Left outer join Porto pd                   on (pd.cd_porto = i.cd_porto_destino)
         Left outer join Pedido_Importacao_Item pii on (pii.cd_pedido_importacao = ii.cd_pedido_importacao and
                                                        pii.cd_item_ped_imp = ii.cd_item_ped_imp)
         Left outer join Pedido_Importacao pi       on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
         Left outer join Pedido_Venda_item pvi      on (pvi.cd_pedido_venda = pii.cd_pedido_venda and 
                                                        pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
         Left outer join Pedido_Venda pv            on (pv.cd_pedido_venda = pvi.cd_pedido_venda)
         Left outer join Cliente c                  on (c.cd_cliente = pv.cd_cliente) 
         Left outer join Produto p                    on (p.cd_produto = ii.cd_produto)
         Left outer join Moeda m                      on (m.cd_moeda = i.cd_moeda)
         left outer join Despachante de with (nolock) on de.cd_despachante = pi.cd_despachante
--         left outer join Produto_Importacao pimp on pimp.cd_produto = p.cd_produto

    where
      -- Definir se filtra por data do pedido ou data entrega itens
      case when @ic_data_filtro = 0 
	   then	@dt_inicial
	   else i.dt_invoice
	end  between @dt_inicial and @dt_final  and
      -- Se for infomado a identificacao da invoice
      IsNull(i.nm_invoice,'') Like (Case
                                       When @nm_invoice <> ''
                                         Then @nm_invoice + '%'
                                       Else IsNull(i.nm_invoice,'')
                                    End) and
      -- Se for informado o importador
      IsNull(imp.nm_fantasia,'') Like (Case
                                         When @nm_fantasia_importador <> ''
                                           Then @nm_fantasia_importador + '%'
                                         Else IsNull(imp.nm_fantasia,'')
                                       End) and
      -- Se for informado o fornecedor
      IsNull(RTrim(f.nm_fantasia_fornecedor),'') Like (Case
                                                         When RTrim(@nm_fantasia_fornecedor) <> ''
                                                           Then RTrim(@nm_fantasia_fornecedor) + '%'
                                                         Else IsNull(RTrim(f.nm_fantasia_fornecedor),'')
                                                       End) and
      -- Se for informado o produto
      IsNull(p.nm_fantasia_produto,'') Like (Case 
                                               When @nm_fantasia_produto <> ''
                                                 Then @nm_fantasia_produto + '%'
                                               Else IsNull(p.nm_fantasia_produto,'')
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
      IsNull(c.nm_fantasia_cliente,'') = (Case  
                                            When @nm_fantasia_cliente <> ''
                                              Then @nm_fantasia_cliente
                                            Else IsNull(c.nm_fantasia_cliente,'') 
                                          End) 
    Order By i.nm_invoice
