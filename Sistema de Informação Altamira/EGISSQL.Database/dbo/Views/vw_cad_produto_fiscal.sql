CREATE view vw_cad_produto_fiscal as

select
		cd_produto,
		cd_destinacao_produto,
		cd_dispositivo_legal_ipi,
		cd_dispositivo_legal_icms,
		cd_tipo_produto,
		cd_procedencia_produto,
		cd_classificacao_fiscal,
		cd_tributacao,
		cd_usuario,
		dt_usuario,
		pc_aliquota_iss_produto,
		pc_aliquota_icms_produto,
		ic_substrib_produto,
		qt_aliquota_icms_produto,
		pc_interna_icms_produto,
		ic_isento_icms_produto
from
		Produto_Fiscal



