
CREATE PROCEDURE pr_venda_cli_regiao

--pr_venda_cli_regiao
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período de Cliente
-- filtrado por região
--Data          : 05/01/2004
---------------------------------------------------

@cd_regiao    int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1

as
-- Geração da tabela auxiliar de Vendas por Segmento
create table
  #VendaGrupoAux
( Nome varchar(50),
  Qtd Float,
  Venda Float,
  Pedidos Int )

  insert into #VendaGrupoAux
  select 
        bi.nm_fantasia_cliente              , 
        sum(bi.qt_item_pedido_venda)        ,
        sum(bi.qt_item_pedido_venda * bi.vl_unitario_item_pedido*dbo.fn_vl_moeda(@cd_moeda)),
        count(distinct(bi.cd_pedido_venda))
  from
     vw_venda_bi bi inner join
     Vendedor_Regiao vr on vr.cd_vendedor = bi.cd_vendedor
  where
    (bi.dt_pedido_venda between @dt_inicial and @dt_final )     and
    bi.cd_regiao_venda = @cd_regiao
  group by nm_fantasia_cliente
  order  by 1 desc




----------------------------------
-- Fim da seleção de vendas totais
----------------------------------

declare @qt_total_grupo int
declare @vl_total_grupo float

-- Total de Grupos
set @qt_total_grupo = @@rowcount

-- Total de Vendas Geral por Grupo
set    @vl_total_grupo     = 0
select @vl_total_grupo = @vl_total_grupo + venda
from
  #VendaGrupoAux

--select * from #VendaGrupoAux
--select * from #ClienteCategoria

--Cria a Tabela Final de Vendas por Grupo
select IDENTITY(int,1,1) as 'Posicao',
       a.Nome,
       a.qtd,
       a.venda,
       a.Pedidos,
       cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc'
Into #VendaGrupo
from #VendaGrupoAux a
order by a.Venda desc

select * from #VendaGrupo order by Posicao


--exec dbo.pr_venda_cli_regiao  @cd_regiao = 3, @dt_inicial = 'nov  1 2003 12:00:00:000AM', @dt_final = 'nov 30 2003 12:00:00:000AM', @cd_moeda = 1
