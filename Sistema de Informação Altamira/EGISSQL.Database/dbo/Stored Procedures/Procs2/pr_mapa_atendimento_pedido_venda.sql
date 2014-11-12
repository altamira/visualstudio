
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_atendimento_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes / Anderson
--Banco de Dados   : EgisSQL
--Objetivo         : Mapa de Atendimento Pedidos Faturados dentro prazo do Comercial
--
--                   
--Data             : 24.03.2007
--Atualizado       : 04/04/2007 - Acrescentado Vendedor, e Filtro por vendedor e produto - Anderson
--                 : 01.08.2007 - Acerto do Tipo de Pedido - Carlos Fernandes
--                 : 18.12.2007 - Acerto das Datas da Consulta - Carlos Fernandes.

-- 04.06.2008 - Desenvolvimento das alterações necessárias
-- 14.03.2009 - Modificações e Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_mapa_atendimento_pedido_venda

@cd_parametro int      = 1,   --1 = Geral (Analítico)
@ic_filtro    char(1)  = 'T', --(T)odos, 
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_vendedor  int      = 0,
@cd_produto   int      = 0

as

declare @dt_hoje datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)


select distinct
  
  b.nm_fantasia_cliente                                 as 'Cliente',
  i.cd_nota_saida                                       as 'Nota',
  n.dt_nota_saida                                       as 'Emissao',
  a.cd_pedido_venda                                     as 'Pedido',
  d.cd_item_pedido_venda                                as 'Item',
  d.qt_item_pedido_Venda                                as 'Qtde',
  d.qt_saldo_pedido_Venda                               as 'QtdeSaldo',
  i.qt_item_nota_saida                                  as 'QtdeFaturada',

  --select * from destinacao_produto
  cast(round(i.vl_total_item +

  --frete
  isnull(vl_frete_item,0)  + 

  --seguro
  isnull(vl_seguro_item,0) + 

  --IPI
  isnull(i.vl_ipi,0),2) as decimal(25,2))               as 'Faturamento',

  case when isnull(i.cd_servico,0)=0 
  then 
    cast(round((i.qt_item_nota_saida * i.vl_unitario_item_nota),2) as decimal(25,2))
  else
     0.00 end                                           as 'FaturamentoProduto',
  case when isnull(i.cd_servico,0)>0 
  then 
    cast(round((i.qt_item_nota_saida * i.vl_servico),2) as decimal(25,2))  
  else 
    0.00 end	                                        as 'FaturamentoServico',

  --dbo.fn_data(n.dt_saida_nota_saida)                    as 'Saida',
  n.dt_saida_nota_saida                                 as 'Saida',
  
  a.dt_pedido_venda                                     as 'EmissaoPedido',
  d.dt_entrega_vendas_pedido                            as 'Comercial',
  d.dt_entrega_fabrica_pedido                           as 'Fabrica',
  d.dt_reprog_item_pedido                               as 'Reprogramacao',
  d.cd_produto,
  d.nm_fantasia_produto,
  d.nm_produto_pedido                                   as 'Descricao',
  gp.nm_grupo_produto                                   as 'GrupoProduto',
  -- Tipo do Pedido : 1 = Normal, 2 = Especial
