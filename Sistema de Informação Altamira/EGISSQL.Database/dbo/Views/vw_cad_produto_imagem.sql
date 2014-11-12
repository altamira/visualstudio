CREATE view vw_cad_produto_imagem as

select
		cd_produto,
		cd_produto_imagem,
		nm_imagem_produto,
		cd_usuario,
		dt_usuario,
		cd_tipo_imagem_produto

from
		Produto_Imagem



