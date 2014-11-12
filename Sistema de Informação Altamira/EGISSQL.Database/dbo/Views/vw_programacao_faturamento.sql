
CREATE VIEW vw_programacao_faturamento
AS
    SELECT     
      case 
        --Quando a data de crédito estiver nula significa que o crédito para o pedido não está liberado
        when pv.dt_credito_pedido_venda is null then 1 else 0 
      end as ic_credito,
      case
        when ((pvi.ic_desconto_item_pedido = 'S') and (pvi.dt_desconto_item_pedido is null)) then
          1
        else
          0
      end as ic_desconto,
      --Verificando tipo de entrega
      case when (isnull(pv.cd_tipo_entrega_produto,1) = 1) and (IsNull(pvi.ic_pedido_venda_item,'P') = 'P') then
        --Verificando se saldo do produto é suficiente para o faturamento do
        --Saldo do item do pedido
       (case 
          when (IsNull(pc.ic_estoque_produto, 'S') <> 'N') and
               ( pvi.qt_saldo_pedido_venda > 
                --Verificando se produto de baixa é outro para pegar o saldo de produto de baixa              
                 ( IsNull((dbo.fn_saldo_do_produto_fase(IsNull(p.cd_produto_baixa_estoque, p.cd_produto), dbo.fn_fase_produto(p.cd_produto, 0))),0) ))
        then 
          1 
        else 
          0
        end)
      else
        --Forma de entrega parcial e programado
        --Verificando se estoque é superior a Zero
        (case 
           when (IsNull(pc.ic_estoque_produto, 'S') <> 'N') and
                (( IsNull((dbo.fn_saldo_do_produto_fase(IsNull(p.cd_produto_baixa_estoque, p.cd_produto), dbo.fn_fase_produto(p.cd_produto, 0))),0) )
                <= 0) and (IsNull(pvi.ic_pedido_venda_item,'P') = 'P') then
          1
        else
          0
        end)
      end as ic_saldo_real,
      case 
        when (IsNull(pv.cd_tipo_restricao_pedido,0) > 0) then 1 else 0
      end as ic_restricao,
      case 
        when exists(select top 1 'X' from Previa_Faturamento_Composicao 
                    where cd_pedido_venda = pv.cd_pedido_venda and 
                          cd_item_pedido_venda = pvi.cd_item_pedido_venda and 
                          ic_fatura_previa_faturam = 'N') then 1 else 0
      end as ic_producao,

      case 
        when pii.cd_pedido_importacao is not null and pii.qt_saldo_item_ped_imp > 0 then 1 else 0
      end as ic_importacao,

      case 
        when exists(select top 1 'X' from Pedido_Compra_Item where cd_pedido_venda = pv.cd_pedido_venda and cd_item_pedido_venda = pvi.cd_item_pedido_venda and qt_saldo_item_ped_compra > 0) then 1 else 0
      end as ic_compra,

      case 
        when pvi.dt_entrega_vendas_pedido <= getdate() then 1 else 0
      end as ic_atraso,

      case
        when exists(select top 1 'X' from Cliente where cd_cliente = pv.cd_cliente and ic_liberado_pesq_credito = 'S') then 0 else 1
      end as ic_consulta_credito,

      case
        when (pvi.dt_item_pedido_venda = pvi.dt_entrega_vendas_pedido) or (pvi.dt_entrega_vendas_pedido - pvi.dt_item_pedido_venda) <= 
        IsNull((Select qt_dia_imediato_empresa from parametro_comercial where cd_empresa = dbo.fn_empresa()),0)
        then 1 else 0
      end as ic_imediato,

      case
        when isnull(pv.ic_fatsmo_pedido, 'N') = 'S' then 1 else 0
      end as ic_smo_item_pedido_venda,

      case
        when isnull(pv.ic_operacao_triangular, 'N') = 'S' then 1 else 0
      end as ic_operacao_triangular,

      case
        when isnull(pv.ic_outro_cliente, 'N') = 'S' then 1 else 0
      end as ic_outro_cliente,

      case
        when isnull(pv.ic_outro_cliente, 'N') = 'S' then (select nm_fantasia_cliente from Cliente where cd_cliente = pv.cd_cliente_entrega)
      end as nm_cliente_entrega,

      case
      	when isNull(pvi.ic_sel_fechamento,IsNull(pv.ic_fechamento_total,'N')) = 'S' then 1 else 0
      end as ic_fechado,
    
      case 
        when isnull(t.ic_sedex, 'N') = 'S' then 1 else 0
      end as ic_sedex,     
      
      case
        when (IsNull(pv.cd_tipo_entrega_produto,1) <> 1) then 0
  	    else
          IsNull((Select top 1 1 from Pedido_Venda_item 
          where Pedido_Venda_item.cd_pedido_venda = 
          pvi.cd_pedido_venda and 
          Pedido_Venda_item.dt_cancelamento_item is null and
          Pedido_Venda_Item.qt_saldo_pedido_venda > 0 and
          Pedido_Venda_Item.qt_saldo_pedido_venda >
          ( IsNull((dbo.fn_saldo_do_produto_fase(IsNull(p.cd_produto_baixa_estoque, p.cd_produto), dbo.fn_fase_produto(p.cd_produto, 0))),0) )
          ),0) 
      end as ic_pedido_total_n_permitido, 
      cast(pvi.dt_entrega_vendas_pedido as int) - cast(getdate()as int) as qt_dias,
      c.nm_fantasia_cliente,
      pv.cd_cliente, 
      pv.dt_pedido_venda, 
      pv.cd_pedido_venda, 
      pvi.cd_item_pedido_venda, 
      pvi.qt_item_pedido_venda, 
      pvi.qt_saldo_pedido_venda,
      pvi.vl_unitario_item_pedido,
      isnull(pvi.vl_unitario_item_pedido, 0) * isnull(pvi.qt_item_pedido_venda, 0) as vl_total_item,
      case
		    when (IsNull(pvi.ic_pedido_venda_item,'P')  = 'P') then        
          pvi.nm_fantasia_produto 
        else
          (Select top 1 nm_servico from Servico where cd_servico = pvi.cd_servico)
      end as nm_fantasia_produto, 
      --Verificando se produto de baixa é outro para pegar o saldo de produto de baixa
      case  
        when (IsNull(pvi.ic_pedido_venda_item,'P') = 'P') and
             ( IsNull(pvi.ic_produto_especial,'N') = 'N')then
          ( IsNull((dbo.fn_saldo_do_produto_fase(IsNull(p.cd_produto_baixa_estoque, p.cd_produto), dbo.fn_fase_produto(p.cd_produto, 0))),0) )
      else
        IsNull(pvi.qt_saldo_pedido_venda,0)
      end as qt_saldo_atual_produto, 
      pvi.dt_entrega_vendas_pedido, 
      pvi.dt_entrega_fabrica_pedido, 
      pvi.dt_reprog_item_pedido, 
      pii.dt_entrega_ped_imp, 
      tep.nm_tipo_entrega_produto,
      case when tep.cd_tipo_entrega_produto = 1 then 'S' else 'N' end as ic_entrega_total,
      pvi.ic_progfat_item_pedido,
      pvi.dt_progfat_item_pedido,
      pvi.qt_progfat_item_pedido,
      pv.qt_volume_pedido_venda,
      pv.qt_fatpliq_pedido_venda,
      pv.qt_fatpbru_pedido_venda,
      pvi.qt_liquido_item_pedido,
      pv.cd_tipo_entrega_produto,	  
      trp.nm_tipo_restricao_pedido,

      --Define se o produto possui reserva em estoque

      IsNull((Select top 1 'S' from Movimento_estoque me where me.cd_documento_movimento = cast(pvi.cd_pedido_venda as varchar(30)) and me.cd_item_documento = pvi.cd_item_pedido_venda), 'N') as ic_reservado, 
      IsNull((select top 1 ic_sce_tipo_pedido from tipo_pedido where cd_tipo_pedido = pv.cd_tipo_pedido),'S') as ic_sce_tipo_pedido,
      t.nm_fantasia as 'nm_transportadora',
      tle.sg_tipo_local_entrega,
      IsNull((Select top 1 dt_previa_faturamento 
              from previa_faturamento 
              where cd_previa_faturamento = 
              (Select top 1 cd_previa_faturamento 
               from previa_faturamento_composicao 
               where cd_pedido_venda = pvi.cd_pedido_venda 
                     and cd_item_pedido_venda = pvi.cd_item_pedido_venda
              )
             ),NULL) as dt_previa_faturamento,
      IsNull(pvi.ic_produto_especial,'N') as ic_produto_especial,
      pvi.ic_ordsep_pedido_venda,
      case 
         when (IsNull(pvi.ic_pedido_venda_item,'P')  = 'P') then  0 else 1 end 
      as ic_servico
    FROM
      Pedido_Venda_Item pvi LEFT OUTER JOIN
      Pedido_Importacao_Item pii ON pvi.cd_pedido_venda = pii.cd_pedido_venda AND pvi.cd_item_pedido_venda = pii.cd_item_pedido_venda RIGHT OUTER JOIN
      Pedido_Venda pv ON pvi.cd_pedido_venda = pv.cd_pedido_venda LEFT OUTER JOIN
      Cliente c ON pv.cd_cliente = c.cd_cliente left outer join
      Transportadora t on t.cd_transportadora = pv.cd_transportadora left outer join
      Tipo_Local_Entrega tle on tle.cd_tipo_local_entrega = pv.cd_tipo_local_entrega left outer join
      Tipo_Entrega_Produto tep on pv.cd_tipo_entrega_produto = tep.cd_tipo_entrega_produto left outer join
      Produto p on pvi.cd_produto = p.cd_produto left outer join
      Produto_Custo pc on pvi.cd_produto = pc.cd_produto left outer join
      Tipo_Restricao_Pedido trp on pv.cd_tipo_restricao_pedido = trp.cd_tipo_restricao_pedido      
    WHERE     
       pv.dt_cancelamento_pedido is null 
       and IsNull(pvi.qt_saldo_pedido_venda,0) > 0 and 
       pvi.dt_cancelamento_item is null

