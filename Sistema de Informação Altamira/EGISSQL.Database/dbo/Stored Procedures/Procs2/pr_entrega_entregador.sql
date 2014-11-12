
CREATE PROCEDURE pr_entrega_entregador
---------------------------------------------------
--GBS Global Business Solution Ltda            2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Listar as Notas de Saída p/ Entregador
--Data: 05/04/2002
--Atualizado: Igor Gama - 19/07/2002
--            Daniel C. Neto - 02/08/2002 - Adicionado vl_frete no resumo
--            Daniel Duela - 08/08/2003 - Acerto nos filtros e Adição do Campo ORDEM
--            Daniel Duela - 12/08/2003 - Acerto no Campo Ordem - Pegando Campo correto
-- 13/08/2003 - Acerto - Daniel C. Neto.
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
---------------------------------------------------

@ic_parametro  int,
@cd_entregador int,
@dt_inicial    datetime,
@dt_final      datetime
AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- listagem analitica
-------------------------------------------------------------------------------
  begin
    select        
      n.qt_ord_entrega_nota_saida as 'Ordem',
      e.cd_entregador,
      e.nm_entregador,
      n.dt_entrega_nota_saida     as 'Entrega',
      n.dt_saida_nota_saida       as 'Saida',
--      n.cd_nota_saida             as 'NF',

      case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
        n.cd_identificacao_nota_saida
      else
        n.cd_nota_saida                              
      end                         as 'NF',

      n.dt_nota_saida             as 'Emissao',
      n.nm_fantasia_nota_saida    as 'Cliente',
      v.nm_Fantasia_vendedor      as 'FantasiaVendedor', 
      v.nm_vendedor               as 'Vendedor',
      t.nm_transportadora         as 'Transportadora',
      n.vl_frete                  as 'Frete',
      n.vl_total                  as 'Valor',
      (select 
         max(i.cd_pedido_venda) 
       from 
         Nota_Saida_Item i 
       where 
         n.cd_nota_saida = i.cd_nota_saida) 
                                             as 'Pedido',
       n.nm_obs_entrega_nota_saida           as 'Observacao'
    from Nota_Saida n
    left outer join Vendedor v on 
      n.cd_vendedor = v.cd_vendedor
    left outer join transportadora t on 
      n.cd_transportadora = t.cd_transportadora
    Inner Join Entregador e on 
      n.cd_entregador = e.cd_entregador
    where
      n.cd_entregador = @cd_entregador                        and
      n.dt_saida_nota_saida between @dt_inicial and @dt_final and
      n.dt_cancel_nota_saida is null
    order by
      n.dt_saida_nota_saida

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- listagem do resumo
-------------------------------------------------------------------------------
begin

  declare @vl_total_resumo decimal(25,2)
    select
      e.cd_entregador,
      e.nm_entregador                                  as 'Entregador',
      count(n.cd_nota_saida)                           as 'Qtde',
      sum(n.vl_frete)                                  as 'ValorFrete',
      sum(n.vl_total)                                  as 'ValorTotal',
      max(n.dt_saida_nota_saida)                       as 'UltimaEntrega', 
      avg(e.vl_custo_entrega)                          as 'CustoUnitario',
      avg(e.vl_custo_entrega) * count(n.cd_nota_saida) as 'CustoTotal'
    into #Resumo_Entregador
    from
      Nota_Saida n
    inner join Entregador e on
      e.cd_entregador = n.cd_entregador
    where
      ((e.cd_entregador = @cd_entregador) or (@cd_entregador=0)) and
      n.dt_saida_nota_saida between @dt_inicial and @dt_final    and
      n.dt_cancel_nota_saida is null
    group by
      e.nm_entregador, e.cd_entregador

    -- total p/ cálculo do percentual
    select 
      @vl_total_resumo = isnull(sum(ValorTotal),1)
    from
      #Resumo_Entregador

    select
      cd_entregador,
      Entregador,
      Qtde,
      cast(ValorFrete as decimal(25,2))                                      as 'ValorFrete',
      cast(ValorTotal as decimal(25,2))                                      as 'ValorTotal',
      cast(((isnull(ValorTotal,1)/@vl_total_resumo) * 100) as decimal(25,2)) as 'Percentual',
      UltimaEntrega,
      cast(CustoUnitario as decimal(25,2))                                   as 'CustoUnitario',
      cast(CustoTotal as decimal(25,2))                                      as 'CustoTotal'
    from           
      #Resumo_Entregador
    order by
      Entregador      
end    
