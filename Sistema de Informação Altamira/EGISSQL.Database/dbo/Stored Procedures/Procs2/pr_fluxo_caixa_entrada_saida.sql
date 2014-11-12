
-------------------------------------------------------------------------------
--sp_helptext pr_fluxo_caixa_entrada_saida
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Fluxo de Caixa por Entrada/Saída
--Data             : 03.03.2008
--Alteração        : 21.10.2008
--
--
------------------------------------------------------------------------------
create procedure pr_fluxo_caixa_entrada_saida
@ic_parametro int    = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

--Verificar se os Valores Pagos devem ser Considerados no Fluxo
--Carlos 22.11.2005

declare @ic_pagamento_fluxo char(1)

select
  @ic_pagamento_fluxo = isnull(ic_pagamento_fluxo,'N')
from
  Parametro_Financeiro with (nolock) 
where
  cd_empresa = dbo.fn_empresa()


------------------------------------------------------------------------------
--Documentos a Receber
------------------------------------------------------------------------------

if @ic_parametro = 1

begin

SELECT     
  dr.cd_identificacao, 
  drp.dt_pagamento_documento as dt_vencimento_documento, 
  dr.cd_cliente, 
  c.nm_fantasia_cliente, 
  ( isnull(drp.vl_pagamento_documento, 0) ) 
--Comentado Carlos 11.09.2007
--           - isnull(drp.vl_juros_pagamento, 0)     
--          + isnull(drp.vl_desconto_documento, 0) + isnull(drp.vl_abatimento_documento, 0)
--          - isnull(drp.vl_despesa_bancaria, 0)+ isnull(drp.vl_reembolso_documento, 0)
--          - isnull(drp.vl_credito_pendente, 0)) 

                                                     as vl_documento_receber, 
  p.nm_portador,
  dr.vl_saldo_documento,
  dr.dt_emissao_documento,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  drp.dt_pagamento_documento

into #DocumentoReceberPagamento
FROM         
  Documento_Receber_Pagamento drp with (nolock) left outer join
  Documento_Receber dr            with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber LEFT OUTER JOIN
  Portador p                      with (nolock) on dr.cd_portador = p.cd_portador LEFT OUTER JOIN
  Cliente c                       with (nolock) on dr.cd_cliente = c.cd_cliente        LEFT OUTER JOIN
  Plano_Financeiro pf             with (nolock) on pf.cd_plano_financeiro = dr.cd_plano_financeiro

where
  @ic_pagamento_fluxo = 'S' and
  drp.dt_pagamento_documento between @dt_inicial and @dt_final and
  isnull(dr.cd_lote_receber,0)=0
order by
  drp.dt_pagamento_documento desc

SELECT     
  dr.cd_identificacao, 
  dr.dt_vencimento_documento, 
  dr.cd_cliente, 
  c.nm_fantasia_cliente, 
  case when IsNull(dr.vl_saldo_documento,0)=0 then
       case when @ic_pagamento_fluxo = 'S' 
            then dr.vl_documento_receber
            else 0.00 end
  else
       dr.vl_saldo_documento end        as vl_documento_receber, 
  p.nm_portador,
  dr.vl_saldo_documento,
  dr.dt_emissao_documento,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  null as  dt_pagamento_documento

into #DocumentoReceber

FROM         
  Documento_Receber dr                with (nolock)
  LEFT OUTER JOIN Portador p          with (nolock) on dr.cd_portador = p.cd_portador
  LEFT OUTER JOIN Cliente c           with (nolock) on dr.cd_cliente  = c.cd_cliente
  LEFT OUTER JOIN Plano_Financeiro pf with (nolock) on pf.cd_plano_financeiro = dr.cd_plano_financeiro
  
