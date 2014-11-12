
create procedure pr_inventario_produto_padrao
---------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		    : Paulo Santos
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de Inventário Produto Padrão
--Data			: 28/10/2004
-- 01/11/2004 - Inclusão dos parâmetros da STP - ELIAS
-- 15.03.2005 - Substituído qt_peso_liquido por p.qt_peso_bruto - Clelson Camargo
---------------------------------------------------
@cd_grupo_estoque int,
@dt_inicial datetime,
@dt_final datetime

AS

  select f.nm_fase_produto as Fase,
         mp.nm_mat_prima as MateriaPrima,
         ge.nm_grupo_estoque as GrupoEstoque,
         p.nm_fantasia_produto as Fantasia,
         p.nm_produto as Descricao,
         cast(pf.qt_atual_prod_fechamento as decimal(25,4)) as Qtde,
         cast((pf.qt_atual_prod_fechamento * isnull(p.qt_peso_bruto,0)) as decimal(25,4)) as Peso,
         cast((pf.qt_atual_prod_fechamento * pc.vl_custo_produto) as decimal(25,2))as Custo
  from Produto p 
       left outer join Produto_Fechamento pf on p.cd_produto = pf.cd_produto
       left outer join Fase_Produto f on pf.cd_fase_produto = f.cd_fase_produto
       left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto
       left outer join Materia_Prima mp on pc.cd_mat_prima = p.cd_materia_prima
       left outer join Grupo_Estoque ge on ge.cd_grupo_estoque = pc.cd_grupo_estoque
  where pf.dt_produto_fechamento = @dt_final and
        (isnull(pf.qt_atual_prod_fechamento,0) <> 0) and 
        isnull(ge.cd_grupo_estoque,0) = case when (isnull(@cd_grupo_estoque,0)=0) 
                                        then isnull(ge.cd_grupo_estoque,0)
                                        else isnull(@cd_grupo_estoque,0) end  
  order by f.nm_fase_produto, ge.nm_grupo_estoque, mp.nm_mat_prima, p.nm_fantasia_produto

