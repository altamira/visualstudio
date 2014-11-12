
-------------------------------------------------------------------------------
--sp_helptext pr_pedido_venda_motivo_reprogramacao
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Pedidos por Motivo de Reprogramação
--Data             : 15.12.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_pedido_venda_motivo_reprogramacao
@ic_parametro             int      = 0,
@dt_inicial               datetime ='',
@dt_final                 datetime ='',
@cd_motivo_reprogramacao  int      = 0

as

--select * from motivo_reprogramacao
--select * from pedido_venda_item

if @ic_parametro = 1  --Resumo
begin
  select 
    mr.cd_motivo_reprogramacao,
    mr.nm_motivo_reprogramacao,
    count(pvi.cd_motivo_reprogramacao)                           as 'Qtd_Reprog',
    sum( pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) as 'Valor_Total'
  into
    #AuxMotivoReprogramacao   
  from
    motivo_reprogramacao mr
    left outer join pedido_venda_item pvi on pvi.cd_motivo_reprogramacao = mr.cd_motivo_reprogramacao
    left outer join pedido_venda      pv  on pv.cd_pedido_venda          = pvi.cd_pedido_venda
  where
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
    pvi.dt_cancelamento_item is null
  group by
    mr.cd_motivo_reprogramacao,
    mr.nm_motivo_reprogramacao
  
  declare @qt_total float
  set @qt_total = 0.00

  select
    @qt_total = sum(qtd_reprog)
  from
   #AuxMotivoReprogramacao

  select
    identity(int,1,1) as Posicao,
    *,
    perc = (qtd_reprog/@qt_total)*100 
  into
    #MotivoReprogramacao
  from 
    #AuxMotivoReprogramacao
  order by
    qtd_reprog desc

  select
    *
  from 
    #MotivoReprogramacao
  order by
    Posicao


end


if @ic_parametro = 2 and @cd_motivo_reprogramacao>0
begin

--select * from pedido_venda_item

  select 
    mr.cd_motivo_reprogramacao,
    mr.nm_motivo_reprogramacao,
    pv.cd_pedido_venda,
    pv.dt_pedido_venda,
    pvi.cd_item_pedido_venda,
    pvi.qt_item_pedido_venda,
    pvi.vl_unitario_item_pedido,
    pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido  as 'Valor_Total',
    c.nm_fantasia_cliente,
    v.nm_fantasia_vendedor,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.sg_unidade_medida,
    pvi.dt_entrega_vendas_pedido  as 'Comercial',
    pvi.dt_entrega_fabrica_pedido as 'Fábrica',
    pvi.dt_reprog_item_pedido     as 'Reprogramação',
    Dias = ( cast( getdate()-pvi.dt_reprog_item_pedido as int ) ),
    pvi.nm_observacao_fabrica1,
    pvi.nm_observacao_fabrica2
  from
    motivo_reprogramacao mr
    left outer join pedido_venda_item pvi on pvi.cd_motivo_reprogramacao = mr.cd_motivo_reprogramacao
    left outer join pedido_venda      pv  on pv.cd_pedido_venda          = pvi.cd_pedido_venda
    left outer join cliente c             on c.cd_cliente                = pv.cd_cliente
    left outer join vendedor v            on v.cd_vendedor               = pv.cd_vendedor
    left outer join produto p             on p.cd_produto                = pvi.cd_produto
    left outer join unidade_medida um     on um.cd_unidade_medida        = p.cd_unidade_medida
  where
    pvi.cd_motivo_reprogramacao = @cd_motivo_reprogramacao and
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
    pvi.dt_cancelamento_item is null
  order by
    pv.dt_pedido_venda  desc

end

