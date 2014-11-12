
create procedure pr_programacao_importacao

@dt_inicial  		 datetime,
@dt_final    		 datetime,
@cd_pedido_importacao	 int,
@nm_identificacao_pedido VarChar(20),
@cd_produto              int,
@cd_cliente              int,
@cd_fornecedor           int,
@cd_pais                 int,
@ic_data_filtro          int,   -- Define datas do filtro = (1) Data Pedido (2) Data Entrega Itens
@ic_tipo_consulta        int, -- Define se a consulta é (1) programação de importação, 
                              -- (2) itens do controle de importação ou (3) controle de importação
@nm_fantasia_produto     VarChar(30),
@nm_fantasia_fornecedor  Char(15),
@nm_fantasia_cliente     VarChar(15)

as
Begin

  --select * from pedido_importacao

  If @ic_tipo_consulta = 1     -- Pesquisa programação de importação
    select 
           Case 
             When (pii.dt_entrega_ped_imp < GetDate() and IsNull(pii.qt_saldo_item_ped_imp,0) <> 0)
               Then 'S'
             Else 'N' 
           End as 'FlagAtrasado',
           Case  
             When IsNull(pii.cd_item_pedido_venda,0) <> 0
               Then 'S'
             Else 'N' 
           End as 'FlagPedidoVenda',          
           Case 
             When IsNull(it.cd_invoice_item,0) <> 0
               Then 'S'
             Else 'N'
           End as 'FlagInvoice',          
           Case
             When (di.dt_chegada is not null) or (i.dt_liberacao_prev is not null)
               Then 'S'
             Else 'N'
           End as 'FlagChegouPais',          
           Case
             When (di.dt_desembaraco is not null) or (i.dt_liberacao_prev is not null)
               Then 'S'
             Else 'N' 
           End as 'FlagMercadoriaLiberada',          
           Case
             When (di.dt_chegada_fabrica is not null) or (i.dt_chegada_empresa_prev is not null)
               Then 'S'
             Else 'N'
           End as 'FLagMercadoriaEmpresa',          

           Case 
             When (IsNull(it.qt_invoice_item,0) >= IsNull(pii.qt_item_ped_imp,0))
               Then 'S'
             Else 'N' 
           End as 'FlagEmbarqueTotal',          
           Case 
             When (IsNull(it.qt_invoice_item,0) < IsNull(pii.qt_item_ped_imp,0)) and
                  IsNull(it.qt_invoice_item,0) <> 0 
               Then 'S'
             Else 'N' 
           End as 'FlagEmbarqueParcial',          
           Year(pi.dt_pedido_importacao) as 'Ano',
           pi.cd_pedido_importacao as 'Pedido',
           IsNull(pi.cd_identificacao_pedido,'') as 'Identificacao',
           f.nm_fantasia_fornecedor as 'Fornecedor',
           s.sg_status_pedido as 'Status',
           IsNull(fe.nm_forma_entrega,'') as 'FormaEntrega',
           pa.nm_pais as 'PaisOrigem',
           pii.cd_item_ped_imp as 'ItemImportacao',
           pii.nm_fantasia_produto as 'Produto',
           pii.dt_entrega_ped_imp as 'Entrega',
           IsNull(pii.qt_item_ped_imp,0) as 'Qtd',
           IsNull(pii.qt_saldo_item_ped_imp,0) as 'Saldo',
           IsNull(pii.qt_item_ped_imp,0) - IsNull(pii.qt_saldo_item_ped_imp,0) as 'QtdFat',
           IsNull(pii.vl_item_ped_imp,0) as 'Unitario',
           IsNull(pii.pc_desc_item_ped_imp,0) as 'PercDesconto',
           mo.sg_moeda as 'Moeda',
           (IsNull(pii.vl_item_ped_imp,0) * IsNull(pii.qt_item_ped_imp,0)) as 'TotalMoeda',
           (IsNull(pii.vl_item_ped_imp,0) * IsNull(pii.qt_item_ped_imp,0) * IsNull(pi.vl_moeda_ped_imp,0)) as 'Total',
           i.nm_invoice as 'Invoice',
           i.dt_invoice as 'EmissaoInvoice', 
           i.dt_embarque as 'Embarque', 
           Case 
              When IsNull(di.nm_di,'') <> ''  
                Then IsNull(di.dt_chegada, di.dt_previsao_chegada_di)
              Else i.dt_chegada_pais_prev 
           End as 'ChegadaPais',
           di.nm_di as 'DI',
           Case 
              When IsNull(di.nm_di,'') <> ''  
                Then IsNull(di.dt_desembaraco, di.dt_prev_desembaraco) 
              Else i.dt_liberacao_prev
           End as 'Liberacao',
           Case 
              When IsNull(di.nm_di,'') <> ''  
                Then IsNull(di.dt_chegada_fabrica, di.dt_prev_chegada_fabrica)
              Else i.dt_chegada_empresa_prev
           End as 'ChegadaEmpresa',
           pii.cd_pedido_venda as 'PedidoVenda',
           pii.cd_item_pedido_venda as 'ItemPedidoVenda',
           IsNull(c.nm_fantasia_cliente,'') as 'Cliente',
           pii.nm_item_obs_ped_imp as 'Observacao',
           co.nm_fantasia_comprador as 'Comprador',
           IsNull(pi.vl_pedido_importacao,0) as 'TotalPedidoMoeda',
           (IsNull(pi.vl_pedido_importacao,0) * IsNull(pi.vl_moeda_ped_imp,0)) as 'TotalPedido',
           pi.dt_pedido_importacao as 'Emissao',
           IsNull(pi.vl_moeda_ped_imp,0) as 'VlCotação',
           IsNull(it.cd_invoice_item,0) as 'InvoiceItem',
           pv.dt_pedido_venda           as 'EmissaoPV',
           pvi.dt_entrega_vendas_pedido as 'EntregaItemPV',
           ti.nm_tipo_importacao        as Metodo,
           pi.cd_licenca_importacao     as 'LicencaImportacao',
           pi.dt_registro_licenca       as 'DataLicenca',
           pi.dt_validade_licenca       as 'ValidadeLicenca',
           de.nm_fantasia               as 'Despachante',
           pi.nm_ref_ped_imp,
           ei.dt_previsao_embarque      as PrevisaoEmbarque,
           ei.dt_embarque               as DataEmbarque,
           ei.dt_previsao_chegada       as PrevisaoChegada,
           ei.dt_chegada                as Chegada 

