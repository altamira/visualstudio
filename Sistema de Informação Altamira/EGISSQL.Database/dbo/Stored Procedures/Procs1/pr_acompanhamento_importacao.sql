
create procedure pr_acompanhamento_importacao
as
select
	--Header do relatório
	di.nm_di as 'DI',
        i.nm_invoice as 'Invoice',
        sd.nm_status_di as 'Status',
	i.dt_invoice as 'Emissão Invoice',
        di.dt_previsao_chegada_di as 'Chegada País',
        di.dt_desembaraco as 'Liberação',
	di.dt_chegada_fabrica as 'Chegada Empresa',
	f.nm_fantasia_fornecedor as 'Fornecedor',
	p.nm_pais as 'País',
	di.ds_observacao_di as 'Observações',
	--Subdetalhe do relatório
	case when IsNull(pii.nm_fantasia_produto,'')<>''
		then pii.nm_fantasia_produto
		else pr.nm_fantasia_produto end as 'Produto',
	pii.cd_pedido_importacao as 'Pedido Importação',
	pii.cd_item_ped_imp as 'Item',
	IsNull(pii.qt_item_ped_imp,0) as 'Quantidade',
	IsNull(dii.qt_efetiva_chegada,0) as 'Quant. DI'        
from                    di_item 		dii
	left outer join di 			di  on dii.cd_di=di.cd_di
        left outer join invoice 		i   on dii.cd_invoice=i.cd_invoice
        left outer join invoice_item		ii  on dii.cd_invoice = ii.cd_invoice
                                                   and dii.cd_invoice_item = ii.cd_invoice_item
	left outer join status_di 		sd  on sd.cd_status_di=di.cd_status_di
	left outer join fornecedor 		f   on f.cd_fornecedor=di.cd_fornecedor
	left outer join pedido_importacao 	pi  on pi.cd_pedido_importacao=ii.cd_pedido_importacao
	left outer join pedido_importacao_item 	pii on pii.cd_pedido_importacao=ii.cd_pedido_importacao 
                                                   and pii.cd_item_ped_imp=ii.cd_item_ped_imp
	left outer join pais 			p   on p.cd_pais=f.cd_pais
	left outer join produto 		pr  on pr.cd_produto=dii.cd_produto

where (di.cd_status_di not in (4,5))
and pii.qt_saldo_item_ped_imp > 0
order by i.nm_invoice, Produto

