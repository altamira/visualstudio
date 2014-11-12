
create procedure pr_analise_prazo_itens_fornecedor
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

-- Busca itens de pedido e Fornecedor

  select 
    f.nm_fantasia_fornecedor as Fornecedor,
    cast((isnull(di.dt_chegada,dt_previsao_chegada_di) - pi.dt_pedido_importacao) as integer) as 'DiasAtraso',
    count(pii.cd_pedido_importacao) as ItensPedido
  Into 
    #Itens
  from
    pedido_importacao_item 	pii left outer join 
    pedido_importacao 		pi  on pii.cd_pedido_importacao 	= pi.cd_pedido_importacao 	left outer join 
    fornecedor 			f   on f.cd_fornecedor 			= pi.cd_fornecedor 		left outer join 
    di_item 			dii on pii.cd_pedido_importacao  	= dii.cd_pedido_importacao 	and
                                       pii.cd_item_ped_imp 		= dii.cd_item_ped_imp 		left outer join 
    di 				    on dii.cd_di = di.cd_di
  where
    isnull(di.dt_chegada,dt_previsao_chegada_di) between @dt_inicial and @dt_final
  and IsNull(pii.dt_cancel_item_ped_imp,0)=0
  group by 
    f.nm_fantasia_fornecedor, 
    cast((isnull(di.dt_chegada,dt_previsao_chegada_di) - pi.dt_pedido_importacao) as integer)
  order by
    1

  select
    i.Fornecedor,
    sum(i.ItensPedido) as ItensPedido,
    p.cd_ordem_analise_comex
  into 
    #Tabela_Final
  from
    #Periodo p inner join
    #Itens i on i.DiasAtraso between p.qt_faixa_inicial and p.qt_faixa_final
  group by
    p.cd_ordem_analise_comex, i.Fornecedor


  select 
    Fornecedor,
    cast(sum(ItensPedido) as float) as qt_total
  into
    #Total_Fornecedor 
  from 
    #Tabela_Final
  group by
    Fornecedor

  select 
     t.Fornecedor as 'Fornecedor',
     t.ItensPedido as 'Itens',
     p.nm_analise_comex as 'Prazo',
    ((t.ItensPedido * 100) / f.qt_total ) as '(%)'
  from
    #Tabela_Final t left outer join
    #Periodo p on p.cd_ordem_analise_comex = t.cd_ordem_analise_comex left outer join
    #Total_Fornecedor f on t.Fornecedor = f.Fornecedor
  order by
    t.Fornecedor, p.cd_ordem_analise_comex