where
  isnull(dr.cd_lote_receber,0)=0 and
  dbo.fn_dia_util(( dr.dt_vencimento_documento + IsNull(p.qt_credito_efetivo,0) ),'S','U')
  between @dt_inicial and @dt_final and
 ((dr.dt_cancelamento_documento is null) or (dr.dt_cancelamento_documento > @dt_final)) and
 ((dr.dt_devolucao_documento    is null) or (dr.dt_devolucao_documento    > @dt_final)) and
  dr.vl_saldo_documento > 0 and
  dr.cd_documento_receber not in ( select cd_documento_receber from documento_receber_desconto )

order by
  dt_vencimento_documento desc

--deleta os documentos pagos
if @ic_pagamento_fluxo = 'N' 
begin
  delete from #DocumentoReceber where isnull(vl_saldo_documento,0) = 0
end

--Adiciona os Documentos Pagos
select * into #DocReceber from #DocumentoReceberPagamento

--Todos os Documentos
insert into #DocReceber 
  select * from #DocumentoReceber

SELECT  
  cd_identificacao, 
  dt_vencimento_documento, 
  cd_cliente, 
  nm_fantasia_cliente, 
  sum(IsNull(vl_documento_receber,0)) as vl_documento_receber ,
  nm_portador,
  dt_emissao_documento,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
into
  #aux1
from
  #DocReceber
group by
  cd_identificacao, 
  dt_vencimento_documento, 
  cd_cliente, 
  nm_fantasia_cliente, 
  nm_portador,
  dt_emissao_documento,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
order by
  dt_vencimento_documento desc

