
CREATE PROCEDURE pr_cliente_importacao
@ic_parametro     int, 
@dt_inicial       datetime,
@dt_final         datetime,
@cd_moeda int
as
-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Resumo de Fornecedor Importacao (Filtrado por Período) 
-------------------------------------------------------------------------------
begin

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da Tabela Auxiliar de Vendas por Cliente
select 
  vw.nm_fantasia_cliente                                 as 'Cliente', 
  vw.cd_cliente,
  sum(qt_item_pedido_venda * (vl_unitario_item_pedido / @vl_moeda)) as 'Compra', 
  cast(sum(dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda*
                                       (vl_unitario_item_pedido / @vl_moeda))
                                  , pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
  cast(sum((qt_item_pedido_venda *
           (vl_lista_item_pedido / @vl_moeda)
          )
      ) as decimal(25,2)) as 'TotalLiSta',
  cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) as 'CustoContabil',
  cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda))  /
       sum((dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda *
                                       (vl_unitario_item_pedido / @vl_moeda))
                                  , pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)))	as decimal(25,2)) * 100 as 'MargemContribuicao',
  cast(sum((qt_item_pedido_venda* ps.vl_custo_contabil_produto / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',
  max(dt_pedido_venda)                                as 'UltimaCompra', 
  count(distinct cd_pedido_venda)                              as 'pedidos',
  (select max(v.nm_fantasia_vendedor)
   from Cliente c inner join 
        vendedor v on c.cd_vendedor = v.cd_vendedor
   where c.cd_cliente = vw.cd_cliente)                 as 'setor'
--  (select max(v.nm_fantasia_vendedor)
--   from vendedor v
--   where v.cd_vendedor = max(vw.cd_vendedor))                 as 'setor'
into #VendaClienteAux1
from 
  vw_venda_bi vw left outer join
  Produto_Custo ps on vw.cd_produto = ps.cd_produto
where
 (vw.dt_pedido_venda between @dt_inicial and @dt_final) 
group by 
	nm_fantasia_cliente, vw.cd_cliente
order by 
	Compra desc

declare @qt_total_cliente int
declare @vl_total_cliente float

-- Total de Cliente
set @qt_total_cliente = @@rowcount

-- Total de Vendas Geral
set @vl_total_cliente = 0
select @vl_total_cliente = @vl_total_cliente + compra
from
  #VendaClienteAux1

--Define tabela com Total Geral de Venda Ano
--select @vl_total_cliente as 'TOTALANO' 
--into ##TotalVendaAno

--Cria a Tabela Final de Vendas por Cliente
-- Define a posição de Compra do Cliente - IDENTITY

select IDENTITY(int, 1,1) as 'Posicao',
       cd_cliente,
       Cliente, 
       Compra, 
       TotalLiquido,
       TotalLista,
       CustoContabil,
       MargemContribuicao,
       BNS,
       cast(((Compra / @vl_total_cliente ) * 100) as decimal (25,2)) as 'Perc',
       UltimaCompra,
       setor, 
       pedidos,
       cast((( TotalLista / Compra ) * 100) - 100 as decimal (15,2)) as 'Desc'
Into #VendaCliente1
from #VendaClienteAux1
Order by Compra desc

--Mostra tabela ao usuário
select * from #VendaCliente1
order by posicao
end

-- -------------------------------------------------------------------------------
-- if @ic_parametro = 2    -- Resumo de Plano de Compra (Filtrado por Período) 
-- -------------------------------------------------------------------------------
-- begin  
-- end
-- 
-- -------------------------------------------------------------------------------
-- if @ic_parametro = 3    -- Consulta de Pedido de Compra (Filtrado por Fornecedor e Período)  
-- -------------------------------------------------------------------------------
-- begin
-- -- Geração da Tabela Auxiliar de Vendas por Cliente
-- 
-- end
-- 
-- -------------------------------------------------------------------------------
-- if @ic_parametro = 4    -- Consulta de Nota de Entrada (Filtrado por Fornecedor e Período) 
-- -------------------------------------------------------------------------------
-- begin
-- 
-- end
-- 
-- -------------------------------------------------------------------------------
-- if @ic_parametro = 5    -- Resumo Anual (Filtrado por Fornecedor e Ano) 
-- -------------------------------------------------------------------------------
-- begin
-- --
-- end

