
CREATE VIEW vw_contmatic_baixa_contas_receber
------------------------------------------------------------------------------------
--sp_helptext vw_contmatic_baixa_contas_receber
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--
--Banco de Dados	: EGISSQL
--
--Objetivo	        : Baixa do Contas a Receber
--
--Data                  : 03.06.2009
--Atualização           : 
--24.06.2009 - Ajustes Diversos - Carlos Fernandes
--12.08.2009 - Ajustes das contas contábeis - Carlos Fernandes
-- 
------------------------------------------------------------------------------------
as

--select * from documento_receber_pagamento
--select * from documento_receber

select
  0                         as Lancamento,      --9999999
  d.cd_identificacao,
  c.nm_fantasia_cliente,
  d.dt_emissao_documento,
  d.dt_vencimento_documento,
  dp.dt_pagamento_documento,
--  dp.dt_pagamento_documento as Data_Pagamento,  --DD/MM
   dbo.fn_strzero(day(dp.dt_pagamento_documento),2) + '/'+
   dbo.fn_strzero(month(dp.dt_pagamento_documento),2) as Data_Pagamento, 

--  cast(0 as varchar(7))     as Debito,

  dbo.fn_strzero(case when isnull(pcb.cd_conta_reduzido,0)>0 then
       pcb.cd_conta_reduzido
  else
       0
  END,7)                                                                                           as Debito,


  dbo.fn_strzero(case when isnull(pc.cd_conta,0)>0 then
     pc.cd_conta_reduzido
  else
     0
   end,7)                      as Credito,

--  cast(0 as varchar(7))     as Credito,
  --dbo.fn_strzero(105,7)         as Credito,

  dp.vl_pagamento_documento as Valor,
  --0                         as Codigo_Historico,
  --'00000'                     as Codigo_Historico,
  dbo.fn_strzero(pf.cd_historico_contabil,5)         as Codigo_Historico,


--select * from documento_receber_pagamento

  cast(rtrim(ltrim(d.cd_identificacao))+' '+dp.nm_obs_documento as varchar(200))  as Complemento,
  cast('' as varchar(42))   as CCDB,    
  cast('' as varchar(42))   as CCCR

    
from
  documento_receber_pagamento dp with (nolock) 
  inner join documento_receber d with (nolock) on d.cd_documento_receber = dp.cd_documento_receber
  inner join Cliente c           with (nolock) on c.cd_cliente           = d.cd_cliente
  left outer join Plano_Conta pc with (nolock) on pc.cd_conta            = c.cd_conta

  left outer join plano_financeiro pf     with (nolock) on pf.cd_plano_financeiro = d.cd_plano_financeiro

  left outer join conta_agencia_banco cab with (nolock) on cab.cd_conta_banco     = dp.cd_conta_banco
  left outer join plano_conta pcb         with (nolock) on pcb.cd_conta           = cab.cd_conta
  
where
  d.cd_portador <> 999 --Carteira --> Verificar

  --Definir as contas contábeis
   
 
