
-------------------------------------------------------------------------------
--pr_ranking_venda_fornecedor_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Vendas por Fornecedor do Produto Vendido
--Data             : 05.05.2006
--Alteração        : 30.01.2010
------------------------------------------------------------------------------
create procedure pr_ranking_venda_fornecedor_produto
@ic_parametro    int      = 0,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_moeda        int      = 1,
@cd_tipo_mercado int      = 0

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


------------------------------------------------------------------------------
--Fornecedor
------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  -- Geração da tabela auxiliar de Vendas por Produto  

  Select   
    f.cd_fornecedor,
    sum(a.qt_item_pedido_venda*(a.vl_unitario_item_pedido / @vl_moeda))  as 'Venda',  
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*  
                                         (a.vl_unitario_item_pedido / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',  
    cast(sum((a.qt_item_pedido_venda *  
             (a.vl_lista_item_pedido / @vl_moeda)  
            )  
        ) as decimal(25,2)) as 'TotalLiSta',  
    cast(sum((a.qt_item_pedido_venda* case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',  
  
    cast(sum((a.qt_item_pedido_venda * (case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)  
       / case when (dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda * (a.vl_unitario_item_pedido / @vl_moeda)), a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, '2006-02-01') ) = 0 then 1 else
  						 (dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda * (a.vl_unitario_item_pedido / @vl_moeda)), a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, '2006-02-01') ) end
		 ) * 100) as decimal(25,2)) as 'MargemContribuicao',  
    cast(sum((a.qt_item_pedido_venda* case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',  
    sum(a.qt_item_pedido_venda)         as 'Qtd',  
    max(a.dt_pedido_venda)              as 'UltimaVenda',   
    count(distinct a.cd_pedido_venda)   as 'pedidos'  
  into #VendaProdutoFornecedor
  from  
     vw_venda_bi a
--     inner join pedido_compra_item pci on pci.cd_produto      = a.cd_produto
--     inner join pedido_compra      pc  on pc.cd_pedido_compra = pci.cd_pedido_compra
     inner join fornecedor_produto fp  on fp.cd_produto       = a.cd_produto 
                                          --and fp.cd_fornecedor    = pc.cd_fornecedor 

     inner join fornecedor         f   on f.cd_fornecedor     = fp.cd_fornecedor  --( pc.cd_fornecedor )

  where  
--    pc.dt_pedido_compra between @dt_inicial and @dt_final  and
    a.dt_pedido_venda between @dt_inicial and @dt_final     and  
    a.cd_produto is not null 
  group by    
    f.cd_fornecedor
  order by 1 desc  
    
  declare @qt_total int  
  declare @vl_total float  
    
  -- Total de Produtos  
  set @qt_total = @@rowcount  
    
  -- Total de Vendas Geral por Produto  
  set @vl_total     = 0  

  select @vl_total = @vl_total + venda  
  from  
    #VendaProdutoFornecedor
    
  select IDENTITY(int, 1,1) AS 'Posicao',  
         a.cd_fornecedor,
         a.qtd,  
         a.venda,   
         a.TotalLiquido,  
         a.TotalLista,  
         a.CustoContabil,  
         a.MargemContribuicao,  
         a.BNS,  
        (a.venda/@vl_total)*100 as 'Perc',  
         a.UltimaVenda, a.pedidos,  
        (case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0  
         else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end ) as 'Desc'  
  into #VendaFornecedor
  from #VendaProdutoFornecedor a  
  order by a.venda desc  
    
  --Mostra tabela ao usuário  

  select   
         f.nm_fantasia_fornecedor,
         a.*  
  from 
    #VendaFornecedor a 
    left outer join fornecedor f on f.cd_fornecedor = a.cd_fornecedor
  order by 
    posicao  

end

------------------------------------------------------------------------------
--Produtos do Fornecedor
------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  -- Geração da tabela auxiliar de Vendas por Produto  

  Select   
    f.cd_fornecedor,
    case IsNull(a.cd_produto,0)
      when 0 then
        a.nm_categoria_produto
      else
        a.nm_fantasia_produto  
    end                                                                  as nm_fantasia_produto, 
    a.cd_produto                                                         as 'Produto',   
    sum(a.qt_item_pedido_venda*(a.vl_unitario_item_pedido / @vl_moeda))  as 'Venda',  
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*  
                                         (a.vl_unitario_item_pedido / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',  
    cast(sum((a.qt_item_pedido_venda *  
             (a.vl_lista_item_pedido / @vl_moeda)  
            )  
        ) as decimal(25,2)) as 'TotalLiSta',  
    cast(sum((a.qt_item_pedido_venda* case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',  
  
    cast(sum((a.qt_item_pedido_venda * (case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)  
       / case when (dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda * (a.vl_unitario_item_pedido / @vl_moeda)), a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, '2006-02-01') ) = 0 then 1 else
  						 (dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda * (a.vl_unitario_item_pedido / @vl_moeda)), a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, '2006-02-01') ) end
		 ) * 100) as decimal(25,2)) as 'MargemContribuicao',  
    cast(sum((a.qt_item_pedido_venda* case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',  
    sum(a.qt_item_pedido_venda)         as 'Qtd',  
    max(a.dt_pedido_venda)              as 'UltimaVenda',   
    count(distinct a.cd_pedido_venda)   as 'pedidos'  
  into #VendaCategAux  
  from  
     vw_venda_bi a
     inner join pedido_compra_item pci on pci.cd_produto      = a.cd_produto
     inner join pedido_compra      pc  on pc.cd_pedido_compra = pci.cd_pedido_compra
     inner join fornecedor_produto fp  on fp.cd_produto       = a.cd_produto and
                                          fp.cd_fornecedor    = pc.cd_fornecedor 
     inner join fornecedor         f   on f.cd_fornecedor     = pc.cd_fornecedor 

--select * from fornecedor_produto

  where  
    (a.dt_pedido_venda between @dt_inicial and @dt_final )    and  
     a.cd_produto is not null 
  group by    
    f.cd_fornecedor,
    a.cd_produto, 
    (case IsNull(a.cd_produto,0)
      when 0 then
        a.nm_categoria_produto
      else
        a.nm_fantasia_produto  
    end)
  order by 1 desc  
    
  declare @qt_total_categ int  
  declare @vl_total_categ float  
    
  -- Total de Produtos  
  set @qt_total_categ = @@rowcount  
    
  -- Total de Vendas Geral por Produto  
  set @vl_total_categ     = 0  
  select @vl_total_categ = @vl_total_categ + venda  
  from  
    #VendaCategAux  
    
  select IDENTITY(int, 1,1) AS 'Posicao',  
         a.cd_fornecedor,
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
  into #VendaCateg  
  from #VendaCategAux a  
  order by a.venda desc  
    
  --Mostra tabela ao usuário  
  select   
         f.nm_fantasia_fornecedor,
         dbo.fn_mascara_produto(b.cd_produto) as cd_mascara_produto,  
         b.nm_produto,  
         un.sg_unidade_medida,  
         a.*  
  from #VendaCateg a 
        left outer join Produto b on   a.produto = b.cd_produto 
        left outer join Unidade_medida un on un.cd_unidade_medida = b.cd_unidade_medida  
        left outer join fornecedor f on f.cd_fornecedor = a.cd_fornecedor
  order by posicao  


end


