create procedure pr_consulta_saldo_estoque_sem_entrada
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Consulta das Saldo de estoque que não tiveram entrada
--Data: 01.04.2004
---------------------------------------------------
@dt_base as datetime
as

  select
    dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto, 
    p.nm_fantasia_produto,
    p.nm_produto,
    fp.sg_fase_produto,
    pf.dt_produto_fechamento as 'dt_fechamento',
    pf.qt_atual_prod_fechamento 
  from
    Produto		p,
    Produto_Fechamento    pf,
    Fase_produto		fp
  where
    p.cd_produto 			= pf.cd_produto 	and
    pf.cd_fase_produto 		= fp.cd_fase_produto 	and
    pf.dt_produto_fechamento 	= @dt_base    	and
    pf.qt_atual_prod_fechamento   > 0			and
    pf.cd_produto not in (select distinct cd_produto
                          from Nota_Entrada_PEPS)
  order by 
    1, 3


