
-------------------------------------------------------------------------------
--pr_ranking_cliente_anual_faturamento_quantidade
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Ranking de Faturamento de Quantidade por Cliente 
--Data             : 02.05.2006
--Alteração        : 21.11.2007
--01.02.2008 - Ajustes Diversos - Carlos Fernandes
--14.02.2008 - Acerto da Quantidade Multiplica pelo Fator de Embalagem - Carlos Fernandes
------------------------------------------------------------------------------------------
create procedure pr_ranking_cliente_anual_faturamento_quantidade
@cd_ano          int      = 0,
@cd_tipo_mercado int      = 0,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_cliente      int      = 0

as

declare @ic_fator_conversao char(1)

select
  @ic_fator_conversao = isnull(ic_conversao_qtd_fator,0)
from
  Parametro_BI
where
  cd_empresa = dbo.fn_empresa()


--select * from vw_faturamento_bi

Select 
      vw.nm_fantasia_destinatario                as 'Cliente',

      dbo.fn_mascara_produto(p.cd_produto)  as cd_mascara_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,


      --Total do Ano
     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) ) as 'Total_ano',

     --Valores de Venda Mensais

      sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Janeiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Fevereiro',
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Marco',
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Abril',
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Maio',
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Junho',
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Julho',
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Agosto',
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Setembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Outubro',
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Novembro',
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Dezembro',

      --Média

     (sum(isnull(case when month(vw.dt_nota_saida) = 1  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 2  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 3  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 4  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 5  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 6  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 7  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 8  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 9  then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 10 then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 11 then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(vw.dt_nota_saida) = 12 then vw.qt_item_nota_saida  * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0))) / 12 as 'Media'

into
  #FaturamentoReal
from
  vw_faturamento_bi vw                  with (nolock) 
  left outer join Produto p             with (nolock) on p.cd_produto         = vw.cd_produto
  left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida

where
--  vw.cd_cliente = case when @cd_cliente = 0 then vw.cd_cliente else @cd_cliente end and
  year(vw.dt_nota_saida) = @cd_ano and
  vw.cd_cliente          = case when @cd_cliente = 0                then vw.cd_cliente      else @cd_cliente      end and
  vw.cd_tipo_mercado     = case when isnull(@cd_tipo_mercado,0) = 0 then vw.cd_tipo_mercado else @cd_tipo_mercado end  
  
Group By 
   vw.nm_fantasia_destinatario,
   p.cd_produto,
   p.nm_fantasia_produto,
   p.nm_produto,
   um.sg_unidade_medida
    

declare  @vl_total float

set @vl_total = 0

select
  @vl_total = @vl_total + isnull(total_ano,0)
from
  #FaturamentoReal
  

--select @vl_total

select 
  IDENTITY(int, 1,1)                   AS 'Posicao',
  *,
  Perc = cast(( total_ano / @vl_total ) * 100 as float )
into
  #Faturamento
from 
  #FaturamentoReal
order by
  total_ano desc
  
select * from #Faturamento

