
-------------------------------------------------------------------------------
--pr_header_lote_itau_sispag
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_header_lote_itau_sispag
as 
Select
	IDENTITY(Int,1,1) as Teste,
	D.cd_conta_banco,
	D.cd_tipo_pagto_eletronico,
	D.cd_forma_pagto_eletronica,
	B.cd_numero_banco,
	A.cd_numero_agencia_banco,
 	C.cd_dac_conta_banco,
 	C.nm_conta_banco,
	FPE.sg_banco_forma_pagto,
   TPE.sg_banco_tipo_pagto,
	PP.sg_banco,
	PP.cd_cgc_empresa
into
	#header_lote_itau_sispag
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
	D.cd_conta_banco,
	D.cd_tipo_pagto_eletronico,
	D.cd_forma_pagto_eletronica,
	B.cd_numero_banco,
	A.cd_numero_agencia_banco,
 	C.cd_dac_conta_banco,
 	C.nm_conta_banco,
	C.cd_conta_banco,
	FPE.sg_banco_forma_pagto,
   TPE.sg_banco_tipo_pagto,
	PP.sg_banco,
	PP.cd_cgc_empresa

