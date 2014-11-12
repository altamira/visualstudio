
CREATE PROCEDURE pr_analise_cliente_sem_compra

-----------------------------------------------------------------------------------------------------
--pr_analise_cliente_sem_compra
-----------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Daniel Carrasco Neto
--Banco de Dados  : EgisSQL
--Objetivo        : Analisa os clientes que não compraram nos últimos
--                  meses a partir de uma data base...
--Data          : 05/09/2002
--Atualizado    : 05/11/2002 - Acerto de joins e where's para funcionamento correto
--              : 24.02.2006 - Acerto Geral da Consulta - Carlos Fernandes
--              : 04.05.2006 - Código do Cliente - carlos Fernandes
--              : 12.05.2006 - Data da Última Compra do Cliente - Carlos Fernandes
-- 09.04.2008 - Segmento de Mercado - Carlos Fernandes
-- 11.02.2009 - Critério de Visita - Carlos Fernandes
-----------------------------------------------------------------------------------------------------
@cd_vendedor int = 0,
@dt_base     datetime

as

  declare @dt_atual datetime

  Select
    @dt_atual = DateAdd(day, 1, @dt_base)

  -- Pegando todos os Clientes com compras por Vendedor, que não compram mais

  Select 
    a.cd_cliente                 as 'cliente',
    max(a.dt_pedido_venda)       as 'UltimaCompra',
    sum(b.qt_item_pedido_venda * b.vl_unitario_item_pedido)    as 'Volume'
  into 
    #Pedido
  from
    Pedido_Venda a                 with (nolock)
    inner join Pedido_Venda_Item b with (nolock) on b.cd_pedido_venda = a.cd_pedido_venda
    inner join Cliente c           with (nolock) on a.cd_cliente = c.cd_cliente
  where
    IsNull(a.dt_cancelamento_pedido, @dt_atual) > @dt_base  and
    isnull(a.ic_consignacao_pedido,'N') = 'N'               and
    IsNull(c.cd_vendedor,0) = ( case @cd_vendedor 
                                  when 0 then 
                                    IsNull(c.cd_vendedor,0)
                                  else 
                                    @cd_vendedor
                                end )                      and
    b.dt_cancelamento_item is null
  group by 
    a.cd_cliente
  having
    max(a.dt_pedido_venda) < @dt_base
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

Select 
  @vl_total_grupo = Sum(Volume)
from
  #Pedido

select 
  c.nm_fantasia_vendedor,
  b.nm_fantasia_cliente,
  '( ' + b.cd_ddd + ') ' + b.cd_telefone as 'Telefone',
  ( select top 1 nm_fantasia_contato from Cliente_Contato where cd_cliente = a.cliente) as 'Contato',       
  a.UltimaCompra,
  a.Volume,
  cast((a.Volume/@vl_total_grupo)*100 as Decimal(25,4)) as 'Perc',
  (Select top 1 nm_status_cliente from Status_cliente d with (nolock) where d.cd_status_cliente = b.cd_status_cliente ) as 'Status',
  (Select top 1 nm_pais           from Pais p           with (nolock) where p.cd_pais = b.cd_pais) as Pais,
  a.cliente          as cd_cliente,
  ra.nm_ramo_atividade,
  cv.nm_criterio_visita,
  cg.nm_cliente_grupo
from 
    #Pedido a
    inner join Cliente b               with (nolock) on b.cd_cliente          = a.cliente
    left outer join Vendedor c         with (nolock) on c.cd_vendedor         = b.cd_vendedor
    left outer join Ramo_Atividade ra  with (nolock) on ra.cd_ramo_atividade  = b.cd_ramo_atividade 
    left outer join Criterio_Visita cv with (nolock) on cv.cd_criterio_visita = b.cd_criterio_visita
    left outer join Cliente_Grupo   cg with (nolock) on cg.cd_cliente_grupo   = b.cd_cliente_grupo
order by 
  a.Volume 
desc

