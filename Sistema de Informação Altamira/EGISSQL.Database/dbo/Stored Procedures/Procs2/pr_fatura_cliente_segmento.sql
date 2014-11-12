
CREATE PROCEDURE pr_fatura_cliente_segmento

------------------------------------------------------------------------------------------------------
--pr_fatura_cliente_segmento
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Márcio Rodrigues
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Fatura no Período por Segmento de Mercado
--Data          : 07/03/2007
--Atualizado    : 01.02.2010 - Ajustes nos Valores com o Ranking de Faturamento por Cliente - Carlos Fernandes

------------------------------------------------------------------------------------------------------

@cd_ramo_atividade int = 0,
@dt_inicial        datetime,
@dt_final          datetime,
@cd_moeda          int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Segmento

select 
        cli.cd_cliente                 as 'cliente', 
--        sum(b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda)    as 'Venda'
    sum(case when isnull(b.cd_item_nota_saida,0)>0 then
      cast((case when IsNull(b.cd_servico,0)=0 and isnull(b.vl_servico,0)=0
      then
        cast(round((isnull(b.vl_unitario_item_nota,0) * ( 1 - IsNull(b.pc_desconto_item,0) / 100) * 
    		(IsNull(b.qt_item_nota_saida,0))),2)
        --Adiciona o IPI
    		+ isnull(b.vl_ipi,0) as money) 
      else
        round(IsNull(b.qt_item_nota_saida,0) * isnull(b.vl_servico,0),2) + 
        (case IsNull(b.ic_iss_servico, 'N') 
          when 'S' then
            isnull(a.vl_iss,0)
          else
            0.00
          end)
       end) +  --Rateio das despesas - Frete/Seguro/Outras
       IsNull(b.vl_frete_item,0.00) + 
       IsNull(b.vl_seguro_item,0.00) + 
       IsNull(b.vl_desp_acess_item,0.00) as money)
    else
       isnull(a.vl_total,0)
    end)                                           as 'Venda'


into #FaturaGrupoAux
from
   Nota_Saida a                   with (nolock)  
   inner join Nota_Saida_Item b   with (nolock) on a.cd_nota_saida = b.cd_nota_saida   
   inner join Cliente cli         with (nolock) on cli.cd_cliente  = a.cd_cliente  
   left outer join Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal = b.cd_operacao_fiscal
   left outer join Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
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
    and ( opf.ic_comercial_operacao = 'S' )           --Considerar apenas as operações fiscais de valor comercial
    and ( opf.ic_analise_op_fiscal  = 'S' )           --Verifica apenas as operações fiscais selecionadas para o BI
    and ( gof.cd_tipo_operacao_fiscal = 2 )           --Desconsiderar notas de entrada

Group by cli.cd_cliente
order  by 1 desc

---------------------------------
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
       b.nm_fantasia_cliente,
--       a.qtd,
       a.venda, 
      cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc'



Into #FaturaGrupo
from #FaturaGrupoAux a , Cliente b

Where
     a.cliente = b.cd_cliente

order by a.Venda desc

select * from #FaturaGrupo order by Posicao

