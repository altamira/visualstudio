
create procedure pr_lancamento_saida_nota_fiscal
@dt_inicial   		datetime,
@dt_final      		datetime,
@cd_nota_saida 		int

as 

  select
     
    case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
      n.cd_identificacao_nota_saida
    else
      n.cd_nota_saida
    end                                                  as cd_nota_fiscal,

    n.*,

    vn.nm_vendedor,			
    v.nm_fantasia_vendedor,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    f.cd_mascara_operacao + ' - ' + f.nm_operacao_fiscal as 'CFOP',
    f.cd_tipo_natureza_operacao,
    n.vl_total,			
    n.nm_bairro_entrega + ' - ' + n.sg_estado_entrega as 'BairroEst',
    case
      when isnull(pv.ic_outro_cliente, 'N') = 'S' then (select nm_fantasia_cliente from Cliente where cd_cliente = pv.cd_cliente_faturar)
    end as 'nm_cliente_faturar',
    o.nm_observacao_entrega,		
    o.sg_observacao_entrega,		
    c.cd_cliente,			
    td.nm_tipo_destinatario,
    n.nm_fantasia_destinatario as nm_fantasia_cliente,	
    c.nm_endereco_cliente,
    t.cd_transportadora,
    t.nm_transportadora,
    t.cd_ddd,
    t.cd_telefone,
    n.dt_cancel_nota_saida,
    te.nm_tipo_local_entrega,
    IsNull(n.nm_cidade_entrega, n.nm_cidade_nota_saida) as nm_cidade_entrega,
    IsNull(n.sg_estado_entrega, n.sg_estado_nota_saida) as sg_estado_entrega,
    c.cd_cidade,
    c.cd_estado,
    c.cd_pais,
    n.cd_coleta_nota_saida,
    Case 
      when n.dt_coleta_nota_saida is not null then 
	'S'
      else
        'N'
      end as 'ic_coleta_nota_saida',
     Case 
      when IsNull(n.ic_coleta_nota_saida, 'N') = 'S' then 'Coletado'
      Else 'Não Coletado'
    End as 'nm_status_coleta',
    vc.nm_veiculo,
    vc.cd_placa_veiculo,
    m.nm_motorista
    
  from
    nota_saida n                    with (nolock) 
  left outer join Pedido_Venda pv   with (nolock) on 
    n.cd_pedido_venda = pv.cd_pedido_venda
  left outer join operacao_fiscal f with (nolock) on 
    n.cd_operacao_fiscal = f.cd_operacao_fiscal
  left outer join transportadora t  with (nolock) on 
    n.cd_transportadora = t.cd_transportadora 
  left outer join vendedor v        with (nolock) on 
    pv.cd_vendedor = v.cd_vendedor
  left outer join vendedor vi       with (nolock) on
    pv.cd_vendedor_interno = vi.cd_vendedor
  left outer join vendedor vn       with (nolock) on
    n.cd_vendedor = vn.cd_vendedor
   left outer join entregador e     with (nolock) on 
    n.cd_entregador = e.cd_entregador 
  left outer join cliente c         with (nolock) on 
    n.cd_cliente = c.cd_cliente
  left outer join
    observacao_Entrega o            with (nolock) on 
    n.cd_observacao_entrega = o.cd_observacao_entrega 
  left outer join
    Tipo_Local_Entrega te           with (nolock) on 
    te.cd_tipo_local_entrega = n.cd_tipo_local_entrega
  left outer join
    Tipo_Destinatario td            with (nolock) on 
    n.cd_tipo_destinatario = td.cd_tipo_destinatario
  left outer join Veiculo vc        with (nolock) on vc.cd_veiculo   = n.cd_veiculo
  left outer join Motorista m       with (nolock) on m.cd_motorista = n.cd_motorista

  where
    (n.cd_nota_saida = @cd_nota_saida) or
    (n.dt_cancel_nota_saida is null and
     @cd_nota_saida = 0 and
     n.dt_nota_saida between @dt_inicial and @dt_final)

  order by 
    n.dt_nota_saida desc, n.cd_nota_saida desc	

