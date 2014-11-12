
--sp_helptext vw_prestacao_conta

CREATE VIEW vw_resumo_prestacao_conta_composicao
------------------------------------------------------------------------------------
--sp_helptext vw_resumo_prestacao_conta_composicao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra os dados para Montagem da Prestação de Conta
--                        a partir dos itens
--Data                  : 19.11.2007
--Atualização           : 25.01.2008 - Acerto dos Tipos dos Campos - Carlos Fernandes
-- 25.01.2008 - Acrestar o Total das Despeas - Carlos Fernandes
-- 25.04.2008 - Ajuste Geral - Carlos Fernandes
-- 28.04.2008 - Acerto do Assunto e Total de Despeas - Carlos Fernandes
-- 11.08.2008 - Fornecedor - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from prestacao_conta_composicao

Select
      td.nm_tipo_despesa,
      isnull(td.ic_reembolsavel_despesa,'S') as ic_reembolsavel_despesa,
      pcc.cd_item_prestacao,
      pcc.cd_tipo_despesa,
      pcc.qt_item_despesa,
      pcc.dt_item_despesa,
      pcc.vl_item_despesa,
      pcc.vl_total_despesa,
      pcc.cd_documento_despesa,
      pcc.ic_tipo_pagamento_despesa,
      pcc.nm_obs_item_despesa,
      pcc.cd_tipo_cartao_credito,
      --pcc.cd_projeto_viagem,
      pcc.ic_projeto_despesa,
      pcc.nm_projeto_viagem,
      pcc.cd_cliente,
      pcc.nm_cliente_despesa, 
      pcc.ic_imposto_despesa,
      --pcc.cd_centro_custo,
      pcc.ic_tipo_lancamento,
      pcc.ic_comprovante,
      pc.*,
      tpc.nm_tipo_prestacao,
      mpc.nm_motivo_prestacao,
      f.cd_chapa_funcionario,
      f.nm_funcionario         as Fornecedor,
      f.cd_fornecedor,
      case when isnull(f.cd_conta,0)=0
      then
        f.nm_funcionario
      else
        isnull(fc.nm_funcionario,f.nm_funcionario) 
      end                                          as nm_funcionario,
      f.nm_setor_funcionario,
      f.cd_agencia_funcionario,
      f.cd_conta_funcionario,
      f.cd_banco,
      b.nm_banco,
      d.nm_departamento,
      c.nm_centro_custo,
      c.sg_centro_custo,
    tcc.nm_cartao_credito,
      m.nm_fantasia_moeda,
      rv.nm_local_viagem, 
      rv.dt_inicio_viagem,
      rv.dt_fim_viagem,
      cast(isnull(pv.nm_projeto_viagem,'') as varchar(40))             as nm_projeto_viagem_cadastro,
      isnull(pv.cd_identificacao_projeto,0)                            as cd_identificacao_projeto,
     av.nm_assunto_viagem,
     tv.nm_tipo_viagem,

     case when isnull(pcc.nm_projeto_viagem,'')<>'' then
       pcc.nm_projeto_viagem
     else
       cast(isnull(pv.nm_projeto_viagem,'') as varchar(40))   
     end                                                               as nm_projeto_consistido,
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
     isnull(pc.vl_despesa_prestacao,0)  as vl_total_despesa_prestacao

     --isnull(sa.vl_adiantamento,0)       as vl_adiantamento

from
    Prestacao_Conta_Composicao pcc        with (nolock) 
    inner join Prestacao_Conta       pc   with (nolock) on pc.cd_prestacao          = pcc.cd_prestacao
    left join Tipo_Prestacao_Conta   tpc  with (nolock) on (pc.cd_tipo_prestacao    = tpc.cd_tipo_prestacao) 
    left join Funcionario F               with (nolock) on (f.cd_funcionario        = pc.cd_funcionario) 
    left join Departamento D              with (nolock) on (d.cd_departamento       = pc.cd_departamento) 
    left join Centro_Custo C              with (nolock) on (c.cd_centro_custo       = case when isnull(pcc.cd_centro_custo,0)=0 then pc.cd_centro_custo else pcc.cd_centro_custo end )
    left join Tipo_Cartao_Credito tcc     with (nolock) on tcc.cd_cartao_credito    = pc.cd_cartao_credito
    left join Projeto_Viagem pv           with (nolock) on pv.cd_projeto_viagem     = case when isnull(pcc.cd_projeto_viagem,0)=0 then pc.cd_projeto_viagem else pcc.cd_projeto_viagem end   
    left join Requisicao_Viagem rv        with (nolock) on rv.cd_requisicao_viagem  = pc.cd_requisicao_viagem 
    left join Moeda M                     with (nolock) on (m.cd_moeda              = pc.cd_moeda) 
    left join Banco b                     with (nolock) on b.cd_banco               = f.cd_banco
    left join Motivo_Prestacao_Conta mpc  with (nolock) on (mpc.cd_motivo_prestacao = pc.cd_motivo_prestacao) 
    left join Assunto_Viagem av           with (nolock) on (pc.cd_assunto_viagem    = av.cd_assunto_viagem) 
    left join Tipo_Viagem tv              with (nolock) on (tv.cd_tipo_viagem       = rv.cd_tipo_viagem) 
    left join Tipo_Despesa td             with (nolock) on (td.cd_tipo_despesa      = pcc.cd_tipo_despesa) 
    left join Funcionario fc              with (nolock) on  fc.cd_funcionario       = pcc.cd_funcionario_composicao

--                                                            and isnull(td.ic_reembolsavel_despesa,'S') = 'S')

    --left join Solicitacao_Adiantamento sa with (nolock) on sa.cd_prestacao          = pc.cd_prestacao


--select * from prestacao_conta_composicao
--select * from solicitacao_adiantamento

