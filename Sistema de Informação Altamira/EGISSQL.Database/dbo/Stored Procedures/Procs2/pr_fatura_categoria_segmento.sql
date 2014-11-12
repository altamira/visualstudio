
CREATE PROCEDURE pr_fatura_categoria_segmento

--pr_fatura_categoria_segmento
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Márcio Rodrigues	
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Fatura no Período por Segmento de Mercado
--		  Filtrado por Categoria de Produto.
--Data          : 03/07/2007
--Atualizado    : 


---------------------------------------------------

@cd_ramo_atividade int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Segmento

select 
        b.cd_categoria_produto                 as 'categoria', 
        sum(b.qt_item_nota_saida)            as 'Qtd',
        sum(b.qt_item_nota_saida * b.vl_unitario_item_nota/ @vl_moeda)    as 'Venda'

into #FaturaGrupoAux
from
   Nota_Saida a with (nolock)  
   inner join Nota_Saida_Item b with (nolock) on a.cd_nota_saida = b.cd_nota_saida   
   inner join Cliente cli         with (nolock) on cli.cd_cliente    = a.cd_cliente  
where
   (a.dt_nota_saida between @dt_inicial and @dt_final )           and
   ((a.dt_cancel_nota_saida is null ) or 
   (a.dt_cancel_nota_saida > @dt_final))                          and
    a.vl_total > 0                                     and
   (b.qt_item_nota_saida * b.vl_unitario_item_nota/ @vl_moeda) > 0         and
   ((b.dt_cancel_item_nota_saida is null ) or 
   (b.dt_cancel_item_nota_saida > @dt_final))                          and
    ((cli.cd_ramo_atividade  = @cd_ramo_atividade) or
     (@cd_ramo_atividade = 0))

Group by b.cd_categoria_produto
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
  #FaturaGrupoAux

--Cria a Tabela Final de Vendas por Grupo


select IDENTITY(int,1,1) as 'Posicao',
       b.nm_categoria_produto,
       a.qtd,
       a.venda, 
      cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc'

Into #FaturaGrupo
from #FaturaGrupoAux a , Categoria_Produto b

Where
     a.categoria = b.cd_categoria_produto

order by a.Venda desc

select * from #FaturaGrupo order by Posicao

