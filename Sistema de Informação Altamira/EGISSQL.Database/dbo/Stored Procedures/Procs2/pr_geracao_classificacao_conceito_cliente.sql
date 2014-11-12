
-------------------------------------------------------------------------------
--pr_geracao_classificacao_conceito_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática da Classificação de Conceito de Cliente
--Data             : 05.06.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_classificacao_conceito_cliente
@dt_inicial datetime,
@dt_final   datetime,
@cd_cliente int  = 0,
@qt_mes     int  = 0

as

--Verifica se foi enviado o número de meses

if @qt_mes = 0
begin
   set @qt_mes = 12
end


     select 
       pv.cd_cliente,
       sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido ) as TotalVenda
     into
       #AuxTotalVendaCliente
     from 
        Pedido_Venda pv with (nolock)
        inner join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
     where 
        pv.cd_cliente      = case when @cd_cliente = 0 then pv.cd_cliente else @cd_cliente end and
        pv.dt_pedido_venda between @dt_inicial and @dt_final and
        pv.dt_cancelamento_pedido is null  
     group by
        pv.cd_cliente
   

    select 
      a.*,
      Media = TotalVenda / @qt_mes,

      --Conceito do Cliente

      ( select cd_conceito_cliente 
        from cliente_conceito_vendas
        where
           ( TotalVenda / @qt_mes ) between vl_inicio_venda and vl_fim_venda
          ) as cd_conceito_cliente, 

      --Critério de Visita

      ( select cd_criterio_visita
        from cliente_conceito_vendas
        where
           ( TotalVenda / @qt_mes ) between vl_inicio_venda and vl_fim_venda
          ) as cd_criterio_visita
    into
      #AuxClassificada
    from 
      #AuxTotalVendaCliente a

    select * from #AuxClassificada

    --select * from cliente_conceito_vendas
    --select * from cliente_conceito

    --Atualização da Tabela de Cliente

    update
      Cliente
    set
      cd_conceito_cliente = a.cd_conceito_cliente,
      cd_criterio_visita  = a.cd_criterio_visita
    from
      Cliente c
      inner join #AuxClassificada a on a.cd_cliente = c.cd_cliente
     

