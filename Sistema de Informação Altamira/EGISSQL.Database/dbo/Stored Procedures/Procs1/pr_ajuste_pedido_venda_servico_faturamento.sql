
-------------------------------------------------------------------------------
--sp_helptext pr_ajuste_pedido_venda_servico_faturamento
-------------------------------------------------------------------------------
--pr_ajuste_pedido_venda_servico_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Ajuste dos Pedidos de Vendas com Produto / Serviço
--                   Prorevest
--
--Data             : 02.Setembro.2010
--Alteração        : 11.09.2010
--
--
------------------------------------------------------------------------------
create procedure pr_ajuste_pedido_venda_servico_faturamento
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

declare @cd_nota_fiscal int

set @cd_nota_fiscal = 0

--select @dt_inicial,@dt_final

    select 
      pvi.cd_pedido_venda,
      pvi.cd_item_pedido_venda,
      pvi.qt_saldo_pedido_venda,
      pvs.cd_pedido_venda      as cd_pvs,
      pvs.cd_item_pedido_venda as cd_pvis,
      ns.cd_nota_saida,
      ns.dt_nota_saida

    into
      #Saldo_Servico

    from pedido_venda_item pvi            with (nolock)  

    left outer join pedido_venda_item pvs with (nolock)  on pvs.cd_pedido_venda      = pvi.cd_pedido_venda and
                                                            isnull(pvs.cd_produto_servico,0) >0              

    left outer join nota_saida_item nsi   with (nolock)  on nsi.cd_pedido_venda      = pvs.cd_pedido_venda      and
                                                            nsi.cd_item_pedido_venda = pvs.cd_item_pedido_venda 

    left outer join nota_saida      ns    with (nolock)  on ns.cd_nota_saida         = nsi.cd_nota_saida      

    where
      isnull(pvi.cd_produto_servico,0)=0    and
      isnull(pvi.qt_saldo_pedido_venda,0)>0 and
      isnull(pvs.cd_produto_servico,0) >0   
      and ns.cd_nota_saida = case when @cd_nota_fiscal = 0 then ns.cd_nota_saida else @cd_nota_fiscal end
      and ns.dt_nota_saida between @dt_inicial and @dt_final

    --Atualiza a tabela de item do pedido de venda

--    select * from       #Saldo_Servico


    update
      pedido_venda_item
    set
     qt_saldo_pedido_venda = 0
    from
     pedido_venda_item pvi
     inner join #Saldo_Servico SS ON ss.cd_pedido_venda      = pvi.cd_pedido_venda and
                                     ss.cd_item_pedido_venda = pvi.cd_item_pedido_venda
 
    
     drop table #Saldo_Servico

--select * from status_pedido

select pv.* into #Pedido_Status from pedido_venda pv where pv.cd_status_pedido = 1 and
pv.cd_pedido_venda in ( select i.cd_pedido_venda 
                     from pedido_venda_item i where pv.cd_pedido_venda = i.cd_pedido_venda and
                     isnull(qt_saldo_pedido_venda,0)=0 )


update
  pedido_venda
set
  cd_status_pedido = 2
from
  pedido_venda
where
  cd_pedido_venda in ( select cd_pedido_venda from #Pedido_Status )

drop table #pedido_status


