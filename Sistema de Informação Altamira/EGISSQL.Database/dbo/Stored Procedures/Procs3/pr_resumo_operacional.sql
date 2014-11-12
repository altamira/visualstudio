
-------------------------------------------------------------------------------
--pr_resumo_operacional
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Resumo Operacional - Estratégico
--                   Tomada de Decisão
--Data             : 14.10.2005
--Atualizado       : 15.10.2005
--------------------------------------------------------------------------------------------------
create procedure pr_resumo_operacional
@ic_parametro int = 0, --Parâmetro
@cd_ano       int = 0, --Ano
@cd_moeda     int = 1  --Moeda - R$ Padrão
as

--------------------------------------------------------------------------------------------------
--Ano
--------------------------------------------------------------------------------------------------
if @ic_parametro = 1
begin

  --select * from vw_proposta_bi

  --Total de Propostas
  select
    year(dt_consulta)                                   as Ano,
    sum (qt_item_consulta * vl_unitario_item_consulta ) as TotalProposta
  into #Proposta
  from
    vw_proposta_bi
  where
    isnull(ic_consignacao_consulta,'N')='N' and 
    year(dt_consulta) = case when @cd_ano = 0 then year(dt_consulta) else @cd_ano end
  group by
    year(dt_consulta)  

  --Total de Perdas
  select
    year(dt_consulta)                                   as Ano,
    sum (qt_item_consulta * vl_unitario_item_consulta ) as TotalPerdas
  into #Perda
  from
    vw_proposta_bi
  where
    isnull(ic_consignacao_consulta,'N')='N' and 
    dt_perda_consulta_itens is not null     and 
    year(dt_consulta) = case when @cd_ano = 0 then year(dt_consulta) else @cd_ano end
  group by
    year(dt_consulta)  

  --Total de Vendas
  select 
    year(dt_pedido_venda)     as 'Ano' , 
    sum(isnull(qt_item_pedido_venda * 
           vl_unitario_item_pedido,0)) as 'Total',
    sum(qt_item_pedido_venda * vl_unitario_item_pedido * dbo.fn_vl_moeda(@cd_moeda)) as 'TotalVendas', 
    sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido * qt_item_pedido_venda) * dbo.fn_vl_moeda(@cd_moeda), 
                                 pc_icms, pc_ipi, cd_destinacao_produto, ''))   as 'TotalLiquido'
  into 
    #VendaAnual
  from
    vw_venda_bi
  where
    year(dt_pedido_venda) = (case when @cd_ano = 0 then year(dt_pedido_venda) else @cd_ano end)
  Group by 
    year(dt_pedido_venda) 

  --Resumo Geral 

  select
    va.Ano,
    pr.TotalProposta,
    pe.TotalPerdas,
    va.TotalVendas,
    0.00 as TotalPedidosCancelados,
    0.00 as TotalCarteiraPedidos,
    0.00 as TotalPedidosAtrasados,
    0.00 as TotalFaturamento,
    0.00 as TotalDevolucao,
    0.00 as TotalContasReceber,
    0.00 as TotalAtrasoReceber,
    0.00 as TotalContasPagar,
    0.00 as TotalAtrasoPagar,
    0.00 as TotalCompras,
    0.00 as TotalAtrasoCompras,
    0.00 as TotalRecebimento,
    0.00 as TotalProducao,
    0.00 as TotalAtrasoProducao,
    0.00 as TotalEstoque
  from
    #VendaAnual va
    left outer join #Proposta pr on pr.ano = va.ano
    left outer join #Perda    pe on pe.ano = va.ano

 --Total de Pedidos Cancelados

 --Total da Carteira de Pedidos

 --Total de Pedidos Atrasados

 --Total de Faturamento

 --Total de Devolução

 --Total de Contas a Receber

 --Total de Atraso de Contas a Receber

 --Total de Contas a Pagar

 --Total de Atraso de Contas a Pagar

 --Total de Pedidos de Compras

 --Total de Recebimento

 --Total de Produção

 --Total de Atraso de Produção

 --Total de Horas para produção conforme Carga Máquina

 --Total de Estoque
  
end

