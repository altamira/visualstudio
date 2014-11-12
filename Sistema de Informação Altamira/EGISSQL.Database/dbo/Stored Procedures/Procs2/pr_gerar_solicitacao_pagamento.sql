
CREATE PROCEDURE pr_gerar_solicitacao_pagamento
---------------------------------------------------
--GBS - Global Business Solution	       2001
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Danilo Campoi
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Solicitação de Pagamento
--Data          : 01/03/2006
--Atualizado    :  
---------------------------------------------------
@cd_solicitacao_pagamento int,
@dt_inicial            datetime,
@dt_final              datetime
                                                               
AS
   -- Traz Todas as Solicitações de Pagamento
  if (@cd_solicitacao_pagamento = 0)                      
     Begin  

       select a.cd_solicitacao , a.dt_solicitacao , dt_necessidade,nm_departamento,nm_usuario,
              nm_centro_custo,nm_tipo_solicitacao,dt_vencimento
       from   solicitacao_pagamento a 
      left outer join departamento b                on b.cd_departamento = a.cd_departamento
      left outer join usuario c                     on c.cd_usuario = a.cd_usuario
      left outer join centro_custo d                on d.cd_centro_custo = a.cd_centro_custo
      left outer join tipo_solicitacao_pagamento e  on e.cd_tipo_solicitacao = a.cd_tipo_solicitacao
      where a.dt_solicitacao  between @dt_inicial and @dt_final
      order by 
      a.cd_solicitacao desc 
    End




-- =============================================
-- Testando a procedure
-- =============================================
--EXECUTE pr_gerar_solicitacao_pagamento 0,'01/01/1999', '01/12/2006'
