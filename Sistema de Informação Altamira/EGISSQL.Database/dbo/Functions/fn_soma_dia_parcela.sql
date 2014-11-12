
---------------------------------------------------------------------------------------
--fn_soma_dia_parcela
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Autor
--Banco de Dados	: EGISSQL ou EGISADMIN
--Objetivo		: 
--
--Data			: 13/04/2004
--Atualização           : 
---------------------------------------------------------------------------------------

create function fn_soma_dia_parcela
(@cd_condicao_pagamento int)
returns int

as

begin

  declare @qt_soma_dia_parcela int
  declare @qt_parcela          int
  
  select 
    @qt_parcela = count(cd_condicao_pagamento) 
  from
    condicao_pagamento_parcela
  where
     cd_condicao_pagamento = @cd_condicao_pagamento

  select 
    @qt_soma_dia_parcela = sum( isnull(qt_dia_cond_parcela_pgto,0) )
  from
    condicao_pagamento_parcela
  where
     cd_condicao_pagamento = @cd_condicao_pagamento
  

  --select * from condicao_pagamento
  --select * from condicao_pagamento_parcela

  if @qt_parcela>0
     set @qt_soma_dia_parcela = @qt_soma_dia_parcela/@qt_parcela
    

  RETURN(@qt_soma_dia_parcela)

end

