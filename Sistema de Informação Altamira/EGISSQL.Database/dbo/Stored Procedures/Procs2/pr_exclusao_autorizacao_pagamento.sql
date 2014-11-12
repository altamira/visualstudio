
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_autorizacao_pagamento
-------------------------------------------------------------------------------
--pr_exclusao_autorizacao_pagamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Exclusão Completa da Autorização de Pagamento - AP
--Data             : 09.11.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_exclusao_autorizacao_pagamento
@cd_ap int = 0
as

if @cd_ap>0
begin

  delete from autorizacao_pagamento_contabil where cd_ap = @cd_ap   

  delete from autorizacao_pagto_composicao   where cd_ap = @cd_ap

  delete from autorizacao_pagamento          where cd_ap = @cd_ap

end


