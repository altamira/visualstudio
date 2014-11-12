
CREATE   PROCEDURE pr_analise_importacao_produto_vendido
@dt_inicial    DateTime,
@dt_final      DateTime

as

set dateformat mdy

declare @Hoje datetime
set @Hoje = convert(varchar,getdate(),101)

declare @cd_fase_produto int

select 
  @cd_fase_produto = cd_fase_produto 
from 
  parametro_comercial 
where 
  cd_empresa = dbo.fn_empresa()

--Buscando moedas e última cotação
select
  m.cd_moeda,
  m.sg_moeda,
  (select top 1 vl_moeda from valor_moeda where cd_moeda = m.cd_moeda and isnull(vl_moeda,0) > 0 order by dt_moeda desc) as vl_moeda
into
  #Moeda
from
  Moeda m

--Pegando itens de pedido de venda com saldo a faturar
select
  pv.cd_cliente,
  pv.cd_pedido_venda,
  pvi.cd_item_pedido_venda,
  pv.dt_fechamento_pedido,
  pvi.cd_produto,
  pvi.dt_entrega_vendas_pedido,
  pvi.qt_item_pedido_venda,
  pvi.qt_saldo_pedido_venda,
  isnull(p.cd_fase_produto_baixa,@cd_fase_produto) as cd_fase_produto,
  '' as nm_fantasia_pai
into
  #Pedido
from
  Pedido_Venda pv With (nolock)
 	left outer join Pedido_Venda_Item	pvi with (nolock)	on pv.cd_pedido_venda = pvi.cd_pedido_venda 
  left outer join Produto	p with (nolock)	on pvi.cd_produto	= p.cd_produto
where
  pvi.qt_saldo_pedido_venda 		> 0
  and pvi.dt_cancelamento_item 		is null
  and pv.dt_fechamento_pedido		between @dt_inicial and @dt_final
  and isnull(ic_progfat_item_pedido,'N') = 'N'
--  and isnull(qt_progfat_item_pedido,0)  < pvi.qt_saldo_pedido_venda
  and isnull(pvi.cd_produto,0)		> 0
union all
select
  pv.cd_cliente,
  pv.cd_pedido_venda,
  pvi.cd_item_pedido_venda,
  pv.dt_fechamento_pedido,
  pvc.cd_produto,
  pvi.dt_entrega_vendas_pedido,
  pvi.qt_item_pedido_venda  * isnull(pvc.qt_item_produto_comp,0) 	as qt_item_pedido_venda,
  pvi.qt_saldo_pedido_venda * isnull(pvc.qt_item_produto_comp,0) 	as qt_saldo_pedido_venda,
  isnull(pvc.cd_fase_produto,@cd_fase_produto) 				as cd_fase_produto,
  pvi.nm_fantasia_produto 						as nm_fantasia_pai
from
  Pedido_Venda pv With (nolock)
  left outer join Pedido_Venda_Item	pvi With (nolock)	on pv.cd_pedido_venda	= pvi.cd_pedido_venda
  left outer join Pedido_Venda_Composicao	pvc With (nolock)	on pvi.cd_pedido_venda = pvc.cd_pedido_venda and
                                                						   pvi.cd_item_pedido_venda	= pvc.cd_item_pedido_venda	
where
  pvi.qt_saldo_pedido_venda 		> 0
  and pvi.dt_cancelamento_item 		is null
  and pv.dt_fechamento_pedido		between @dt_inicial and @dt_final
  and isnull(ic_progfat_item_pedido,'N') = 'N'
--  and isnull(qt_progfat_item_pedido,0)  < pvi.qt_saldo_pedido_venda
  and isnull(pvi.cd_produto,0)		= 0
  and isnull(pvc.cd_produto,0)		> 0
union all
select
  isnull(pv.cd_cliente,0) as cd_cliente,
  isnull(pv.cd_pedido_venda,0) as cd_pedido_venda,
  isnull(pvi.cd_item_pedido_venda,0) as cd_item_pedido_venda,
  pv.dt_fechamento_pedido,
  ppc.cd_produto,
  pvi.dt_entrega_vendas_pedido,
  qt_comp_processo				as qt_item_pedido_venda,
  qt_comp_processo				as qt_saldo_pedido_venda,
  isnull(ppc.cd_fase_produto,@cd_fase_produto) 	as cd_fase_produto,
  p.nm_fantasia_produto 			as nm_fantasia_pai
