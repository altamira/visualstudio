
create procedure pr_consulta_ped_imp_cancelado
---------------------------------------------------------------
--pr_consulta_ped_imp_cancelado
---------------------------------------------------------------
--GBS - Global Business Solution Ltda                      2004 
---------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--Autor(es)              : Daniel C. Neto.
--Banco de Dados         : EgisSql
--Objetivo               : Realizar uma consulta de Pedidos Cancelados, ou por Item.
--Data                   : 18/02/2003
--Atualizado             : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------------

@ic_parametro as int,
@cd_pedido as Int,
@dt_inicial as datetime,
@dt_final as datetime

AS

--------------------------------------------------------------------------------------------
  if @ic_parametro = 1 -- Realiza a Consulta do Pedido
--------------------------------------------------------------------------------------------  
  Begin

    select distinct
      t.sg_tipo_pedido,
      p.cd_pedido_importacao,
      p.dt_pedido_importacao,
      f.nm_fantasia_fornecedor,
      p.dt_entrega_ped_imp,
      p.dt_canc_pedido_importacao,
      p.nm_canc_pedido_importacao,
      p.cd_comprador,
      p.vl_pedido_importacao,
      (Select nm_fantasia_comprador From Comprador Where cd_comprador = p.cd_comprador) as 'nm_comprador',
      Case 
        When p.dt_canc_pedido_importacao is not null then 'S' Else 'N' end as 'BaixaTotal'
    from
      Pedido_Importacao p left outer join
      Tipo_Pedido t
        on p.cd_tipo_pedido = t.cd_tipo_pedido left outer join
      Fornecedor f
        on p.cd_fornecedor = f.cd_fornecedor
    where
      ( (@cd_pedido = 0 and p.dt_pedido_importacao between @dt_inicial and @dt_final ) or
	(p.cd_pedido_importacao = @cd_pedido) ) and 
      -- Falta definir ainda qual o código adequeado para o Cancelamento do Pedido de Importação.
      (p.dt_canc_pedido_importacao is not null)
    order by
      p.dt_pedido_importacao
    desc

end
else 
--------------------------------------------------------------------------------------------
  if @ic_parametro = 2 -- Realiza a Consulta de Itens do Pedido
--------------------------------------------------------------------------------------------  
  Begin
    select
      t.sg_tipo_pedido,
      p.cd_pedido_importacao,
      p.dt_pedido_importacao,
      f.nm_fantasia_fornecedor,
      f.nm_razao_social,
      i.qt_item_ped_imp,
      i.qt_saldo_item_ped_Imp,
      i.cd_item_ped_imp,
      i.nm_produto_pedido,
      i.dt_cancel_item_ped_imp,
      i.nm_motivo_cancel_item_ped
    from
      Pedido_Importacao_Item i left outer join
      Pedido_Importacao p on p.cd_pedido_importacao = i.cd_pedido_importacao left outer join
      Tipo_Pedido t       on p.cd_tipo_pedido       = t.cd_tipo_pedido left outer join
      Fornecedor f        on f.cd_fornecedor        = f.cd_fornecedor
    where
      i.cd_pedido_importacao = @cd_pedido and
      -- Falta definir ainda qual o código adequeado para o Cancelamento do Pedido de Importação no Status_Pedido
      (p.dt_canc_pedido_importacao is not null)
    order by
      p.dt_pedido_importacao
    desc
end
Else
--------------------------------------------------------------------------------------------
  if @ic_parametro = 3 -- Realiza a Consulta para Relatório
--------------------------------------------------------------------------------------------  
  Begin
    Select
      t.sg_tipo_pedido,
      t.nm_tipo_pedido,
      p.cd_pedido_importacao,
      p.dt_pedido_importacao,
      f.nm_fantasia_fornecedor,
      (Select nm_fantasia_Contato_forne
       From Fornecedor_Contato
       Where cd_fornecedor = p.cd_fornecedor and cd_contato_fornecedor = p.cd_contato_fornecedor) as 'nm_fantasia_contato',
      p.nm_canc_pedido_importacao,
      p.dt_canc_pedido_importacao,
      i.cd_item_ped_imp,
      i.qt_item_ped_imp,
      i.vl_item_ped_imp,
      (i.qt_item_ped_imp * i.vl_item_ped_imp) as 'vl_total_item_pedido',
      i.dt_entrega_ped_imp,
      pd.cd_produto,
      i.nm_produto_pedido,
      i.nm_fantasia_produto
    from
      Pedido_Importacao p left outer join
      Pedido_Importacao_Item i
        on p.cd_pedido_importacao = i.cd_pedido_importacao Left Outer Join
      Produto pd
        on i.cd_produto = pd.cd_produto Left Outer Join
      Tipo_Pedido t
        on p.cd_tipo_pedido = t.cd_tipo_pedido left outer join
      Fornecedor f
        on p.cd_fornecedor = f.cd_fornecedor
    where
      p.dt_pedido_importacao between @dt_inicial and @dt_final and
      (p.cd_status_pedido = 7 or p.dt_canc_pedido_importacao is not null)

    order by
      p.dt_pedido_importacao
    desc
end


