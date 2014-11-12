
-------------------------------------------------------------------------------
--sp_helptext pr_contabilizacao_baan_fornecedor
-------------------------------------------------------------------------------
--pr_contabilizacao_baan_acerto_prestacao_conta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Contabilização do Financeiro para o Sistema BAAN
--Data             : 28.05.2007
--Alteração        : 05.06.2007
--                 : 06.06.2007 - Prestação de Contas
--                 : 14.09.2007 - Acerto do Funcionário - Carlos Fernandes
--                   24.09.2007 - Complemento - Carlos Fernandes.
--                   27.09.2007 - Flag para controle da confirmação da contabilização
--                   22.10.2007 - Mudança conta CPMF para tirar o Setor - Carlos Fernandes/
--                   26.10.2007 - CPMF, colocar outros - Carlos Fernandes
--                   05.11.2007 - Centro de Custo do Item da Despesa - Carlos Fernadnes
--                   12.11.2007 - Funcionário Histórico - Carlos Fernandes
-- 14.11.2007 - Histórico - Carlos Fernandes
-- 26.12.2007 - Acerto espaço - Nome do Funcionário - Carlos Fernandes
-- 04.07.2008 - Ajuste do processo para Fornecedor - Carlos Fernandes
-- 15.09.2008 - Alteração do histórico - Crédito - Carlos Fernandes
--            - Número do Depósito - Carlos Fernandes
-- 07.07.2010 - Ajustes Diversos, está dobrando valor Crédito - Carlos Fernandes
-----------------------------------------------------------------------------------------
create procedure pr_contabilizacao_baan_fornecedor
@ic_parametro    int      = 1,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@cd_centro_custo int      = 0

as

-------------------------------------------------------------------------------
--Parâmetro Contas a Receber
-------------------------------------------------------------------------------
declare @cd_conta_fornecedor int 

select
  @cd_conta_fornecedor = isnull(cd_conta_fornecedor,0)
from
  parametro_prestacao_conta with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

-------------------------------------------------------------------------------
--Crédito da Prestação de Contas
-------------------------------------------------------------------------------

--select * from prestacao_conta
--select * from prestacao_conta_contabil

select
  p.cd_prestacao,  

  --Crédito

  d.cd_mascara_conta                    as CONTA,

  cast(null as varchar)                 as SETOR,

  cast(null as varchar)                 as PROJETO,

  cast(null as varchar)                 as CCUSTO,

  isnull(a.vl_contab_prestacao,0)       as VALOR,
  'C'                                   as TIPO,
  cast(null as varchar)                 as FORNEC,
  cast(null as varchar)                 as CLIENTE,

  case when isnull(p.cd_nota_entrada,0)>0
  then
   --cast('NF '+cast(p.cd_nota_entrada as varchar)+ ' '+ rtrim(ltrim(isnull(f.nm_funcionario,''))) as varchar(40))
   cast('C: '+CAST(cd.cd_deposito as varchar(6)) + ' PAGTO. FORNECEDOR' as varchar) 
  else
    cast(rtrim(ltrim(isnull(a.nm_historico_contabil,'')))+' '+
    rtrim(ltrim(isnull(f.nm_funcionario,'')))        as varchar(40)) 
  end                                              as HISTORICO

into
  #FinanceiroBaanCredito
from
  --select * from prestacao_conta_contabil where cd_prestacao = 1804
  Prestacao_Conta_Contabil a          with (nolock) 
  left outer join Prestacao_Conta p   on p.cd_prestacao         = a.cd_prestacao
  left outer join plano_conta d       on d.cd_conta             = case when @cd_conta_fornecedor<>0 
                                                                  then
                                                                    @cd_conta_fornecedor
                                                                  else
                                                                    a.cd_conta_debito
                                                                  end

  left outer join Centro_Custo cc      on cc.cd_centro_custo     = isnull(a.cd_centro_custo,p.cd_centro_custo)
  left outer join Funcionario f        on f.cd_funcionario       = p.cd_funcionario
  left outer join Projeto_Viagem proj  on proj.cd_projeto_viagem = a.cd_projeto_viagem
  left outer join Controle_Deposito cd on cd.cd_prestacao        = p.cd_prestacao and
                                          cd.cd_deposito         = case when isnull(p.cd_deposito,0)>0 then
                                                                     p.cd_deposito
                                                                  else
                                                                     cd.cd_deposito
                                                                  end  

