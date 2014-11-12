
CREATE PROCEDURE pr_venda_categoria_estado
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Categoria
--		  Filtrado por Estado.
--Data          : 05/09/2002
--Atualizado    : 29/08/2003 - Incluído por País - Daniel C. Neto
-- 03/09/2003 - Acertos nas tabelas temp. - Daniel C. Neto.
-- 06/11/2003 - Incluído filtro por moeda - Daniel C. Neto.
-- 05/01/2004 - Mudança para usar a nova view - Daniel C. Neto.
-- 27.04.2004 - Inclusão de coluna com o valor líquido. Igor Gama
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.

---------------------------------------------------
@cd_pais   int =1,
@cd_estado int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1,
@cd_cidade  int = 0
as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

  -- Geração da tabela auxiliar de Vendas por Segmento
  select 
    cd_categoria_produto                 as 'categoria', 
    sum(qt_item_pedido_venda)            as 'Qtd',
    sum(qt_item_pedido_venda * vl_unitario_item_pedido/ @vl_moeda)    as 'Venda',
    sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido * qt_item_pedido_venda) / @vl_moeda, 
                                 pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)) as 'TotalLiquido',
    count(*) as 'Pedidos'
  into #VendaGrupoAux
  from
     vw_venda_bi
  where
    (dt_pedido_venda between @dt_inicial and @dt_final )     and
    ((cd_estado  = @cd_estado) or(@cd_estado = 0))         and 
    cd_pais = @cd_pais
    and  cd_cidade = (case @cd_cidade when 0 then cd_cidade else @cd_cidade end )
  group by cd_categoria_produto
  order  by 1 desc

  -------------------------------------------------
  -- calculando Quantos Clientes no Período.
  -------------------------------------------------

  -- Relacionando clientes com as Categorias que esse cliente comprou.
  select distinct
    a.cd_categoria_produto, 
    a.cd_cliente as Clientes
  into #ClienteCategoria1
  from
    vw_venda_bi a 
  where
     (a.dt_pedido_venda between @dt_inicial and @dt_final )
  order by
    a.cd_categoria_produto

  select 
    a.cd_categoria_produto, 
    count(Clientes) as Clientes
  into #ClienteCategoria
  from #ClienteCategoria1 a
  group by a.cd_categoria_produto

  ----------------------------------
  -- Fim da seleção de vendas totais
  ----------------------------------

  declare @qt_total_grupo int
  declare @vl_total_grupo float

  -- Total de Grupos
  set @qt_total_grupo = @@rowcount

  -- Total de Vendas Geral por Grupo
  set    @vl_total_grupo     = 0
  select @vl_total_grupo = @vl_total_grupo + venda
  from
    #VendaGrupoAux
  
  --Cria a Tabela Final de Vendas por Grupo
  select 
    IDENTITY(int,1,1) as 'Posicao',
    b.nm_categoria_produto,
    a.qtd,
    a.venda,
    a.TotalLiquido,
    a.Pedidos,
    cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc',
    c.Clientes
  Into #VendaGrupo
  from #VendaGrupoAux a , Categoria_Produto b, #ClienteCategoria c
  Where
    a.categoria = b.cd_categoria_produto and
    c.cd_categoria_produto = a.categoria
  order by a.Venda desc

  select * from #VendaGrupo

