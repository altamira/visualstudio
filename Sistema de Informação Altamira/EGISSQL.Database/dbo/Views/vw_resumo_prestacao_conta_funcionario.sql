
--sp_helptext vw_prestacao_conta

CREATE VIEW vw_resumo_prestacao_conta_funcionario
------------------------------------------------------------------------------------
--sp_helptext vw_resumo_prestacao_conta_funcionario
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra os dados para Montagem da Prestação de Conta
--Data                  : 19.11.2007
--Atualização           : 25.01.2008 - Acerto dos Tipos dos Campos - Carlos Fernandes
-- 25.01.2008 - Acrestar o Total das Despeas - Carlos Fernandes
-- 25.04.2008 - Ajuste Geral - Carlos Fernandes
-- 28.04.2008 - Acerto do Assunto e Total de Despeas - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from prestacao_conta_composicao

Select
     pc.cd_prestacao,
     pc.dt_fechamento_prestacao,
     pc.cd_departamento,
      isnull(fc.cd_funcionario,f.cd_funcionario)           as cd_funcionario,
      isnull(fc.nm_funcionario,f.nm_funcionario)           as nm_funcionario,
      d.nm_departamento,
      c.nm_centro_custo,
      0.00                                                 as qt_prestacao,
      0.00                                                 as vl_prestacao,
      0.00                                                 as vl_pagamento_empresa,
      0.00                                                 as vl_pagamento_funcionario,
      0.00                                                 as vl_despesa_prestacao,
     
      isnull(pcc.vl_total_despesa,0)                       as TotalDespesa,

      0.00                                                 as TotalAdiantamento,
      0.00                                                 as TotalReembolsavel,
      0.00                                                 as TotalNaoReembolsavel


from
    Prestacao_Conta pc                       with (nolock) 
    left join Prestacao_Conta_Composicao pcc with (nolock) on pcc.cd_prestacao        = pc.cd_prestacao
    left join Funcionario F                  with (nolock) on f.cd_funcionario        = pc.cd_funcionario
    left join Funcionario fc                 with (nolock) on fc.cd_funcionario        = pcc.cd_funcionario_composicao
    left join Departamento D                 with (nolock) on d.cd_departamento       = isnull(fc.cd_departamento,f.cd_departamento)
    left join Centro_Custo C                 with (nolock) on c.cd_centro_custo       = isnull(fc.cd_centro_custo,f.cd_centro_custo)
where
  isnull(f.cd_conta,0)<>0

    --left join Solicitacao_Adiantamento sa with (nolock) on sa.cd_prestacao          = pc.cd_prestacao


--select * from prestacao_conta
--select * from solicitacao_adiantamento

