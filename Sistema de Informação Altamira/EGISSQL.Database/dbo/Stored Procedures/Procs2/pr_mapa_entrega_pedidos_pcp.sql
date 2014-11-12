
CREATE PROCEDURE pr_mapa_entrega_pedidos_pcp

@cd_parametro int,    --1 = Geral (Analítico), 2 = Resumo, 3 = Liberados e não faturados
@ic_filtro    char(1),   --(T)odos, (P)rogramar, (R)eprogramar
@dt_inicial   datetime,
@dt_final     datetime

as

--select * from pedido_venda_item

select distinct
  b.nm_fantasia_cliente       as 'Cliente',
  a.cd_pedido_venda           as 'Pedido',
  d.cd_item_pedido_venda      as 'Item',
  a.dt_pedido_venda           as 'Emissao',
  d.qt_item_pedido_venda      as 'Qtde',
  d.qt_saldo_pedido_venda     as 'QtdeSaldo',
  (d.qt_item_pedido_venda *
  d.vl_unitario_item_pedido)  as 'Venda',
  d.dt_entrega_vendas_pedido  as 'Comercial',
  d.dt_entrega_fabrica_pedido as 'Fabrica',
  d.dt_reprog_item_pedido     as 'Reprogramacao',
  d.cd_produto,
  d.cd_grupo_produto,
  -- Tipo do Pedido : 1 = Normal, 2 = Especial
   TipoPedido = 
     case when a.cd_tipo_pedido = 1 then 
       'PV' 
     when 
       a.cd_tipo_pedido = 2 then 'PVE' 
     else 
      tp.sg_tipo_pedido end,

--  tp.sg_tipo_pedido   as 'TipoPedido',
  d.nm_produto_pedido as 'Descricao',

  MascaraProduto =
    case when (a.cd_tipo_pedido = 1) or (d.cd_produto > 0) then
      (select max(cd_mascara_produto) from Produto where cd_produto = d.cd_produto)
    when a.cd_tipo_pedido = 2 then  
      (cast(d.cd_grupo_produto as char(2)) + '9999999')
    else 
      Null end,

  d.nm_fantasia_produto,


  case when isnull(d.ic_controle_pcp_pedido,'N') <> 'N' then
    isnull(d.ic_controle_pcp_pedido,'N')
  else
    case when isnull(p.ic_pcp_produto,'N')='S' then
      p.ic_pcp_produto
    else
      isnull(p.ic_controle_pcp_produto,'N')
    end
  end                                       as 'Pcp',

  Programado = 
  case when d.dt_entrega_fabrica_pedido is null then 'N' else 'S' end,
  nm_observacao_fabrica1 as 'Observacao1',
  nm_observacao_fabrica2 as 'Observacao2',
  dt_producao_comp_especial =

  (select top 1 max(ce.dt_producao_comp_especial) as dt_producao_comp_especial
   from Componente_Especial ce with (nolock) 
   where 
     ce.cd_pedido_venda      = d.cd_pedido_venda and
     ce.cd_item_pedido_venda = d.cd_item_pedido_venda
   group by 
     ce.cd_pedido_venda,
     ce.cd_item_pedido_venda),
     cd_pedido_venda_comp_esp =

  (select top 1 max(ce.cd_pedido_venda) as cd_pedido_venda_comp_esp
   from Componente_Especial ce with (nolock) 
   where 
     ce.cd_pedido_venda      = d.cd_pedido_venda and
     ce.cd_item_pedido_venda = d.cd_item_pedido_venda
   group by 
     ce.cd_pedido_venda,
     ce.cd_item_pedido_venda),

  ic_reserva_item_pedido              as 'Reservado',

  Atraso =
    case when (d.dt_reprog_item_pedido is not null) then
      case when Cast(d.dt_reprog_item_pedido-(GetDate()-1) as Int) >= 0 then 
        Null
      else (Cast(d.dt_reprog_item_pedido-(GetDate()-1) as Int)) * -1
    end
    when (d.dt_entrega_fabrica_pedido is not null) then
      case when Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int) >= 0 then 
        Null
      else (Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int)) * -1
    end
    else 
      (Cast(d.dt_entrega_vendas_pedido-(GetDate()-1) as Int)) * -1 end,

  c.dt_entrega_item_ped_compr         as 'MateriaPrima',
  d.cd_consulta,
  d.cd_item_consulta,
  d.cd_categoria_produto,
  isnull(d.ic_fatura_item_pedido,'N') as 'LibFat',
  a.cd_status_pedido                  as 'Status',

  Quebra =  isnull(d.dt_reprog_item_pedido,d.dt_entrega_fabrica_pedido),

  ReqCompra = ( select top 1 cd_requisicao_compra from Requisicao_Compra_Item
                where cd_pedido_venda      = d.cd_pedido_venda and
                      cd_item_pedido_venda = d.cd_item_pedido_venda order by cd_requisicao_compra desc ),

  OP        = ( select top 1 cd_processo from Processo_Producao with (nolock) 
                where
                      cd_pedido_venda = d.cd_pedido_venda and
                      cd_item_pedido_venda = d.cd_item_pedido_venda
                order by cd_processo desc ),

 Mapa = isnull(d.ic_manut_mapa_producao,'S'),

 c.cd_pedido_compra,
 c.cd_item_pedido_compra,
 gp.nm_grupo_produto,
 gc.nm_grupo_categoria,
 cp.nm_categoria_produto

