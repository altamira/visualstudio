﻿
CREATE PROCEDURE pr_transfer_princing_venda

  @dt_inicial 		datetime,
  @dt_final   		datetime,
  @cd_aplicacao_markup  int
AS

  declare @SQL 			  varchar(8000),
  	  @SQLColunas		  varchar(8000),
  	  @SQLValorLiquido	  varchar(8000),
  	  @sg_coluna 		  varchar(15),
  	  @pc_coluna 		  float,
	  @SQLAux		  varchar(8000),
	  @SQLValorLiquidoAux 	  varchar(8000)

  --Gera o comando SQL para a consulta principal
  set @SQL = 'SELECT nsi.nm_fantasia_produto,'
	     + ' nsi.cd_item_nota_saida,'
	     + ' ns.nm_razao_social_c,'
	     + ' ns.cd_nota_saida,'
	     + ' nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0) AS QTD_ITEM,'
	     + ' (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100))  as VL_ITEM,'
	     + ' (nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100)) AS VL_TOTALBRUTO,'
	     + ' nsi.pc_icms,'
	     + ' (nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100)) * nsi.pc_icms / 100 AS VL_ICMS '

  --Gerar comando SQL Aux. para a consulta
  set @SQLAux = 'SELECT nsi.nm_fantasia_produto,'
	     + ' Sum(nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) AS QTD_ITEM'


  --Cursor p/ pegar informações de colunas que serão geradas
  declare cFormacao_Markup cursor for
    Select 
      tm.sg_tipo_markup, 
      fm.pc_formacao_markup
    from
      Formacao_Markup fm inner join 
      Tipo_Markup tm on fm.cd_tipo_markup =  tm.cd_tipo_markup
    where
      fm.cd_aplicacao_markup = @cd_aplicacao_markup
    order by
      fm.cd_aplicacao_markup
  
  open cFormacao_Markup

  fetch next from cFormacao_Markup
  into @sg_coluna, @pc_coluna
  
  set @SQLValorLiquido = ',((nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100))) - ('
  set @SQLValorLiquido = @SQLValorLiquido + '(((nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - ((cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100))) * nsi.pc_icms / 100))'
  set @SQLColunas = ''

  set @SQLValorLiquidoAux = ',Sum(((nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100))) - ('
  set @SQLValorLiquidoAux = @SQLValorLiquidoAux + '((nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100)) * nsi.pc_icms / 100)'

  --Enquanto existir formação de markup criar coluna para a formação
  while @@FETCH_STATUS = 0
  begin
    set @SQLColunas = @SQLColunas + ', (nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100)) * IsNull('  + cast(@pc_coluna as varchar) + ',0) / 100 as ' + rtrim(@sg_coluna)
    set @SQLValorLiquido = @SQLValorLiquido + ' + ((nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (((cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100))) * IsNull('  + cast(@pc_coluna as varchar) + ',0) / 100))'
    set @SQLValorLiquidoAux = @SQLValorLiquidoAux + ' + ((nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) * (((cast(nsi.vl_unitario_item_nota as decimal(15,2)) - (cast(nsi.vl_unitario_item_nota as decimal(15,2)) * cast(nsi.pc_desconto_item as decimal(15,2)) / 100)) * IsNull('  + cast(@pc_coluna as varchar) + ',0) / 100)))'

    fetch next from cFormacao_Markup
    into @sg_coluna, @pc_coluna    
  end
  
  close cFormacao_Markup
  deallocate cFormacao_Markup

  --Define a coluna valor liquido total da estrutura básica do comando SQL
  --Atualiza estrutura principal
  set @SQLValorLiquido = @SQLValorLiquido + ') as VL_TOTALLIQUIDO'
  set @SQL = @SQL + IsNull(@SQLColunas,'') + @SQLValorLiquido		  
                  + ' FROM Nota_Saida_Item as nsi'
                  + ' INNER JOIN'
                  + ' Nota_Saida as ns ON nsi.cd_nota_saida = ns.cd_nota_saida'
                  + ' LEFT OUTER JOIN'
                  + ' Produto_Custo as pc ON nsi.cd_produto = pc.cd_produto'
                  + ' where '
		  + ' (nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0))>0'
                  + ' and ns.dt_cancel_nota_saida is null '
		  + ' and (ns.cd_operacao_fiscal = ''5.12'' or ns.cd_operacao_fiscal = ''6.12'')'
                  + ' and ns.dt_nota_saida between ' + quotename(@dt_inicial, '''') + ' and ' + quotename(@dt_final, '''')
                  + ' and ns.cd_status_nota not in (3,4,7) '--Devolução Parcial/Devolução Total/Cancelado 
                  + ' and IsNull(pc.ic_importacao_produto,''N'') = ''S'' '--Filtra somente os produtos de importação
 

  set @SQLValorLiquidoAux = @SQLValorLiquidoAux + ')) / Sum(nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0)) as VL_MEDIA'
  set @SQLAux = @SQLAux + @SQLValorLiquidoAux
                  + ' FROM Nota_Saida_Item as nsi'
                  + ' INNER JOIN'
                  + ' Nota_Saida as ns ON nsi.cd_nota_saida = ns.cd_nota_saida'
                  + ' LEFT OUTER JOIN'
                  + ' Produto_Custo as pc ON nsi.cd_produto = pc.cd_produto'
                  + ' where '
		  + ' (nsi.qt_item_nota_saida - ISNULL(nsi.qt_devolucao_item_nota, 0))>0'
                  + ' and ns.dt_cancel_nota_saida is null '
		  + ' and (ns.cd_operacao_fiscal = ''5.12'' or ns.cd_operacao_fiscal = ''6.12'')'
                  + ' and ns.dt_nota_saida between ' + quotename(@dt_inicial, '''') + ' and ' + quotename(@dt_final, '''')
                  + ' and ns.cd_status_nota not in (3,4,7) '--Devolução Parcial/Devolução Total/Cancelado 
                  + ' and IsNull(pc.ic_importacao_produto,''N'') = ''S'' '--Filtra somente os produtos de importação
  		  + ' GROUP BY nsi.nm_fantasia_produto'

exec('Select a.*, r.vl_media from ('+ @SQL +') as a inner join (' + @SQLAux +') as r '
   + 'on a.nm_fantasia_produto = r.nm_fantasia_produto order by a.nm_fantasia_produto')
    

