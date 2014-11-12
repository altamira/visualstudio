
CREATE PROCEDURE pr_transfer_pricing_resumo

  @dt_inicial 		datetime,
  @dt_final   		datetime,
  @cd_aplicacao_markup  int

AS

  declare @SQL 			varchar(8000)
  declare @SQL_valor_liquido 	varchar(8000)
  declare @sg_coluna 		varchar(15)
  declare @pc_coluna 		float


  set @SQL_valor_liquido = ', cast((sum((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) - ((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) * nsi.pc_desconto_item) / 100)) / (sum(nsi.qt_item_nota_saida)) '

  set @SQL = 'select '
            + ' p.nm_fantasia_produto nm_produto ' 

  --Curosor p/ pegar informações de colunas que serão geradas
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

  --Enquanto existir formação de markup criar coluna para a formação
  while @@FETCH_STATUS = 0
  begin

    set @SQL_valor_liquido = @SQL_valor_liquido + ' - (((sum((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) - ((nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) * nsi.pc_desconto_item) / 100)) / (sum(nsi.qt_item_nota_saida)) * ' + cast(@pc_coluna as varchar) + ') / 100) '

    fetch next from cFormacao_Markup
    into @sg_coluna, @pc_coluna    
  end
  
  close cFormacao_Markup
  deallocate cFormacao_Markup

  set @SQL = @SQL + @SQL_valor_liquido + ' as decimal(15,2)) as vl_unitario_liquido'

  set @SQL = @SQL + ' from '
                  + '   Produto p left outer join '
                  + '   Produto_Custo pc on p.cd_produto = pc.cd_produto left outer join '
                  + '   Nota_Saida_Item nsi on p.cd_produto = nsi.cd_produto left outer join '
                  + '   Nota_Saida ns on nsi.cd_nota_saida = ns.cd_nota_saida '
                  + ' where '
                  + '   pc.ic_importacao_produto = ' + quotename('S', '''')
                  + '   and ns.dt_cancel_nota_saida is null '
                  + '   and ns.dt_nota_saida between ' + quotename(@dt_inicial, '''') + ' and ' + quotename(@dt_final, '''')
                  + '   and ns.cd_status_nota not in (3,4,7) '--Devolução Parcial/Devolução Total/Cancelado 
                  + ' group by '
                  + '   p.nm_fantasia_produto '
                  + ' order by '
                  + '   p.nm_fantasia_produto'
  
  create table #Media_Venda
  (nm_fantasia_produto varchar(30),
   vl_venda_media float)
  
  insert into #Media_Venda exec(@SQL)

  SELECT     
    distinct nei.nm_fantasia_produto,
    oi.nm_origem_importacao, 
    ne.cd_nota_entrada, 
    cast(nei.qt_item_nota_entrada as decimal(15,2)) as qt_item_nota_entrada, 
    cast(nei.vl_fob_item as decimal(15,2)) as vl_fob_item, 
    cast(nei.pc_conversao_fob as decimal(10,6)) as pc_conversao_fob, 
    cast(nei.vl_fob_item * nei.pc_conversao_fob as decimal(15,2)) AS vl_real, 
    cast(isnull(nei.vl_frete_item,0) + isnull(nei.vl_seguro_item,0) as decimal(15,2)) AS vl_frete_seguro, 
    cast(isnull(nei.vl_imposto_importacao,0) as decimal(15,2)) as vl_imposto_importacao,
    cast((((isnull(nei.vl_fob_item,0) * isnull(nei.pc_conversao_fob,1)) + 
    isnull(nei.vl_frete_item,0) + isnull(nei.vl_seguro_item,0) + 
    isnull(nei.vl_imposto_importacao,0))) as decimal(15,2)) AS vl_unitario,-- / case when nei.qt_item_nota_entrada = 0 then 1 else nei.qt_item_nota_entrada end AS vl_unitario
    cast(isnull(mv.vl_venda_media, 0) as decimal(15,2)) as vl_venda_media,
    cast(isnull(mv.vl_venda_media, 0) - (((isnull(nei.vl_fob_item,0) * isnull(nei.pc_conversao_fob,1)) + 
    isnull(nei.vl_frete_item,0) + isnull(nei.vl_seguro_item,0) + 
    isnull(nei.vl_imposto_importacao,0))) as decimal(15,2)) AS vl_transfer_pricing,
    cast(isnull(mv.vl_venda_media, 0) * 1.05 as decimal(15,2)) as vl_ajuste_5,
    cast((isnull(mv.vl_venda_media, 0) * 1.05) - (((isnull(nei.vl_fob_item,0) * isnull(nei.pc_conversao_fob,1)) + 
    isnull(nei.vl_frete_item,0) + isnull(nei.vl_seguro_item,0) + 
    isnull(nei.vl_imposto_importacao,0))) as decimal(15,2)) as vl_ajustado,
    cast((isnull(mv.vl_venda_media, 0) * 1.05) - (((isnull(nei.vl_fob_item,0) * isnull(nei.pc_conversao_fob,1)) + 
    isnull(nei.vl_frete_item,0) + isnull(nei.vl_seguro_item,0) + 
    isnull(nei.vl_imposto_importacao,0))) * nei.qt_item_nota_entrada as decimal(15,2)) as vl_total_lalur
  FROM         
    Nota_Entrada ne RIGHT OUTER JOIN
    Nota_Entrada_Item nei ON ne.cd_nota_entrada = nei.cd_nota_entrada LEFT OUTER JOIN
    Origem_Importacao oi ON ne.cd_origem_importacao = oi.cd_origem_importacao LEFT OUTER JOIN
    Produto p ON nei.cd_produto = p.cd_produto left outer join
    Produto_Custo pc on pc.cd_produto = nei.cd_produto left outer join
    #Media_Venda mv on mv.nm_fantasia_produto = nei.nm_fantasia_produto
  WHERE
    ne.dt_entrada_nota_entrada between @dt_inicial and @dt_final
    and pc.ic_importacao_produto = 'S' and
    isnull(mv.vl_venda_media, 0) - cast((((isnull(nei.vl_fob_item,0) * isnull(nei.pc_conversao_fob,1)) + 
    isnull(nei.vl_frete_item,0) + isnull(nei.vl_seguro_item,0) + 
    isnull(nei.vl_imposto_importacao,0))) as decimal(15,2)) < 0
  ORDER BY
    nei.nm_fantasia_produto

  drop table #Media_Venda

