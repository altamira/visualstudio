
CREATE PROCEDURE pr_consulta_ped_compra_fornecedor

@cd_pedido Integer
AS
  select
--      pc.cd_status_pedido,
      pc.cd_pedido_compra,
      pc.dt_pedido_compra,
      f.nm_fantasia_fornecedor,
      fc.nm_fantasia_contato_forne,
      pc.vl_total_pedido_compra,
      pc.dt_nec_pedido_compra,
      pc.dt_conf_pedido_compra,
      pc.nm_contato_conf_ped_comp,
      pc.cd_tipo_comunicacao,
      pc.nm_conf_pedido_compra,
      pc.cd_usuario,
      pc.dt_usuario

    from
      Pedido_Compra pc
    LEFT OUTER JOIN
      Fornecedor f
    ON
      pc.cd_fornecedor = f.cd_fornecedor
    LEFT OUTER JOIN
      Fornecedor_Contato fc
    ON
      pc.cd_contato_fornecedor = fc.cd_contato_fornecedor and
      pc.cd_fornecedor = fc.cd_fornecedor

    where
      pc.dt_conf_pedido_compra is null and
      pc.dt_cancel_ped_compra is null and
      IsNull(pc.cd_status_pedido,8) = 8 and -- Todos os pedidos em aberto
     (pc.cd_pedido_compra = @cd_pedido or @cd_pedido = 0)

    order by
      pc.dt_pedido_compra desc