--select * from embarque_importacao

    from Pedido_Importacao pi                       with (nolock)
--         inner join Pedido_Importacao_item pii on (pii.cd_pedido_importacao = pi.cd_pedido_importacao)
         left outer join Pedido_Importacao_item pii with (nolock) on (pii.cd_pedido_importacao = pi.cd_pedido_importacao)
         left outer join Fornecedor f               with (nolock) on (pi.cd_fornecedor         = f.cd_fornecedor)
         left outer join Produto p                  with (nolock) on (pii.cd_produto           = p.cd_produto)
         left outer join Forma_Entrega fe           with (nolock) on (pi.cd_forma_entrega      = fe.cd_forma_entrega)
         left outer join Pais pa                    with (nolock) on (pi.cd_origem_pais        = pa.cd_pais)
         left outer join Moeda mo                   with (nolock) on (pi.cd_moeda              = mo.cd_moeda)
         left outer join Pedido_Venda_Item pvi      with (nolock) on (pvi.cd_pedido_venda      = pii.cd_pedido_venda and
                                                                      pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
         left outer join Pedido_Venda pv            with (nolock) on (pv.cd_pedido_venda       = pvi.cd_pedido_venda)
         left outer join Cliente c                  with (nolock) on (c.cd_cliente             = pv.cd_cliente)
         left outer join Status_Pedido s            with (nolock) on (s.cd_status_pedido       = pi.cd_status_pedido)
         left outer join di_item dii                with (nolock) on (dii.cd_pedido_importacao = pii.cd_pedido_importacao and
                                                                      dii.cd_item_ped_imp      = pii.cd_item_ped_imp)
         Left outer join di                         with (nolock) on (di.cd_di                 = dii.cd_di)
         Left outer join Comprador co               with (nolock) on (co.cd_comprador          = pi.cd_comprador)
         Left outer join invoice_item it            with (nolock) on (it.cd_pedido_importacao  = pii.cd_pedido_importacao and
                                                                      it.cd_item_ped_imp       = pii.cd_item_ped_imp)
         Left outer join invoice i                  with (nolock) on (i.cd_invoice             = it.cd_invoice)
         left outer join Tipo_importacao ti         with (nolock) on ti.cd_tipo_importacao     = pi.cd_tipo_importacao
         left outer join Despachante de             with (nolock) on de.cd_despachante         = pi.cd_despachante
         left outer join Embarque_Importacao ei     with (nolock) on ei.cd_pedido_importacao   = pi.cd_pedido_importacao

    where
      -- Definir se filtra por data do pedido ou data entrega itens
      (Case @ic_data_filtro
         When 1 Then pi.dt_pedido_importacao 
         When 2 Then pii.dt_entrega_ped_imp 
         When 0 Then @dt_inicial
       End) between @dt_inicial and @dt_final and
      pii.dt_cancel_item_ped_imp is null and --Data  do Cancelamento        
      -- Se for informado o pedido
      pi.cd_pedido_importacao = (Case 
                                   When @cd_pedido_importacao <> 0 
                                     Then @cd_pedido_importacao
                                   Else pi.cd_pedido_importacao
                                 End) and
      -- Se for informado a identificacao do pedido
      IsNull(pi.cd_identificacao_pedido,'') Like (Case
                                                    When @nm_identificacao_pedido <> ''
                                                      Then @nm_identificacao_pedido + '%'
                                                    Else IsNull(pi.cd_identificacao_pedido,'')
                                                  End) and
      -- Se for informado o produto
      IsNull(pii.nm_fantasia_produto,'') Like (Case 
                                                 When @nm_fantasia_produto <> ''
                                                   Then @nm_fantasia_produto + '%'
                                                 Else IsNull(pii.nm_fantasia_produto,'')
                                               End) and
      -- Se for informado o cliente
      IsNull(c.nm_fantasia_cliente,'') = (Case  
                                            When @nm_fantasia_cliente <> ''
                                              Then @nm_fantasia_cliente
                                            Else IsNull(c.nm_fantasia_cliente,'') 
                                          End) and
      -- Se for informado o fornecedor
      IsNull(RTrim(f.nm_fantasia_fornecedor),'') Like (Case
                                                         When RTrim(@nm_fantasia_fornecedor) <> ''
                                                           Then RTrim(@nm_fantasia_fornecedor) + '%'
                                                         Else IsNull(RTrim(f.nm_fantasia_fornecedor),'')
                                                       End) and
      -- Se for informado o pais
      IsNull(pi.cd_origem_pais,0) = (Case
                                       When @cd_pais <> 0
                                         Then @cd_pais
                                       Else IsNull(pi.cd_origem_pais,0)
                                     End) 
    Order By pi.cd_pedido_importacao, pii.cd_item_ped_imp 

  Else If @ic_tipo_consulta = 2         -- Pesquisa controle de importação (Itens)

    select 
           pi.cd_pedido_importacao       as 'Pedido',
           pii.cd_item_ped_imp           as 'ItemImportacao',
           pii.nm_fantasia_produto       as 'Produto',
           p.cd_mascara_produto,
           p.nm_produto,
           pii.dt_entrega_ped_imp        as 'Entrega',
           IsNull(pii.qt_item_ped_imp,0) as 'Qtd',
           IsNull(pii.qt_saldo_item_ped_imp,0) as 'Saldo',
           IsNull(pii.qt_item_ped_imp,0) - IsNull(pii.qt_saldo_item_ped_imp,0) as 'QtdFat',
           IsNull(pii.vl_item_ped_imp,0) as 'Unitario',
           IsNull(pii.pc_desc_item_ped_imp,0) as 'PercDesconto',
           mo.sg_moeda as 'Moeda',
           (IsNull(pii.vl_item_ped_imp,0) * IsNull(pii.qt_item_ped_imp,0)) as 'TotalMoeda',
           (IsNull(pii.vl_item_ped_imp,0) * IsNull(pii.qt_item_ped_imp,0) * IsNull(pi.vl_moeda_ped_imp,0)) as 'Total',
           i.nm_invoice as 'Invoice',
           i.dt_invoice as 'EmissaoInvoice', 
           i.dt_embarque as 'Embarque', 
           Case 
              When IsNull(di.nm_di,'') <> ''  
                Then IsNull(di.dt_chegada, di.dt_previsao_chegada_di)
              Else i.dt_chegada_pais_prev 
           End as 'ChegadaPais',
           di.nm_di as 'DI',
           Case 
              When IsNull(di.nm_di,'') <> ''  
                Then IsNull(di.dt_desembaraco, di.dt_prev_desembaraco) 
              Else i.dt_liberacao_prev
           End as 'Liberacao',
           Case 
              When IsNull(di.nm_di,'') <> ''  
                Then IsNull(di.dt_chegada_fabrica, di.dt_prev_chegada_fabrica)
              Else i.dt_chegada_empresa_prev
           End as 'ChegadaEmpresa',
           pii.cd_pedido_venda              as 'PedidoVenda',
           pii.cd_item_pedido_venda         as 'ItemPedidoVenda',
           IsNull(c.nm_fantasia_cliente,'') as 'Cliente',
           pii.nm_item_obs_ped_imp          as 'Observacao',
           ti.nm_tipo_importacao            as Metodo,

           pi.cd_licenca_importacao         as 'LicencaImportacao',
           pi.dt_registro_licenca           as 'DataLicenca',
           pi.dt_validade_licenca           as 'ValidadeLicenca',
           ''                               as 'Despachante',
           pimp.cd_part_number_produto,  
           pi.nm_ref_ped_imp,
           ei.dt_previsao_embarque      as PrevisaoEmbarque,
           ei.dt_embarque               as DataEmbarque,
           ei.dt_previsao_chegada       as PrevisaoChegada,
           ei.dt_chegada                as Chegada 
   

    from 
--    Pedido_Importacao 		pi  inner join 
    Pedido_Importacao pi with (nolock)
    left outer join Pedido_Importacao_item pii  with (nolock) on (pii.cd_pedido_importacao = pi.cd_pedido_importacao) 
    left outer join Produto p with (nolock) on (pii.cd_produto = p.cd_produto)
   	left outer join Moeda	mo on (pi.cd_moeda = mo.cd_moeda)	
    left outer join Pedido_Venda_Item	pvi with (nolock) on (pvi.cd_pedido_venda = pii.cd_pedido_venda and
                                                            pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)
    left outer join Pedido_Venda pv with (nolock) on (pvi.cd_pedido_venda = pv.cd_pedido_venda)
    left outer join Cliente	c with (nolock) on (c.cd_cliente = pv.cd_cliente)
    left outer join Status_Pedido s with (nolock) on (s.cd_status_pedido = pi.cd_status_pedido)
    left outer join invoice_item it with (nolock) on (it.cd_pedido_importacao = pii.cd_pedido_importacao and
                                                      it.cd_item_ped_imp = pii.cd_item_ped_imp)
    Left outer join invoice	i with (nolock) on (i.cd_invoice = it.cd_invoice)
    Left outer join di_item	dii with (nolock) on (dii.cd_invoice = it.cd_invoice and
                                                  dii.cd_invoice_item = it.cd_invoice_item)
    Left outer join di di with (nolock) on (di.cd_di = dii.cd_di)
    left outer join Tipo_importacao ti      with (nolock) on ti.cd_tipo_importacao = pi.cd_tipo_importacao
    Left outer join Produto_importacao pimp with (nolock) on pimp.cd_produto       = p.cd_produto
    left outer join Embarque_Importacao ei     with (nolock) on ei.cd_pedido_importacao   = pi.cd_pedido_importacao

    where 
      pi.cd_pedido_importacao = @cd_pedido_importacao and
          pii.dt_cancel_item_ped_imp is null and --Data  do Cancelamento        
          IsNull(pii.nm_fantasia_produto,'') Like (Case 
                                                     When @nm_fantasia_produto <> ''
                                                       Then @nm_fantasia_produto + '%'
                                                     else IsNull(pii.nm_fantasia_produto,'')
                                                   End) 
    Order By pi.cd_pedido_importacao, pii.cd_item_ped_imp 

  Else If @ic_tipo_consulta = 3       -- Pesquisa controle de importação (pedidos)
  Begin  
    select pi.cd_pedido_importacao as 'Pedido',    
           Case when    
                IsNull((Select top 1 IsNull(cf.ic_licenca_importacao,'N')    
                        from pedido_importacao_item pii  
                             inner join Produto_Fiscal pf with (nolock) on pf.cd_produto = pii.cd_produto  
                             inner join Classificacao_Fiscal cf with (nolock) on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal      
                        where pii.cd_pedido_importacao = pi.cd_pedido_importacao  
                        order by IsNull(cf.ic_licenca_importacao,'N') desc),'N') = 'N'    
               Then 'N'    
           Else    
               'S'      
           End as 'Lic'    
  
    into #PedidoImportacao   
    from Pedido_Importacao pi  with (nolock)    
    where    
      -- Definir se filtra por data do pedido ou data entrega itens    
       pi.dt_pedido_importacao  between @dt_inicial and @dt_final   
  
  
    select Distinct    
           Year(pi.dt_pedido_importacao) as 'Ano',    
           pi.cd_pedido_importacao as 'Pedido',    
           IsNull(pi.cd_identificacao_pedido,'') as 'Identificacao',    
           f.nm_fantasia_fornecedor as 'Fornecedor',    
           s.sg_status_pedido as 'Status',    
           pi.dt_pedido_importacao as 'Emissao',    
           IsNull(pi.vl_pedido_importacao,0) as 'TotalPedidoMoeda',    
           IsNull(pi.vl_moeda_ped_imp,0) as 'VlCotação',    
           (IsNull(pi.vl_pedido_importacao,0) * IsNull(pi.vl_moeda_ped_imp,0)) as 'TotalPedido',    
           IsNull(fe.nm_forma_entrega,'') as 'FormaEntrega',    
           pa.nm_pais as 'PaisOrigem',    
           co.nm_fantasia_comprador as 'Comprador',    
           mo.sg_moeda as 'Moeda',    
           IsNull(pi.ic_fechado_ped_importacao,'N') as 'PedidoFechando',    
           pi.cd_licenca_importacao as 'LicencaImportacao',    
           pi.dt_registro_licenca as 'DataLicenca',    
           pi.dt_validade_licenca as 'ValidadeLicenca',    
           de.nm_fantasia         as 'Despachante',      
           IsNull(pit.lic,'N')    as Lic,
           pi.nm_ref_ped_imp,
           ei.dt_previsao_embarque      as PrevisaoEmbarque,
           ei.dt_embarque               as DataEmbarque,
           ei.dt_previsao_chegada       as PrevisaoChegada,
           ei.dt_chegada                as Chegada 
   
  
  
    from Pedido_Importacao pi  with (nolock)    
--         inner join Pedido_Importacao_item pii on (pii.cd_pedido_importacao = pi.cd_pedido_importacao)    
         left outer join Pedido_Importacao_item pii with (nolock) on (pii.cd_pedido_importacao = pi.cd_pedido_importacao)    
         left outer join Fornecedor f with (nolock) on (pi.cd_fornecedor = f.cd_fornecedor)    
         left outer join Produto p with (nolock) on (pii.cd_produto = p.cd_produto)    
         left outer join Forma_Entrega fe with (nolock) on (pi.cd_forma_entrega = fe.cd_forma_entrega)    
         left outer join Pais pa with (nolock) on (pi.cd_origem_pais = pa.cd_pais)    
         left outer join Moeda mo with (nolock) on (pi.cd_moeda = mo.cd_moeda)    
         left outer join Pedido_Venda_Item pvi with (nolock) on (pvi.cd_pedido_venda = pii.cd_pedido_venda and    
                                                                 pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda)    
         left outer join Pedido_Venda pv with (nolock) on (pii.cd_pedido_venda = pv.cd_pedido_venda)    
         left outer join Cliente c with (nolock) on (c.cd_cliente = pv.cd_cliente)    
         left outer join Status_Pedido s with (nolock) on (s.cd_status_pedido = pi.cd_status_pedido)    
         left outer join di_item dii with (nolock) on (dii.cd_pedido_importacao = pii.cd_pedido_importacao and    
                                                       dii.cd_item_ped_imp = pii.cd_item_ped_imp)    
         Left outer join di with (nolock) on (di.cd_di = dii.cd_di)    
         Left outer join Comprador co with (nolock) on (co.cd_comprador = pi.cd_comprador)    
         left outer join Despachante de with (nolock) on de.cd_despachante = pi.cd_despachante    
         left outer join #PedidoImportacao pit on pit.Pedido = pi.cd_pedido_importacao  
         left outer join Embarque_Importacao ei     with (nolock) on ei.cd_pedido_importacao   = pi.cd_pedido_importacao


    where    
      -- Definir se filtra por data do pedido ou data entrega itens    
      (Case @ic_data_filtro     
         When 1 Then pi.dt_pedido_importacao     
         When 2 Then pii.dt_entrega_ped_imp     
         When 0 Then @dt_inicial    
       End) between @dt_inicial and @dt_final and    
      pii.dt_cancel_item_ped_imp is null and --Data  do Cancelamento            
      -- Se for informado o pedido    
      pi.cd_pedido_importacao = (Case     
                                   When @cd_pedido_importacao <> 0     
                                     Then @cd_pedido_importacao    
                                   Else pi.cd_pedido_importacao    
                                 End) and    
      -- Se for informado a identificacao do pedido    
      IsNull(pi.cd_identificacao_pedido,'') Like (Case    
                                                    When @nm_identificacao_pedido <> ''    
                                                      Then @nm_identificacao_pedido + '%'    
      Else IsNull(pi.cd_identificacao_pedido,'')    
                                                  End) and    
      -- Se for informado o produto    
      IsNull(pii.nm_fantasia_produto,'') Like (Case     
                                                 When @nm_fantasia_produto <> ''    
                                                   Then @nm_fantasia_produto + '%'    
                                                 Else IsNull(pii.nm_fantasia_produto,'')    
                                               End) and    
      -- Se for informado o cliente    
      IsNull(c.nm_fantasia_cliente,'') = (Case      
                                            When @nm_fantasia_cliente <> ''                                               
                                              Then @nm_fantasia_cliente    
                                            Else IsNull(c.nm_fantasia_cliente,'')     
                                          End) and    
      -- Se for informado o fornecedor    
      IsNull(RTrim(f.nm_fantasia_fornecedor),'') Like (Case    
                                                         When RTrim(@nm_fantasia_fornecedor) <> ''    
                                                           Then RTrim(@nm_fantasia_fornecedor) + '%'    
                     Else IsNull(RTrim(f.nm_fantasia_fornecedor),'')    
                                                       End) and    
      -- Se for informado o pais    
      IsNull(pi.cd_origem_pais,0) = (Case    
                                       When @cd_pais <> 0    
                                         Then @cd_pais    
                                       Else IsNull(pi.cd_origem_pais,0)    
                                     End)     
    Order by pi.cd_pedido_importacao desc  
  End  
End

