
CREATE PROCEDURE pr_pedido_compra_confirmacao_fornecedor
@cd_pedido Integer

AS

  select
    pc.cd_pedido_compra,
    pc.dt_pedido_compra,
    f.nm_fantasia_fornecedor,
    fc.nm_fantasia_contato_forne,
    pc.vl_total_ipi_pedido,
    pc.dt_nec_pedido_compra,
    pc.dt_conf_pedido_compra,
    pc.nm_contato_conf_ped_comp,
    pc.cd_tipo_comunicacao,
    pc.nm_conf_pedido_compra,
    pc.cd_usuario,
    pc.dt_usuario,
    'S' as ic_aprov_pedido_compra,
    -- isnull(pc.ic_aprov_pedido_compra,'N') as ic_aprov_pedido_compra,
    c.nm_fantasia_comprador,
    pc.vl_total_pedido_compra,
    case when pc.dt_conf_pedido_compra is null then 'N' else 'S' end as ic_confirmado,
    tc.nm_tipo_comunicacao,
    pc.ds_pedido_compra 

  from
    Pedido_Compra pc left outer join
    Fornecedor f on pc.cd_fornecedor = f.cd_fornecedor left outer join
    Fornecedor_Contato fc on pc.cd_contato_fornecedor = fc.cd_contato_fornecedor and
                             pc.cd_fornecedor = fc.cd_fornecedor  left outer join
    Comprador c on c.cd_comprador = pc.cd_comprador left outer join
    Tipo_Comunicacao tc on tc.cd_tipo_comunicacao = pc.cd_tipo_comunicacao
    
  where
    (((@cd_pedido = 0) and (pc.dt_conf_pedido_compra is null)) or (@cd_pedido <> 0)) and
    (((@cd_pedido = 0) and (pc.ic_aprov_comprador_pedido = 'S')) or (@cd_pedido <> 0)) and
    (pc.cd_pedido_compra = @cd_pedido or @cd_pedido = 0) and 
     pc.dt_cancel_ped_compra is null and
     pc.ic_aprov_pedido_compra = 'S'
--     pc.cd_status_pedido = 8
  order by
    pc.cd_pedido_compra

