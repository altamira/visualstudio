
CREATE PROCEDURE pr_consulta_bordero_fornecedor
@ic_gerado_sap char(1),
@cd_bordero    int
AS

-------------------------------------------------------------------------------
if @ic_gerado_sap = 'S'  -- gerado p/ sistema SAP/DOS
-------------------------------------------------------------------------------
  begin

    select distinct 
      t.sg_tipo_conta_pagar,
      d.nm_fantasia_fornecedor,
      d.cd_identificacao_document,
      p.nm_obs_documento_pagar,
      d.dt_vencimento_documento,
      (select top 1 ba.cd_numero_banco from banco ba, fornecedor o where o.cd_fornecedor = d.cd_fornecedor and o.cd_banco = ba.cd_banco) as 'cd_numero_banco',
      (select top 1 o.cd_banco from fornecedor o where o.cd_fornecedor = d.cd_fornecedor) as 'cd_banco',  
      (select top 1 o.cd_agencia_banco from fornecedor o where o.cd_fornecedor = d.cd_fornecedor) as 'cd_agencia_banco',  
      (select top 1 o.cd_conta_banco from fornecedor o where o.cd_fornecedor = d.cd_fornecedor) as 'cd_conta_corrente',
      --Razão Social / CNPJ
      (select top 1 o.nm_razao_social    from fornecedor o where o.cd_fornecedor = d.cd_fornecedor)         as 'nm_razao_social',
      (select top 1 o.cd_cnpj_fornecedor from fornecedor o where o.cd_fornecedor = d.cd_fornecedor)         as 'cd_cnpj',

--      d.cd_identificacao_document,
      p.vl_juros_documento_pagar +
      p.vl_abatimento_documento -
      p.vl_desconto_documento as 'vl_juros_abatimento',
      p.vl_pagamento_documento +
      p.vl_juros_documento_pagar -
      p.vl_desconto_documento - 
      p.vl_abatimento_documento as 'vl_documento',
      b.dt_debito_bordero,
      b.dt_vencimento_bordero,
      b.dt_inicial_bordero,
      b.dt_final_bordero,
      p.ic_deposito_conta,
      case when isnull(ic_tipo_deposito,'N') = 'D'
           then 'DOC'
           else
                  case when isnull(ic_tipo_deposito,'N') = 'T' then 'TED' else '' end 
      end  as 'nm_tipo_deposito'

    into #TabelaDistinta
    from 
      tipo_conta_pagar t,
      bordero b,
      documento_pagar d,
      documento_pagar_pagamento p
         
where
      b.cd_bordero = @cd_bordero and
      cast(b.cd_bordero as varchar(50)) = p.cd_identifica_documento and
      p.cd_tipo_pagamento = 1 and  -- borderô
      d.cd_documento_pagar = p.cd_documento_pagar and
      d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar and
      t.ic_tipo_bordero = 'F' 

    select * from #TabelaDistinta
    order by
      sg_tipo_conta_pagar,
      nm_fantasia_fornecedor,
      vl_documento

    drop table #TabelaDistinta

  end
-------------------------------------------------------------------------------
else  -- gerado p/ sistema novo (SQL)
-------------------------------------------------------------------------------
  begin
    select 
      t.sg_tipo_conta_pagar,
      d.nm_fantasia_fornecedor,
      d.cd_identificacao_document,
      p.nm_obs_documento_pagar,
      d.dt_vencimento_documento,
      (select top 1 ba.cd_numero_banco   from banco ba,fornecedor o where o.cd_fornecedor = d.cd_fornecedor and o.cd_banco = ba.cd_banco) as 'cd_numero_banco',
      (select top 1 o.cd_banco           from fornecedor o where o.cd_fornecedor = d.cd_fornecedor)         as 'cd_banco',  
      (select top 1 o.cd_agencia_banco   from fornecedor o where o.cd_fornecedor = d.cd_fornecedor)         as 'cd_agencia_banco',  
      (select top 1 o.cd_conta_banco     from fornecedor o where o.cd_fornecedor = d.cd_fornecedor)         as 'cd_conta_corrente',
      --Razão Social / CNPJ
      (select top 1 o.nm_razao_social    from fornecedor o where o.cd_fornecedor = d.cd_fornecedor)         as 'nm_razao_social',
      (select top 1 o.cd_cnpj_fornecedor from fornecedor o where o.cd_fornecedor = d.cd_fornecedor)         as 'cd_cnpj',
    
      p.vl_juros_documento_pagar -
      p.vl_abatimento_documento -
      p.vl_desconto_documento as 'vl_juros_abatimento',
      p.vl_pagamento_documento +
      p.vl_juros_documento_pagar -
      p.vl_desconto_documento - 
      p.vl_abatimento_documento as 'vl_documento',
      b.dt_debito_bordero,
      b.dt_vencimento_bordero,
      b.dt_inicial_bordero,
      b.dt_final_bordero,
      p.ic_deposito_conta,
      case when isnull(ic_tipo_deposito,'N') = 'D'
           then 'DOC'
           else
                case when isnull(ic_tipo_deposito,'N') = 'T' then 'TED' else '' end 
      end  as 'nm_tipo_deposito'

    into #TabelaDistinta2

    from 
      tipo_conta_pagar t,
      bordero b,
      documento_pagar d,
      documento_pagar_pagamento p
     where
      b.cd_bordero = @cd_bordero and
      p.cd_identifica_documento = cast(@cd_bordero as varchar(50)) and
      p.cd_tipo_pagamento = (select
                               min(cd_tipo_pagamento)
                             from
                               tipo_pagamento_documento
                             where
                               sg_tipo_pagamento like 'BORDER%') and  -- borderô
      d.cd_documento_pagar = p.cd_documento_pagar and
      d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 
   
    select * from #TabelaDistinta2
    order by
      sg_tipo_conta_pagar,
      nm_fantasia_fornecedor,
      vl_documento

    drop table #TabelaDistinta2

  end

  --Write your procedures's statement here
