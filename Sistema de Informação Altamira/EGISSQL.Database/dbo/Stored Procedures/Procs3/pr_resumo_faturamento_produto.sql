
-------------------------------------------------------------------------------
--pr_resumo_faturamento_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Resumo do Faturamento por Produto, Cliente, Vendedor
--Data             : 12.10.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_resumo_faturamento_produto
@ic_parametro int = 0,
@dt_inicial   datetime,
@dt_final     datetime,
@cd_produto   int = 0,
@cd_vendedor  int = 0,
@cd_cliente   int = 0,
@cd_moeda     int = 1

--Definição dos Parâmetros----------------------------------------------------

--1 = Produto / Cliente
--2 = Produto / Vendedor
--3 = Cliente / Produto
--4 = Vendedor / Produto


as

--select * from nota_saida_item

--select * from vw_faturamento_bi order by dt_nota_saida desc
--select * from vw_faturamento_devolucao_bi
--select * from vw_faturamento_devolucao_mes_anterior_bi
--select * from vw_faturamento_cancelado_bi vw
--select * from status_nota


--Moeda

declare @vl_moeda float
 
set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0
                       then 1
                       else dbo.fn_vl_moeda(@cd_moeda) 
                  end )

--Ano
declare @cd_ano int

set @cd_ano = year(@dt_final)

if @cd_ano = 0
   set @cd_ano = year(getdate())

declare @vl_total_periodo decimal(25,2)
declare @vl_total_ano     decimal(25,2)

set @vl_total_periodo = 0
set @vl_total_ano     = 0


--Calculo do total do Período--------------------------------------------------------------------

select
  @vl_total_periodo = sum(qt_item_nota_saida*vl_unitario_item_nota)
from
  vw_faturamento_bi
where
  dt_nota_saida between @dt_inicial and @dt_final
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
  and cd_status_nota in (1,5)

set @vl_total_periodo = @vl_total_periodo / @vl_moeda

--Calculo do total do Ano------------------------------------------------------------------------

select
  @vl_total_ano = sum(qt_item_nota_saida*vl_unitario_item_nota)
from
  vw_faturamento_bi
where
  year(dt_nota_saida) = @cd_ano
  and cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
  and cd_status_nota in (1,5)

set @vl_total_ano = @vl_total_ano / @vl_moeda

--Apresentação dos dados conforme parâmetro------------------------------------------------------


--1 = Produto / Cliente

if @ic_parametro=1
begin

  select
    p.nm_fantasia_produto                               as 'Produto',
    c.nm_fantasia_cliente                               as 'Nome',
    max(p.cd_mascara_produto)                           as Codigo,
    max(p.nm_produto)                                   as Descricao,
    sum(vw.qt_item_nota_saida)     / @vl_moeda          as Quantidade,
    sum(vw.vl_total)               / @vl_moeda          as TotalImpostos,
    sum(vw.qt_item_nota_saida*
        vw.vl_unitario_item_nota)  / @vl_moeda          as TotalSemImpostos
  into
    #Consulta1  
  from
    vw_faturamento_bi vw
    inner join Cliente c           on c.cd_cliente      = vw.cd_cliente
    inner join Produto p           on p.cd_produto      = vw.cd_produto
  where
    vw.cd_produto    = case when @cd_produto = 0 then vw.cd_produto else @cd_produto end and
    vw.dt_nota_saida between @dt_inicial and @dt_final
    and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and vw.cd_status_nota in (1,5)

  group by
    p.nm_fantasia_produto,
    c.nm_fantasia_cliente
  order by
    p.nm_fantasia_produto,
    c.nm_fantasia_cliente

  select
    *,
    MargemPeriodo = (TotalSemImpostos/@vl_total_periodo)*100,
    MargemAno     = (TotalSemImpostos/@vl_total_ano)*100
  from
    #Consulta1

end

--2 = Produto / Vendedor

