
CREATE VIEW vw_Detalhe_itau_sispag
------------------------------------------------------------------------------------
--vw_Detalhe_itau_sispag
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
	PP.cd_lote,
	D.cd_documento_pagar,
	D.cd_conta_banco,
	LTrim(Rtrim(nm_codigo_barra_documento)) as nm_codigo_barra_documento,
	Replace(substring(LTrim(Rtrim(nm_codigo_barra_documento)),1,3),'.','')     as cd_banco,
	Replace(substring(LTrim(Rtrim(nm_codigo_barra_documento)),4,1),'.','') 		as cd_moeda,
	(Replace(substring(LTrim(Rtrim(nm_codigo_barra_documento)),5,5),'.','') +
	Replace(substring(LTrim(Rtrim(nm_codigo_barra_documento)),11,21),'.','')) 	as cd_livre,
	Replace(substring(LTrim(Rtrim(nm_codigo_barra_documento)),33,1),'.','') 	as cd_dv,
	Replace(substring(LTrim(Rtrim(nm_codigo_barra_documento)),34,4),'.','') 	as cd_fator,
	Replace(substring(LTrim(Rtrim(nm_codigo_barra_documento)),38,10),'.','') 	as vl_titulo,
	Cast(coalesce(BTMP.sg_tipo_movimento_banco,TMP.sg_tipo_movimento,'0') as int) as cd_tipo_moviment,
	PP.sg_banco
from
	documento_pagar D inner join 
  	conta_agencia_banco c on (c.cd_conta_banco = d.cd_conta_banco) inner join 
	Parametro_Pagamento_Eletronico_Sispag  PP ON (pp.cd_banco = c.cd_banco AND pp.cd_conta_banco = d.cd_conta_banco) left join
	documento_pagar_cod_barra B on (D.cd_documento_pagar = B.cd_documento_pagar)left join
   tipo_movimento_pagamento TMP on (TMP.cd_tipo_movimento = D.cd_tipo_movimento) left join
	banco_tipo_movimento_pagamento BTMP on (BTMP.cd_tipo_movimento = D.cd_tipo_movimento and c.cd_banco = BTMP.cd_banco)
   
where 
	ic_envio_documento = 'S' and
	dt_envio_banco is null
