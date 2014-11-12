
CREATE PROCEDURE pr_resumo_produto_pais
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Igor
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Estado.
--Data          : 27.04.2004
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.

---------------------------------------------------
@cd_pais    int = 1,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1
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
  	IsNull(vwd.cd_pais,0) cd_pais,
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																	as TotalLista  
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw   left outer join
    vw_destinatario vwd  on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario left join
    Produto p  on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
  group by 
  	IsNull(vwd.cd_pais,0),
  	vw.cd_produto
  order by 1, 2 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_produto,
  	IsNull(vwd.cd_pais,0) cd_pais,
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																	as TotalLista  
  into 
    #FaturaDevolucao
  from
    vw_faturamento_devolucao_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario left join
    Produto p  on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
  group by 
  	IsNull(vwd.cd_pais,0),
  	vw.cd_produto
  order by 1, 2 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	vw.cd_produto,
  	IsNull(vwd.cd_pais,0) cd_pais,
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																	as TotalLista  
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario left join
    Produto p  on vw.cd_produto = p.cd_produto
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
  group by 
  	vw.cd_produto,
  	IsNull(vwd.cd_pais,0)
  order by 1, 2 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	vw.cd_produto,
  	IsNull(vwd.cd_pais,0) cd_pais,
    sum(vw.vl_unitario_item_atual) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
  	sum(p.vl_produto * vw.qt_item_nota_saida) / @vl_moeda 																	as TotalLista  
  into 
    #FaturaCancelado
  from
    vw_faturamento_cancelado_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario left join
    Produto p  on vw.cd_produto = p.cd_produto
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais = @cd_pais or @cd_pais = 0) 
  group by 
  	vw.cd_produto,
  	IsNull(vwd.cd_pais,0)
  order by 1, 2 desc


  select 
  	 a.cd_produto,
    a.cd_pais,
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
      isnull(d.TotalLiquido,0)) as float) as TotalLiquido  ,
        --Total de Lista
    		cast(IsNull(a.TotalLista,0) -
    		 (isnull(b.TotalLista,0) + 
     				--Verifica o parametro do BI
  					(case @ic_devolucao_bi
  		 			when 'N' then 0
  		 			else isnull(c.TotalLista,0)
  		 			end) + 
  			  isnull(d.TotalLista,0)) as money) as TotalLista
  into 
  	#FaturaResultado
  from 
    #FaturaAnual a
      left outer join  
    #FaturaDevolucao b
  	  on a.cd_pais = b.cd_pais and a.cd_produto = b.cd_produto
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_pais = c.cd_pais  and a.cd_produto = c.cd_produto
      left outer join  
    #FaturaCancelado d
  	  on a.cd_pais = d.cd_pais  and a.cd_produto = d.cd_produto

  Select  
  	@vl_total_Venda = sum(IsNull(Venda,0))
  From
  	#FaturaResultado

  -- Mostra a Tabela com dados do Mês
  select  
    IDENTITY(int,1,1) as 'Posicao',
    dbo.fn_mascara_produto(b.cd_produto) as 'cd_mascara_produto',  
	 b.nm_fantasia_produto,  
    b.nm_produto,  
    un.sg_unidade_medida,
    isnull(c.nm_pais,'Sem país') as nm_pais,
    a.qtd,
    a.Venda,
    a.TotalLiquido,
    a.TotalLista
  Into
    #Tabela
  from
   	#FaturaResultado a  left outer join 
    	Pais c      on a.cd_pais = c.cd_pais left join
      Produto b   on a.cd_produto = b.cd_produto  left outer join   
    	Unidade_Medida un on un.cd_unidade_medida = b.cd_unidade_medida
  Order by Venda desc

  Select * from #Tabela Order By Posicao
