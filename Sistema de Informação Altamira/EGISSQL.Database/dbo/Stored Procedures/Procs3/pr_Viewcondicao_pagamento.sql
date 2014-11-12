

/****** Object:  Stored Procedure dbo.pr_Viewcondicao_pagamento    Script Date: 13/12/2002 15:08:10 ******/
CREATE PROCEDURE pr_Viewcondicao_pagamento
AS
SELECT     cop.cd_condicao_pagamento, cop.nm_condicao_pagamento, cop.sg_condicao_pagamento, cop.qt_parcela_condicao_pgto, 
                      copp.cd_condicao_parcela_pgto, copp.pc_condicao_parcela_pgto, copp.qt_dia_cond_parcela_pgto, copp.ic_ipi_cond_parcela_pgto
FROM         Condicao_Pagamento cop INNER JOIN
                      condicao_pagamento_parcela copp ON cop.cd_condicao_pagamento = copp.cd_condicao_pagamento


