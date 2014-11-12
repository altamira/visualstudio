
-------------------------------------------------------------------------------
--pr_programacao_entrega_comercial
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta da carteira de pedidos em aberto por data de entrega
--Data             : 28.01.2006
--Atualizado       : 28.01.2006
--                 : 12.05.2007 - Acerto do Tipo do Pedido - Carlos Fernandes
--                 : 04.07.2007 - Incluído a condição de pagamento - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_programacao_entrega_comercial

@cd_parametro int,       --1 = Geral (Analítico)
@ic_filtro    char(1),   --(T)odos, 
@dt_inicial   datetime,
@dt_final     datetime

as

--select * from tipo_pedido

select distinct
  b.nm_fantasia_cliente                                 as 'Cliente',
  a.cd_pedido_venda                                     as 'Pedido',
  d.cd_item_pedido_venda                                as 'Item',
  a.dt_pedido_venda                                     as 'Emissao',
  d.qt_item_pedido_venda                                as 'Qtde',
  d.qt_saldo_pedido_venda                               as 'QtdeSaldo',
  ( d.qt_item_pedido_venda - d.qt_saldo_pedido_venda )  as 'QtdeEntregue',
  (d.qt_item_pedido_venda * d.vl_unitario_item_pedido)  as 'Venda',
  d.dt_entrega_vendas_pedido                            as 'Comercial',
  d.dt_entrega_fabrica_pedido                           as 'Fabrica',
  d.dt_reprog_item_pedido                               as 'Reprogramacao',
  d.cd_produto,
  d.nm_fantasia_produto,
  d.cd_grupo_produto,
  -- Tipo do Pedido : 1 = Normal, 2 = Especial
--   TipoPedido = 
--     case when a.cd_tipo_pedido = 1 then 
--       'PV' 
--     when 
--       a.cd_tipo_pedido = 2 then 'PVE' 
--     else 
--       Null end,
  tp.sg_tipo_pedido   as 'TipoPedido',
  d.nm_produto_pedido as 'Descricao',
  MascaraProduto =
    case when (a.cd_tipo_pedido = 1) or (d.cd_produto > 0) then
      (select max(cd_mascara_produto) from Produto where cd_produto = d.cd_produto)
    when a.cd_tipo_pedido = 2 then  
      (cast(d.cd_grupo_produto as char(2)) + '9999999')
    else 
      Null end,
  d.ic_controle_pcp_pedido as 'Pcp',
  Programado = 
  case when d.dt_entrega_fabrica_pedido is null then 'N' else 'S' end,
  nm_observacao_fabrica1   as 'Observacao1',
  nm_observacao_fabrica2   as 'Observacao2',
  ic_reserva_item_pedido   as 'Reservado',

  Atraso =
    case when (d.dt_entrega_vendas_pedido is not null) then
      case when Cast(d.dt_entrega_vendas_pedido-(GetDate()-1) as Int) >= 0 then 
        Null
      else (Cast(d.dt_entrega_vendas_pedido-(GetDate()-1) as Int)) * -1
    end
    when (d.dt_entrega_fabrica_pedido is not null) then
      case when Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int) >= 0 then 
        Null
      else (Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int)) * -1
    end
    else 
      Null end,

  d.cd_consulta,
  d.cd_item_consulta,
  d.cd_categoria_produto,
  d.ic_fatura_item_pedido as 'LibFat',
  a.cd_status_pedido      as 'Status',
  Quebra =  isnull(d.dt_entrega_vendas_pedido,d.dt_entrega_fabrica_pedido),
  dbo.fn_ultima_ordem_producao_item_pedido(a.cd_pedido_venda, d.cd_item_pedido_venda) as cd_processo,
  cp.nm_condicao_pagamento
into #TmpPedidosGeral
from 
  Pedido_Venda a                        with (nolock)
  left outer join Tipo_Pedido tp        with (nolock) on tp.cd_tipo_pedido         = a.cd_tipo_pedido
  left outer join Cliente b             with (nolock) on  a.cd_cliente             = b.cd_cliente
  left outer join Pedido_Venda_Item d   with (nolock) on  a.cd_pedido_venda        = d.cd_pedido_venda 
  left outer join Condicao_Pagamento cp with (nolock) on  cp.cd_condicao_pagamento = a.cd_condicao_pagamento
where 
  d.dt_entrega_vendas_pedido between @dt_inicial and @dt_final and
  isnull(d.qt_saldo_pedido_venda,0) > 0        and
  d.dt_cancelamento_item is null 

-- Variáveis para alimentar primeiro e último pedidos : emissão
declare @dt_inicial_emissao datetime
declare @dt_final_emissao   datetime
  
select 
  @dt_inicial_emissao = min(Emissao) 
from #TmpPedidosGeral 

select 
  @dt_final_emissao = max(Emissao) 
from #TmpPedidosGeral

-----------------------------------------------------------------------------------------
if @cd_parametro = 1 -- Consulta todos os pedidos (Analítico)
-----------------------------------------------------------------------------------------
begin
  select 
    a.*,
    @dt_inicial_emissao                 as 'EmissaoInicial',
    @dt_final_emissao                   as 'EmissaoFinal',
    isnull(b.ic_orcamento_consulta,'S') as 'Orcamento'
  from 
    #TmpPedidosGeral a, Consulta_Itens b
  where 
    a.cd_consulta      *= b.cd_consulta and
    a.cd_item_consulta *= b.cd_item_consulta 
  order by 
    a.Comercial,
    Year(a.Emissao),
    a.TipoPedido

end