from
  Processo_Producao	pp With (nolock)
  left outer join Processo_Producao_Componente ppc	on pp.cd_processo = ppc.cd_processo
  left outer join Pedido_Venda_Item	pvi With (nolock)	on pvi.cd_pedido_venda = pp.cd_pedido_venda	and
                                                         pvi.cd_item_pedido_venda	= pp.cd_item_pedido_venda
	left outer join Pedido_Venda pv With (nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
	left outer join Produto	p With (nolock)	on pp.cd_produto = p.cd_produto
where
--  pvi.qt_saldo_pedido_venda 		> 0
  pvi.dt_cancelamento_item 		is null
--  and pv.dt_fechamento_pedido		between @dt_inicial and @dt_final
--  and isnull(ic_progfat_item_pedido,'N') = 'N'
--  and isnull(qt_progfat_item_pedido,0)  < pvi.qt_saldo_pedido_venda
  and pp.cd_status_processo 		not in (5,6)

--Pegando dados dos produtos
select
  p.cd_produto,
  p.nm_fantasia_produto,
  p.cd_unidade_medida,
  um.sg_unidade_medida,
  IsNull(p.qt_peso_liquido,0)		as qt_liquido,
  IsNull(p.qt_peso_bruto,0) 		as qt_bruto,
  p.cd_mascara_produto,
  case when IsNull(p.vl_fator_conversao_produt,1) = 0 
  then 
    1 
  else 
    IsNull(p.vl_fator_conversao_produt,1)
  end 					as qt_conversao,

  case when IsNull(p.vl_fator_conversao_produt,1) = 0 
  then 
    1 
  else 
    IsNull(p.vl_fator_conversao_produt,1)
  end 					as vl_conversao,

  IsNull(p.qt_multiplo_embalagem,1) 	as qt_multiplo,

  pa.cd_pais,
  pa.sg_pais,
  m.sg_moeda,
  m.vl_moeda,
  isnull(i.vl_produto_importacao,0)		as vl_fob,
  isnull(pc.vl_custo_contabil_produto,0)	as vl_custo,
  p.cd_categoria_produto,
  isnull(p.ic_processo_produto,'N')		as ic_processo,
  isnull(ic_estoque_produto,'S')		as ic_estoque,

  isnull((select sum(pii.qt_saldo_item_ped_imp)
          from Pedido_Importacao_Item 	pii
          where pii.cd_produto = p.cd_produto
                and isnull(pii.cd_produto,0) > 0
                and pii.dt_cancel_item_ped_imp is null
                and isnull(pii.qt_saldo_item_ped_imp,0) > 0
                and pii.dt_entrega_ped_imp between @Hoje and dateadd(dd,30,@hoje)),0)
  +
  isnull((select sum(pci.qt_saldo_item_ped_compra)
          from Pedido_Compra_Item 		pci
          where pci.cd_produto = p.cd_produto
                and isnull(pci.cd_produto,0) > 0
                and pci.dt_item_canc_ped_compra is null
                and isnull(pci.qt_saldo_item_ped_compra,0) > 0
                and pci.dt_entrega_item_ped_compr between @Hoje and dateadd(dd,30,@hoje)),0)
  +
  isnull((select sum(nsi.qt_item_nota_saida)
          from nota_saida_item 	nsi, operacao_fiscal ofi, nota_saida ns, grupo_operacao_fiscal gofi
          where nsi.cd_operacao_fiscal = ofi.cd_operacao_fiscal
                and nsi.cd_nota_saida = ns.cd_nota_saida
                and ofi.cd_grupo_operacao_fiscal = gofi.cd_grupo_operacao_fiscal
                and nsi.cd_produto = p.cd_produto
                and ns.dt_cancel_nota_saida is null
                and gofi.cd_tipo_operacao_fiscal = 1
                and isnull(ns.ic_emitida_nota_saida,'N') = 'N'),0)
 as qt_30,

  isnull((select sum(pii.qt_saldo_item_ped_imp)
          from Pedido_Importacao_Item 	pii
          where pii.cd_produto = p.cd_produto
                and isnull(pii.cd_produto,0) > 0
                and pii.dt_cancel_item_ped_imp is null
                and isnull(pii.qt_saldo_item_ped_imp,0) > 0
                and pii.dt_entrega_ped_imp between @Hoje+30 and dateadd(dd,60,@hoje)),0)
  +
  isnull((select sum(pci.qt_saldo_item_ped_compra)
          from Pedido_Compra_Item 		pci
          where pci.cd_produto = p.cd_produto
                and isnull(pci.cd_produto,0) > 0
                and pci.dt_item_canc_ped_compra is null
                and isnull(pci.qt_saldo_item_ped_compra,0) > 0
                and pci.dt_entrega_item_ped_compr between @Hoje+30 and dateadd(dd,60,@hoje)),0)
 as qt_60
into
  #Produto
from
  Produto	p With (nolock)
	left outer join Unidade_Medida um	 With (nolock) on p.cd_unidade_medida	= um.cd_unidade_medida
  left outer join Produto_Importacao i With (nolock) on p.cd_produto = i.cd_produto
  left outer join Pais pa With (nolock)	on isnull(isnull(i.cd_pais_procedencia, p.cd_origem_produto),1)	= pa.cd_pais
	left outer join Produto_Custo	pc With (nolock) on p.cd_produto = pc.cd_produto
  left outer join #Moeda	m	on isnull(i.cd_moeda, pa.cd_moeda) = m.cd_moeda	
where
  exists (select 0 from #Pedido where cd_produto = p.cd_produto)

  --Buscando material em transito requisição
  select
    rci.cd_produto,
    sum(rci.qt_item_requisicao_compra*p.vl_conversao) as qt_requisitado
  into
    #Requisitado
  from
    Requisicao_Compra_Item rci With (nolock)
   	inner join  #Produto	p	on rci.cd_produto = p.cd_produto
  where
    not exists (select 0 from pedido_compra_item where cd_requisicao_compra = rci.cd_requisicao_compra and cd_requisicao_compra_item = rci.cd_item_requisicao_compra)
    and not exists (select 0 from pedido_importacao_item where cd_requisicao_compra = rci.cd_requisicao_compra and cd_item_requisicao_compra = rci.cd_item_requisicao_compra)
    and isnull(rci.cd_produto,0) > 0
  group by
    rci.cd_produto

  --Buscando material em pedido de importacao
  select
    pii.cd_produto,
    sum(pii.qt_saldo_item_ped_imp*p.vl_conversao) as qt_importado
  into
    #Importado
  from
    Pedido_Importacao_Item pii With (nolock)
    inner join #Produto	p	on pii.cd_produto = p.cd_produto
  where
    isnull(pii.cd_produto,0) > 0
    and pii.dt_cancel_item_ped_imp is null
    and isnull(pii.qt_saldo_item_ped_imp,0) > 0
  group by
    pii.cd_produto

  --Buscando material em pedido de compra
  select
    pci.cd_produto,
    sum(pci.qt_saldo_item_ped_compra*p.vl_conversao) as qt_comprado
  into
    #Comprado
  from
    Pedido_Compra_Item pci With (nolock)
   	inner join #Produto	p	on pci.cd_produto = p.cd_produto
  where
    isnull(pci.cd_produto,0) > 0
    and pci.dt_item_canc_ped_compra is null
    and isnull(pci.qt_saldo_item_ped_compra,0) > 0
  group by
    pci.cd_produto


--Montando tabela final
Select
  0							as Selecionado,
  Case when p.qt_conversao = 1 then 
    case when cast(v.qt_saldo_pedido_venda as int) = 0 then
      1
    else
      case when v.qt_saldo_pedido_venda / cast(v.qt_saldo_pedido_venda as int) <> 1 then
        cast(v.qt_saldo_pedido_venda as int) + 1
      else
        v.qt_saldo_pedido_venda
      end
    end  
  Else 
    Case When Cast(v.qt_saldo_pedido_venda / p.qt_conversao as Int) = (v.qt_saldo_pedido_venda / p.qt_conversao) Then 
      (v.qt_saldo_pedido_venda / p.qt_conversao)
    Else 
      Cast(v.qt_saldo_pedido_venda / p.qt_conversao as Int) + 1
    End  
  End							as QtdImportar,
  v.qt_saldo_pedido_venda				as SaldoConvertido,
  cli.nm_fantasia_cliente				as Cliente,
  v.cd_pedido_venda					as Pedido,
  v.cd_item_pedido_venda				as ItemPV,
  p.nm_fantasia_produto					as Produto,
  v.nm_fantasia_pai					as ProdutoPai,
  v.qt_item_pedido_venda				as QtdePedido,
  v.qt_saldo_pedido_venda				as SaldoPedido,
  IsNull(ps.qt_saldo_reserva_produto,0) 		as SaldoDisponivel,
  IsNull(ps.qt_saldo_atual_produto,0) 			as SaldoFisico,
  v.dt_fechamento_pedido 				as Fechamento,
  v.dt_entrega_vendas_pedido 				as Comercial,
  v.cd_produto 						as CodigoProduto,
  p.cd_unidade_medida 					as UnidadeMedida,
  p.sg_unidade_medida 					as NomeUnidadeMedida,
  p.cd_categoria_produto				as CategoriaProduto,
  p.qt_liquido 						as PesoLiquido,
  p.qt_bruto				 		as PesoBruto,
  p.cd_mascara_produto 					as MascaraProduto,
  p.qt_conversao					as FatorConversao,
  p.qt_multiplo						as MultiploEmbalagem,
  p.cd_pais						as Origem,
  p.sg_pais						as Pais,
  p.sg_moeda						as Moeda,
  p.vl_moeda						as Cotacao,
  p.vl_fob						as FOBOrigem,
  case when isnull(p.vl_fob,0) = 0 then
    p.vl_custo
  else
    p.vl_moeda * p.vl_fob
  end 							as Custo,
  fp.nm_fase_produto					as FaseProduto,

  isnull(r.qt_requisitado,0)				as Requisitado,
  isnull(i.qt_importado,0)				as Importado,
  isnull(c.qt_comprado,0)				as Comprado,

  isnull(r.qt_requisitado,0) +
  isnull(i.qt_importado,0)   +
  isnull(c.qt_comprado,0)				as Transito,
  p.cd_produto,
  isnull(p.qt_30,0) * p.vl_conversao			as Qtd30,
  isnull(p.qt_60,0) * p.vl_conversao			as Qtd60,
  0 as QtdAnt,
  IsNull(cf.ic_licenca_importacao,'N') as LicencaImportacao
from
  #Pedido			v 	left outer join
  #Produto			p	on v.cd_produto 		= p.cd_produto
  left outer join Fase_Produto fp With (nolock)	on v.cd_fase_produto	= fp.cd_fase_produto	
	left outer join Cliente	cli With (nolock)	on v.cd_cliente	= cli.cd_cliente
	left outer join Produto_Saldo	ps With (nolock) on v.cd_produto	= ps.cd_produto	and
                                        					  v.cd_fase_produto	= ps.cd_fase_produto
	left outer join #Requisitado r	on p.cd_produto	= r.cd_produto
	left outer join #Importado i	on p.cd_produto	= i.cd_produto 
  left outer join #Comprado c	on p.cd_produto 	= c.cd_produto
  left outer join Produto_Fiscal pf with (nolock) on pf.cd_produto = v.cd_produto
  left outer join Classificacao_Fiscal cf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
where
  IsNull(ps.qt_saldo_reserva_produto,0) < 0
  and not exists (select 0 
                  from requisicao_compra_item With (nolock) 
                  where cd_pedido_venda 	= v.cd_pedido_venda and 
                        cd_item_pedido_venda 	= v.cd_item_pedido_venda and
                        cd_produto		= v.cd_produto)
  and p.ic_processo = 'N'
  and p.ic_estoque  = 'S'
  and not exists (select 0 
                  from OM With (nolock)
                  where cd_pedido_venda 	= v.cd_pedido_venda and
                        cd_item_pedido_venda 	= v.cd_item_pedido_venda and
                        cd_produto		= v.cd_produto)
order by
  IsNull(cf.ic_licenca_importacao,'N'),
  fp.nm_fase_produto desc,
  p.sg_pais desc,
  p.nm_fantasia_produto

