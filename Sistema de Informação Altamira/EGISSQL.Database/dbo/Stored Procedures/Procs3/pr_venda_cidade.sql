
CREATE PROCEDURE pr_venda_cidade
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2006
------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta Vendas no Período por Cidade
--Data             : 21.04.2006
--Atualizado       : 
------------------------------------------------------------------------------------------------------
@cd_pais    int = 1,
@cd_estado  int = 0,
@cd_cidade  int = 0,
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

  -- Geração da tabela auxiliar de Vendas 

  select 
    cd_pais                              as 'pais', 
    cd_estado                            as 'estado', 
    cd_cidade                            as 'cidade',
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
    and  cd_cidade = (case @cd_cidade when 0 then cd_cidade else @cd_cidade end )
  Group by cd_pais, cd_estado, cd_cidade
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
    b.cd_pais, b.cd_estado, b.cd_cidade,
    count(*) as Clientes
  into 
    #ClienteEstado
  from
    #QtdCliente a, Cliente b  
  where 
    a.cd_cliente = b.cd_cliente  
  group by 
    b.cd_pais, b.cd_estado, b.cd_cidade

  ----------------------------------
  -- Fim da seleção de vendas totais
  ----------------------------------

  declare @qt_total_grupo int
  declare @vl_total_grupo float

  -- Total de Grupos
  set @qt_total_grupo = @@rowcount

  -- Total de Vendas Geral por Grupo
  set    @vl_total_grupo = 0

  select 
    @vl_total_grupo = @vl_total_grupo + venda
  from 
    #VendaGrupoAux

  --Cria a Tabela Final de Vendas por Grupo
  select 
    IDENTITY(int,1,1) as 'Posicao',
    b.cd_pais,
    b.cd_estado,
    d.nm_pais,
    b.sg_estado,
    ci.cd_cidade,
    ci.nm_cidade,
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
    left outer join Estado b         on a.estado     = b.cd_estado and a.pais = b.cd_pais
    left outer join #ClienteEstado c on a.estado     = c.cd_estado and a.pais = c.cd_pais and c.cd_cidade = a.cidade
    left outer join Pais d           on a.pais       = d.cd_pais
    left outer join Cidade ci        on ci.cd_pais   = a.pais   and
                                        ci.cd_estado = a.estado and
                                        ci.cd_cidade = a.cidade
  order by a.Venda desc

  select * from #VendaGrupo  
  order by Posicao

