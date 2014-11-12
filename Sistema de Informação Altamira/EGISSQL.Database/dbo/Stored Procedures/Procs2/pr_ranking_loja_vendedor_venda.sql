


CREATE   procedure pr_ranking_loja_vendedor_venda 
-----------------------------------------------------------------------------------
-- GBS - Global Business Solution                                              2000
--Stored Procedure : SQL Server 2000
--Daniel Duela / Daniel Carrasco
--Raking de Região x Vendedor
--Data         : 03/12/2003
--Atualizado   : 30/03/2004 - Acerto para bater com a consulta de pedido de venda
-- - Daniel C. Neto.
-----------------------------------------------------------------------------------
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime,
@cd_loja    int,
@cd_moeda     int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-----------------------------------------------------------------------------------------
if @ic_parametro = 1  -- Consulta do Ranking Loja
-----------------------------------------------------------------------------------------
begin
  -- Montagem da tabela de total de vendedores por região
  select 
    cd_loja as 'cd_loja',
    count(*)        as 'qtdvendedores'
  into #Resumo_Vendedor_Setor
  from
	  Vendedor
  group by cd_loja


  -- Geração da tabela auxiliar de Vendas por Setor
  select 
    isnull(vr.cd_loja,0) as 'cd_loja', 
    sum(vw.qt_item_pedido_venda*(vw.vl_unitario_item_pedido / @vl_moeda)) as 'Venda', 
    cast(sum(dbo.fn_vl_liquido_venda('V',(vw.qt_item_pedido_venda*
                                         (vw.vl_unitario_item_pedido / @vl_moeda))
                                        , vw.pc_icms, vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
    cast(sum((vw.qt_item_pedido_venda *
             (vw.vl_lista_item_pedido / @vl_moeda))) as decimal(25,2)) as 'TotalLiSta',
    cast(sum((vw.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',
    cast(sum((vw.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /
         sum((dbo.fn_vl_liquido_venda('V',(vw.qt_item_pedido_venda*
                                          (vw.vl_unitario_item_pedido / @vl_moeda))
                                         , vw.pc_icms, vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial))) as decimal(25,2)) * 100 as 'MargemContribuicao',
    cast(sum((vw.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',
    max(vw.dt_pedido_venda)            as 'UltimaVenda', 
    count(distinct vw.cd_pedido_venda) as 'Pedidos'
  into 
		#VendaSetorAux1
  from
    vw_venda_bi vw 
  left outer join Vendedor vr on
    vw.cd_vendedor=vr.cd_vendedor
  left outer join Produto_Custo ps on 
    ps.cd_produto = vw.cd_produto 
  where
    (vw.dt_pedido_venda between @dt_inicial and @dt_final)
 group by vr.cd_loja
  order by 2 desc

  declare @qt_total_setor int
  declare @vl_total_setor float
  -- Total de Setores
  set @qt_total_setor = @@rowcount

  -- Total de Vendas Geral dos Setores
  set @vl_total_setor = 0

  Select 
		@vl_total_setor = @vl_total_setor + sum(IsNull(venda,0))
  from
    #VendaSetorAux1

--Cria a Tabela Final de Vendas por Setor
  select IDENTITY(int, 1,1)      as 'Posicao',
         a.cd_loja, 
         (Select top 1 nm_fantasia_loja from loja where cd_loja = a.cd_loja) as nm_loja,
         isnull((Select qtdvendedores from #Resumo_Vendedor_Setor where cd_loja = a.cd_loja),0) as Qtd_vendedores,
         isnull(a.venda,0)       as Venda, 
         a.TotalLiquido,
         a.TotalLista,
         a.CustoContabil,
         a.MargemContribuicao,
         a.BNS,
         isnull(((a.venda/@vl_total_setor)*100),0) as Perc,
         a.UltimaVenda, 
         isnull(a.pedidos,0)     as Pedidos
  Into 
		#VendaSetor1
  from 
    #VendaSetorAux1 a
  Order by a.venda desc

--Mostra tabela ao usuário
  select * from #VendaSetor1
  order by posicao
end


-----------------------------------------------------------------------------------------
if @ic_parametro = 2  -- Consulta do Ranking Vendedores por Loja
-----------------------------------------------------------------------------------------
begin

  select 
    c.cd_vendedor as 'setor',
    count(*) as 'qtdclientes'
  into #Resumo_Clientes_Setor
  from
    Cliente c
  inner join Vendedor vr on
    c.cd_vendedor=vr.cd_vendedor and
    vr.cd_loja=@cd_loja
  group by
    c.cd_vendedor

-- Geração da tabela auxiliar de Vendas por Setor
  select 
    vw.cd_vendedor                    as 'setor', 
    sum(vw.qt_item_pedido_venda*(vw.vl_unitario_item_pedido / @vl_moeda)) as 'Venda', 
    cast(sum(dbo.fn_vl_liquido_venda('V',(vw.qt_item_pedido_venda*
                                         (vw.vl_unitario_item_pedido / @vl_moeda))
                                        , vw.pc_icms, vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
    cast(sum((vw.qt_item_pedido_venda *
             (vw.vl_lista_item_pedido / @vl_moeda))) as decimal(25,2)) as 'TotalLiSta',
    cast(sum((vw.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',
    cast(sum((vw.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /
         sum((dbo.fn_vl_liquido_venda('V',(vw.qt_item_pedido_venda*
                                         (vw.vl_unitario_item_pedido / @vl_moeda))
                                        , vw.pc_icms, vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial))) as decimal(25,2)) * 100 as 'MargemContribuicao',

    cast(sum((vw.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',
    max(vw.dt_pedido_venda)           as 'UltimaVenda', 
    count(distinct vw.cd_pedido_venda) as 'pedidos'
  into 
		#VendaSetorAux2
  from
    vw_venda_bi vw 
  left outer join Produto_Custo ps on 
    ps.cd_produto = vw.cd_produto 
  where
    (vw.dt_pedido_venda between @dt_inicial and @dt_final) --and 
  Group by 
		 cd_vendedor
  Order by 2 desc



  declare @qt_total_setor2 int
  declare @vl_total_setor2 float

-- Total de Setores
  set @qt_total_setor2 = @@rowcount

-- Total de Vendas Geral dos Setores
  set @vl_total_setor2 = 0
  select 
		@vl_total_setor2 = @vl_total_setor2 + sum(venda)
  from
    #VendaSetorAux2



--Cria a Tabela Final de Vendas por Loja
  select 
    IDENTITY(int, 1,1)      as 'Posicao',
    a.setor, 
    b.nm_fantasia_vendedor as 'Vendedor',
    isnull(c.qtdclientes,0) as 'qtdclientes',
    isnull(a.venda,0)       as 'venda', 
    a.TotalLiquido,
    a.TotalLista,
    a.CustoContabil,
    a.MargemContribuicao,
    a.BNS,
    isnull(((a.venda/@vl_total_setor2)*100),0) as 'Perc',
    a.UltimaVenda, 
    isnull(a.pedidos,0)     as 'pedidos'
  into #VendaSetor2
  from 
    #VendaSetorAux2 a, 
    vendedor b,
    #Resumo_Clientes_setor c
  where
    a.setor *= b.cd_vendedor and
    a.setor = c.setor 
  Order by a.venda desc

--Mostra tabela ao usuário
  select * from #VendaSetor2
  order by posicao
end

-----------------------------------------------------------------------------------------
if @ic_parametro = 3  -- Consulta do Ranking Categorias por Loja
-----------------------------------------------------------------------------------------
begin
-- Geração da Tabela Auxiliar de Vendas por Cliente
  select 
    vr.cd_loja as 'cd_loja', 
    vw.cd_categoria_produto,       
    sum(vw.qt_item_pedido_venda) as 'qtd',
    sum(vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido / @vl_moeda) as 'Compra',
    cast(sum(dbo.fn_vl_liquido_venda('V',(vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido), vw.pc_icms, 
                                     vw.pc_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido
  into #VendaClienteCategoriaAuxGeral3
  from --pedido_venda a 
    vw_venda_bi vw 
      inner join 
    Vendedor vr 
      on vw.cd_vendedor = vr.cd_vendedor and 
         vr.cd_loja = @cd_loja
--   left outer join  pedido_venda_item c on 
--     c.cd_pedido_venda = a.cd_pedido_venda 
      left outer join 
    Cliente cli 
      on cli.cd_cliente = vw.cd_cliente
  where
    (vw.dt_pedido_venda between @dt_inicial and @dt_final)        and
    (vw.qt_item_pedido_venda*vw.vl_unitario_item_pedido / @vl_moeda) > 0     -- and
--    isnull(a.ic_consignacao_pedido,'N') <> 'S'            and
--    IsNull(c.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final
--    IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final --Desconsider pedidos de venda cancelados                
  group by 
    vr.cd_loja, vw.cd_categoria_produto
  order by 3 desc 

  declare @qt_total_cliente3 int
  declare @vl_total_cliente3 float

-- Total de Cliente
  set @qt_total_cliente3 = @@rowcount

-- Total de Vendas Geral
  set     @vl_total_cliente3 = 0
  select @vl_total_cliente3 = @vl_total_cliente3 + compra
  from
    #VendaClienteCategoriaAuxGeral3

  select 
    IDENTITY(int, 1,1) AS 'Posicao', 
    b.cd_categoria_produto, 
    b.sg_categoria_produto as 'Categoria',
    a.qtd,
    a.Compra, 
    a.TotalLiquido,
    cast(((a.compra/@vl_total_cliente3)*100)as decimal(25,2)) as 'Perc'
  Into #VendaClienteCategoriaGeral3
  from 
    #VendaClienteCategoriaAuxGeral3 a
      left outer join 
    categoria_produto b 
      on b.cd_categoria_produto = a.cd_categoria_produto
  Order by Compra desc
     

--Mostra tabela ao usuário
  select * from #VendaClienteCategoriaGeral3
  order by Posicao
end



