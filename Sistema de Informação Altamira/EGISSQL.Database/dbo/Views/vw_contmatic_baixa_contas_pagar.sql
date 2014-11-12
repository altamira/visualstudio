
CREATE VIEW vw_contmatic_baixa_contas_pagar
------------------------------------------------------------------------------------
--sp_helptext vw_contmatic_baixa_contas_pagar
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--
--Banco de Dados	: EGISSQL
--
--Objetivo	        : Baixa do Contas a Pagar
--
--Data                  : 03.06.2009
--Atualização           : 
-- 24.06.2009 - Complemento - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from documento_pagar_pagamento
--select * from documento_pagar

select
  0                         as Lancamento,      --9999999
  cast(d.cd_identificacao_document as varchar(30)) as documento,
  d.dt_emissao_documento_paga,
  dp.dt_pagamento_documento,
  d.nm_fantasia_fornecedor,

--   cast(day(dp.dt_pagamento_documento) as varchar)+'/'+
--   cast(month(dp.dt_pagamento_documento) as varchar) as Data_Pagamento,  --DD/MM
   dbo.fn_strzero(day(dp.dt_pagamento_documento),2) + '/'+
   dbo.fn_strzero(month(dp.dt_pagamento_documento),2) as Data_Pagamento, 
  
  --Débito
  --Fornecedor
  dbo.fn_strzero(case when isnull(pcf.cd_conta,0)>0 then
     pcf.cd_conta_reduzido
  else
  --Empresa Diversa 
     case when isnull(pce.cd_conta_reduzido,0)>0 then
       pce.cd_conta_reduzido
     else
       --Funcionário
       case when isnull(pfu.cd_conta_reduzido,0)>0 then
         pfu.cd_conta_reduzido
       else
         0
       end
     end
  end,7)                      as Debito,
  --cast(0 as varchar(7))     as Debito,
  dbo.fn_strzero(
  case when isnull(pcb.cd_conta_reduzido,0)>0 then
       pcb.cd_conta_reduzido
  else
       0
  END,7)                                                                                           as Credito,
  --cast(0 as varchar(7))     as Credito,
  dp.vl_pagamento_documento                                                                        as Valor,
  --'00000'                     as Codigo_Historico,
  dbo.fn_strzero(pf.cd_historico_contabil,5)                                                       as Codigo_Historico,
  cast(rtrim(ltrim(d.cd_identificacao_document))+' '+dp.nm_obs_documento_pagar as varchar(200))    as Complemento,
  cast('' as varchar(42))                                                                          as CCDB,    
  cast('' as varchar(42))                                                                          as CCCR,
  cab.nm_conta_banco

--select * from documento_pagar
    
from
  documento_pagar_pagamento dp            with (nolock) 
  inner join documento_pagar d            with (nolock) on d.cd_documento_pagar   = dp.cd_documento_pagar
  left outer join fornecedor f            with (nolock) on f.cd_fornecedor        = d.cd_fornecedor
  left outer join empresa_diversa ed      with (nolock) on ed.cd_empresa_diversa  = d.cd_empresa_diversa
  left outer join plano_conta pcf         with (nolock) on pcf.cd_conta           = f.cd_conta
  left outer join plano_conta pce         with (nolock) on pce.cd_conta           = ed.cd_conta
  left outer join conta_agencia_banco cab with (nolock) on cab.cd_conta_banco     = dp.cd_conta_banco
  left outer join plano_conta pcb         with (nolock) on pcb.cd_conta           = cab.cd_conta
  left outer join plano_financeiro pf     with (nolock) on pf.cd_plano_financeiro = d.cd_plano_financeiro
  left outer join funcionario func        with (nolock) on func.cd_funcionario    = d.cd_funcionario
  left outer join plano_conta pfu         with (nolock) on pfu.cd_conta           = func.cd_conta

--select * from funcionario
--select * from plano_financeiro

  --Definir as contas contábeis

--select * from empresa_diversa    
--select * from documento_pagar
--select * from documento_pagar_pagamento
--select * from conta_agencia_banco

--select * from plano_conta
--select * from fornecedor
 