where
  a.dt_contab_prestacao between @dt_inicial and @dt_final and
  isnull(a.cd_conta_debito,0)>0                    and
  isnull(a.ic_contabilizado_fornecedor,'N') = 'N'  and
  isnull(a.ic_cartao_credito,'N')           = 'N'  and
  p.dt_pagamento_prestacao is not null  and
  --Fornecedor
  isnull(f.cd_conta,0)>0
 
order by
  a.dt_contab_prestacao

--select * from #FinanceiroBaanDebito

-------------------------------------------------------------------------------
--Débito da Prestação de Contas
-------------------------------------------------------------------------------

select
  p.cd_prestacao,  

  --Dédito

  c.cd_mascara_conta                    as CONTA,
  cast(isnull(f.cd_identificacao_funcionario,f.cd_registro_funcionario) as varchar) as SETOR,

--  cc.cd_mascara_centro_custo            as SETOR,
--   case when sa.cd_tipo_adiantamento = 2 then
--     'CAIXA'
--   else
--     ''
--   end                                   as SETOR,

  cast(null as varchar)                            as PROJETO,
  cast(null as varchar)                            as CCUSTO,
  isnull(a.vl_contab_prestacao,0)                  as VALOR,
  'D'                                              as TIPO,
  cast(null as varchar)                            as FORNEC,
  cast(null as varchar)                            as CLIENTE,

  case when isnull(p.cd_nota_entrada,0)>0
  then
   cast('NF '+cast(p.cd_nota_entrada as varchar)+ ' '+ rtrim(ltrim(isnull(f.nm_funcionario,''))) as varchar(40))
  else
    cast(rtrim(ltrim(isnull(a.nm_historico_contabil,'')))+' '+
    rtrim(ltrim(isnull(f.nm_funcionario,'')))        as varchar(40)) 
  end                                              as HISTORICO

into
  #FinanceiroBaanDebito
from
  Prestacao_Conta_Contabil a            with (nolock) 
  left outer join Prestacao_Conta p     on p.cd_prestacao         = a.cd_prestacao
  left outer join plano_conta c         on c.cd_conta             = a.cd_conta_credito
  left outer join Centro_Custo cc       on cc.cd_centro_custo     = a.cd_centro_custo
  left outer join Funcionario f         on f.cd_funcionario       = p.cd_funcionario
  left outer join Projeto_Viagem proj   on proj.cd_projeto_viagem = p.cd_projeto_viagem

where
  a.dt_contab_prestacao between @dt_inicial and @dt_final and
  isnull(a.cd_conta_credito,0)>0                   and
  isnull(a.ic_contabilizado_fornecedor,'N') = 'N'  and
  isnull(a.ic_cartao_credito,'N')= 'N' and
  p.dt_pagamento_prestacao is not null  and
  --Fornecedor
  isnull(f.cd_conta,0)>0


order by
  a.dt_contab_prestacao

--Montagem da Tabela Débito/Crédito

-- select
--   *
-- from 
--   #FinanceiroBaanDebito
-- union all
--   select * from #FinanceiroBaanCredito

select
  max(cd_prestacao)            as cd_prestacao,
  CONTA,
  MAX(SETOR)                   AS SETOR,
  MAX(PROJETO)                 AS PROJETO,
  MAX(CCUSTO)                  AS CCUSTO,
  SUM(ISNULL(VALOR,0))         AS VALOR,
  TIPO,
  MAX(FORNEC)                  AS FORNEC,
  MAX(CLIENTE)                 AS CLIENTE,   
  --'PC N. '+cast(cd_prestacao as varchar(8)) as HISTORICO
  cast(MAX(HISTORICO) as varchar(40))    as HISTORICO
into
  #ContabCredito
from 
  #FinanceiroBaanCredito
GROUP BY
--  cd_prestacao,
  CONTA,
  TIPO

select
  *
from 
  #ContabCredito
union all
  select * from #FinanceiroBaanDebito

--select * from #ContabDebito
   

