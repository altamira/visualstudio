
create procedure pr_analise_prazo_valor_fornecedor
@dt_inicial 	datetime,
@dt_final 	datetime,
@cd_moeda       int = 0
as

-- busca os parâmetros do prazo na tabela de Parâmetro de Análise de Entrega
  select
    qt_faixa_inicial,
    qt_faixa_final,
    cd_analise_comex,    
    nm_analise_comex,
    cd_ordem_analise_comex
  into
    #Periodo
  from
    Parametro_Analise_Comex

 --converte valores do pedido para moeda
/* select pi.cd_pedido_importacao,
       pi.vl_pedido_importacao * dbo.fn_vl_moeda_periodo(pi.cd_moeda,pi.dt_pedido_importacao) / 
       dbo.fn_vl_moeda_periodo(@cd_moeda,pi.dt_pedido_importacao) as ValorPedido

 into #CotacaoPedido
 from pedido_importacao pi
 where pi.dt_entrega_ped_imp between @dt_inicial and @dt_final*/

 select pi.cd_pedido_importacao,
       Sum(((pii.vl_item_ped_imp * pii.qt_item_ped_imp) * dbo.fn_vl_moeda_periodo(pi.cd_moeda,pi.dt_pedido_importacao))) as ValorItem,
       Cast(0 as Float) as ValorPedido,
       pi.dt_pedido_importacao 
 into #CotacaoPedido
 from pedido_importacao_item pii
      left outer join pedido_importacao pi on pi.cd_pedido_importacao = pii.cd_pedido_importacao
 where pii.dt_entrega_ped_imp between @dt_inicial and @dt_final
   and IsNull(pii.dt_cancel_item_ped_imp,0)=0
 group by pi.cd_pedido_importacao, pi.dt_pedido_importacao

 update #CotacaoPedido set ValorPedido = ValorItem / dbo.fn_vl_moeda_periodo(@cd_moeda,dt_pedido_importacao)

-- Busca valores de pedido já convertido para a moeda, Fornecedor e Dias Entrega

 select f.nm_fantasia_fornecedor as Fornecedor,
    cast((isnull(di.dt_chegada,dt_previsao_chegada_di) - pi.dt_pedido_importacao) as integer) as 'DiasEntrega',
	isnull(sum(co.ValorPedido),0) as 'ValorPedido'
  Into #Valores
  from
    pedido_importacao_item pii 
	left outer join pedido_importacao pi on pii.cd_pedido_importacao=pi.cd_pedido_importacao
 	left outer join fornecedor f on f.cd_fornecedor=pi.cd_fornecedor
	left outer join di_item	dii on pii.cd_pedido_importacao=dii.cd_pedido_importacao and
								   pii.cd_item_ped_imp=dii.cd_item_ped_imp
 	left outer join di on dii.cd_di=di.cd_di
    left outer join #CotacaoPedido co on co.cd_pedido_importacao=pi.cd_pedido_importacao
  where
    isnull(di.dt_chegada,dt_previsao_chegada_di) between @dt_inicial and @dt_final
  and IsNull(pii.dt_cancel_item_ped_imp,0)=0
  group by 
    f.nm_fantasia_fornecedor,
    cast((isnull(di.dt_chegada,dt_previsao_chegada_di) - pi.dt_pedido_importacao) as integer)
  order by
    1

-- Busca os valores de acordo com o perido definido na tabela de parametro

  select
    v.Fornecedor,
    sum(v.ValorPedido) as ValorPedido,
    p.cd_ordem_analise_comex
  into 
	#Tabela_Final
  from
    #Periodo p inner join
    #Valores v on v.DiasEntrega between p.qt_faixa_inicial and p.qt_faixa_final
  group by
    p.cd_ordem_analise_comex, v.Fornecedor

  select 
    Fornecedor,
    cast(sum(ValorPedido) as float) as qt_total
  into
    #Total_Fornecedor 
  from 
    #Tabela_Final
  group by
    Fornecedor

-- Busca os dados, ordena como especificado no campo e pega a porcentagem

  select 
     t.Fornecedor as 'Fornecedor',
     t.ValorPedido as 'Valor',
     p.nm_analise_comex as 'Prazo',
    ((t.ValorPedido * 100) / (case when f.qt_total=0 then 1 else f.qt_total end) ) as '(%)'
  from
    #Tabela_Final t 
	left outer join #Periodo p on p.cd_ordem_analise_comex = t.cd_ordem_analise_comex
    left outer join #Total_Fornecedor f on t.Fornecedor = f.Fornecedor
  order by
    t.Fornecedor, p.cd_ordem_analise_comex


