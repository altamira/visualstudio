

CREATE PROCEDURE pr_diario_duplicata_aberto
--------------------------------------------------------------------
--pr_diario_duplicata_aberto
-------------------------------------------------------------------- 
--GBS - Global Business Solution Ltda                           2004
--------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000 
--Autor(es)           : Daniel C. Neto 
--Banco de Dados      : EGISSQL 
--Objetivo            : Consultar Diario de Duplicatas em Aberto por Cliente.
--Data                : 30/09/2002 
--                    : 01/10/2002 - Acertos de Filtro - Daniel C. Neto.
--                    : 10/10/2002 - Acertado cálculo do vl_reembolso - Daniel c. Neto.
--                    : 31/03/2003 - Mudado calculo do campo VL_CREDITO_PENDENTE de (+) para (-)
--                    : 02/04/2003 - Otimização da SP. A versão antiga não trazia os resultados corretos. (DUELA)
--                    : 08/04/2002 - Validação de Valores (DUELA)
--                    : 22/04/2002 - Validação de Valores (DUELA)
--                    : 30/07/2003 - Arredondamento de Valores - ELIAS
--                                 - Acerto no Filtro, que somente traz aquilo que está em aberto ou então foi
--                                   pago APÓS a data final, no caso o filtro estava para documentos em 
--                                   aberto pagos APÓS ou NA DATA FINAL. - ELIAS
--                    : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
-- 18.09.2010 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------ 
@cd_cliente 		int,
@dt_inicial             datetime,
@dt_final               datetime

as 

-------------------------------------------------------------
-- Descobrindo saldo anterior
-------------------------------------------------------------

--Soma dos Documentos Anteriores
  select distinct
    d.cd_documento_receber,
    d.cd_identificacao,
    d.cd_cliente,
    c.nm_razao_social_cliente as 'Cliente',
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.dt_cancelamento_documento,    
    p.nm_portador             as 'Portador',
    cast(str(isnull(d.vl_documento_receber,0),25,2) as decimal(25,2)) as 'vl_documento_receber'
   into #Tabela_DocumentoAUX
   from Documento_Receber d with (nolock) 
   left outer join Documento_Receber_Pagamento dp on dp.cd_documento_receber = d.cd_documento_receber 
   left outer join Cliente c                      on c.cd_cliente=d.cd_cliente
   left outer join Portador p                     on p.cd_portador=d.cd_portador
   where 
     ((d.cd_cliente = @cd_cliente) or (@cd_cliente = 0)) and
     (cast(round(d.vl_Saldo_documento,2) as decimal(25,2)) > 0 or dp.dt_pagamento_documento > @dt_final or 
      d.dt_devolucao_documento > @dt_final or d.dt_cancelamento_documento>@dt_final) and
     d.dt_emissao_documento < @dt_final+1 and
     d.dt_cancelamento_documento is null

--Soma dos Pagamentos Anteriores

  select 
    isnull(d.cd_documento_receber,tda.cd_documento_receber) as 'cd_documento_receber',
    sum(cast(str(isnull(dp.vl_pagamento_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_juros_pagamento, 0),25,2) as decimal(25,2))
             + cast(str(isnull(dp.vl_desconto_documento, 0),25,2) as decimal(25,2))
             + cast(str(isnull(dp.vl_abatimento_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_despesa_bancaria, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_reembolso_documento, 0),25,2) as decimal(25,2))
             - cast(str(isnull(dp.vl_credito_pendente, 0),25,2) as decimal(25,2))) as 'vl_pagamento'
   into #Tabela_Pagamento
   from Documento_Receber d with (nolock) 
     left outer join #Tabela_DocumentoAUX tda       on tda.cd_documento_receber=d.cd_documento_receber
     left outer join Documento_Receber_Pagamento dp on dp.cd_documento_receber = d.cd_documento_receber 
   where 
     ((d.cd_cliente = @cd_cliente) or (@cd_cliente = 0)) and
     tda.cd_documento_receber=d.cd_documento_receber and
     dp.dt_pagamento_documento < @dt_final+1 and
     d.dt_emissao_documento < @dt_final+1 and
     d.dt_cancelamento_documento is null and
     d.dt_devolucao_documento is null
   group by d.cd_documento_receber, tda.cd_documento_receber

--Diferença entre o Valor Bruto do Documento e os Pagamentos
  select
    td.cd_cliente,
    td.Cliente,
    td.dt_emissao_documento,
    td.cd_documento_receber,
    td.cd_identificacao,
    td.dt_vencimento_documento,
    td.dt_cancelamento_documento,
    td.vl_documento_receber,   
    td.Portador,
    (cast(round(isnull(td.vl_documento_receber,0),2) as decimal(25,2)) - 
     cast(round(isnull(tp.vl_pagamento,0),2) as decimal(25,2))) as 'vl_saldo_documento'
  from #Tabela_DocumentoAUX td
  left outer join #Tabela_Pagamento tp on
    tp.cd_documento_receber=td.cd_documento_receber
  order by Cliente, cd_cliente, dt_emissao_documento

drop table #Tabela_DocumentoAUX
drop table #Tabela_Pagamento

