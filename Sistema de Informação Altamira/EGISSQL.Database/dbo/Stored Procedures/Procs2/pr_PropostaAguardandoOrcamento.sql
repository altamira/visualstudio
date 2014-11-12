
CREATE PROCEDURE pr_PropostaAguardandoOrcamento

  @cd_consulta integer, --Código da proposta
  @nm_fantasia_cliente varchar(30)  --Nome fantasia do Cliente

AS


  Declare @SQL varchar(2000)

  set @SQL  = 'SELECT '
                + 'dbo.Consulta.cd_consulta, '
                + '(Select top 1 nm_grupo_produto from Grupo_Produto where cd_grupo_produto = dbo.Consulta_Itens.cd_grupo_produto) as nm_grupo_produto, '
                + 'dbo.Cliente.nm_fantasia_cliente, '
                + 'dbo.Consulta.dt_consulta, '
                + 'dbo.Consulta_Itens.cd_item_consulta, '
                + 'dbo.Consulta_Itens.qt_item_consulta, '
                + 'dbo.Consulta_Itens.nm_fantasia_produto, '
                + 'dbo.Consulta_Itens.dt_entrega_consulta, '
                + 'dbo.Consulta_Itens.nm_produto_consulta, '                
					 + '(Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = dbo.Consulta.cd_vendedor_interno) as nm_fantasia_vendedor_int, '
                + '(Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = dbo.Consulta.cd_vendedor) as nm_fantasia_vendedor_ext,     '
                + '(Select top 1 cd_mascara_categoria from categoria_produto where cd_categoria_produto = dbo.Consulta_itens.cd_categoria_produto) as nm_categoria_produto, '
                + '(Select top 1 nm_grupo_categoria from grupo_categoria where cd_grupo_categoria = dbo.Consulta_itens.cd_grupo_categoria) as nm_grupo_categoria '
           + 'FROM '        
                + 'dbo.Consulta_Itens INNER JOIN '
                + 'dbo.Consulta ON dbo.Consulta_Itens.cd_consulta = dbo.Consulta.cd_consulta INNER JOIN '
                + 'dbo.Cliente ON dbo.Consulta.cd_cliente = dbo.Cliente.cd_cliente '

           + 'where dbo.Consulta_itens.ic_orcamento_consulta = ''S'' and isNull(dbo.Consulta_Itens.vl_lista_item_consulta,0) = 0 '        

    --Verifica se deverá realizar filtragem por algum campo
     
        --Verifica qual campo está preenchido
        if (@cd_consulta > 0)
           set @SQL = @SQL + 'and dbo.Consulta.cd_consulta = ' + cast(@cd_consulta as varchar(10)) + ' '

        if (rtrim(ltrim(@nm_fantasia_cliente)) != '')
        begin
            set @SQL = @SQL + ' and dbo.Cliente.nm_fantasia_cliente = ''' + @nm_fantasia_cliente + ''''
        end
        
        --Ordena os dados
        set @SQL = @SQL + ' order by nm_categoria_produto, dbo.Consulta.dt_consulta'
    exec (@SQL)

