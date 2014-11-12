
CREATE PROCEDURE pr_consulta_notas_transportadora
@ic_parametro  int,
@cd_transportadora int,
@dt_inicial    datetime,
@dt_final      datetime
AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- listagem analitica
-------------------------------------------------------------------------------
  begin

    select
      n.dt_entrega_nota_saida     as 'Entrega',
      n.dt_saida_nota_saida       as 'Saida',
      n.cd_nota_saida             as 'NF',
      n.dt_nota_saida             as 'Emissao',
      n.nm_fantasia_nota_saida    as 'Cliente',
      v.nm_vendedor               as 'Vendedor',
      n.vl_total                  as 'Valor',
      e.cd_entregador             as 'Entregador',
      o.cd_observacao_entrega     as 'ObservacaoEntrega',
      p.cd_pedido_venda           as 'Pedido Venda',
      (select max(cd_pedido_venda) from Nota_Saida_Item  
       where cd_nota_saida = n.cd_nota_saida) as 'Pedido',
      n.nm_obs_entrega_nota_saida as 'Observacao'
    from
      Nota_Saida n
        left outer join
      Vendedor v
        on n.cd_vendedor = v.cd_vendedor
        left outer join
      Entregador e
        on n.cd_entregador = e.cd_entregador
        left outer join
      Observacao_Entrega o
        on n.cd_observacao_entrega = o.cd_observacao_entrega 
	left outer join Nota_Saida_Item nsi
	on n.cd_nota_saida = nsi.cd_nota_saida
	left outer join Pedido_Venda p
	on nsi.cd_pedido_venda = p.cd_pedido_venda
    where
      n.cd_transportadora = @cd_transportadora and
      n.dt_saida_nota_saida between @dt_inicial and @dt_final and
      n.dt_cancel_nota_saida is null
    order by
      n.dt_saida_nota_saida desc

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- listagem do resumo
-------------------------------------------------------------------------------
  begin

    select
      e.nm_entregador              as 'Entregador',
      count(n.cd_nota_saida)       as 'Qtde',
      sum(n.vl_total)              as 'ValorTotal',
      0.00                         as 'Percentual',
      max(n.dt_entrega_nota_saida) as 'UltimaEntrega' 
    --  0.00                         as 'CustoUnitario',  -- verificar como se calcula
    --  0.00                         as 'CustoTotal'      -- verificar como se calcula
    into
      #Resumo_Trasnportadora
    from
      Nota_Saida n
        inner join
      Entregador e
        on e.cd_entregador = n.cd_entregador
    where
      n.dt_saida_nota_saida between @dt_inicial and @dt_final
    group by
      e.nm_entregador

    select * from #Resumo_Transportadora
      

  end    

