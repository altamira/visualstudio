
create procedure pr_busca_operacao_fiscal_pedido_compra
@cd_produto     			int,
@cd_destinacao_produto      int,
@cd_estado					int
as

declare @cd_fiscal_tipo_produto char(5),
		@ic_zona_franca char(1),
		@cd_digito_fiscal_entrada varchar,
		@cd_mascara_operacao_fiscal varchar(20)

--Define informações fiscais do último produto definido na nota de entrada
Select top 1 @cd_fiscal_tipo_produto = t.cd_fiscal_tipo_produto
from
	Produto_fiscal pf
inner join
	Tipo_Produto t
on t.cd_tipo_produto = pf.cd_tipo_produto	
where
	cd_produto = @cd_produto

--Define se é zona franca
Select top 1 @ic_zona_franca = ic_zona_franca,
			 @cd_digito_fiscal_entrada = cd_digito_fiscal_entrada
from
	Estado_Parametro
where
	cd_estado = @cd_estado

set @cd_mascara_operacao_fiscal = IsNull(@cd_digito_fiscal_entrada,'') + '.' + IsNull(@cd_fiscal_tipo_produto,'')

select
  top 1 
  cd_operacao_fiscal
from
  Operacao_Fiscal
where
  replace(cd_mascara_operacao,'.','')    = replace(@cd_mascara_operacao_fiscal,'.','') and
  cd_destinacao_produto  = @cd_destinacao_produto        and
  ic_zfm_operacao_fiscal = @ic_zona_franca  
