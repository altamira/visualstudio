
-------------------------------------------------------------------------------
--sp_helptext pr_ranking_vendedor_anual_vendas_quantidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Ranking de Quantidade de Vendas por Vendedor
--Data             : 02.05.2006
--Alteração        : 21.11.2007
--08.01.2008 - Ajuste Gerais - Carlos Fernadnes
--14.02.2008 - Acerto da Conversão pelo Fator do Produto - Carlos Fernandes
-- 05.06.2009 - Desenvolvimento Geral - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_ranking_vendedor_anual_vendas_quantidade
@cd_ano          int      = 0,
@cd_tipo_mercado int      = 0,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_vendedor     int      = 0

as

declare @ic_fator_conversao char(1)

select
  @ic_fator_conversao = isnull(ic_conversao_qtd_fator,0)
from
  Parametro_BI with (nolock) 
where
  cd_empresa = dbo.fn_empresa()


--select * from vw_venda_bi

Select 

      vw.nm_vendedor_externo                as 'Vendedor',
      dbo.fn_mascara_produto(p.cd_produto)  as cd_mascara_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,

      --Total do Ano

     (sum(isnull(case when month(vw.dt_pedido_venda) = 1  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 2  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 3  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 4  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 5  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 6  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 7  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 8  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 9  then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 10 then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 11 then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 12 then vw.qt_item_pedido_venda  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_pedido_venda) = 1  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Janeiro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 2  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Fevereiro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 3  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Marco',
      sum(isnull(case when month(vw.dt_pedido_venda) = 4  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Abril',
      sum(isnull(case when month(vw.dt_pedido_venda) = 5  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Maio',
      sum(isnull(case when month(vw.dt_pedido_venda) = 6  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Junho',
      sum(isnull(case when month(vw.dt_pedido_venda) = 7  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Julho',
      sum(isnull(case when month(vw.dt_pedido_venda) = 8  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Agosto',
      sum(isnull(case when month(vw.dt_pedido_venda) = 9  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Setembro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 10 then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Outubro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 11 then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Novembro',
      sum(isnull(case when month(vw.dt_pedido_venda) = 12 then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Dezembro',

      --Média

     (sum(isnull(case when month(vw.dt_pedido_venda) = 1  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 2  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 3  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 4  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 5  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 6  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 7  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 8  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 9  then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 10 then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 11 then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_pedido_venda) = 12 then vw.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0))) / 12 as 'Media'

into
  #VendaReal
from
  vw_venda_bi vw                        with (nolock) 
  left outer join Produto p             with (nolock) on p.cd_produto         = vw.cd_produto
  left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida

where 
--  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  year(vw.dt_pedido_venda) = @cd_ano and
  vw.cd_vendedor     = case when @cd_vendedor = 0               then vw.cd_vendedor     else @cd_vendedor      end and
  vw.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
  and vw.nm_fantasia_produto is not null

Group By 
   vw.nm_vendedor_externo,
   p.cd_produto,
   p.nm_fantasia_produto,
   p.nm_produto,
   um.sg_unidade_medida
    

declare  @vl_total float

set @vl_total = 0

select
  @vl_total = @vl_total + isnull(total_ano,0)
from
  #VendaReal
  

--select @vl_total

select 
  IDENTITY(int, 1,1)                   AS 'Posicao',
  *,
  Perc = cast(( total_ano / @vl_total ) * 100 as float )
into
  #Venda
from 
  #VendaReal
order by
  total_ano desc
  
select 
 * 
from 
 #Venda 
where
  Vendedor is not null
order by Vendedor,nm_fantasia_produto


