
CREATE PROCEDURE pr_fatura_cliente_fonte_inf

------------------------------------------------------------------------------------------------------
--pr_fatura_cliente_fonte_inf
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Carlos Cardoso Ferandes
--Banco de Dados  : EgisSQL
--Objetivo        : Consulta Faturamento no Período por Fonte de Informação
--	
--Data            : 02.05.2006
--Atualizado      : 02.05.2006 - Acertos Diversos - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@cd_fonte_informacao int = 0,
@dt_inicial          datetime,
@dt_final            datetime,
@cd_moeda            int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Fonte de Informação

select 
        c.cd_cliente                                                       as 'cliente', 
        sum(b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda)    as 'Venda'

into #VendaGrupoAux
from
     Nota_Saida a 
     inner join Nota_Saida_Item b on a.cd_nota_saida = b.cd_nota_saida
     inner join cliente c         on c.cd_cliente    = a.cd_cliente
  Where
    (c.cd_fonte_informacao = case when @cd_fonte_informacao = 0 then c.cd_fonte_informacao else @cd_fonte_informacao end ) and
    (a.dt_nota_saida between @dt_inicial and @dt_final ) and
     a.dt_cancel_nota_saida is null    and  
     isnull(a.vl_total,0) > 0          and
     a.cd_status_nota <> 7             and
     a.cd_nota_saida = b.cd_nota_saida and     
    (b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda) > 0 and
     b.dt_cancel_item_nota_saida is null   

Group by c.cd_cliente
order  by 1 desc

-------------------------------------------------
-- calculando Potencial - A Definir.
-------------------------------------------------


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

--Cria a Tabela Final de Vendas por Grupo


select IDENTITY(int,1,1) as 'Posicao',
       b.nm_fantasia_cliente,
       b.dt_cadastro_cliente,
       ( select top 1 nm_fantasia_vendedor 
         from Vendedor x where x.cd_vendedor = b.cd_vendedor) as 'Fant_V_E',
       ( select top 1 nm_fantasia_vendedor 
         from Vendedor x where x.cd_vendedor = b.cd_vendedor_interno) as 'Fant_V_I',
       a.venda, 
      cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc'



Into #VendaGrupo
from #VendaGrupoAux a , Cliente b

Where
     a.cliente = b.cd_cliente

order by a.Venda desc

select * from #VendaGrupo order by Posicao

