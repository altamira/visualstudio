
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
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_fluxo_caixa_entrada_saida
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--Verificar se os Valores Pagos devem ser Considerados no Fluxo
--Carlos 22.11.2005

declare @ic_pagamento_fluxo char(1)

select
  @ic_pagamento_fluxo = isnull(ic_pagamento_fluxo,'N')
from
  Parametro_Financeiro
where
  cd_empresa = dbo.fn_empresa()


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

into #DocumentoPagamento
FROM         
  Documento_Receber_Pagamento drp left outer join
  Documento_Receber dr on drp.cd_documento_receber = dr.cd_documento_receber LEFT OUTER JOIN
  Portador p           on dr.cd_portador = p.cd_portador LEFT OUTER JOIN
  Cliente c            on dr.cd_cliente = c.cd_cliente        LEFT OUTER JOIN
  Plano_Financeiro pf on pf.cd_plano_financeiro = dr.cd_plano_financeiro

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

into #Documento

FROM         
  Documento_Receber dr with (nolock)
   LEFT OUTER JOIN Portador p  ON dr.cd_portador = p.cd_portador
   LEFT OUTER JOIN Cliente c    ON dr.cd_cliente  = c.cd_cliente
   LEFT OUTER JOIN Plano_Financeiro pf on pf.cd_plano_financeiro = dr.cd_plano_financeiro
  
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
  delete from #Documento where isnull(vl_saldo_documento,0) = 0
end

--Adiciona os Documentos Pagos
select * into #DocReceber from #DocumentoPagamento

--Todos os Documentos
insert into #DocReceber 
  select * from #Documento

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

drop table #DocumentoPagamento
drop table #Documento
drop table #DocReceber