if @ic_parametro=2
begin

  select
    p.nm_fantasia_produto                               as 'Produto',
    v.nm_fantasia_vendedor                              as 'Nome',
    max(p.cd_mascara_produto)                           as Codigo,
    max(p.nm_produto)                                   as Descricao,
    sum(vw.qt_item_nota_saida)     / @vl_moeda          as Quantidade,
    sum(vw.vl_total)               / @vl_moeda          as TotalImpostos,
    sum(vw.qt_item_nota_saida*
        vw.vl_unitario_item_nota)  / @vl_moeda          as TotalSemImpostos
  into
    #Consulta2
  from
    vw_faturamento_bi vw
    inner join Vendedor v          on v.cd_vendedor      = vw.cd_vendedor
    inner join Produto p           on p.cd_produto      = vw.cd_produto
  where
    vw.cd_produto    = case when @cd_produto = 0 then vw.cd_produto else @cd_produto end and
    vw.dt_nota_saida between @dt_inicial and @dt_final
    and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and vw.cd_status_nota in (1,5)

  group by
    p.nm_fantasia_produto,
    v.nm_fantasia_vendedor

  order by
    p.nm_fantasia_produto,
    v.nm_fantasia_vendedor

  select
    *,
    MargemPeriodo = (TotalSemImpostos/@vl_total_periodo)*100,
    MargemAno     = (TotalSemImpostos/@vl_total_ano)*100
  from
    #Consulta2

end


--3 = Cliente / Produto

if @ic_parametro=3
begin

  select
    c.nm_fantasia_cliente                               as Nome,
    p.nm_fantasia_produto                               as Produto,
    max(p.cd_mascara_produto)                           as Codigo,
    max(p.nm_produto)                                   as Descricao,
    max(um.sg_unidade_medida)                           as Unidade,
    sum(vw.qt_item_nota_saida)     / @vl_moeda          as Quantidade,
    sum(vw.vl_total)               / @vl_moeda          as TotalImpostos,
    sum(vw.qt_item_nota_saida*
        vw.vl_unitario_item_nota)  / @vl_moeda          as TotalSemImpostos
  into
    #Consulta3
  from
    vw_faturamento_bi vw
    inner join Produto p              on p.cd_produto         = vw.cd_produto
    left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
    inner join Cliente c              on c.cd_cliente         = vw.cd_cliente
  where
    vw.cd_cliente    = case when @cd_cliente = 0 then vw.cd_cliente else @cd_cliente end and
    vw.dt_nota_saida between @dt_inicial and @dt_final
    and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and vw.cd_status_nota in (1,5)

  group by
    c.nm_fantasia_cliente,
    p.nm_fantasia_produto

  order by
    c.nm_fantasia_cliente,
    p.nm_fantasia_produto

  select
    *,
    MargemPeriodo = (TotalSemImpostos/@vl_total_periodo)*100,
    MargemAno     = (TotalSemImpostos/@vl_total_ano)*100
  from
    #Consulta3

end

--4 = Vendedor / Produto

if @ic_parametro=4
begin

  select
    v.nm_fantasia_vendedor                              as Nome,
    p.nm_fantasia_produto                               as Produto,
    max(p.cd_mascara_produto)                           as Codigo,
    max(p.nm_produto)                                   as Descricao,
    max(um.sg_unidade_medida)                           as Unidade,
    sum(vw.qt_item_nota_saida)     / @vl_moeda          as Quantidade,
    sum(vw.vl_total)               / @vl_moeda          as TotalImpostos,
    sum(vw.qt_item_nota_saida*
        vw.vl_unitario_item_nota)  / @vl_moeda          as TotalSemImpostos
  into
    #Consulta4
  from
    vw_faturamento_bi vw
    inner join Produto p              on p.cd_produto         = vw.cd_produto
    left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
    inner join Vendedor v             on v.cd_vendedor        = vw.cd_vendedor
  where
    vw.cd_vendedor    = case when @cd_vendedor = 0 then vw.cd_vendedor else @cd_vendedor end and
    vw.dt_nota_saida between @dt_inicial and @dt_final
    and vw.cd_tipo_destinatario = 1 --Trazer apenas as notas destinadas a clientes
    and vw.cd_status_nota in (1,5)

  group by
    v.nm_fantasia_vendedor,
    p.nm_fantasia_produto
  order by
    v.nm_fantasia_vendedor,
    p.nm_fantasia_produto

  select
    *,
    MargemPeriodo = (TotalSemImpostos/@vl_total_periodo)*100,
    MargemAno     = (TotalSemImpostos/@vl_total_ano)*100
  from
    #Consulta4

end

