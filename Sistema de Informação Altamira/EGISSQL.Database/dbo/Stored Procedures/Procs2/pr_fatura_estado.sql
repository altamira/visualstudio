
CREATE PROCEDURE pr_fatura_estado
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Igor
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Estado.
--Data          : 27.04.2004
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.
-- 19.02.2009 - Ajustes Diversos - Carlos Fernandes
-- 03.07.2010 - Ajuste de Dev. Mês Anterior - Carlos Fernandes

------------------------------------------------------------------------------------------------------
@cd_pais    int = 1,
@cd_estado  int = 0,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1
as


  declare @dt_inicio_periodo datetime

  set
      @dt_inicio_periodo = cast( cast(month(@dt_final) as char(02))+'/'+'01'+'/'+cast(year(@dt_final) as char(04)) as datetime )

  set
      @dt_inicio_periodo = convert(datetime,left(convert(varchar,@dt_inicio_periodo,121),10)+' 00:00:00',121)

  declare 
    @ic_devolucao_bi char(1),
    @vl_total_Venda  float

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )


  set @ic_devolucao_bi = 'N'
  
  Select 
  	top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N')
  from 
  	Parametro_BI with (nolock) 
  where
  	cd_empresa = dbo.fn_empresa()

  Select 
    IsNull(vwd.cd_pais,0)                                                 as cd_pais,
    IsNull(vwd.cd_estado,0)                                               as cd_estado,
    sum(vw.vl_unitario_item_total) / @vl_moeda                            as 'Venda',
    sum(vw.qt_item_nota_saida)                                            as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, @dt_inicial))  as  'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                                     as  'Pedidos',
    count(distinct(vw.cd_cliente))                                        as  'Clientes' 
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
    and (vwd.cd_pais   = @cd_pais   or @cd_pais   = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
  group by 
    isNull(vwd.cd_pais,0),
    IsNull(vwd.cd_estado,0)
  order by 1, 2 desc

  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  select 
    IsNull(vwd.cd_pais,0) cd_pais,
    IsNull(vwd.cd_estado,0) cd_estado,
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
    and (vwd.cd_pais   = @cd_pais   or @cd_pais = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
  group by 
  	IsNull(vwd.cd_pais,0),
    IsNull(vwd.cd_estado,0)
  order by 1, 2 desc

  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  select 
    IsNull(vwd.cd_pais,0)                                       as cd_pais,
    IsNull(vwd.cd_estado,0)                                     as cd_estado,
    sum(vw.vl_unitario_item_total) / @vl_moeda                  as 'Venda',
    sum(vw.qt_item_nota_saida)                                  as 'Qtd',
    sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total / @vl_moeda, 
                                 vw.vl_icms_item, vw.vl_ipi, 
                                 vw.cd_destinacao_produto, vw.dt_restricao_item_nota))  as 'TotalLiquido',
    count(distinct(vw.cd_nota_saida))                           as  'Pedidos',
    count(distinct(vw.cd_cliente))                              as  'Clientes' 
  into 
    #FaturaDevolucaoAnoAnterior
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join
    vw_destinatario vwd
     on vw.cd_cliente           = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario
  where 
--    year(vw.dt_nota_saida) = year(@dt_inicial) 
--  	(vw.dt_nota_saida < @dt_inicial) and

   year(vw.dt_restricao_item_nota) = year(@dt_inicial) 

    and vw.dt_nota_saida < @dt_inicio_periodo 

    --and vw.dt_restricao_item_nota < @dt_inicio_periodo 

    and vw.dt_restricao_item_nota between @dt_inicial and @dt_final
    and (vwd.cd_pais   = @cd_pais   or @cd_pais   = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)

  group by 
    IsNull(vwd.cd_pais,0),
    IsNull(vwd.cd_estado,0)
  order by 1, 2 desc

  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  select 
    IsNull(vwd.cd_pais,0)                                       as cd_pais,
    IsNull(vwd.cd_estado,0)                                     as cd_estado,
    sum(vw.vl_unitario_item_atual) / @vl_moeda                  as 'Venda',
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
     on vw.cd_cliente           = vwd.cd_destinatario and
        vw.cd_tipo_destinatario = vwd.cd_tipo_destinatario
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
    and (vwd.cd_pais   = @cd_pais   or @cd_pais   = 0) 
    and (vwd.cd_estado = @cd_estado or @cd_estado = 0)
  group by 
  	IsNull(vwd.cd_pais,0),
    IsNull(vwd.cd_estado,0)
  order by 1, 2 desc

--select * from vw_destinatario

  select 
    a.cd_pais,
    a.cd_estado,
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
  	  on a.cd_pais = b.cd_pais and a.cd_estado = b.cd_estado
      left outer join  
    #FaturaDevolucaoAnoAnterior c
  	  on a.cd_pais = c.cd_pais and a.cd_estado = c.cd_estado
      left outer join  
    #FaturaCancelado d
  	  on a.cd_pais = d.cd_pais and a.cd_estado = d.cd_estado

  Select  
  	@vl_total_Venda = sum(IsNull(Venda,0))
  From
  	#FaturaResultado

  -- Mostra a Tabela com dados do Mês

  select  
    IDENTITY(int,1,1) as 'Posicao',
    a.cd_pais, 
    a.cd_estado,
    c.nm_pais,
    b.sg_estado,
    a.Venda,
    a.qtd,
    a.TotalLiquido,
    ((a.Venda / @vl_total_Venda) * 100) as Perc,
    a.Pedidos,
    a.Clientes
  Into
    #Tabela
  from
   	#FaturaResultado a 
  	  left outer join 
    Pais c
      on a.cd_pais = c.cd_pais
      left outer join
    Estado b
      on a.cd_pais = b.cd_pais and a.cd_estado = b.cd_estado
  Order by Venda desc


  Select * from #Tabela Order By Posicao

