
CREATE PROCEDURE pr_inf_comercial_duplicata
---------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel Carrasco Neto
--Banco de Dados: SapSQL
--Objetivo: Consultar Duplicatas Pagas Parcialmente
--
--Data: 06/03/2002
--Atualizado: - Inclusão de campos. - 07/03/2002 - Daniel.
--            - Modificação de campo vl_saldo_documento
--            - de float p/ Decimal - 13/03/2002 - Carrasco.
--            15/03/2002 - inclusão de valor total - Elias
--            02/04/2002 - Migração p/ EGISSQL - Elias
--            10/10/2002 - Alterada a forma de cálculo no vl_reembolso
--                       - Daniel C. Neto.
--            31/03/2003 - Mudado calculo do campo VL_CREDITO_PENDENTE de (+) para (-)
---------------------------------------------------
  @cd_documento integer

AS

  select 
    d.cd_documento_receber,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    p.cd_item_documento_receber,
    p.vl_desconto_documento,
    p.vl_abatimento_documento,
    p.vl_despesa_bancaria,
    p.vl_reembolso_documento,
    p.vl_credito_pendente,
    p.dt_pagamento_documento,
    p.vl_pagamento_documento,
    p.vl_juros_pagamento,
    (p.vl_pagamento_documento+
     p.vl_juros_pagamento-
     p.vl_desconto_documento-
     p.vl_abatimento_documento-
     p.vl_despesa_bancaria-
     p.vl_reembolso_documento-
     p.vl_credito_pendente) as 'vl_total_documento',
    Case  -- Marca documento se ele tiver saldo 0
      When cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0 then 'S'
      Else 'N'
    end as 'BaixaTotal'
  from
    Documento_Receber d
      left outer join
    Documento_Receber_Pagamento p
      on d.cd_documento_receber = p.cd_documento_receber
  where
    d.cd_documento_receber = @cd_documento
