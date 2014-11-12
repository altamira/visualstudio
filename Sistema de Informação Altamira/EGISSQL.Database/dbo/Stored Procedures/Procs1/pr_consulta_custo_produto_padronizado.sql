Create Procedure pr_consulta_custo_produto_padronizado 
--------------------------------------------------------------
--pr_consulta_custo_produto_padronizado 
--------------------------------------------------------------
--GBS - Global Business Solution Ltda                     2004
--------------------------------------------------------------
--Banco de Dados      : SQL SERVER 2000
--Autor               : Igor Gama
--Data                : 25.03.2004
--Observações         : Consulta para retornaros custos dos produtos nas notas fiscais
--                      de acordo com o grupo de produto. O Parâmetro de tipo de consulta,
--                      serve para indicar se é uma consulta de produto especial ou de
--                      produto padronizado. Ou seja:
--                      1 - Produto Padronizado;
--                      2 - Produto Especial
--Atualização         : 04/02/2005 - Acerto do Cabeçalho - Sérgio Cardoso 
--                      07.03.2005 - Verificação da Operação Fiscal 
--                                   Notas Canceladas - Carlos Fernandes
--                      09.03.2005 - Acerto do Flag de Controle de Custo - Carlos Fernandes
--                      11/04/2005 - Ordenação por Código de Grupo e não por descrição - ELIAS
---------------------------------------------------------------------------------------------
@ic_tipo_consulta int,    --Especial / Padrão
@cd_grupo_produto int,
@dt_inicial       DateTime,
@dt_final         DateTime
as

  --Padrão

  If @ic_tipo_consulta = 1 
  Begin

		Select 
		  ns.cd_nota_saida,
		  ns.dt_nota_saida,
		  ns.nm_fantasia_nota_saida,
		  nsi.cd_item_nota_saida,
		  nsi.nm_fantasia_produto,
		  nsi.cd_mascara_produto,     
		  nsi.vl_unitario_item_nota,
		  nsi.qt_item_nota_saida,
      (nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) vl_total_item,
		  nsi.nm_produto_item_nota,
		  nsi.cd_pedido_venda,
		  nsi.cd_item_pedido_venda,
      nsi.cd_grupo_produto,
      cast(gp.cd_grupo_produto as varchar)+' - '+gp.nm_grupo_produto as nm_grupo_produto,
      (select count(cd_produto) 
      from Nota_Saida x left outer join Nota_Saida_Item y on x.cd_nota_saida = y.cd_nota_saida
      where y.cd_grupo_produto = nsi.cd_grupo_produto and 
            x.dT_nota_saida between @dt_inicial and @dt_final) as 'QtdProduto'
    from Nota_Saida ns left outer join Nota_Saida_Item nsi on ns.cd_nota_saida = nsi.cd_nota_saida 
      left outer join Grupo_Produto   gp  on nsi.cd_grupo_produto  = gp.cd_grupo_produto
      left outer join Operacao_Fiscal op  on op.cd_operacao_fiscal = ns.cd_operacao_fiscal
  	where
      isnull(nsi.ic_tipo_nota_saida_item,'N')  = 'P'     and
      isnull(gp.ic_especial_grupo_produto,'N') = 'N'     and
	    ns.dt_nota_saida between @dt_inicial and @dt_final and
      isnull(op.ic_comercial_operacao,'N')     = 'S'     and
      isnull(op.ic_exportacao_op_fiscal,'N')   = 'N'     and
      isnull(op.ic_custo_operacao_fiscal,'N')  = 'S'     and
      ns.cd_status_nota <> 7                               and -- Nota Cancelada não Entra
      (nsi.cd_grupo_produto = case when @cd_grupo_produto=0 then nsi.cd_grupo_produto else @cd_grupo_produto end)        
    order by 
      nsi.ic_tipo_nota_saida_item,
      gp.cd_grupo_produto, 
      nsi.cd_produto, 
      nsi.cd_mascara_produto    

  end else if @ic_tipo_consulta = 2
  Begin
    Select 
      ns.cd_nota_saida,
	    ns.dt_nota_saida,
	    ns.nm_fantasia_nota_saida,
	    nsi.cd_item_nota_saida,
	    nsi.nm_fantasia_produto,
	    nsi.cd_mascara_produto,
	    nsi.vl_unitario_item_nota,
	    nsi.qt_item_nota_saida,
      (nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) vl_total_item,
	    nsi.nm_produto_item_nota,
	    nsi.cd_pedido_venda,
	    nsi.cd_item_pedido_venda,
      nsi.cd_grupo_produto,
      cast(gp.cd_grupo_produto as varchar)+' - '+gp.nm_grupo_produto as nm_grupo_produto,
      (select count(distinct cd_produto) 
       from Nota_Saida x left outer join Nota_Saida_Item y on x.cd_nota_saida = y.cd_nota_saida
       where y.cd_grupo_produto = nsi.cd_grupo_produto and 
             x.dT_nota_saida between @dt_inicial and @dt_final) as 'QtdProduto'
    From 
      Nota_Saida ns 
      Left Outer Join Nota_Saida_Item nsi  on ns.cd_nota_saida      = nsi.cd_nota_saida
      Left Outer join Operacao_Fiscal op   on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
      Left Outer Join Grupo_Produto   gp   on nsi.cd_grupo_produto  = gp.cd_grupo_produto
    Where
      IsNull(nsi.ic_tipo_nota_saida_item,'S') = 'P' and
      ns.dt_nota_saida between @dt_inicial and @dt_final and
      IsNull(gp.ic_especial_grupo_produto,'N') = 'S' and
      IsNull(gp.ic_especial_grupo_produto,'N') = 'S' and
      isnull(op.ic_comercial_operacao,'N')     = 'S' and
      isnull(op.ic_exportacao_op_fiscal,'N')   = 'N' and
      isnull(op.ic_custo_operacao_fiscal,'N')  = 'S' and
      ns.cd_status_nota<>7                           and -- Nota Cancelada não Entra
     (nsi.cd_grupo_produto = case when @cd_grupo_produto=0 then nsi.cd_grupo_produto else @cd_grupo_produto end)
    Order By nsi.ic_tipo_nota_saida_item, gp.cd_grupo_produto, nsi.cd_produto, nsi.cd_mascara_produto

  End

