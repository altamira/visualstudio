
--sp_helptext vw_prestacao_conta

CREATE VIEW vw_resumo_prestacao_conta
------------------------------------------------------------------------------------
--vw_resumo_prestacao_conta
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

Select
      pc.*,
      tpc.nm_tipo_prestacao,
      mpc.nm_motivo_prestacao,
      f.cd_chapa_funcionario,
      f.nm_funcionario,
      f.cd_fornecedor,
      f.nm_setor_funcionario,
      f.cd_agencia_funcionario,
      f.cd_conta_funcionario,
      f.cd_banco,
      b.nm_banco,
      d.nm_departamento,
      c.nm_centro_custo,
    tcc.nm_cartao_credito,
      m.nm_fantasia_moeda,
      rv.nm_local_viagem, 
      rv.dt_inicio_viagem,
      rv.dt_fim_viagem,
      pv.nm_projeto_viagem,
     pv.cd_identificacao_projeto,
     av.nm_assunto_viagem,
     tv.nm_tipo_viagem,
     isnull(pc.vl_prestacao,0) * case when pc.vl_prestacao<0 then -1 else 1 end as vl_prestacao_corrigido,

     case when pc.ic_tipo_deposito_prestacao='F' 
     then
       isnull(pc.vl_prestacao,0)
     else
       0.00
     end                                as vl_pagamento_funcionario,

     case when pc.ic_tipo_deposito_prestacao='E'
     then
       isnull(pc.vl_prestacao,0) * -1
     else
       0.00
     end                                as vl_pagamento_empresa,
     isnull(pc.vl_despesa_prestacao,0)  as vl_total_despesa_prestacao,
     isnull(f.cd_conta,0)               as cd_conta

     --isnull(sa.vl_adiantamento,0)       as vl_adiantamento

from
    Prestacao_Conta pc                    with (nolock) 
    left join Tipo_Prestacao_Conta   tpc  with (nolock) on (pc.cd_tipo_prestacao    = tpc.cd_tipo_prestacao) 
    left join Funcionario F               with (nolock) on (f.cd_funcionario        = pc.cd_funcionario) 
    left join Departamento D              with (nolock) on (d.cd_departamento       = pc.cd_departamento) 
    left join Centro_Custo C              with (nolock) on (c.cd_centro_custo       = pc.cd_centro_custo)
    left join Tipo_Cartao_Credito tcc     with (nolock) on tcc.cd_cartao_credito    = pc.cd_cartao_credito
    left join Projeto_Viagem pv           with (nolock) on pv.cd_projeto_viagem     = pc.cd_projeto_viagem  
    left join Requisicao_Viagem rv        with (nolock) on rv.cd_requisicao_viagem  = pc.cd_requisicao_viagem 
    left join Moeda M                     with (nolock) on (m.cd_moeda              = pc.cd_moeda) 
    left join Banco b                     with (nolock) on b.cd_banco               = f.cd_banco
    left join Motivo_Prestacao_Conta mpc  with (nolock) on (mpc.cd_motivo_prestacao = pc.cd_motivo_prestacao) 
    left join Assunto_Viagem av           with (nolock) on (pc.cd_assunto_viagem    = av.cd_assunto_viagem) 
    left join Tipo_Viagem tv              with (nolock) on (tv.cd_tipo_viagem       = rv.cd_tipo_viagem) 
    --left join Solicitacao_Adiantamento sa with (nolock) on sa.cd_prestacao          = pc.cd_prestacao


--select * from prestacao_conta
--select * from solicitacao_adiantamento

