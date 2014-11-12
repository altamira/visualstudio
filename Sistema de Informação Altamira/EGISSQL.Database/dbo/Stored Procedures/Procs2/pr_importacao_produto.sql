
Create procedure pr_importacao_produto
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution S/A                                          2003
--Stored Procedure : SQL Server Microsoft 7.0  
--Márcio Rodrigues


-----------------------------------------------------------------------------------
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1
as

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )

  -- Geração da tabela auxiliar de Vendas por Produto
  select 
    a.nm_fantasia_produto,
    a.cd_produto          as 'produto', 
    sum(a.qt_item_ped_imp*(a.vl_item_ped_imp / @vl_moeda))  as 'Venda',
    sum(a.qt_item_ped_imp*(a.vl_item_ped_imp / @vl_moeda)) as 'TotalLiquido',
     cast(sum((a.qt_item_ped_imp *
              (a.vl_item_ped_imp / @vl_moeda)
             )
         ) as decimal(25,2)) as 'TotalLiSta',
     cast(sum((a.qt_item_ped_imp* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',
     0 as 'MargemContribuicao',
     cast(sum((a.qt_item_ped_imp* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',
     sum(a.qt_item_ped_imp)         as 'Qtd',
     max(a.dt_pedido_importacao)    as 'UltimaVenda', 
     count(distinct a.cd_pedido_importacao) as 'pedidos'
  into #ImportacaoCategAux
from 
     vw_importacao_bi a 
       left outer join
     Produto_Custo ps 
       on ps.cd_produto = a.cd_produto   
  where
    (a.dt_pedido_importacao between @dt_inicial and @dt_final )    and
  --    IsNull(b.dt_cancelamento_item,@dt_final + 1) > @dt_final and --Desconsidera itens cancelados depois da data final
  --  IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados
  --  isNull(b.ic_smo_item_pedido_venda, 'N') = 'N'             and
    a.cd_produto is not null
  group by  
    a.cd_produto, a.nm_fantasia_produto
  order by 1 desc
  
  declare @qt_total_categ int
  declare @vl_total_categ float
  
  -- Total de Produtos
  set @qt_total_categ = @@rowcount
  
  -- Total de Vendas Geral por Produto
  set @vl_total_categ     = 0
  select @vl_total_categ = @vl_total_categ + venda
  from
    #ImportacaoCategAux
  
  select IDENTITY(int, 1,1) AS 'Posicao',
         a.nm_fantasia_produto,
         a.produto,
         a.qtd,
         a.venda, 
         a.TotalLiquido,
         a.TotalLista,
         a.CustoContabil,
         a.MargemContribuicao,
         a.BNS,
        (a.venda/@vl_total_categ)*100 as 'Perc',
         a.UltimaVenda, a.pedidos,
        (case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0
         else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end ) as 'Desc'
  into #ImportacaoCateg
  from #ImportacaoCategAux a
  order by a.venda desc
  
  --Mostra tabela ao usuário
  select 
         dbo.fn_mascara_produto(b.cd_produto) as cd_mascara_produto,
         b.nm_produto,
         un.sg_unidade_medida,
         a.*
  from #ImportacaoCateg a left outer join
       Produto b on   a.produto = b.cd_produto left outer join
       Unidade_medida un on un.cd_unidade_medida = b.cd_unidade_medida
  order by posicao
