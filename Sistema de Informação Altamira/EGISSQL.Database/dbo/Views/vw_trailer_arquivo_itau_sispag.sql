
CREATE VIEW vw_trailer_arquivo_itau_sispag
------------------------------------------------------------------------------------
--vw_trailer_arquivo_itau_sispag
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)       :Márcio Rodrigues 
--Banco de Dados	: EGISSQL 
--Objetivo	      : Seleciona dados da empresa para o SAM
--Data            : 10.04.2006
--Atualização     : 
------------------------------------------------------------------------------------
as

Select
	PP.cd_lote as Qtd_lote,
	Count(*) as Qtd_registro
from
	documento_pagar D inner join 	
  	conta_agencia_banco c on (c.cd_conta_banco = d.cd_conta_banco) inner join 
	agencia_banco a on c.cd_agencia_banco = a.cd_agencia_banco inner join
  	banco b on c.cd_banco = b.cd_banco inner join
	Parametro_Pagamento_Eletronico_Sispag  PP ON pp.cd_banco = b.cd_banco inner join 
	banco_tipo_pagto_eletronico TPE on (TPE.cd_banco = C.cd_banco and D.cd_tipo_pagto_eletronico = TPE.cd_tipo_pagto_eletronico) inner join
	banco_forma_pagto_eletronica FPE on (FPE.cd_banco = C.cd_banco and D.cd_forma_pagto_eletronica = FPE.cd_forma_pagto_eletronica)
where 
	ic_envio_documento = 'S' and
	dt_envio_banco is null
group by
	PP.cd_lote