-- d.dt_item_pedido_compra    

--select * from pedido_compra_item

into #TmpPedidosGeral
from
   Pedido_Venda a                    with (nolock) 

left Join Cliente b                  with (nolock) on   a.cd_cliente      = b.cd_cliente
left Join Pedido_Venda_Item d        with (nolock) on   a.cd_pedido_venda = d.cd_pedido_venda 

--Esta Linha pode causar problema de duplicidade
--Caso um Item do Pedido de Venda tenha diversas compras

left outer join Pedido_Compra_Item c with (nolock) on   d.cd_pedido_venda      = c.cd_pedido_venda and
                                                        d.cd_item_pedido_venda = c.cd_item_pedido_venda and 
                                                        isnull(c.cd_materia_prima,0)>0

left outer join Tipo_Pedido tp       with (nolock) on tp.cd_tipo_pedido = a.cd_tipo_pedido
left outer join Produto p            on p.cd_produto            = d.cd_produto
left outer join Categoria_produto cp on cp.cd_categoria_produto = p.cd_categoria_produto
left outer join Grupo_Produto     gp on gp.cd_grupo_produto     = p.cd_grupo_produto
left outer join Grupo_Categoria   gc on gc.cd_grupo_categoria   = cp.cd_grupo_categoria

where 
  d.dt_entrega_vendas_pedido between @dt_inicial and @dt_final and
  isnull(d.qt_saldo_pedido_venda,0) > 0        and
  d.dt_cancelamento_item is null and  
  ((@ic_filtro='P' and (d.dt_entrega_fabrica_pedido is null or d.dt_entrega_fabrica_pedido='')) or
   (@ic_filtro='R' and (d.dt_reprog_item_pedido     is null or d.dt_reprog_item_pedido='')) or
   (@ic_filtro='T')) and
  isnull(d.cd_produto_servico,0)=0 

--select * from #TmpPedidosGeral where pedido = 778

-- Variáveis para alimentar primeiro e último pedidos : emissão

declare @dt_inicial_emissao datetime
declare @dt_final_emissao   datetime
  
select 
  @dt_inicial_emissao = min(Emissao) 
from 
  #TmpPedidosGeral 
where 
  Pcp     = 'S' and 
  LibFat <> 'S' --and 
--  Status not in (3,4,5) -- Reposição, Falta Material, Retrabalho

select 
  @dt_final_emissao = max(Emissao) 
from #TmpPedidosGeral
where 
  Pcp     = 'S' and 
  LibFat <> 'S' --and 
  --Status not in (3,4,5)

