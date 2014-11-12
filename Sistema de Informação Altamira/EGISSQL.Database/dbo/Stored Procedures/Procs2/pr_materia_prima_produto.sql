Create procedure pr_materia_prima_produto
----------------------------------------------------------------
--pr_materia_prima_produto
----------------------------------------------------------------
--GBS - Global Business Sollution Ltda                      2004
----------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Banco de Dados      : Sql Server 2000
--Autor               : André Gati
--Data                : 18/02/2005
--Objetivo            : Consulta de produto por matéria-prima
--Atualização         : 
-----------------------------------------------------------------------------------
@cd_materia_prima int = 0 
as

select
	mp.sg_mat_prima as 'MateriaPrima',
	gp.nm_grupo_produto as 'GrupoProduto',
	p.cd_produto as 'Codigo',
    p.nm_fantasia_produto as 'Fantasia',
    p.nm_produto as 'Produto',
	um.nm_unidade_medida as 'Unidade',
    pc.vl_custo_produto as 'Custo',
    pc.dt_custo_produto as 'Data'
from produto p
	left outer join materia_prima mp on mp.cd_mat_prima=p.cd_materia_prima
	left outer join produto_custo pc on pc.cd_produto=p.cd_produto
	left outer join grupo_produto gp on gp.cd_grupo_produto=p.cd_grupo_produto
	left outer join unidade_medida um on um.cd_unidade_medida=p.cd_unidade_medida
	left outer join produto_composicao po on po.cd_produto=p.cd_produto
where
	p.cd_materia_prima = case when @cd_materia_prima=0
								then p.cd_materia_prima
								else @cd_materia_prima end
						

