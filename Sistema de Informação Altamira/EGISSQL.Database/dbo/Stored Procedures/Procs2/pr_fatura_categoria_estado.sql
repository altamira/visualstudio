CREATE PROCEDURE pr_fatura_categoria_estado
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Igor
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Categoria.
--Data          : 27.04.2004
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.

---------------------------------------------------
@cd_pais    int = 1,
@cd_estado  int,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1,
@cd_cidade  int = 0
as
  declare 
    @ic_devolucao_bi char(1),
    @vl_total_Venda float

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )


  set @ic_devolucao_bi = 'N'
  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
  	vw.cd_produto,
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos',
    count(distinct(vw.cd_cliente))                              as  'Clientes' 
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0) and 
    vwd.cd_cidade = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	vw.cd_produto
  order by 1, 2 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_produto,
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos',
    count(distinct(vw.cd_cliente))                              as  'Clientes' 
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0) and
    vwd.cd_cidade = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	vw.cd_produto
  order by 1, 2 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	vw.cd_produto,
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos',
    count(distinct(vw.cd_cliente))                              as  'Clientes' 
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
    and  vwd.cd_cidade = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	vw.cd_produto
  order by 1, 2 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_produto,
    sum(vw.vl_unitario_item_atual) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos',
    count(distinct(vw.cd_cliente))                              as  'Clientes' 
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
    and  vwd.cd_cidade = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	vw.cd_produto
  order by 1, 2 desc


  select 
    a.cd_produto,
    a.Pedidos,
    a.Clientes,
    cast(IsNull(a.qtd,0) -
      (isnull(b.qtd,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.qtd,0)
    		end) + 
      isnull(d.qtd,0)) as float) as Qtd,
    cast(IsNull(a.Venda,0) -
      (isnull(b.Venda,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.Venda,0)
    		end) + 
      isnull(d.Venda,0)) as float) as Venda,
    cast(IsNull(a.TotalLiquido,0) -
      (isnull(b.TotalLiquido,0) + 
    	--Verifica o parametro do BI
    	(case @ic_devolucao_bi
    		when 'N' then 0
    		else isnull(c.TotalLiquido,0)
    		end) + 
      isnull(d.TotalLiquido,0)) as float) as TotalLiquido  
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
      left outer join  
    #FaturaDevolucao b
  	  on a.cd_produto = b.cd_produto
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_produto = c.cd_produto
      left outer join  
    #FaturaCancelado d
  	  on a.cd_produto = d.cd_produto

  Select  
  	@vl_total_Venda = sum(IsNull(Venda,0))
  From
  	#FaturaResultado

  -- Mostra a Tabela com dados do Mês
  select  
    IDENTITY(int,1,1) as 'Posicao',
    c.nm_categoria_produto,
    sum(a.qtd) as 'qtd',
    Sum(a.Venda) as 'venda',
    sum((a.Venda / @vl_total_Venda) * 100) as Perc,
    sum(a.Pedidos) as 'pedidos',
    sum(a.Clientes) as 'clientes',
    sum(a.TotalLiquido) as 'totalliquido'
  Into
    #Tabela
  from
   	#FaturaResultado a 
  	  left outer join 
    Produto b
      on a.cd_produto = b.cd_produto
      left outer join 
    Categoria_Produto c
      on b.cd_categoria_produto = c.cd_categoria_produto
  Group by nm_categoria_produto
  Order by Venda desc

  Select * from #Tabela Order By Posicao

