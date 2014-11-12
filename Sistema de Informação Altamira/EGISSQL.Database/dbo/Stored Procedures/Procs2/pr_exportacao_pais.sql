
-----------------------------------------------------------------------------------
-- GBS - Global Business Solution                                              2000
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000
--Autor            : Alexandre
--Objetivo         : Exportação por País
--Data             : 31-01-06
--Atualizado       : 
-----------------------------------------------------------------------------------


create procedure pr_exportacao_pais
@dt_inicial datetime,
@dt_final datetime,
@cd_moeda int

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                       else dbo.fn_vl_moeda(@cd_moeda) end )

-- Geração da Tabela Auxiliar de Vendas por Cliente
select 
  vw.nm_fantasia_cliente as 'Cliente', 
  vw.cd_cliente,
  pa.nm_pais as 'Pais',
  
  sum(qt_item_pedido_venda * (vl_unitario_item_pedido / @vl_moeda)) as 'Compra', 
  cast(sum(dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda*
                                       (vl_unitario_item_pedido / @vl_moeda))
                                  , pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)) as decimal(25,2)) as 'TotalLiquido',
  cast(sum((qt_item_pedido_venda *
           (vl_lista_item_pedido / @vl_moeda)
          )
      ) as decimal(25,2)) as 'TotalLiSta',
  cast(sum( ( (qt_item_pedido_venda * case when isnull(vw.custocomposicao,0)>0 then vw.custocomposicao else vw.custoproduto end  ) / @vl_moeda) ) as decimal(25,2) ) as 'CustoContabil',

  cast(sum((qt_item_pedido_venda* case when isnull(vw.custocomposicao,0)>0 then vw.custocomposicao else vw.custoproduto end / @vl_moeda))  /
       sum((dbo.fn_vl_liquido_venda('V',(qt_item_pedido_venda *
                                       (vl_unitario_item_pedido / @vl_moeda))
                                  , pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)))	as decimal(25,2)) * 100 as 'MargemContribuicao',
  cast(sum((qt_item_pedido_venda* case when isnull(vw.custocomposicao,0)>0 then vw.custocomposicao else vw.custoproduto end / @vl_moeda)) as decimal(25,2)) * dbo.fn_pc_bns() as 'BNS',

  max(dt_pedido_venda)                                         as 'UltimaCompra', 
  count(distinct cd_pedido_venda)                              as 'pedidos',

  (select max(v.nm_fantasia_vendedor)
   from Cliente c inner join 
        vendedor v on c.cd_vendedor = v.cd_vendedor
   where c.cd_cliente = vw.cd_cliente)                         as 'setor'

--  (select max(v.nm_fantasia_vendedor)
--   from vendedor v
--   where v.cd_vendedor = max(vw.cd_vendedor))                 as 'setor'
into #VendaClienteAux1
from 
  vw_venda_bi vw left outer join Pais pa on pa.cd_pais = vw.cd_Pais
where
 (vw.dt_pedido_venda between @dt_inicial and @dt_final) 
group by 
   vw.nm_fantasia_cliente, vw.cd_cliente,pa.nm_pais
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

-- Cria a Tabela Final de Vendas por Cliente

-- Define a posição de Compra do Cliente - IDENTITY

select IDENTITY(int, 1,1) as 'Posicao',
       cd_cliente,
       Pais, 
       setor, 
       Compra, 
       TotalLiquido,
       TotalLista,
       CustoContabil,
       MargemContribuicao,
       BNS,
       cast(((Compra / @vl_total_cliente ) * 100) as decimal (25,2)) as 'Perc',
       UltimaCompra,
       pedidos,
       cast((( TotalLista / Compra ) * 100) - 100 as decimal (15,2)) as 'Desc'
Into #VendaCliente1
from #VendaClienteAux1
Order by Compra desc

--Mostra tabela ao usuário
select * from #VendaCliente1
order by posicao
