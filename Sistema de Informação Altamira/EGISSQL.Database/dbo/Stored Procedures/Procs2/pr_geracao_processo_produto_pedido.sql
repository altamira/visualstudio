
-------------------------------------------------------------------------------
--pr_geracao_processo_produto_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta e Geração de Processo de Fabricação de Produto
--                   referente aos Pedidos de Venda em Aberto
--Data             : 07.07.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_processo_produto_pedido
@ic_parametro int = 0,
@cd_produto   int = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

declare @cd_fase_produto int 

--Fase do Produto Padrão

select
  @cd_fase_produto = cd_fase_produto
from
  parametro_comercial
where 
  cd_empresa=dbo.fn_empresa()

select distinct
  0  as ic_selecionado,
  p.cd_mascara_produto,
  pvi.cd_produto,
  pvi.qt_saldo_pedido_venda,
  pvi.qt_item_pedido_venda,
  pv.cd_pedido_venda, 
  pvi.cd_item_pedido_venda,
  pvi.dt_item_pedido_venda, 
  pvi.dt_entrega_vendas_pedido, 
  dias = cast( getdate() - pvi.dt_entrega_vendas_pedido as int ),
  pvi.vl_unitario_item_pedido, 
  pvi.nm_fantasia_produto,
  pvi.nm_produto_pedido, 
  um.sg_unidade_medida,
  cli.nm_fantasia_cliente,
  case when isnull(p.cd_fase_produto_baixa,0)=0 then @cd_fase_produto 
                                                else p.cd_fase_produto_baixa end as 'cd_fase_produto',
  ps.qt_saldo_reserva_produto as 'Saldo',
  ps.qt_minimo_produto        as 'EstoqueMinimo',
  fp.nm_fase_produto          as 'Fase',
  ps.qt_producao_produto      as 'QtdProducao',
  case when pvi.cd_produto>0 then
       case when ps.qt_saldo_reserva_produto<0 or 
                 ps.qt_saldo_reserva_produto<=isnull(ps.qt_minimo_produto,0) 
       then abs(ps.qt_saldo_reserva_produto)+isnull(ps.qt_minimo_produto,0)
       else 0.00 end 
  else pvi.qt_item_pedido_venda end  as 'QtdProduzir'                                         

-- into
--   #AuxProdutoProcesso

FROM
  Pedido_Venda pv with (nolock)
  inner join Pedido_Venda_Item pvi with (nolock)     on pv.cd_pedido_venda = pvi.cd_pedido_venda 
  left outer join Produto p with (nolock)            on p.cd_produto=pvi.cd_produto
  left outer join Cliente cli with (nolock)          on cli.cd_cliente  = pv.cd_cliente  
  left outer join Produto_Saldo ps with (nolock)     on ps.cd_produto      = pvi.cd_produto and
                                                        ps.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                             then @cd_fase_produto 
                                                                             else p.cd_fase_produto_baixa end 
  left outer join Fase_Produto fp with (nolock)      on fp.cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0 
                                                                             then @cd_fase_produto 
                                                                             else p.cd_fase_produto_baixa end 
  left outer join Unidade_Medida um with (nolock)    on um.cd_unidade_medida = p.cd_unidade_medida
where
  isnull(pvi.qt_saldo_pedido_venda,0)>0 and
  pvi.dt_cancelamento_item is null      and
  pvi.cd_produto = case when @cd_produto=0 then pvi.cd_produto else @cd_produto end 
--  and not exists ( select cd_processo from Processo_Producao_Pedido where cd_pedido_venda      = pvi.cd_pedido_venda and
--                                                                      cd_item_pedido_venda = pvi.cd_item_pedido_venda )
order by
  pvi.cd_produto,
  pvi.dt_item_pedido_venda desc  

-- select 
--   * 
-- from
--   #AuxProdutoProcesso
-- where
--   isnull(QtdProducao,0)>0
-- order by
--   cd_produto,
--   dt_item_pedido_venda desc  
  