select 
  (select count(*)  from #DocReceber) as TotalReg,
  (select sum(IsNull(vl_documento_receber,0)) from #DocReceber) as TotalValor,
  a.*
from
  #aux1 a
  
drop table #DocumentoReceberPagamento
drop table #DocumentoReceber
drop table #aux1

--drop table #DocReceber

end

------------------------------------------------------------------------------
--Documentos a Pagar
------------------------------------------------------------------------------

if @ic_parametro = 2
begin
  --select * from documento_pagar

SELECT     
  dp.cd_identificacao_document as cd_identificacao, 
  dp.dt_vencimento_documento, 
  IsNull( isnull(dpp.vl_pagamento_documento,0)+
    isnull(dpp.vl_juros_documento_pagar,0)-
    isnull(dpp.vl_desconto_documento,0)-
    isnull(dpp.vl_abatimento_documento,0),0) as vl_documento_pagar,
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.dt_emissao_documento_paga,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
 dpp.dt_pagamento_documento

into #DocumentoPagarPagamento

FROM         
  Documento_Pagar_Pagamento dpp       with (nolock) left outer join
  Documento_Pagar dp                  with (nolock) on dp.cd_documento_pagar = dpp.cd_documento_pagar
  left outer join Plano_Financeiro pf with (nolock) on pf.cd_plano_financeiro = dp.cd_plano_financeiro
where
  ( dpp.dt_pagamento_documento between @dt_inicial and @dt_final ) and
  dp.cd_documento_pagar not in ( select cd_documento_pagar from documento_pagar_plano_financ )
order by
 dpp.dt_pagamento_documento desc

SELECT     
  cd_identificacao_document as cd_identificacao, 
  dt_vencimento_documento, 
  isnull(dp.vl_saldo_documento_pagar,0) as vl_documento_pagar,
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.dt_emissao_documento_paga,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  null as dt_pagamento_documento

into #DocumentoPagar

FROM         
  Documento_Pagar dp                  with (nolock) 
  left outer join Plano_Financeiro pf with (nolock) on pf.cd_plano_financeiro = dp.cd_plano_financeiro

where
  ( dbo.fn_dia_util( dp.dt_vencimento_documento,'S','U') between @dt_inicial and @dt_final ) and
  ((dp.dt_cancelamento_documento is null) or (dp.dt_cancelamento_documento > @dt_final)) and
  ((dp.dt_devolucao_documento is null) or (dp.dt_devolucao_documento > @dt_final)) and
  isnull(dp.vl_saldo_documento_pagar,0) > 0 and
  dp.cd_documento_pagar not in ( select cd_documento_pagar from documento_pagar_plano_financ )

order by
 dp.dt_vencimento_documento desc

SELECT     
  cd_identificacao_document as cd_identificacao, 
  dt_vencimento_documento, 
  isnull(dpf.vl_plano_financeiro,0) as vl_documento_pagar,
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.dt_emissao_documento_paga,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  ( select top 1 dt_pagamento_documento from documento_pagar_pagamento where cd_documento_pagar = dpf.cd_documento_pagar ) as dt_pagamento_documento

into #DocumentoPagarRateado

FROM         
  documento_pagar_plano_financ dpf              with (nolock) 
  inner join Documento_Pagar dp                 with (nolock) on dp.cd_documento_pagar  = dpf.cd_documento_pagar
  left outer join Plano_Financeiro pf           with (nolock) on pf.cd_plano_financeiro = dpf.cd_plano_financeiro

where
  ( dbo.fn_dia_util( dp.dt_vencimento_documento,'S','U') between @dt_inicial and @dt_final ) and
  ((dp.dt_cancelamento_documento is null) or (dp.dt_cancelamento_documento > @dt_final)) and
  ((dp.dt_devolucao_documento is null)    or (dp.dt_devolucao_documento > @dt_final)) 
order by
 dp.dt_vencimento_documento desc

select * 
into 
  #DocPagar 
from 
  #DocumentoPagarPagamento

insert into #DocPagar 
  select * from #DocumentoPagar

insert into #DocPagar 
  select * from #DocumentoPagarRateado

select
  cd_identificacao                as cd_identificacao, 
  dt_vencimento_documento, 
  sum(vl_documento_pagar)         as vl_documento_pagar,
  nm_favorecido,
  dt_emissao_documento_paga,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
into
  #aux2
from
  #DocPagar
group by
  cd_identificacao, 
  dt_vencimento_documento, 
  nm_favorecido,
  dt_emissao_documento_paga,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
order by
 dt_vencimento_documento desc

select
  (select count(*)  from #DocPagar) as TotalReg,
  (select sum(IsNull(vl_documento_pagar,0)) from #DocPagar) as TotalValor,
  a.*
from
  #aux2 a

drop table #aux2 
drop table #DocumentoPagarPagamento
drop table #DocumentoPagar
drop table #DocPagar
drop table #DocumentoPagarRateado

end

------------------------------------------------------------------------------
--Tabela Geral
------------------------------------------------------------------------------
-- select
--   identity(int,1,1)            as cd_controle,
--   --r.*,
--   --p.*,
--   r.cd_identificacao            as cd_identificacao_receber,
--   r.dt_vencimento_documento     as dt_vencimento_receber,
--   r.nm_fantasia_cliente,
--   r.vl_documento_receber,
--   r.nm_portador,
--   r.vl_saldo_documento,
--   r.dt_emissao_documento,
--   r.cd_mascara_plano_financeiro as cd_mascara_receber,
--   r.nm_conta_plano_financeiro   as nm_plano_receber,
--   r.dt_pagamento_documento      as dt_pagamento_receber,
-- 
--   p.cd_identificacao            as cd_identificacao_pagar,
--   p.dt_vencimento_documento     as dt_vencimento_pagar,
--   p.vl_documento_pagar,
--   p.nm_favorecido,
--   p.dt_emissao_documento_paga,
--   p.cd_mascara_plano_financeiro as cd_mascara_pagar,
--   p.nm_conta_plano_financeiro   as nm_plano_pagar,
--   p.dt_pagamento_documento      as dt_pagamento_pagar
-- into
--   #Movimento
-- from
--   #DocReceber r
--   full outer join #DocPagar p on  p.dt_vencimento_documento = r.dt_vencimento_documento
-- order by
--  r.dt_vencimento_documento desc, 
--  p.dt_vencimento_documento desc
-- 
-- select
--   m.*
-- from
--   #Movimento m
-- order by
--  m.dt_vencimento_receber desc, 
--  m.dt_vencimento_pagar   desc
-- 
