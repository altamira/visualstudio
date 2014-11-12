
CREATE PROCEDURE pr_fatura_cli_vend_estado

----------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	          2002
----------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server    2000
--Autor(es)     : Igor
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Categoria.
--Data          : 27.04.2004
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 19.02.2009 - Ajustes Diversos - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
@cd_pais    int = 1,
@cd_estado  int = 0,
@dt_inicial dateTime,
@dt_final   dateTime,
@ic_filtro  char(1),
@cd_moeda   int = 1,
@cd_cidade  int = 0
as
  declare 
    @ic_devolucao_bi char(1),
    @vl_total_Venda  float

  set @ic_devolucao_bi = 'N'

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )

  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI with (nolock) 
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
    case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end as 'codigo',
    sum(vw.vl_unitario_item_total) / @vl_moeda                            as 'Venda',
    sum(vw.qt_item_nota_saida)                                            as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                                     as  'Pedidos'
  into 
    #FaturaAnual
  from
    vw_faturamento_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente           = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais   = @cd_pais   or @cd_pais = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
    and vwd.cd_cidade  = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end

  order by 1, 2 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
  	case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end as 'codigo',
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos'
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
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
    and vwd.cd_cidade = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end
  order by 1, 2 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
  	case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end as 'codigo',
    sum(vw.vl_unitario_item_total) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos'
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
    and vwd.cd_cidade = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end
  order by 1, 2 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
  	case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end as 'codigo',
    sum(vw.vl_unitario_item_atual) / @vl_moeda as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos'
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
    and (vwd.cd_pais   = @cd_pais   or @cd_pais = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
    and vwd.cd_cidade = (case @cd_cidade when 0 then vwd.cd_cidade else @cd_cidade end )
  group by 
  	case When @ic_filtro = 'C' then vw.cd_cliente Else vw.cd_vendedor end
  order by 1, 2 desc


  select 
    a.codigo,
    a.Pedidos,
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
  	  on a.codigo = b.codigo
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.codigo = c.codigo
      left outer join  
    #FaturaCancelado d
  	  on a.codigo = d.codigo

  Select  
  	@vl_total_Venda = sum(IsNull(Venda,0))
  From
  	#FaturaResultado

  -- Mostra a Tabela com dados do Mês
  select  
    IDENTITY(int,1,1) as 'Posicao',
    b.nm_fantasia as 'Nome',
    sum(a.qtd) as 'qtd',
    Sum(a.Venda) as 'venda',
    sum((a.Venda / @vl_total_Venda) * 100) as Perc,
    sum(a.Pedidos) as 'pedidos',
    sum(a.TotalLiquido) as 'totalliquido'
  Into
    #Tabela
  from
   	#FaturaResultado a 
  	  left outer join 
    vw_destinatario b
      on a.codigo = b.cd_destinatario and
         b.cd_tipo_destinatario = case When @ic_filtro = 'C' then 1 Else 3 end
  Group by nm_fantasia
  Order by Venda desc

  Select * from #Tabela Order By Posicao