--   TipoPedido = 
--     case when a.cd_tipo_pedido = 1 then 
--       'PV' 
--     when 
--       a.cd_tipo_pedido = 2 then 'PVE' 
--     else 
--       Null end,

  tp.sg_tipo_pedido as TipoPedido,

  MascaraProduto =
    case when (a.cd_tipo_pedido = 1) or (d.cd_produto > 0) then
      (select max(cd_mascara_produto) from Produto where cd_produto = d.cd_produto)
    when a.cd_tipo_pedido = 2 then  
      (cast(d.cd_grupo_produto as char(2)) + '9999999')
    else 
      Null end,
  d.ic_controle_pcp_pedido                              as 'Pcp',
  Programado = 
  case when d.dt_entrega_fabrica_pedido is null then 'N' else 'S' end,
  nm_observacao_fabrica1                                as 'Observacao1',
  nm_observacao_fabrica2                                as 'Observacao2',
  ic_reserva_item_pedido                                as 'Reservado',
  Atraso =
    case when (d.dt_entrega_vendas_pedido is not null) then
      case when Cast(d.dt_entrega_vendas_pedido-@dt_hoje as Int) >= 0 then 
        Null
      else (Cast(d.dt_entrega_vendas_pedido-@dt_hoje as Int)) * -1
    end
    when (d.dt_entrega_fabrica_pedido is not null) then
      case when Cast(d.dt_entrega_fabrica_pedido-@dt_hoje as Int) >= 0 then 
        Null
      else (Cast(d.dt_entrega_fabrica_pedido-@dt_hoje as Int)) * -1
    end
    else 
      Null 
  end,
  d.cd_consulta,
  d.cd_item_consulta,
  cp.nm_categoria_produto                               as 'CategoriaProduto',
  d.ic_fatura_item_pedido                               as 'LibFat',
  Quebra = isnull(d.dt_entrega_vendas_pedido,d.dt_entrega_fabrica_pedido),
  dbo.fn_ultima_ordem_producao_item_pedido(a.cd_pedido_venda, d.cd_item_pedido_venda) as cd_processo,
  ve.nm_fantasia_vendedor                               as 'VendedorExterno',
  vi.nm_fantasia_vendedor                               as 'VendedorInterno',
  Dias = cast( n.dt_nota_saida - d.dt_entrega_vendas_pedido as int ),
  Atendimento = ( case when n.dt_nota_saida <= d.dt_entrega_vendas_pedido and d.qt_saldo_pedido_venda=0 then 'S' else 'N' end ),
  d.cd_pdcompra_item_pedido


--select * from pedido_venda_item

into 
  #TmpPedidosGeral

from 
  pedido_venda_item d               with (nolock)  
  left outer join nota_saida_item i with (nolock) on i.cd_pedido_venda        = d.cd_pedido_venda and
                                                   i.cd_item_pedido_venda   = d.cd_item_pedido_venda  
  inner join nota_saida   n         with (nolock) on n.cd_nota_saida          = i.cd_nota_saida
  inner join Pedido_Venda a         with (nolock) on a.cd_pedido_venda        = i.cd_pedido_venda
  left Join Cliente b               with (nolock) on a.cd_cliente             = b.cd_cliente
--   left Join Pedido_Venda_Item d   with (nolock) on d.cd_pedido_venda        = i.cd_pedido_venda and
--                                                    d.cd_item_pedido_venda   = i.cd_item_pedido_venda
  left Join Grupo_Produto gp        with (nolock) on gp.cd_grupo_produto      = d.cd_grupo_produto
  left Join Categoria_Produto cp    with (nolock) on cp.cd_categoria_produto  = d.cd_categoria_produto
  left Join Destinacao_Produto dp   with (nolock) on dp.cd_destinacao_produto = n.cd_destinacao_produto
  left Join Vendedor ve             with (nolock) on ve.cd_vendedor           = a.cd_vendedor_pedido
  left Join Vendedor vi             with (nolock) on vi.cd_vendedor           = a.cd_vendedor_interno
  left Join Tipo_Pedido tp          with (nolock) on tp.cd_tipo_pedido        = a.cd_tipo_pedido

where 
  isnull(i.cd_pedido_venda,0)>0 and isnull(i.cd_item_pedido_venda,0)>0 and
  --n.dt_nota_saida between @dt_inicial and @dt_final and
  --Filtro pela data de entrada do comercial - Item do Pedido de Venda
  d.dt_entrega_vendas_pedido between @dt_inicial and @dt_final         and
  n.dt_cancel_nota_saida      is null and
  i.dt_cancel_item_nota_saida is null and
  d.dt_cancelamento_item      is null and
  a.dt_cancelamento_pedido    is null and
  isnull(i.cd_produto,0)         = case when isnull(@cd_produto,0)=0  then isnull(i.cd_produto,0)         else @cd_produto  end and
  isnull(a.cd_vendedor_pedido,0) = case when isnull(@cd_vendedor,0)=0 then isnull(a.cd_vendedor_pedido,0) else @cd_vendedor end

-- Variáveis para alimentar primeiro e último pedidos : emissão
declare @dt_inicial_emissao datetime
declare @dt_final_emissao   datetime
  
select 
  @dt_inicial_emissao = min(Emissao) 
from 
  #TmpPedidosGeral 

select 
  @dt_final_emissao = max(Emissao) 
from 
  #TmpPedidosGeral

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
    a.Emissao desc,
    a.Nota    desc

end

