
CREATE PROCEDURE pr_venda_anual_mes
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2002
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000
--Carlos Cardoso Fernandes / Lucio        
--Vendas Anuais (Mes a Mes)
--Data          : 10.06.2000
--Atualizado    : 11.07.2000
--              : 26.10.2000 - Lucio : Incluida a linha "set nocount on" 
--              : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)]
--              : 06.04.2002 - Migração p/ Banco EGISSQL
--              : 01.08.2002 - Duela
-- 03/11/2003 - Incluído filtro de Moeda. - Daniel C. Neto.
--              : 23.04.2004 - Inclusão de Campo Total Líquido - Igor Gama
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 15.11.2006 - Verificação da Coluna de Meta e (%) - Carlos Fernandes
-- 02.11.2007 - Saldo em Carteira - Carlos Fernandes
--------------------------------------------------------------------------------------

@cd_ano   int = 0,
@cd_moeda int = 1

as

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )
  
  ----------------------------------------------------
  -- Linha abaixo incluída para rodar no ASP
  ----------------------------------------------------
  set nocount on

  select 
    month(dt_pedido_venda)        as 'NumeroMes',
    max(dt_pedido_venda)          as 'Data',   
    sum((qt_item_pedido_venda * vl_unitario_item_pedido) / @vl_moeda)  as 'Vendas',
    sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido * qt_item_pedido_venda) / @vl_moeda, 
                                 pc_icms, pc_ipi, cd_destinacao_produto,
             cast(str(month(dt_pedido_venda)) + '-01-' + str(IsNull(@cd_ano, year(getdate()))) as dateTime))) as 'TotalLiquido',
    count(distinct(cd_pedido_venda))        as 'Pedidos',
    sum (case when isnull(qt_saldo_pedido_venda,0)>0 then
          qt_saldo_pedido_venda * vl_unitario_item_pedido / @vl_moeda
          --qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda
         else 0 end )                                                 as 'TotalCarteira'


  into 
    #VendaAnualMes
  from
  	vw_venda_bi with (nolock)
  where
    year(dt_pedido_venda) = @cd_ano
  group by 
    month(dt_pedido_venda)

  declare   @vl_total_vendas float
  set       @vl_total_vendas = 0
  
  select
    @vl_total_vendas = @vl_total_vendas + vendas
  From
    #VendaAnualMes
  
  ----------------------------------------------------
  --Meta do Mês Busca no Cadastro de Categoria
  ----------------------------------------------------
  select 
    month(a.dt_inicial_meta_categoria)      as 'NumeroMes',
    sum(isnull(a.vl_ven_meta_categoria,0))  as 'MetaMes' 
  into 
  	#MetaAnualMesCategoria
  from
    Meta_Categoria_Produto a
  WHERE
    year(a.dt_inicial_meta_categoria) = @cd_ano  
  Group by 
  	month(a.dt_inicial_meta_categoria)

  --select * from meta_venda

  select
    month(a.dt_inicial_meta_venda)     as 'NumeroMes',
    sum(isnull(vl_venda_mes_meta,0))   as 'MetaMes'
  into
    #MetaAnualMes
  from
    Meta_Venda a
  where
    year(dt_final_meta_venda) = @cd_ano
  group by
    month(a.dt_inicial_meta_venda)

  ----------------------------------------------------
  -- Mostra a Tabela com dados do Mês
  ----------------------------------------------------
  select 
    a.numeromes,
    DateName(month,a.Data)                     as 'Mes',
    a.vendas,
    a.TotalLiquido,
    (a.vendas/@vl_total_vendas)*100            as 'perc',
    pedidos,
    b.MetaMes, 
   (a.vendas/b.MetaMes)*100                    as 'Ating',
   a.TotalCarteira
  from
    #VendaAnualMes a 
    left outer join #MetaAnualMes b	      on a.numeromes = b.numeroMes
--    left outer join #MetaAnualMesCategoria c  on a.numeromes = c.numeroMes
  order by 1 desc


