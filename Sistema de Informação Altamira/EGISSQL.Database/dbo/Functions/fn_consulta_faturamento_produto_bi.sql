CREATE FUNCTION fn_consulta_faturamento_produto_bi
  (@dt_inicial DateTime, @dt_final DateTime, @cd_moeda int)
RETURNS @Faturamento_produto TABLE 
	(cd_produto int,
   UltimaNota DateTime,
   Notas int,
   QtdItem float,
   Venda float,
   TotalLiquido float,
   vl_ipi float,
   vl_icms float)
as
Begin

  declare	@ic_devolucao_bi char(1)
  
  set @ic_devolucao_bi = 'N'
  
  Select top 1 @ic_devolucao_bi = IsNull(ic_devolucao_bi,'N') from Parametro_BI where cd_empresa = dbo.fn_empresa()
  
  ----------------------------------------------------
  -- Faturamento do Mês Corrente
  ----------------------------------------------------
  Declare @FaturaAnual TABLE 
	(cd_produto int,
   UltimaNota DateTime,
   Notas float,
   QtdItem float,
   Venda float,
   TotalLiquido float,
   vl_ipi float,
   vl_icms float)

  Insert Into @FaturaAnual
  Select 
  	vw.cd_produto,
  	max(vw.dt_nota_saida) as UltimaNota,
    count(distinct(vw.cd_nota_saida)) as Notas,
    sum(vw.qt_item_nota_saida) as QtdItem,
    sum(vw.vl_unitario_item_total) * dbo.fn_vl_moeda(@cd_moeda) as Venda,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
    sum(vw.vl_ipi) vl_ipi,
    Sum(vw.vl_icms_item) vl_icms
  from
    vw_faturamento_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
  	vw.cd_produto
  order by 1 desc
  
  
  ----------------------------------------------------
  -- Devoluções do Mês Corrente
  ----------------------------------------------------
  Declare @FaturaDevolucao TABLE 
	(cd_produto int,
   UltimaNota DateTime,
   Notas float,
   QtdItem float,
   Venda float,
   TotalLiquido float,
   vl_ipi float,
   vl_icms float)

  Insert Into @FaturaDevolucao
  select 
  	vw.cd_produto,
  	max(vw.dt_nota_saida) as UltimaNota,
    count(distinct(vw.cd_nota_saida)) as Notas,
    cast(sum(vw.qt_item_nota_saida) as money) as QtdItem,
    sum(vw.vl_unitario_item_total) * dbo.fn_vl_moeda(@cd_moeda) as Venda,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
    sum(vw.vl_ipi) vl_ipi,
    Sum(vw.vl_icms_item) vl_icms
  from
    vw_faturamento_devolucao_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
    vw.cd_produto
  order by 1 desc
    
  ----------------------------------------------------
  -- Total de Devoluções do Ano Anterior
  ----------------------------------------------------
  Declare @FaturaDevolucaoAnoAnterior TABLE 
	(cd_produto int,
   UltimaNota DateTime,
   Notas float,
   QtdItem float,
   Venda float,
   TotalLiquido float,
   vl_ipi float,
   vl_icms float)

  Insert Into @FaturaDevolucaoAnoAnterior
  select 
  	vw.cd_produto,
  	max(vw.dt_nota_saida) as UltimaNota,
    count(distinct(vw.cd_nota_saida)) as Notas,
    cast(sum(vw.qt_item_nota_saida) as money) as QtdItem,
    sum(vw.vl_unitario_item_total) * dbo.fn_vl_moeda(@cd_moeda) as Venda,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_total , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
    sum(vw.vl_ipi) vl_ipi,
    Sum(vw.vl_icms_item) vl_icms
  from
    vw_faturamento_devolucao_mes_anterior_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
    year(vw.dt_nota_saida) = year(@dt_inicial) and
  	(vw.dt_nota_saida < @dt_inicial) and
  	vw.dt_restricao_item_nota between @dt_inicial and @dt_final
  group by 
  	vw.cd_produto
  order by 1 desc
  
  ----------------------------------------------------
  -- Cancelamento do Mês Corrente
  ----------------------------------------------------
  Declare @FaturaCancelado TABLE 
	(cd_produto int,
   UltimaNota DateTime,
   Notas float,
   QtdItem float,
   Venda float,
   TotalLiquido float,
   vl_ipi float,
   vl_icms float)

  Insert Into @FaturaCancelado
  select 
  	vw.cd_produto,
  	max(vw.dt_nota_saida) as UltimaNota,
    count(distinct(vw.cd_nota_saida)) as Notas,
    cast(sum(vw.qt_item_nota_saida) as money) as QtdItem,
    sum(vw.vl_unitario_item_atual) * dbo.fn_vl_moeda(@cd_moeda) as Venda,
    cast(sum(dbo.fn_vl_liquido_venda('F',vw.vl_unitario_item_atual , vw.vl_icms_item, 
             vw.vl_ipi, vw.cd_destinacao_produto, @dt_inicial)) as money) as TotalLiquido,
    sum(vw.vl_ipi) vl_ipi,
    Sum(vw.vl_icms_item) vl_icms
  from
    vw_faturamento_cancelado_bi vw
      left outer join 
    Produto_Custo pc
      on vw.cd_produto = pc.cd_produto 
  where 
  	vw.dt_nota_saida between @dt_inicial and @dt_final
  group by 
    vw.cd_produto
  order by 1 desc
  
  ----------------------------------
  -- União das tabelas para gerar o resultado esperado
  ----------------------------------
--   Declare @FaturaResultado TABLE 
-- 	(cd_produto int,
--    UltimaNota DateTime,
--    Notas float,
--    QtdItem float,
--    Venda float,
--    TotalLiquido float,
--    vl_ipi float,
--    vl_icms float)

  Insert into @Faturamento_produto
  select 
      a.cd_produto,
      a.UltimaNota,
      a.Notas,
			--Quantidade
  		cast(IsNull(a.QtdItem,0) -
  		    (isnull(b.QtdItem,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			   when 'N' then 0
		 			   else isnull(c.QtdItem,0)
		 			 end) + 
			    isnull(d.QtdItem,0)) as money) as QtdItem,
      --Total de Venda
  		 cast(IsNull(a.Venda,0) -
  		 (isnull(b.Venda,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			when 'N' then 0
		 			else isnull(c.Venda,0)
		 			end) + 
			  isnull(d.Venda,0)) as money) as Venda,
      --Total Líquido
  		cast(IsNull(a.TotalLiquido,0) -
  		 (isnull(b.TotalLiquido,0) + 
   				--Verifica o parametro do BI
					(case @ic_devolucao_bi
		 			when 'N' then 0
		 			else isnull(c.TotalLiquido,0)
		 			end) + 
			  isnull(d.TotalLiquido,0)) as money) as TotalLiquido,
      a.vl_ipi,
      a.vl_icms
  from 
    @FaturaAnual a
  	  left outer join  
    @FaturaDevolucao b
  	  on a.cd_produto = b.cd_produto
      left outer join  
    @FaturaDevolucaoAnoAnterior c
  	  on a.cd_produto = c.cd_produto
      left outer join  
    @FaturaCancelado d
    	on a.cd_produto = d.cd_produto


  Return
end

