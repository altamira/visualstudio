
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                     2006
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Consulta da Contabilização da Movimentação de Viagem
--Data           : 25.04.2006
--Atualizado     : 25.04.2006
--               : 
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_contabilizacao_movimento_viagem


@cd_tipo_despesa_viagem  int      = 0,
@dt_inicial              datetime = '',
@dt_final                datetime = ''


AS

--Geração da contabilização do Movimento de Viagem

--select * from requisicao_viagem_prestacao

select 
  r.cd_requisicao_viagem,
  case when isnull(r.cd_conta_debito,0) = 0 then isnull(tdv.cd_conta,0) 
                                            else r.cd_conta_debito  end as cd_conta_debito,

  case when isnull(r.cd_conta_credito,0) = 0 then isnull(tp.cd_conta,0) 
                                            else r.cd_conta_credito end as cd_conta_credito
into
 #ContaRV

from 
  requisicao_viagem_prestacao r
  left outer join tipo_despesa_viagem tdv     on tdv.cd_despesa_viagem  = r.cd_tipo_despesa_viagem
  left outer join plano_financeiro pf         on pf.cd_plano_financeiro = tdv.cd_plano_financeiro
  left outer join tipo_pagamento_documento tp on tp.cd_tipo_pagamento   = r.cd_tipo_pagamento
where 
    isnull(r.cd_tipo_despesa_viagem,0) = case when isnull(@cd_tipo_despesa_viagem,0)= 0  
                                     then isnull(r.cd_tipo_despesa_viagem,0) 
                                     else isnull(@cd_tipo_despesa_viagem,0 ) end
    and r.dt_prestacao_viagem between @dt_inicial and @dt_final


--select * from #ContaRV
--select * from tipo_despesa_viagem

select 
  r.vl_prestacao_req_viagem    as 'Valor',
  r.cd_requisicao_viagem       as 'Requisicao',
  m.nm_moeda                   as 'Moeda',
  cd_mascara_plano_financeiro  as 'Classificacao',  
  pf.nm_conta_plano_financeiro as 'Conta', 
  r.dt_prestacao_viagem        as 'Dataprestacao',  
  r.nm_historico_prestacao     as 'Historico', 
  cast(null as varchar(60))    as 'Complemento',

  case when cc.cd_conta_debito>0  
       then r.vl_prestacao_req_viagem
       else 0.00
  end as 'Debito',                       --Débito

  case when cc.cd_conta_debito>0  
        then r.vl_prestacao_req_viagem
        else 0.00
  end as 'Credito',                         --Crédito

  cc.cd_conta_debito           as ContaDebito,
  cc.cd_conta_credito          as ContaCredito,
  pcd.cd_conta_reduzido        as cd_reduzido_debito,
  pcc.cd_conta_reduzido        as cd_reduzido_credito,
  pcd.nm_conta                 as nm_conta_debito,
  pcc.nm_conta                 as nm_conta_credito,
  pcd.cd_mascara_conta         as cd_mascara_debito,
  pcc.cd_mascara_conta         as cd_mascara_credito


from 
  requisicao_viagem_prestacao r
  inner join #ContaRV cc on cc.cd_requisicao_viagem = r.cd_requisicao_viagem
  left outer join Moeda m                      on m.cd_moeda             = r.cd_moeda
  left outer join Tipo_Despesa_Viagem tdv      on tdv.cd_despesa_viagem  = r.cd_tipo_despesa_viagem
  left outer join plano_financeiro pf          on pf.cd_plano_financeiro = tdv.cd_plano_financeiro
  left outer join Plano_Conta pcd              on pcd.cd_conta           = cc.cd_conta_debito
  left outer join Plano_Conta pcc              on pcc.cd_conta           = cc.cd_conta_credito
where 
    isnull(r.cd_tipo_despesa_viagem,0) = case when isnull(@cd_tipo_despesa_viagem,0)= 0  
                                     then isnull(r.cd_tipo_despesa_viagem,0) 
                                     else isnull(@cd_tipo_despesa_viagem,0 ) end and 
    r.dt_prestacao_viagem between @dt_inicial and @dt_final




