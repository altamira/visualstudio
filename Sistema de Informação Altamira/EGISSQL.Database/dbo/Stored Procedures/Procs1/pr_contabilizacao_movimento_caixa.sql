
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Carlos Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Consulta da Contabilização da Movimentação de Caixa
--Data           : 28.03.2006
--Atualizado     : 28.03.2006
--               : 
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_contabilizacao_movimento_caixa


@cd_tipo_caixa  int = 0,
@dt_inicio      dateTime ,
@dt_Fim         dateTime


AS

--Geração da contabilização do Caixa

select 
  c.cd_lancamento_caixa,
  case when isnull(c.cd_conta_debito,0) = 0 then isnull(tc.cd_conta,0) 
                                            else c.cd_conta_debito  end as cd_conta_debito,

  case when isnull(c.cd_conta_credito,0) = 0 then isnull(pf.cd_conta,0) 
                                            else c.cd_conta_credito end as cd_conta_credito
into
 #ContaCaixa

from 
  caixa_lancamento c
  left outer join plano_financeiro pf on pf.cd_plano_financeiro = c.cd_plano_financeiro
  left outer join Tipo_Caixa tc   on tc.cd_tipo_caixa = c.cd_tipo_caixa
where 
    isnull(c.cd_tipo_caixa,0) = case when isnull(@cd_tipo_caixa ,0)= 0  
                                     then isnull(c.cd_tipo_caixa,0) 
                                     else isnull(@cd_tipo_caixa,0 ) end and 
    isnull(c.dt_lancamento_caixa, getdate()) between case when isnull(@dt_inicio, '') = '' 
                                                          then isnull(c.dt_lancamento_caixa, getdate()) 
                                                          else isnull(@dt_inicio,'') end and                                                  
																										 case when isnull(@dt_fim, '') = '' 
                                                          then isnull(c.dt_lancamento_caixa, getdate()) 
                                                          else isnull(@dt_fim, '')end


--Atualiza a Conta Contábil na tabela de Caixa_Lançamento

update
  Caixa_Lancamento
set
  cd_conta_debito  = cc.cd_conta_debito,
  cd_conta_credito = cc.cd_conta_credito
from
  Caixa_Lancamento cl, #ContaCaixa cc
where
  cl.cd_lancamento_caixa = cc.cd_lancamento_caixa


--select * from #ContaCaixa


select 
  c.vl_lancamento_caixa,
  c.cd_lancamento_caixa,
  m.nm_moeda,
  cd_mascara_plano_financeiro  as 'Classificacao',  
  pf.nm_conta_plano_financeiro as 'conta', 
  c.dt_lancamento_caixa,
  c.nm_historico_lancamento,
  cast(null as varchar(60))    as 'nm_complemento',
  c.cd_tipo_operacao,
  tpf.sg_tipo_operacao,
  case tpf.sg_tipo_operacao  
    when 'E' then c.vl_lancamento_caixa
    else 0.00
  end as 'vl_entrada',                       --Débito
  case tpf.sg_tipo_operacao  
    when 'S' then c.vl_lancamento_caixa
    else 0.00
  end as 'vl_saida',                         --Crédito
  cc.cd_conta_debito,
  cc.cd_conta_credito,
  pcd.cd_conta_reduzido as cd_reduzido_debito,
  pcc.cd_conta_reduzido as cd_reduzido_credito,
  pcd.nm_conta          as nm_conta_debito,
  pcc.nm_conta          as nm_conta_credito,
  pcd.cd_mascara_conta  as cd_mascara_debito,
  pcc.cd_mascara_conta  as cd_mascara_credito

--select * from plano_conta
 
from 
  caixa_lancamento c
  inner join #ContaCaixa cc on cc.cd_lancamento_caixa = c.cd_lancamento_caixa
  left outer join tipo_operacao_financeira tpf on c.cd_tipo_operacao = tpf.cd_tipo_operacao
  left outer join  plano_financeiro pf         on pf.cd_plano_financeiro = c.cd_plano_financeiro
  left outer join Moeda m                      on m.cd_moeda = c.cd_moeda
  left outer join Tipo_Caixa tc                on tc.cd_tipo_caixa = c.cd_tipo_caixa
  left outer join Plano_Conta pcd              on pcd.cd_conta     = cc.cd_conta_debito
  left outer join Plano_Conta pcc              on pcc.cd_conta     = cc.cd_conta_credito
where 
    isnull(c.cd_tipo_caixa,0) = case when isnull(@cd_tipo_caixa ,0)= 0  
                                     then isnull(c.cd_tipo_caixa,0) 
                                     else isnull(@cd_tipo_caixa,0 ) end and 
    isnull(c.dt_lancamento_caixa, getdate()) between case when isnull(@dt_inicio, '') = '' 
                                                          then isnull(c.dt_lancamento_caixa, getdate()) 
                                                          else isnull(@dt_inicio,'') end and                                                  
																										 case when isnull(@dt_fim, '') = '' 
                                                          then isnull(c.dt_lancamento_caixa, getdate()) 
                                                          else isnull(@dt_fim, '')end



