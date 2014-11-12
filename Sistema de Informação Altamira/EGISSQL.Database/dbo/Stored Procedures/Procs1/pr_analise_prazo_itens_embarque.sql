
create procedure pr_analise_prazo_itens_embarque
@dt_inicial 	datetime,
@dt_final 	datetime
as

  declare @qt_total float

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

-- Busca itens de pedido ,Método de Embarque e Dias de Entrega

  select 
	t.nm_tipo_importacao as Embarque,
	cast((isnull(di.dt_chegada,dt_previsao_chegada_di) - pi.dt_pedido_importacao) as integer) as 'DiasEntrega',
    count(pii.cd_pedido_importacao) as ItensPedido
  Into 
	#Itens
  from
    pedido_importacao_item 	pii left outer join 
    pedido_importacao 		pi  on pii.cd_pedido_importacao 	= pi.cd_pedido_importacao 	left outer join 
	tipo_importacao t on t.cd_tipo_importacao=pi.cd_tipo_importacao 		left outer join 
    di_item 			dii on pii.cd_pedido_importacao  	= dii.cd_pedido_importacao 	and
                                       pii.cd_item_ped_imp 		= dii.cd_item_ped_imp 		left outer join 
    di 				    on dii.cd_di = di.cd_di
  where
    isnull(di.dt_chegada,dt_previsao_chegada_di) between @dt_inicial and @dt_final
  and IsNull(pii.dt_cancel_item_ped_imp,0)=0
  group by 
    t.nm_tipo_importacao,
    cast((isnull(di.dt_chegada,dt_previsao_chegada_di) - pi.dt_pedido_importacao) as integer)
  order by
    1

  select
    i.Embarque,
    sum(i.ItensPedido) as ItensPedido,
    p.cd_ordem_analise_comex
  into 
	#Tabela_Final
  from
    #Periodo p inner join
    #Itens i on i.DiasEntrega between p.qt_faixa_inicial and p.qt_faixa_final
  group by
    p.cd_ordem_analise_comex, i.Embarque


  select 
    Embarque,
    cast(sum(ItensPedido) as float) as qt_total
  into
    #Total_Embarque 
  from 
    #Tabela_Final
  group by
    Embarque

  select 
     t.Embarque as 'Embarque',
     t.ItensPedido as 'Itens',
     p.nm_analise_comex as 'Prazo',
    ((t.ItensPedido * 100) / e.qt_total ) as '(%)'
  from
    #Tabela_Final t left outer join
    #Periodo p on p.cd_ordem_analise_comex = t.cd_ordem_analise_comex left outer join
    #Total_Embarque e on t.Embarque = e.Embarque
  order by
    t.Embarque, p.cd_ordem_analise_comex

