CREATE PROCEDURE pr_inventario_revenda_nao_peps
--pr_inventario_revenda_nao_peps
---------------------------------------------------
--GBS - Global Business Solution               2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(s): Daniel Carrasco 
--Banco de Dados: EGISSQL
--Objetivo: Consultar Produtos de Revenda.
--Data        : 01/11/2004
--Atualização : 08/11/2004
-- 15.03.2005 - OS: 0-SCI-041104-1808 - Clelson Camargo
---------------------------------------------------
@dt_base datetime

as
  declare @cd_mes_base int
  declare @dt_inicial datetime

  select @cd_mes_base = datepart(mm,@dt_base)

  if @cd_mes_base = (select datepart(mm,(@dt_base+1)))
    raiserror('Para esta consulta é necessário escolher o último dia do mês!',16, 1)
  else  
  begin
    select @dt_inicial = cast(cast(datepart(mm,(@dt_base-1)) as varchar)+
                              '/01/'+
                              cast(datepart(yyyy,(@dt_base-1)) as varchar) as datetime)

	  select     
	    p.cd_produto as Codigo,
		dbo.fn_mascara_produto(p.cd_produto) as Mascara,
		p.nm_produto as Produto, 
		p.nm_fantasia_produto as Fantasia, 
		un.sg_unidade_medida as UN, 
		pf.qt_atual_prod_fechamento as Saldo,
	    pf.cd_fase_produto as CodFase, 
		fp.nm_fase_produto as Fase, 
		0 as Nota, 
		cast(null as datetime) as Data, 
	    cast(null as decimal(25,2)) as VlUnitario,
		cast((((IsNull(pf.vl_custo_prod_fechamento, pc.vl_custo_produto) *
	            IsNull(mv.pc_metodo_valoracao,0))/100) * 
	            IsNull(mv.qt_metodo_valoracao,0)) as decimal(25,2)) as Custo,
	    cast(p.vl_produto as decimal(25,2)) as PrecoLista,
		cast(null as decimal(25,2)) as Total
	  into
	    #RevendaNaoPEPS
	  from         
		Produto p Left outer join
		Unidade_Medida un ON p.cd_unidade_medida = un.cd_unidade_medida Left outer join
		Produto_Fechamento pf ON p.cd_produto = pf.cd_produto Left outer join
		Fase_Produto fp ON fp.cd_fase_produto = pf.cd_fase_produto Left outer join
		Grupo_Produto gp ON p.cd_grupo_produto = gp.cd_grupo_produto Left outer join
		Produto_Custo pc ON p.cd_produto = pc.cd_produto left outer join
	    Metodo_Valoracao mv on pc.cd_metodo_valoracao = mv.cd_metodo_valoracao
	  where
	    pf.dt_produto_fechamento = @dt_base and
	    IsNull(p.ic_revenda_produto, gp.ic_revenda_grupo_produto) = 'S' and
	    IsNull(pf.qt_atual_prod_fechamento,0) > 0
	    and IsNull(pc.ic_peps_produto,'N') = 'N'
	
	select
	  nsad.cd_produto as Codigo, 
	  nsad.cd_fase_produto as CodFase, 
	  nsad.cd_nota_saida as NotaSaida,
	  ns.dt_nota_saida as Data,
	  cast(nsad.vl_unitario_max as decimal(25,2)) as VlUnitario
	into #MaiorNotaFiscal
	from
	  nota_saida ns,
	  (select 
	     max(nsa.cd_nota_saida) as cd_nota_saida, 
	     nsax.cd_produto, 
	     nsax.cd_fase_produto, 
	     nsax.vl_unitario_max
	   from
	     Nota_Saida_Item nsa,
	    (select nsi.cd_produto, nsi.cd_fase_produto, max(nsi.vl_unitario_item_nota) as vl_unitario_max
	     from nota_saida ns, nota_saida_item nsi
	     where ns.cd_nota_saida = nsi.cd_nota_saida and ns.dt_nota_saida < @dt_inicial
	     group by nsi.cd_produto, nsi.cd_fase_produto) nsax
	   where
	     nsa.cd_produto = nsax.cd_produto and
	     nsa.cd_fase_produto = nsax.cd_fase_produto and
	     nsa.vl_unitario_item_nota = nsax.vl_unitario_max
	     group by nsax.cd_produto, nsax.cd_fase_produto, nsax.vl_unitario_max) nsad
	where nsad.cd_nota_saida = ns.cd_nota_saida
	
	  update #RevendaNaoPEPS
	  set Nota = m.NotaSaida,
	      Data = m.Data,
	      VlUnitario = m.VlUnitario,
	      Total = Saldo * m.VlUnitario
	  from #RevendaNaoPEPS r, #MaiorNotaFiscal m
	  where r.Codigo = m.Codigo and r.CodFase = m.CodFase
	
	  select * from #RevendaNaoPEPS
	  order by Fase, Mascara
  end
