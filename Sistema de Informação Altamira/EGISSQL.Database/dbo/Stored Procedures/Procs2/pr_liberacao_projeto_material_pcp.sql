
create procedure pr_liberacao_projeto_material_pcp  
  
@dt_inicial       DateTime,  
@dt_final         DateTime,  
@ic_tipo_consulta Char(1),  -- (1) Liberados  (2) Pendentes  (3) Todos  
@cd_projeto       Int  
  
as  
  
Declare @Sql as VarChar(8000)  
  
Set DateFormat mdy  
  
Set @Sql = 'select pcm.dt_liberacao_material    as DataLiberacao,  ' +
                   'pr.cd_projeto               as Projeto, ' +
                   'pr.cd_interno_projeto       as IdentificacaoProjeto, ' + 
                   'pr.nm_projeto               as NomeProjeto, ' +
                   'c.nm_fantasia_cliente       as Cliente, ' +
                   'pr.dt_entrada_projeto       as Entrada, ' +
                   'pr.dt_fim_projeto           as FimProjeto, ' +
                   'pc.nm_projeto_composicao    as Composicao, ' + 
                   'pc.nm_item_desenho_projeto  as Desenho, '+
                   'pcm.cd_projeto_material     as Item, ' + 
                   'p.nm_fantasia_produto       as Produto, ' + 
                   'pcm.nm_esp_projeto_material as Especificacao, ' +  
                   'pcm.qt_projeto_material     as Quantidade, ' +  
                   'um.sg_unidade_medida        as Unidade, ' + 
                   'pj.nm_fantasia_projetista   as Projetista, ' +
                   'pcm.nm_desenho_material     as DesenhoMaterial, ' +
                   'pr.ic_montagem_prod_cliente as Montado, ' +
                   'pr.cd_pedido_venda          as PV, ' +
                   'pr.cd_item_pedido_venda     as ItemPV, ' +
                   'pr.cd_pedido_venda_molde    as PVAssociado, ' +
                   'pr.cd_item_pedido_molde     as ItemPVAssociado, ' +
                   'pcm.nm_obs_projeto_material as Obs, ' +
                   'rtrim(substring(pcm.ds_projeto_material,1,200)) as Descritivo, ' + 
                   'pcm.cd_requisicao_compra, ' +
                   'pcm.cd_item_requisicao_compra, ' +
                   'rci.dt_item_nec_req_compra, ' +
                   'pcm.cd_requisicao_interna, ' +
                   'pcm.cd_item_req_interna, ' +
                   'substring(tpp.nm_tipo_produto_projeto,1,1) as CompradoFabricado, ' +
                   'Fornecedor = case when rci.cd_requisicao_compra > 0 then ' +
                        'isnull((select f.nm_fantasia_fornecedor ' +
                        'from pedido_compra_item pci, pedido_compra pc, fornecedor f ' +
                        'where pci.cd_requisicao_compra = rci.cd_requisicao_compra and ' +
                        '      pci.cd_requisicao_compra_item = rci.cd_item_requisicao_compra and ' +
                        '      pci.cd_pedido_compra = pc.cd_pedido_compra and ' +
                        '      pc.cd_fornecedor = f.cd_fornecedor),''PC não gerado'') ' +
                        'else '''' end, ' +
                  '''__________________'' as ObsGerais, ' +
                  'pvi.dt_entrega_vendas_pedido, ' +
                  'pvi.dt_entrega_fabrica_pedido, ' +
                  'dt_entrega_vendas_molde =  ' +
                  '(select pvi_molde.dt_entrega_vendas_pedido ' +
                  ' from pedido_venda_item pvi_molde ' +
                  ' where pvi_molde.cd_pedido_venda      = pr.cd_pedido_venda_molde and ' +
                  '       pvi_molde.cd_item_pedido_venda = pr.cd_item_pedido_molde), ' +
                  ' dt_entrega_fabrica_molde =  ' +
                  '(select pvi_molde.dt_entrega_fabrica_pedido ' +
                  ' from pedido_venda_item pvi_molde ' +
                  ' where pvi_molde.cd_pedido_venda      = pr.cd_pedido_venda_molde and ' +
                  '       pvi_molde.cd_item_pedido_venda = pr.cd_item_pedido_molde), ' +
                  'pcm.cd_produto            as cd_produto_pai, ' +
                  'prc.cd_produto            as cd_produto_filho, ' +
                  'prc.qt_produto_composicao as qt_produto_filho, ' +
                  'prod.nm_fantasia_produto  as FantasiaProdutoFilho, ' +
                  'prod.nm_produto           as NomeProdutoFilho ' +
            'from projeto_composicao_material pcm ' +  
                 'left outer join projeto_composicao pc on pc.cd_projeto = pcm.cd_projeto and ' +  
                                                       '   pc.cd_item_projeto = pcm.cd_item_projeto ' +
                 'left outer join projeto pr on pr.cd_projeto = pc.cd_projeto ' +
                 'left outer join tipo_produto_projeto tpp on pcm.cd_tipo_produto_projeto = tpp.cd_tipo_produto_projeto ' +
                 'left outer join cliente c on  c.cd_cliente = pr.cd_cliente ' +
                 'left outer join produto p on  p.cd_produto = pcm.cd_produto ' +
                 'left outer join unidade_medida um on um.cd_unidade_medida = pcm.cd_unidade_medida ' +
                 'left outer join projetista pj on pj.cd_projetista = pcm.cd_projetista_liberacao ' +  
                 'left outer join requisicao_compra_item rci on ' + 
                 '   pcm.cd_requisicao_compra      = rci.cd_requisicao_compra and ' +
                 '   pcm.cd_item_requisicao_compra = rci.cd_item_requisicao_compra and ' + 
                 '   pcm.cd_produto                = rci.cd_produto '+
                 'left outer join requisicao_interna ri on pcm.cd_requisicao_interna = ri.cd_requisicao_interna ' +
                 'left outer join pedido_venda_item pvi on ' +
                 '   pr.cd_pedido_venda      = pvi.cd_pedido_venda and ' +
                 '   pr.cd_item_pedido_venda = pvi.cd_item_pedido_venda ' +
                 'left outer join produto_composicao prc on ' +
                 '  pcm.cd_produto = prc.cd_produto_pai ' +
                 'left outer join produto prod on ' +
                 '  prc.cd_produto = prod.cd_produto ' +

            'Where IsNull(pr.cd_projeto,0) = Case ' +
                                           ' When ' + Cast(@cd_projeto as VarChar)+ ' <> 0
                                                Then ' + Cast(@cd_projeto  as VarChar) + '
                                              Else IsNull(pr.cd_projeto,0)
                                            End '

