CREATE PROCEDURE pr_venda_cli_vend_estado
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Cliente/Vendedor
--		  Filtrado por Estado.
--Data          : 05/01/2004
-- 27.04.2004   - Inclusão de coluna de valor líquido. Igor Gama.
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.

--------------------------------------------------
@cd_pais   int =1,
@cd_estado int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1,
@cd_cidade  int = 0,
@ic_filtro varchar(1)
as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

  -- Geração da tabela auxiliar de Vendas por Segmento
  create table
    #VendaGrupoAux
  ( Nome varchar(50) Null,
    Qtd Float Null,
    Venda Float Null,
    TotalLiquido Float Null,
    Pedidos Int Null )

  if @cd_pais = 0 
    set @cd_pais = 1  

  if @ic_filtro = 'C'
    insert into #VendaGrupoAux
    select 
      nm_fantasia_cliente, 
      sum(qt_item_pedido_venda),
      sum(qt_item_pedido_venda * vl_unitario_item_pedido/ @vl_moeda),
      sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido * qt_item_pedido_venda) / @vl_moeda, 
                                 pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)),
      count(distinct(cd_pedido_venda))
    from
       vw_venda_bi
    where
      (dt_pedido_venda between @dt_inicial and @dt_final )     and
      ((cd_estado  = @cd_estado) or ((@cd_estado = 0) and cd_estado is null))         and 
      cd_pais = @cd_pais 
      and cd_cidade = (case @cd_cidade when 0 then cd_cidade else @cd_cidade end )
    group by nm_fantasia_cliente
    order  by 1 desc

  else
    insert into #VendaGrupoAux
    select 
      nm_vendedor_externo, 
      sum(qt_item_pedido_venda),
      sum(qt_item_pedido_venda * vl_unitario_item_pedido/ @vl_moeda),
      sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido * qt_item_pedido_venda) / @vl_moeda, 
                                 pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)),
      count(distinct(cd_pedido_venda))
    from
       vw_venda_bi
    where
      (dt_pedido_venda between @dt_inicial and @dt_final )     and
      ((cd_estado  = @cd_estado) or ((@cd_estado = 0) and cd_estado is null))         and 
      cd_pais = @cd_pais 
      and cd_cidade = (case @cd_cidade when 0 then cd_cidade else @cd_cidade end )
    group by nm_vendedor_externo
    order  by 1 desc

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
    a.Nome,
    a.qtd,
    a.TotalLiquido,
    a.venda,
    a.Pedidos,
    cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc'
  Into #VendaGrupo
  from #VendaGrupoAux a
  order by a.Venda desc
  
  select * from #VendaGrupo order by Posicao

