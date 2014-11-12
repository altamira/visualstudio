

/****** Object:  Stored Procedure dbo.pr_acerto_data_debito_pagamento_bordero    Script Date: 13/12/2002 15:08:10 ******/
create procedure pr_acerto_data_debito_pagamento_bordero
@cd_bordero varchar(4),
@dt_liquidacao datetime
as

begin

UPDATE 
DOCUMENTO_PAGAR_PAGAMENTO 
SET DT_PAGAMENTO_DOCUMENTO = @dt_liquidacao 
WHERE CD_IDENTIFICA_DOCUMENTO = @cd_bordero AND CD_TIPO_PAGAMENTO = 1

update bordero
set dt_liquidacao_bordero = @dt_liquidacao
where
  cd_bordero = cast(@cd_bordero as int)

end

-- exec pr_acerto_data_debito_pagamento_bordero '2926', '02/13/2002'


