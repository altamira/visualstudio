CREATE view vw_cad_produto_agrupamento as

select
		cd_agrupamento_produto,
		nm_agrupamento_produto,
		sg_agrupamento_produto,
		cd_usuario,
		dt_usuario
from
		Produto_Agrupamento


