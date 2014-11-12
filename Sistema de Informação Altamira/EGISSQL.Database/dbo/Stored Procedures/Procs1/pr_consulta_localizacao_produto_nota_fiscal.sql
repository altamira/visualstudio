CREATE PROCEDURE pr_consulta_localizacao_produto_nota_fiscal
---------------------------------------------------
--GBS - Global Business Solution           2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio Cesar
--Banco de Dados: EGISSQL
--Objetivo: Consultar o endereço de estoque dos produtos da(s) nota(s) fiscal(is)
--Data: 16.05.2003
---------------------------------------------------
@dt_inicial datetime,
@dt_final datetime,
@cd_nota_saida_inicial int = 0,
@cd_nota_saida_final int = 0
as

       Select 
			  cast(nsi.cd_nota_saida as varchar) + '.' + cast(nsi.cd_item_nota_saida as varchar) as cd_identificador,
			  ns.nm_fantasia_destinatario,
			  ns.dt_nota_saida,
			  ns.dt_saida_nota_saida,
			  nsi.cd_nota_saida,
              nsi.nm_fantasia_produto,
              case
                      when p.cd_produto_baixa_estoque is null then
                           p.cd_produto
                      else p.cd_produto_baixa_estoque
              end as cd_produto,
              nsi.nm_produto_item_nota,
              nsi.cd_item_nota_saida,
              nsi.qt_item_nota_saida,
              nsi.qt_devolucao_item_nota,
              nsi.dt_cancel_item_nota_saida,
              nsi.cd_pedido_venda,
              nsi.cd_item_pedido_venda,
			  dbo.fn_produto_localizacao(nsi.cd_produto,nsi.cd_fase_produto) as nm_localizacao_estoque
       from Nota_Saida_item nsi
       inner Join Nota_Saida ns
       On ns.cd_nota_saida = nsi.cd_nota_saida
       Left Join Produto p
       On p.cd_Produto = nsi.cd_Produto
       where 
			--Filtra por data caso não for informada número de nota
			((@cd_nota_saida_inicial = 0) and (@cd_nota_saida_final = 0) and
            (ns.dt_nota_saida between @dt_inicial and @dt_final))
			or 
			((@cd_nota_saida_inicial != 0) and (@cd_nota_saida_final != 0) and
            (ns.cd_nota_saida between @cd_nota_saida_inicial and @cd_nota_saida_final))
			or
			((@cd_nota_saida_inicial != 0) and (@cd_nota_saida_final = 0) and
            (ns.cd_nota_saida >= @cd_nota_saida_inicial))
			or
			((@cd_nota_saida_inicial = 0) and (@cd_nota_saida_final != 0) and
            (ns.cd_nota_saida <= @cd_nota_saida_final))
       order by dbo.fn_produto_localizacao(nsi.cd_produto,nsi.cd_fase_produto), nsi.cd_item_nota_saida
