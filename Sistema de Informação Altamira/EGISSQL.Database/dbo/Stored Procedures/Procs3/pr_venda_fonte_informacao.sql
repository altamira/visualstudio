
CREATE PROCEDURE pr_venda_fonte_informacao

------------------------------------------------------------------------------------------------------
--pr_venda_fonte_informacao
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Fonte de Informação.
--Data          : 05/09/2002
--Atualizado    : 05/11/2003 - Incluído consulta por moeda.
--                20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar - Daniel C. Neto.
--                02.05.2006 - Acertos diversos - Carlos Fernandes 
---------------------------------------------------------------------------------------------------------------------------

@cd_fonte_informacao int = 0,
@dt_inicial          datetime,
@dt_final            datetime,
@cd_moeda            int = 1,
@ic_parametro        int = 0
as

--vendas

if @ic_parametro = 1
begin

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geração da tabela auxiliar de Vendas por Segmento

select 
        cli.cd_fonte_informacao                 as 'fonte', 
        sum(b.qt_item_pedido_venda)             as 'Qtd',
        sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda)    as 'Venda'

into #VendaGrupoAux
from
   Pedido_Venda a 
   inner join Pedido_Venda_Item b on a.cd_pedido_venda = b.cd_pedido_venda 
   inner join Cliente cli         on cli.cd_cliente = a.cd_cliente
where
   (cli.cd_fonte_informacao = case when @cd_fonte_informacao = 0 then cli.cd_fonte_informacao else @cd_fonte_informacao end ) and
   (a.dt_pedido_venda between @dt_inicial and @dt_final )           and
   ((a.dt_cancelamento_pedido is null ) or (a.dt_cancelamento_pedido > @dt_final)) and
    isnull(a.vl_total_pedido_venda,0) > 0                                      and
    isnull(a.ic_consignacao_pedido,'N') = 'N'                                  and
   (b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda) > 0         and
   ((b.dt_cancelamento_item is null ) or (b.dt_cancelamento_item > @dt_final)) and
    isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                               

Group by cli.cd_fonte_informacao
order  by 1 desc

--select * from #VendaGrupoAux

-------------------------------------------------
-- calculando Quantos Clientes no Período.
-------------------------------------------------
select distinct a.cd_cliente
into #QtdCliente
from
   Pedido_Venda a 
   inner join Pedido_Venda_Item b on a.cd_pedido_venda = b.cd_pedido_venda 
where
   (a.dt_pedido_venda between @dt_inicial and @dt_final )           and
   ((a.dt_cancelamento_pedido is null ) or 
   (a.dt_cancelamento_pedido > @dt_final))                          and
    a.vl_total_pedido_venda > 0                                     and
    isnull(a.ic_consignacao_pedido,'N') = 'N'                       and
   (b.qt_item_pedido_venda * b.vl_unitario_item_pedido/ @vl_moeda) > 0         and
   ((b.dt_cancelamento_item is null ) or 
   (b.dt_cancelamento_item > @dt_final))                          and
    isnull(b.ic_smo_item_pedido_venda,'N') = 'N'                                

select 
  b.cd_fonte_informacao, 
  count(*) as Clientes
into #ClienteInformacao
from
  #QtdCliente a, Cliente b

where 
  a.cd_cliente = b.cd_cliente

group by b.cd_fonte_informacao

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
       b.cd_fonte_informacao,
       b.nm_fonte_informacao,
       a.qtd,
       a.venda, 
      cast((a.venda/@vl_total_grupo)*100 as Decimal(25,2)) as 'Perc',
       c.Clientes


Into #VendaGrupo
from #VendaGrupoAux a , Fonte_Informacao b, #ClienteInformacao c

Where
     a.fonte = b.cd_fonte_informacao and
     a.fonte = c.cd_fonte_informacao

order by a.Venda desc

select * from #VendaGrupo  
order by Posicao

end

if @ic_parametro = 2
begin
  exec pr_fatura_fonte_informacao @cd_fonte_informacao,@dt_inicial,@dt_final
end