-----------------------------------------------------------------------------------------
if @cd_parametro = 1 -- Consulta todos os pedidos (Analítico)
-----------------------------------------------------------------------------------------
begin
  select 
    a.*,
    ObservacaoCompEspecial =
    case when a.dt_producao_comp_especial is not null then
      'Componentes Especiais Lib. ' + convert(varchar(10),a.dt_producao_comp_especial,3)
    when a.dt_producao_comp_especial is null and a.cd_pedido_venda_comp_esp is not null then
      'Componentes Especiais em Fab.'
    else 
      null end, 
    @dt_inicial_emissao as 'EmissaoInicial',
    @dt_final_emissao   as 'EmissaoFinal',
    isnull(b.ic_orcamento_consulta,'S') as 'Orcamento'
  from #TmpPedidosGeral a, Consulta_Itens b
  where 
    a.Pcp     = 'S' and
    a.LibFat <> 'S' and
--    a.Status not in (3,4,5) and -- Reposição, Falta Material, Retrabalho
    a.cd_consulta      *= b.cd_consulta and
    a.cd_item_consulta *= b.cd_item_consulta 
    and a.Mapa = 'S'
  order by 
    isnull(a.Reprogramacao,a.Fabrica),
    Year(a.Emissao),
    a.Observacao1,
    a.TipoPedido,
    a.MascaraProduto,
    a.Emissao,
    a.Comercial

end

-----------------------------------------------------------------------------------------
if @cd_parametro = 2 -- Resumo 
-----------------------------------------------------------------------------------------
begin
  -- Pedidos a programar
  select 
    a.cd_categoria_produto as 'CodCategoria',
    sum(a.qtde)            as 'QtdeProgramar',
    sum(a.venda)           as 'VendaProgramar'
  into #TmpPedidosProgramar
  from #TmpPedidosGeral a
  where 
    a.Pcp = 'S' and
    a.LibFat <> 'S' and
    a.Fabrica is null 
--    a.Status not in (3,4,5) -- Reposição, Falta Material, Retrabalho
  group by 
    a.cd_categoria_produto

  -- Pedidos em produção
  select 
    a.cd_categoria_produto as 'CodCategoria',
    sum(a.qtde)            as 'QtdeProgramada',
    sum(a.venda)           as 'VendaProgramada'
  into #TmpPedidosProgramados
  from #TmpPedidosGeral a
  where 
    a.Pcp     = 'S' and
    a.LibFat <> 'S' and
    a.Fabrica is not null and
    a.Reprogramacao is null 
--    a.Status not in (3,4,5) -- Reposição, Falta Material, Retrabalho
    and a.Mapa = 'S'

  group by 
    a.cd_categoria_produto

  -- Pedidos reprogramados
  select 
    a.cd_categoria_produto as 'CodCategoria',
    sum(a.qtde)            as 'QtdeReprogramada',
    sum(a.venda)           as 'VendaReprogramada'
  into #TmpPedidosReprogramados
  from #TmpPedidosGeral a
  where 
    a.Pcp     = 'S' and
    a.LibFat <> 'S' and
    a.Reprogramacao is not null 
--    a.Status not in (3,4,5) -- Reposição, Falta Material, Retrabalho
  group by 
    a.cd_categoria_produto

  -- Pedidos atrasados

  select 
    a.cd_categoria_produto as 'CodCategoria',
    sum(a.qtde)            as 'QtdeAtrasada',
    sum(a.venda)           as 'VendaAtrasada'
  into #TmpPedidosAtrasados
  from #TmpPedidosGeral a
  where
    a.Pcp     = 'S' and
    a.LibFat <> 'S' and
    a.Atraso > 0 
--    a.Status not in (3,4,5) -- Reposição, Falta Material, Retrabalho
    and a.Mapa = 'S'

  group by 
    a.cd_categoria_produto

  -- Pedidos liberados e não faturados

  select 
    a.cd_categoria_produto as 'CodCategoria',
    sum(a.qtde)            as 'QtdeLiberada',
    sum(a.venda)           as 'VendaLiberada'
  into #TmpPedidosLiberados
  from #TmpPedidosGeral a
  where 
    a.Pcp    = 'S' and
    a.LibFat = 'S' 
