CREATE view vw_cad_agrupamento_produto as

select
		cd_agrupamento_produto,
		nm_agrupamento_produto,
		sg_agrupamento_produto,
		cd_usuario,
		dt_usuario,
		cd_agrupamento_prod_pai
from
		Agrupamento_Produto



