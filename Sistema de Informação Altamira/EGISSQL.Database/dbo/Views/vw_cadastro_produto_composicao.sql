CREATE view vw_cadastro_produto_composicao as

select
cd_produto_pai,
cd_produto,
cd_item_produto,
qt_item_produto,
qt_produto_composicao,
qt_peso_liquido_produto,
qt_peso_bruto_produto,
cd_ordem_produto,
cd_fase_produto,
cd_materia_prima,
cd_bitola,
cd_usuario,
dt_usuario,
nm_obs_produto_composicao,
ic_calculo_peso_produto,
pc_composicao_produto,
ic_montagemg_produto,
ic_montagemq_produto,
ic_tipo_montagem_produto,
cd_versao_produto_comp,
cd_ordem_produto_comp,
cd_produto_composicao,
cd_versao_produto,
nm_produto_comp

from
		Produto_Composicao