--    a.Status not in (3,4,5) -- Reposição, Falta Material, Retrabalho
    and a.Mapa = 'S'
  group by 
    a.cd_categoria_produto

  -- Total Geral de Pedidos no período

  select 
    b.cd_categoria_produto         as 'CodCategoria',
    sum(b.qt_item_pedido_venda)    as 'QtdeTotal',
    sum(b.qt_item_pedido_venda *
    b.vl_unitario_item_pedido) as 'VendaTotal'
  into #TmpPedidosNoPeriodo
  from Pedido_Venda a
  left Join Pedido_Venda_Item b on 
    a.cd_pedido_venda = b.cd_pedido_venda 
  where 
    (a.dt_pedido_venda between @dt_inicial_emissao and @dt_final_emissao) and
    isnull(b.qt_saldo_pedido_venda,0) > 0                  and
    b.dt_cancelamento_item is null               and  
    isnull(a.ic_consignacao_pedido,'N') = 'N'    and
    --b.cd_item_pedido_venda < 80                  and
    isnull((b.qt_item_pedido_venda * b.vl_unitario_item_pedido),0) > 0 
  group by b.cd_categoria_produto

  -- Total Geral de Pedidos PCP

  select 
    f.CodCategoria,
    a.QtdeProgramar,    
    a.VendaProgramar,
    b.QtdeProgramada,   b.VendaProgramada,
    c.QtdeReprogramada, c.VendaReprogramada,
    e.QtdeAtrasada,     e.VendaAtrasada,
    d.QtdeLiberada,     d.VendaLiberada,
    isnull(a.QtdeProgramar,0)+isnull(b.QtdeProgramada,0)+
      isnull(c.QtdeReprogramada,0)+isnull(d.QtdeLiberada,0)   as 'QtdeGeral',
    isnull(a.VendaProgramar,0)+isnull(b.VendaProgramada,0)+
      isnull(c.VendaReprogramada,0)+isnull(d.VendaLiberada,0) as 'VendaGeral',
    f.QtdeTotal, 
    f.VendaTotal    
  into #TmpPedidosFinal
  from 
    #TmpPedidosProgramar a, 
    #TmpPedidosProgramados b, 
    #TmpPedidosReprogramados c, 
    #TmpPedidosLiberados d,
    #TmpPedidosAtrasados e,
    #TmpPedidosNoPeriodo f
  where 
    f.CodCategoria *= a.CodCategoria and
    f.CodCategoria *= b.CodCategoria and
    f.CodCategoria *= c.CodCategoria and
    f.CodCategoria *= d.CodCategoria and
    f.CodCategoria *= e.CodCategoria 

  -- Resultado Final

  select 
    b.sg_categoria_produto,
    b.cd_grupo_categoria,
    a.*,
    (a.QtdeGeral-QtdeTotal)   as 'QtdeDiferenca',
    (a.VendaGeral-VendaTotal) as 'VendaDiferenca'
  from 
    #TmpPedidosFinal a, 
    Categoria_Produto b
  where 
    ((a.QtdeProgramar is not null)    or
     (a.QtdeProgramada is not null)   or        
     (a.QtdeReprogramada is not null) or
     (a.QtdeLiberada is not null))    and
    a.CodCategoria *= b.cd_categoria_produto
  order by b.cd_grupo_categoria

end

-----------------------------------------------------------------------------------------
if @cd_parametro = 3 -- Pedidos liberados e não faturados
-----------------------------------------------------------------------------------------
begin
  select 
    a.Pedido,
    a.Item,
    a.Qtde,
    a.QtdeSaldo,
    a.Emissao,
    a.Comercial,
    a.Fabrica,
    a.Reprogramacao,
    a.Venda,
    a.Cliente,
    a.Descricao,
    a.Observacao1,
    a.Observacao2,
    a.Status,
    @dt_inicial_emissao as 'EmissaoInicial',
    @dt_final_emissao   as 'EmissaoFinal'
  from #TmpPedidosGeral a
  where 
    a.Pcp    = 'S' and
    a.LibFat = 'S' 
    --a.Item < 80 and 
--    a.Status not in (3,4,5)  -- Reposição, Falta Material, Retrabalho
    and a.Mapa = 'S'
  order by 
    isnull(a.Reprogramacao,a.Fabrica),
    a.Cliente,
    a.Pedido,
    a.Item

end

