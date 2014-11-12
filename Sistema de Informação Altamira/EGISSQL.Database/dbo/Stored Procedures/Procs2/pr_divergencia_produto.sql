
CREATE PROCEDURE pr_divergencia_produto
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2002                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor : Igor Gama
--Objetivo : Divergência de Saldos dos produtos após fechamento do mesmo
--Data          : 25.05.2004
--------------------------------------------------------------------------------------
@dt_inicial datetime,
@dt_final datetime,
@cd_fase_produto int
as
  
  Select
    pf.cd_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    fp.nm_fase_produto,
    pf.qt_peps_prod_fechamento,
    pf.qt_atual_prod_fechamento,
    pf.qt_terc_prod_fechamento,
    pf.qt_consig_prod_fechamento 
  From
    Produto p
      left outer join
    Produto_Fechamento pf
      on pf.cd_produto = p.cd_produto
      left outer join
    Fase_Produto fp
      on pf.cd_fase_produto = fp.cd_fase_produto
  Where
    pf.qt_peps_prod_fechamento <> pf.qt_atual_prod_fechamento
    and pf.dt_produto_fechamento between @dt_inicial and case When @dt_inicial = @dt_final then @dt_inicial else @dt_final end
    and pf.cd_fase_produto = case When @cd_fase_produto = 0 then pf.cd_fase_produto else @cd_fase_produto end