--if @cd_projeto = 0  
--Begin  

  If @ic_tipo_consulta = '1'    -- liberados  
    Begin  
      Set @Sql = @Sql + ' and pcm.dt_liberacao_material between ' + QuoteName(Convert(VarChar, @dt_inicial, 101),'''') + ' and ' + QuoteName(Convert(VarChar, @dt_final, 101),'''')  
      Set @Sql = @Sql + ' and isnull(pcm.cd_requisicao_compra,0) = 0 and isnull(pcm.cd_requisicao_interna,0) = 0 ' 
      Set @Sql = @Sql + ' order by pcm.dt_liberacao_material desc '  
    End  
      
  If @ic_tipo_consulta = '2'    -- Pendentes  
    Begin  
      Set @Sql = @Sql + ' and pcm.dt_liberacao_material is null'  
      Set @Sql = @Sql + ' order by pr.dt_entrada_projeto desc, pr.cd_projeto, pcm.cd_projeto_material'  
    End  
    
  If @ic_tipo_consulta = '3'    -- Todos  
    Begin  
      Set @Sql = @Sql + ' and ( (pr.dt_entrada_projeto between ' + QuoteName(Convert(VarChar, @dt_inicial, 101),'''') + ' and ' + QuoteName(Convert(VarChar, @dt_final, 101),'''') + ')' 
      Set @Sql = @Sql + '   OR (pr.cd_projeto = ' + Cast(@cd_projeto as VarChar) + ') )'
      Set @Sql = @Sql + ' order by pr.dt_entrada_projeto desc, pr.cd_projeto, pcm.cd_projeto_material'  
    End

--End  
--Else  
--  Set @Sql = @Sql + ' order by pcm.cd_projeto_material'  

--select * from projeto_composicao
--select * from projeto_composicao_material
  
--print @sql 
exec (@sql)  

