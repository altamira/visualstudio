
-----------------------------------------------------------------------------------
--GBS - Global Business Sollution S/A                                          2004
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto.
--Vendas por Serviço
--Data       : 19/03/2004
-----------------------------------------------------------------------------------
Create procedure pr_ranking_servico
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Serviço
select 
  a.cd_servico          as 'servico', 
  cast(sum(a.qt_item_pedido_venda*(a.vl_unitario_item_pedido / @vl_moeda)) as decimal(25,2)) as 'Venda', 

  cast(sum(dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*
                                       (a.vl_unitario_item_pedido / @vl_moeda))
                                  , a.pc_icms, a.pc_ipi, a.cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
  cast(sum((a.qt_item_pedido_venda *
           (a.vl_lista_item_pedido / @vl_moeda)
          )
      ) as decimal(25,2)) as 'TotalLiSta',
--  cast(sum((a.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',
--  cast(sum((a.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /
--       sum((dbo.fn_vl_liquido_venda('V',(a.qt_item_pedido_venda*
--                                       (a.vl_unitario_item_pedido / @vl_moeda))
--                                  , a.pc_icms)))
--	as decimal(25,2)) * 100 as 'MargemContribuicao',

--  cast(sum((a.qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',

  sum(a.qt_item_pedido_venda)         as 'Qtd',
  max(a.dt_pedido_venda)    as 'UltimaVenda', 
  count(distinct a.cd_pedido_venda) as 'pedidos'
into #VendaCategAux
from
   vw_venda_bi a --left outer join
--   Produto_Custo ps on ps.cd_produto = a.cd_produto 

where
  (a.dt_pedido_venda between @dt_inicial and @dt_final )    and
  IsNull(a.cd_servico,0) > 0 

group by a.cd_servico
order by 1 desc


declare @qt_total_categ int
declare @vl_total_categ float

-- Total de Serviços
set @qt_total_categ = @@rowcount

-- Total de Vendas Geral por Serviços
set @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #VendaCategAux

print (@vl_total_categ)
--Cria a Tabela Final de Vendas por Setor
--select * from #VendaCategAux order by venda desc

select IDENTITY(int, 1,1) AS 'Posicao',
       a.servico,
       a.qtd,
       a.venda, 
       a.TotalLiquido,
       a.TotalLista,
--       a.CustoContabil,
--       a.MargemContribuicao,
--       a.BNS,
      (a.venda/@vl_total_categ)*100 as 'Perc',
       a.UltimaVenda, a.pedidos,
      (case when (a.TotalLiquido = 0) or (a.TotalLista = 0) then 0
       else (100 - (a.TotalLiquido * 100)/a.TotalLista)  end ) as 'Desc'
into #VendaCateg
from #VendaCategAux a
order by a.venda desc

--Mostra tabela ao usuário
select b.cd_mascara_servico,
       b.nm_servico,
--       b.nm_produto,
--       un.sg_unidade_medida,
       a.*
from #VendaCateg a , Servico b --left outer join
--     Unidade_medida un on un.cd_unidade_medida = b.cd_unidade_medida
where
  a.servico = b.cd_servico
order by servico
