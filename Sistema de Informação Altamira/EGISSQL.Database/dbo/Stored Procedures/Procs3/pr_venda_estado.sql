
CREATE PROCEDURE pr_venda_estado
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Estado.
--Data          : 05/09/2002
--Atualizado    : 29/08/2003
-- Incluído filtro e campo de País - Daniel C. NEto.
-- 06/11/2003 - Incluído filtro por moeda - Daniel C. Neto.
-- 05/01/2004 - Mudança para usar view nova - Daniel c. Neto.
-- 27.04.2004 - Inclusão de coluna de valor líquido, utilizando função 
--              de valor líquido. Igor Gama
---------------------------------------------------
@cd_pais    int = 1,
@cd_estado  int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1
as

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )


  set @cd_estado = isnull(@cd_estado,0)
  set @cd_pais   = isnull(@cd_pais,0)
  set @cd_moeda  = isnull(@cd_moeda,1)

  -- Geração da tabela auxiliar de Vendas por Segmento
  select 
    cd_pais                   as 'pais', 
    cd_estado                 as 'estado', 
    sum(qt_item_pedido_venda)            as 'Qtd',
    sum(qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda)    as 'Venda',
    sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido * qt_item_pedido_venda) / @vl_moeda, 
                                 pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)) as 'TotalLiquido',
    count(distinct(cd_pedido_venda)) as 'Pedidos'
  into #VendaGrupoAux
  from
     vw_venda_bi
  where
     (dt_pedido_venda between @dt_inicial and @dt_final )           
  Group by cd_pais, cd_estado
  order  by 1 desc

  -------------------------------------------------
  -- calculando Quantos Clientes no Período.
  -------------------------------------------------
  select distinct cd_cliente
  into #QtdCliente
  from
     vw_venda_bi
  where
     (dt_pedido_venda between @dt_inicial and @dt_final ) and
      IsNull(cd_categoria_produto,0) <> 0 

  select 
    b.cd_pais, b.cd_estado, 
    count(*) as Clientes
  into 
    #ClienteEstado
  from
    #QtdCliente a, Cliente b  
  where 
    a.cd_cliente = b.cd_cliente  
  group by 
    b.cd_pais, b.cd_estado

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
  from #VendaGrupoAux

  --Cria a Tabela Final de Vendas por Grupo
  select 
    IDENTITY(int,1,1) as 'Posicao',
    b.cd_pais,
    b.cd_estado,
    d.nm_pais,
    b.sg_estado,
    a.qtd,
    a.TotalLiquido,
    a.venda,
    a.Pedidos,
    cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc',
    c.Clientes
  Into 
  	#VendaGrupo
  from 
  	#VendaGrupoAux a 
      left outer join 
    Estado b
  	  on a.estado = b.cd_estado and
  		   a.pais = b.cd_pais
      left outer join 
    #ClienteEstado c
  	  on a.estado = c.cd_estado and
  		   a.pais = c.cd_pais
      left outer join 
    Pais d
  	  on a.pais = d.cd_pais
  order by a.Venda desc

  select * from #VendaGrupo  
  order by Posicao

