
CREATE PROCEDURE pr_rel_pre_calculo
@p_tipo char(1),
@p_1 varchar(10),
@p_2 varchar(10),
@p_traz_perda char(1),
@p_traz_alt char(1)

AS 

   DECLARE @sql VARCHAR(5000)
   DECLARE @sql_compl VARCHAR(200)

   SET @sql = 'SELECT a.cd_consulta,
          b.cd_item_consulta,
          c.nm_fantasia_cliente,
          CONVERT(VARCHAR(10), a.dt_consulta, 103) as dt_consulta,
          IsNull(d.nm_fantasia_contato, '''') as nm_fantasia_contato,
          cd_tel = 
             (case when isnull(d.cd_ddd_contato_cliente,0) = 0 then '''' else
              ''('' + CAST(CAST(d.cd_ddd_contato_cliente as int) as varchar) + '') '' end) 
              +
             (case when isnull(d.cd_telefone_contato,0) = 0 then '''' else
              Left(d.cd_telefone_contato, Len(d.cd_telefone_contato)-4) + ''-'' + Right(d.cd_telefone_contato, 4) end),
          IsNull(e.nm_departamento,'''') as cd_departamento,
          b.cd_grupo_produto,
          b.cd_categoria_produto,
          l.cd_grupo_categoria,
          b.cd_produto,
          b.nm_produto_consulta as ds_produto_consulta,
          b.qt_item_consulta,
          CASE
             WHEN b.cd_serie_produto IS NOT NULL THEN
                CAST(b.cd_serie_produto as varchar)
             WHEN b.cd_serie_produto IS NULL THEN
                ISNULL(CAST((SELECT top 1 MAX(cd_montagem)
                             FROM consulta_item_orcamento g
                             WHERE b.cd_consulta = g.cd_consulta
                                   AND b.cd_item_consulta = g.cd_item_consulta) as varchar), '''') + CAST(h.sg_tipo_montagem as varchar)
          END as cd_montagem,
          CAST(a.cd_vendedor_interno as varchar) + '' - '' + (SELECT top 1 nm_fantasia_vendedor
                                                              FROM vendedor
                                                              WHERE cd_vendedor = a.cd_vendedor_interno)
          as cd_vendedor_interno,
          CONVERT(VARCHAR(10), b.dt_entrega_consulta, 103) as dt_entrega_consulta,
          ISNULL(j.nm_fantasia_produto,'''') as nm_produto_padrao_orcam,
          j.vl_produto,
          AjusteBc = 
          case when i.qt_tpdabc_item_orcamento = 1 then '' Ø 42''
               when i.qt_tpdabc_item_orcamento = 2 then '' Ø 52''
          else ''Sem Ajuste'' end,
          b.ds_observacao_fabrica,
          b.ds_produto_consulta as ds_observacao_item,
          k.ds_especificacao_tecnica,
          i.pc_markup_mat_prima,
          i.pc_markup_mao_obra,
          i.vl_custo_item_orcamento,
          ISNULL(b.ic_item_perda_consulta, ''N'') as ic_item_perda_consulta,
          CONVERT(VARCHAR(10), b.dt_perda_consulta_itens, 103) as dt_perda_consulta_itens,
          CONVERT(VARCHAR(10), GETDATE(), 103) as Emissao,
          IsNull(f.nm_fantasia_usuario,'''') as Usuario,
          cd_pedido_venda = (select top 1 cd_pedido_venda from pedido_venda_item 
                             where cd_consulta = b.cd_consulta and
                                   cd_item_consulta = b.cd_item_consulta),
          cd_item_pedido_venda = (select top 1 cd_item_pedido_venda from pedido_venda_item 
                                  where cd_consulta = b.cd_consulta and
                                        cd_item_consulta = b.cd_item_consulta),
          ic_montagem_g_consulta,
          cd_mascara_produto =
          case when b.cd_produto > 0 then (select cd_mascara_produto from produto  
                                           where cd_produto = b.cd_produto) 
          else cast(b.cd_grupo_produto as char(2)) + ''9999999'' end

   FROM Consulta a

      INNER JOIN Consulta_itens b ON
         a.cd_consulta = b.cd_consulta
   
      INNER JOIN Cliente c ON
         a.cd_cliente = c.cd_cliente
   
      left outer JOIN consulta_item_orcamento i ON
         b.cd_consulta = i.cd_consulta
         AND b.cd_item_consulta = i.cd_item_consulta
         AND i.cd_ordem_item_orcamento = 1
         
      LEFT OUTER JOIN Categoria_Produto l ON
         b.cd_categoria_produto = l.cd_categoria_produto

      LEFT OUTER JOIN EgisAdmin.Dbo.usuario f ON
         i.cd_usuario = f.cd_usuario
         
      LEFT OUTER JOIN Cliente_Contato d ON
         a.cd_cliente = d.cd_cliente
         AND a.cd_contato = d.cd_contato
         
      LEFT OUTER JOIN Departamento e ON
         d.cd_departamento_cliente = e.cd_departamento
         
      LEFT OUTER JOIN tipo_montagem h ON
         ISNULL(b.cd_tipo_montagem, 1) = h.cd_tipo_montagem

      LEFT OUTER JOIN consulta_caract_tecnica_cq ct ON
         b.cd_consulta = ct.cd_consulta and
         b.cd_item_consulta = ct.cd_item_consulta

      LEFT OUTER JOIN produto j ON
         isnull(b.cd_produto_padrao_orcam,ct.cd_produto_padrao_orcam) = j.cd_produto
         
      LEFT OUTER JOIN Cliente_Especificacao_Tecnica k ON
         a.cd_cliente = k.cd_cliente
   WHERE '
    
   --Define se traz perdidas ou não...
   IF @p_traz_perda = 'N'
      SET @sql = @sql + 'b.dt_perda_consulta_itens IS NULL AND '

   -- Consulta Única
   IF @p_tipo = 'U'
      SET @sql_compl = 'a.cd_consulta = ' + @p_1 + ' AND b.cd_item_consulta = ' + @p_2
   ELSE
      -- Faixa de consultas 
      IF @p_tipo = 'F'
         SET @sql_compl = 'i.cd_consulta BETWEEN ' + @p_1 + ' AND ' + @p_2
      ELSE
        -- Único Pedido
        IF @p_tipo = 'P'
           SET @sql_compl = 'b.cd_pedido_venda = ' + @p_1 + ' AND b.cd_item_pedido_venda = ' + @p_2
        ELSE
         -- Consultas entre datas
         IF @p_tipo = 'D'
            SET @sql_compl = 'a.dt_consulta BETWEEN ''' + @p_1 + ''' AND ''' + @p_2 + ''''
         ELSE
            -- Todas as consultas
            IF @p_tipo = 'T'
               SET @sql_compl = 'a.dt_consulta BETWEEN ''01/01/1998'' AND GETDATE()' 
            ELSE
               PRINT '* * * * Parametro inválido para procedure * * * *'

   SET @sql = @sql + @sql_compl + ' ORDER BY a.cd_consulta, b.cd_item_consulta'

   -- PRINT @sql
   EXEC(@sql)

