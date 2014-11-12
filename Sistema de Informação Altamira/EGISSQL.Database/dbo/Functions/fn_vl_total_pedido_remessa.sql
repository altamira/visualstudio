
--------------------------------------------------------------------------------------
--GBS - GLobal Business Solution - 200@cd_fase_produto
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto.
--Função para retornar o valor total do pedido na remessa.
--Data         : 27/04/2005
--------------------------------------------------------------------------------------


CREATE  FUNCTION fn_vl_total_pedido_remessa(
  @cd_remessa_viagem int, 
  @cd_pedido_venda int, 
  @ic_tipo_retorno char(1))

RETURNS Float
AS
BEGIN

  -- Códigos a serem utilizados pra se retornar os valores.
  -- 'N' - Retorna o valor total do pedido normalmente.
  -- 'O' - Retorna somente o valor da substituição tributária do pedido.
  -- 'R' - Retorna o valor total do pedido tirando os pedidos sem valor comercial.

  declare @vl_total_pedido float
  declare @vl_icms_subst float
  declare @vl_final float
  
set @vl_total_pedido = 
    ( select sum( ( cast(str(pvi.vl_unitario_item_pedido,25,2) as decimal(25,2)) * IsNull(rvip.qt_item_pedido_venda,0) + 
                         ( cast(str(pvi.vl_unitario_item_pedido,25,2) as decimal(25,2)) - 
                            (cast(str(pvi.vl_unitario_item_pedido,25,2) as decimal(25,2)) / (1 -
                            (pv.pc_desconto_pedido_venda / 100)) ) ) * IsNull(rvip.qt_item_pedido_venda,0)) ) 
    from
      Remessa_Viagem_Item_pedido rvip left outer join
      Pedido_Venda_Item pvi on pvi.cd_pedido_venda = rvip.cd_pedido_venda and
                                                  pvi.cd_item_pedido_venda = rvip.cd_item_pedido_venda left outer join
      Pedido_Venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join
      Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido
    where rvip.cd_remessa_viagem = @cd_remessa_viagem and
          rvip.cd_pedido_venda = @cd_pedido_venda and
          IsNull(tp.ic_sem_valor_remessa,'N') = ( case when @ic_tipo_retorno = 'R' then
                                                    'N' else IsNull(tp.ic_sem_valor_remessa,'N') end ) ) 


set @vl_icms_subst = 
    IsNull( (
            select 
              sum(distinct ns.vl_icms_subst) as vl_icms_subst
            from 
              Remessa_Viagem_Item_pedido rvip left outer join
              nota_saida_item nsi on rvip.cd_pedido_venda = nsi.cd_pedido_venda and
                                     rvip.cd_item_pedido_venda = nsi.cd_item_pedido_venda left outer join
              nota_saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
            where 
              rvip.cd_remessa_viagem = @cd_remessa_viagem and 
              rvip.cd_pedido_venda = @cd_pedido_venda
            group by
              rvip.cd_remessa_viagem, 
              rvip.cd_pedido_venda ),0)


if @ic_tipo_retorno in ('N','R')
  set @vl_final = @vl_total_pedido + @vl_icms_subst
else
  set @vl_final = @vl_icms_subst


RETURN(@vl_final)

END

