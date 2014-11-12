
create procedure pr_consulta_ped_imp_geral
---------------------------------------------------------------
--pr_consulta_ped_imp_geral
---------------------------------------------------------------
--GBS - Global Business Solution Ltda                      2004 
---------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Daniel C. Neto.
--Banco de Dados         : EgisSql
--Objetivo               : Realizar uma consulta geral sobre Pedido de Importação
--Data                   : 17/02/2003
--Atualizado             : 11/03/2004 - Acertos gerais. - Daniel C. Neto. 
--                       : 27/12/2004 - Acertos do Cabeçalho - Sérgio Cardoso
-- 02.03.2009 - Ajuste Diversos - Carlos Fernandes
----------------------------------------------------------------------------------

  @nm_fornecedor                varchar(40),
  @dt_inicial 			varchar(12),
  @dt_final 			varchar(12),
  @cd_pedido_importacao		int,
  @nm_ordem_compra  	varchar(40),
  @cd_nota_fiscal 		int,
  @cd_di 			varchar(15),
  @nm_referencia 		varchar(40),
  @cd_pais                      int,
  @cd_moeda                     int,
  @cd_termo_comercial           int,
  @cd_identificacao_pedido      VarChar(20)

AS

  declare @SQL   varchar(8000)
  declare @Where varchar(8000)
  declare @Order varchar(600)
  
  set @SQL   = ''
  set @Where = ''
  set @Order = ''

  set @dt_inicial = QuoteName(@dt_inicial, '''')
  set @dt_final   = QuoteName(@dt_final, '''')

  set @SQL = 	'SELECT '
		+ ' f.nm_fantasia_fornecedor, '
		+ ' pi.dt_pedido_importacao, '
		+ ' pi.cd_pedido_importacao, '
		+ ' pii.cd_item_ped_imp, '
		+ ' pii.nm_produto_pedido as nm_produto, '
		+ ' pii.nm_fantasia_produto, p.cd_mascara_produto, '
		+ ' pii.cd_pedido_venda, '               
		+ ' pii.cd_item_pedido_venda, '
		+ ' pi.nm_ref_ped_imp, '
		+ ' pii.qt_item_ped_imp, '
		+ ' pii.vl_item_ped_imp, '
		+ ' pii.pc_desc_item_ped_imp, '
		+ ' case when(pii.dt_cancel_item_ped_imp is null) then  (qt_item_ped_imp * vl_item_ped_imp) else 0 end AS vl_total, '
		+ ' case when (pii.dt_cancel_item_ped_imp is not null) then  (qt_item_ped_imp * vl_item_ped_imp) else 0 end AS vl_totalcanc, '
		+ ' pii.dt_entrega_ped_imp, '
		+ ' pii.dt_prev_embarque_ped_imp, '
		+ ' nsi.cd_nota_saida, '
		+ ' nsi.cd_item_nota_saida, '
		+ ' pii.dt_cancel_item_ped_imp, '
		+ ' cp.nm_condicao_pagamento, '
		+ ' t.nm_transportadora, '
		+ ' di.cd_di, '
		+ ' pii.nm_ordem_compra_ped_imp, ' -- Ordem de Compra
		+ ' pii.cd_pedido_compra, '
                + ' pii.qt_saldo_item_ped_imp, '
		+ ' tp.nm_tipo_pedido, '
		+ ' tp.sg_tipo_pedido, '
		+ ' st.nm_status_pedido, '
		+ ' st.sg_status_pedido, '
		+ ' c.nm_fantasia_comprador, '
		+ ' pa.nm_pais, '
		+ ' m.sg_moeda, '
		+ ' tc.nm_termo_comercial, '
                + ' pi.cd_identificacao_pedido, pimp.cd_part_number_produto '
		+ ' FROM '
		+ ' Pedido_Importacao_Item pii with (nolock) LEFT OUTER JOIN '
		+ ' Pedido_Importacao pi ON pii.cd_pedido_importacao = pi.cd_pedido_importacao LEFT OUTER JOIN '
		+ ' Produto p on p.cd_produto = pii.cd_produto LEFT OUTER JOIN '
		+ ' Condicao_Pagamento cp on cp.cd_condicao_pagamento = pi.cd_condicao_pagamento LEFT OUTER JOIN '
		+ ' Transportadora t ON pi.cd_transportadora = t.cd_transportadora LEFT OUTER JOIN '
	        + ' Di di on di.cd_pedido_importacao = pi.cd_pedido_importacao left outer join ' + 
--		+ ' Destinacao_Produto dp ON pi.cd_destinacao_produto = dp.cd_destinacao_produto LEFT OUTER JOIN '
		+ ' Comprador c ON pi.cd_comprador = c.cd_comprador LEFT OUTER JOIN '
		+ ' Nota_Saida_Item nsi ON pii.cd_item_ped_imp = nsi.cd_item_ped_imp AND pii.cd_pedido_importacao = nsi.cd_pedido_importacao LEFT OUTER JOIN '
		+ ' Fornecedor f ON pi.cd_fornecedor = f.cd_fornecedor LEFT OUTER JOIN'
		+ ' Tipo_Pedido tp ON pi.cd_tipo_pedido = tp.cd_tipo_pedido LEFT OUTER JOIN'
		+ ' Status_Pedido st ON pi.cd_status_pedido = st.cd_status_pedido left outer join '
		+ ' Pais pa ON pi.cd_origem_pais = pa.cd_pais left outer join'
  		+ ' Moeda m ON pi.cd_moeda = m.cd_moeda left outer join'
		+ ' Termo_Comercial tc ON pi.cd_termo_comercial = tc.cd_termo_comercial ' 
                + ' left outer join Produto_Importacao pimp on pimp.cd_produto = p.cd_produto '

  --Montando cláusula where
  
  --Verificando se foi informado o fornecedor
  if @nm_fornecedor <> ''
    set @Where = ' where f.nm_fantasia_fornecedor like ' + quotename(@nm_fornecedor + '%', '''')
  else -- Colocado temporariamente pra tirar os registros de fornecedores nulos.
    set @Where = ' where f.nm_fantasia_fornecedor is not null '

  
  --Verificando se foi informado o período
  if @dt_inicial <> '' and @dt_final <> ''
    if @Where <> ''
      set @Where = @Where + ' and pi.dt_pedido_importacao between ' + @dt_inicial + ' and ' + @dt_final
    else
      set @Where = ' where pi.dt_pedido_importacao between ' + @dt_inicial + ' and ' + @dt_final

  --verificando se foi informado o pedido de importação
  if @cd_pedido_importacao <> 0
    if @Where <> ''
      set @Where = @Where + ' and pi.cd_pedido_importacao = ' + cast(@cd_pedido_importacao as varchar)
    else
      set @Where = ' where pi.cd_pedido_importacao = ' + cast(@cd_pedido_importacao as varchar)

  --verificando se foi informado uma ordem de compra
  if @nm_ordem_compra <> '' 
  if @Where <> ''
    set @Where = @Where + ' and pi.nm_ordem_compra_pedido like ' + quotename(@nm_ordem_compra + '%', '''')
  else
    set @Where = @Where + ' Where pi.nm_ordem_compra_pedido like ' + quotename(@nm_ordem_compra + '%', '''')

  --verificando se foi informado a nota fiscal
  if @cd_nota_fiscal <> 0
    if @Where <> ''
      set @Where = @Where + ' and nsi.cd_nota_saida = ' + cast(@cd_nota_fiscal as varchar)
    else
      set @Where = @Where + ' where nsi.cd_nota_saida = ' + cast(@cd_nota_fiscal as varchar)

  --verificando se foi informado o di
  if @cd_di <> ''
  if @Where <> ''
    set @Where = @Where + ' and di.cd_di = ' + @cd_di
  else
    set @Where = @Where + ' where di.cd_di = ' + @cd_di

  --verificando se foi informado uma referencia
  if @nm_referencia <> ''
    if @Where <> ''
      set @Where = @Where + ' and pi.nm_ref_ped_imp like ' + quotename(@nm_referencia + '%', '''')
    else
      set @Where = @Where + ' where pi.nm_ref_ped_imp like ' + quotename(@nm_referencia  + '%', '''')

  --verificando se foi informado um pais
  if @cd_pais <> 0
    if @Where <> ''
      set @Where = @Where + ' and pi.cd_origem_pais = ' + cast(@cd_pais as varchar)
    else
      set @Where = @Where + ' where pi.cd_origem_pais = ' + cast(@cd_pais as varchar)

  --verificando se foi informado uma moeda
  if @cd_moeda <> 0
    if @Where <> ''
      set @Where = @Where + ' and pi.cd_moeda = ' + cast(@cd_moeda as varchar)
    else
      set @Where = @Where + ' where pi.cd_moeda = ' + cast(@cd_moeda as varchar)

  --verificando se foi informado um Termo Comercial
  if @cd_termo_comercial <> 0
    if @Where <> ''
      set @Where = @Where + ' and pi.cd_termo_comercial = ' + cast(@cd_termo_comercial as varchar)
    else
      set @Where = @Where + ' where pi.cd_termo_comercial = ' + cast(@cd_termo_comercial as varchar)

  -- Verificando se foi informado a identificação do pedido
  if @cd_identificacao_pedido <> '' 
    if @Where <> ''
      set @Where = @Where + ' and pi.cd_identificacao_pedido like ' + quotename(@cd_identificacao_pedido + '%', '''')
    else
      set @Where = @Where + ' Where pi.cd_identificacao_pedido like ' + quotename(@cd_identificacao_pedido + '%', '''')

  set @Order = ' ORDER BY pi.dt_pedido_importacao desc, pi.cd_pedido_importacao DESC, pii.cd_item_ped_imp '

  print (@SQL + @Where + @Order)
  exec(@SQL + @Where + @Order)

