
Create procedure pr_ranking_familia_produto
-----------------------------------------------------------------------------------  
--GBS - Global Business Sollution S/A                                          2003  
-----------------------------------------------------------------------------------  
--Stored Procedure : SQL Server Microsoft 7.0    
-----------------------------------------------------------------------------------  
--Autor      : Daniel C. Neto.  
--Objetivo   : Vendas por Produto  
--Data       : 17/11/2003  
--             27/11/2003 - Daniel C. Neto  
--             13/01/2004 - Inclusão da coluna desconto - Daniel C. Neto.  
--             30/03/2004 - Acerto para bater com a consulta de pedido no SPE - Daniel C. Neto  
--             04.05.2004 - Alteração do cálculo Margem de Contribuição. Igor Gama.  
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar  
--            - Daniel C. Neto.  
-- 02.09.2005 - Margem de Contribuição - Carlos Fernandes.  
-- 03.03.2006 - Mudança para apresentar no nome da categoria para os casos de produto especial.  
-- 15.11.2006 - Acertos na Descrição / Serviço - Carlos Fernandes        
-- 22.02.2007 - Inclusão do valor total sem IPI - Carlos Fernandes
-- 27.12.2007 - Valor em Outra Moeda - Carlos Fernandes
-- 10.01.2008 - Valor dos Impostos - ICMS/PIS/COFINS - Carlos Fernandes
-- 14.04.2009 - Checar o Parâmetro do BI para buscar a Origem do Custo - Carlos Fernandes
-- 10.06.2010 - Família de Produto - Carlos Fernandes
------------------------------------------------------------------------------------------  
@dt_inicial      datetime = '',  
@dt_final        datetime = '',  
@cd_moeda        int = 1,
@cd_tipo_mercado int = 0   
as  
  
  declare @vl_moeda float  
  
  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0
                         then 1  
                         else dbo.fn_vl_moeda(@cd_moeda) 
                    end )  
  
  -- Parâmetro do BI



  -- Geração da tabela auxiliar de Vendas por Produto  

  Select   
    a.nm_familia_produto                  as nm_familia_produto,

    sum(a.qt_item_pedido_venda*(a.vl_unitario_item_pedido / @vl_moeda))           as 'Venda',  
    sum(a.qt_item_pedido_venda*(a.vl_unitario_item_pedido / @vl_moeda)-a.vl_ipi)  as 'VendaSemIPI',
    cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*  
                                         (a.vl_unitario_item_pedido / @vl_moeda))  
                                    , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',  

    cast(sum((a.qt_item_pedido_venda *  
             (a.vl_lista_item_pedido / @vl_moeda)  
            )  
        ) as decimal(25,2)) as 'TotalLiSta',  

    cast(sum((a.qt_item_pedido_venda* case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',  
  
    cast(sum((a.qt_item_pedido_venda * (case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)  
       / case when (dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda * (a.vl_unitario_item_pedido / @vl_moeda)), a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial) ) = 0 then 1 else
  						 (dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda * (a.vl_unitario_item_pedido / @vl_moeda)), a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial) ) end
		 ) * 100) as decimal(25,2))    as 'MargemContribuicao',  
    cast(sum((a.qt_item_pedido_venda* case when isnull(a.custocomposicao,0)>0 then a.custocomposicao else a.custoproduto end / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',  
    sum(a.qt_item_pedido_venda)                as 'Qtd',  
    max(a.dt_pedido_venda)                     as 'UltimaVenda',   
    count(distinct a.cd_pedido_venda)          as 'pedidos',
    sum( isnull(a.vl_pis_item_pedido,0))       as vl_pis,
    sum( isnull(a.vl_cofins_item_pedido,0))    as vl_cofins,
    sum( isnull(a.vl_icms_item_pedido,0))      as vl_icms,  
    sum( isnull(a.vl_ipi_item_pedido,0))       as vl_ipi

  into #VendaCategAux  
  from  
     vw_venda_bi a   
  where  
    (a.dt_pedido_venda between @dt_inicial and @dt_final )    and  
	  a.cd_produto is not null and
  	  a.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then a.cd_tipo_mercado else @cd_tipo_mercado end    
  --  IsNull(a.dt_cancelamento_item,@dt_final + 1) > @dt_final  and --Desconsidera itens cancelados depois da data final  
  --  IsNull(a.dt_cancelamento_pedido,@dt_final+1) > @dt_final and --Desconsider pedidos de venda cancelados  
  --  isNull(b.ic_smo_item_pedido_venda, 'N') = 'N'             and  
  group by    
--    a.cd_produto, a.nm_fantasia_produto  
--     a.cd_produto, 
--     (case IsNull(a.cd_produto,0)
--       when 0 then
--         a.nm_categoria_produto
--       else
--         a.nm_fantasia_produto  
--     end),
-- 	 a.cd_categoria_produto  
      a.nm_familia_produto

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
         a.nm_familia_produto,
         a.qtd,  
         a.venda,   
         a.VendasemIPI,
         a.TotalLiquido,  
         a.TotalLista,  
         a.CustoContabil,  
         a.MargemContribuicao,  
         a.BNS,  
        (a.venda/@vl_total_categ)*100 as 'Perc',  
         a.UltimaVenda, a.pedidos,  
        (case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0  
         else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end ) as 'Desc',
         a.vl_pis,
         a.vl_cofins,
         a.vl_ipi,
         a.vl_icms
  into #VendaCateg  
  from #VendaCategAux a  
  order by a.venda desc  
    
  --Mostra tabela ao usuário  
  select   
         a.*
  from #VendaCateg a 
  order by posicao  

