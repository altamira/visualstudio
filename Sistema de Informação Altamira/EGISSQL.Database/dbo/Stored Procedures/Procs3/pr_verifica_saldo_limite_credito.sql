
CREATE PROCEDURE pr_verifica_saldo_limite_credito

@cd_cliente int,
@cd_pedido_venda int

as

declare @qt_dia_atraso_bloqueio int

set @qt_dia_atraso_bloqueio = 1

select
   @qt_dia_atraso_bloqueio = isnull(qt_dia_atraso_bloqueio ,1)
from
   Parametro_Financeiro 
where
   cd_empresa = dbo.fn_empresa()

if @qt_dia_atraso_bloqueio = 0
   set @qt_dia_atraso_bloqueio = 1

Select c.cd_cliente,
       c.nm_fantasia_cliente,
       IsNull(c.nm_razao_social_cliente,'') + IsNull(c.nm_razao_social_cliente_c,'') as 'RazaoSocial',
       ci.vl_limite_credito_cliente,
       TotalAtraso = (select cast(str(isnull(sum(dr.vl_saldo_documento), 0),25,2) as decimal(25,2)) 
                      from Cliente cli
                           left outer join Documento_Receber dr on dr.cd_cliente = cli.cd_cliente 
                      where cli.cd_cliente = c.cd_cliente and
                            dr.dt_vencimento_documento <= dbo.fn_dia_util (getdate()-@qt_dia_atraso_bloqueio,'N','U') and
                            CAST(dr.vl_saldo_documento AS DECIMAL(25,2)) > 0.001 AND  dr.dt_cancelamento_documento is null and dr.dt_devolucao_documento is null),
       (select Sum(IsNull(vl_saldo_documento,0))
        from documento_receber with (nolock)
        where cd_cliente = @cd_cliente and
              vl_saldo_documento > 0 and
              dt_cancelamento_documento is null
        group by cd_cliente) as vl_saldo_documento,
        (select (Sum( (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0))
                    * (1 + IsNull(pvi.pc_ipi,0) / 100) ) )
         from pedido_venda_item pvi with (nolock)
              inner join pedido_venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
         where pv.cd_cliente = @cd_cliente and
               pv.cd_pedido_venda <> @cd_pedido_venda and
               pvi.qt_saldo_pedido_venda > 0 and
               pvi.dt_cancelamento_item is null and
               pv.dt_fechamento_pedido is not null
         group by pv.cd_cliente) as vl_saldo_pedido,
         Cast(0 as Float) as vl_saldo_credito_cliente
Into #SaldoCredito
from cliente c with (nolock)
     left outer join cliente_informacao_credito ci on ci.cd_cliente = c.cd_cliente
where c.cd_cliente = @cd_cliente 

Update #SaldoCredito set vl_saldo_credito_cliente = isnull(vl_limite_credito_cliente,0) - (isnull(vl_saldo_documento,0) + isnull(vl_saldo_pedido,0))

Select * from #SaldoCredito

--exec pr_verifica_saldo_limite_credito 26941, 57037
