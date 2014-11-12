
CREATE VIEW vw_nextel_exportacao_condicao_pagamento
------------------------------------------------------------------------------------
--vw_nextel_exportacao_condicao_pagamento
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Douglas de Paula Lopes
--Banco de Dados	: EGISSQL
--Objetivo	        : Remessa nextel condicao pagamento.
--Data                  : 22/07/2008  
--Atualização           : 19.11.2008 - Filtro para somente as condições selecionadas para 
--                        Exportação conforme flag do Cadastro - Carlos Fernandes
------------------------------------------------------------------------------------
as
select
  cast(cp.nm_condicao_pagamento as varchar(50)) as DESCR,
  cast(cpp.qt_dia_cond_parcela_pgto as int(2))  as DIAS
from
  condicao_pagamento cp                          with (nolock) 
  left outer join condicao_pagamento_parcela cpp with(nolock) on cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento 
where
  isnull(cp.ic_exporta_cond_pagamento,'N')='S'

