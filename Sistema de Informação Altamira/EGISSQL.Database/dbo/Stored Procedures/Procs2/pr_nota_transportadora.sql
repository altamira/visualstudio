
CREATE PROCEDURE pr_nota_transportadora
@ic_parametro      int,
@cd_transportadora int,
@dt_inicial        datetime,
@dt_final          datetime,
@sg_estado         varchar(2) = ''
AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- listagem analitica
-------------------------------------------------------------------------------
begin

    select
      n.dt_entrega_nota_saida,		--Entrega
      t.nm_endereco,                    --Endereco Transportadora 	
      t.nm_transportadora,              --Transportadora
      t.cd_transportadora,
      t.nm_fantasia,          		--Fantasia Transportadora 
      n.dt_saida_nota_saida,		--Saida
      n.cd_nota_saida,			--NF
      n.dt_nota_saida,			--Emissao
      td.nm_tipo_destinatario,          --Tipo Destinatário
      vw.nm_fantasia as nm_fantasia_nota_saida, --Cliente
      v.nm_vendedor,			--Vendedor
      v.nm_fantasia_vendedor,		--Vendedor
      n.vl_total,			--Valor
      n.vl_frete,
      n.sg_estado_nota_saida,
      e.nm_entregador,                  --Entregador
      (select 
         max(i.cd_pedido_venda) 
       from 
         Nota_Saida_Item i 
       where 
         n.cd_nota_saida = i.cd_nota_saida) as 'Pedido',
       n.nm_obs_entrega_nota_saida as 'Observacao'
    from
      Nota_Saida n
    inner join Operacao_Fiscal op on
      n.cd_operacao_fiscal = op.cd_operacao_fiscal
    left outer join Pedido_Venda p on 
      n.cd_pedido_venda = p.cd_pedido_venda
    left outer join Observacao_entrega o on
      n.cd_observacao_entrega = o.cd_observacao_entrega   
    left outer join Vendedor v on 
      n.cd_vendedor = v.cd_vendedor
    left outer join entregador e
      on n.cd_entregador = e.cd_entregador
    Inner join transportadora t on 
      n.cd_transportadora = t.cd_transportadora
    left outer join vw_Destinatario vw on
      n.cd_cliente = vw.cd_destinatario and op.cd_tipo_destinatario = vw.cd_tipo_destinatario
    left outer join Tipo_Destinatario td on
      op.cd_tipo_destinatario = td.cd_tipo_destinatario
    where
      ( ( @cd_transportadora = 0 ) or ( n.cd_transportadora = @cd_transportadora ) )
      and n.dt_nota_saida between @dt_inicial and @dt_final
      and n.dt_cancel_nota_saida is null
      and n.sg_estado_nota_saida = @sg_estado
    order by
      n.dt_nota_saida desc,
      n.cd_nota_saida asc

end
-----------------------------------------------------------------------------
else if @ic_parametro = 2  -- listagem do resumo
-----------------------------------------------------------------------------
  begin

    declare @vl_total_resumo decimal(25,2)

    select
      t.nm_fantasia,
      t.cd_telefone,
      t.nm_endereco,
      t.ic_cobra_coleta,
      t.cd_transportadora,
      n.sg_estado_nota_saida,
      t.nm_transportadora           as 'Transportadora',	--Transportadora
      count(n.cd_nota_saida)        as 'Qtde', 			--Quantidade	
      sum(n.vl_total)               as 'ValorTotal',    	--Valor Total
      sum(n.vl_frete)               as 'ValorFrete',
      CAST(null as numeric(25,2))   as 'Percentual',		--Porcentagem 
      max(n.dt_entrega_nota_saida)  as 'UltimaEntrega',	   	--Ultima Entrega
      CAST(null as numeric(25,2))   as 'CustoUnitario', 	--Verificar como se calcula
      CAST(null as numeric(25,2))   as 'CustoTotal'          	--Verificar como se calcula
    into
      #Resumo_Transportadora
    from
      Nota_Saida n
      inner join Operacao_Fiscal op on
        n.cd_operacao_fiscal = op.cd_operacao_fiscal
      inner join Transportadora t on 
        t.cd_transportadora = n.cd_transportadora
    where
      n.dt_nota_saida between @dt_inicial and @dt_final 
      and ( ( @cd_transportadora = 0 ) or ( n.cd_transportadora = @cd_transportadora ) )
      and n.dt_cancel_nota_saida is null
    group by
      t.cd_transportadora,
      t.nm_transportadora,
      n.sg_estado_nota_saida,
      t.nm_fantasia,
      t.cd_telefone,
      t.nm_endereco,
      t.ic_cobra_coleta


    -- total p/ cálculo do percentual
    select 
      @vl_total_resumo = isnull(sum(ValorTotal),1)
    from
      #Resumo_Transportadora

    select
      cd_transportadora,
      nm_fantasia,
      cd_telefone,
      nm_endereco,
      ic_cobra_coleta,
      cd_transportadora,
      Transportadora,
      sg_estado_nota_saida,
      Qtde,
      cast(ValorTotal as decimal(25,2)) as 'ValorTotal',
      cast(ValorFrete as decimal(25,2)) as 'ValorFrete',
      cast(((isnull(ValorTotal,1)/@vl_total_resumo) * 100) as decimal(25,2)) as 'Percentual',
      UltimaEntrega,
      cast(CustoUnitario as decimal(25,2)) as 'CustoUnitario',
      cast(CustoTotal as decimal(25,2)) as 'CustoTotal'
    from
      #Resumo_Transportadora
    order by
      Transportadora

  end    
