
CREATE  PROCEDURE pr_fechamento_cambio_importacao    
  
@ic_parametro int,   
@cd_fechamento_cambio int,  
@cd_fornecedor int,  
@cd_moeda int  = 0,
@Cotacao float = 0
  
as  
------------------------------------------------------------------------------------------------------------------------------
 If @ic_parametro = 2    -- Documentos do Fechamento  
------------------------------------------------------------------------------------------------------------------------------
   Select dp.dt_vencimento_documento,  
          dp.cd_identificacao_document,  
          m.sg_moeda,  
          isnull(dp.vl_documento_pagar_moeda,0) as vl_documento_pagar_moeda,  
          isNull(dp.vl_documento_pagar_moeda * fci.vl_moeda,0 ) as 'ValorReal',  
          dp.dt_emissao_documento_paga,  
          tf.nm_tipo_frete,  
          cp.nm_condicao_pagamento,  
          fci.cd_fechamento_cambio  ,
          dp.vl_tarifa_contrato_cambio 
   From fechamento_cambio_importacao fci  
        left outer join documento_pagar dp on dp.cd_fechamento_cambio = fci.cd_fechamento_cambio
        left outer join moeda m on m.cd_moeda = dp.cd_moeda   
        left outer join invoice i on i.cd_invoice = dp.cd_invoice  
        left outer join tipo_frete tf on tf.cd_tipo_frete = i.cd_tipo_frete  
        left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = i.cd_condicao_pagamento  
   Where isNull(fci.cd_fechamento_cambio,0) = @cd_fechamento_cambio
---------------------------------------------------------------  ---------------------------------------------------------------
Else If @ic_parametro = 3     -- Documentos em aberto   
------------------------------------------------------------------------------------------------------------------------------
   Select 0 as 'Seleciona',  
	       dp.cd_documento_pagar,
          dp.dt_vencimento_documento,  
          i.nm_invoice,  
          m.sg_moeda,  
          isnull(dp.vl_documento_pagar_moeda,0) as vl_documento_pagar_moeda,  
          dp.vl_saldo_documento_pagar,  
          dp.vl_saldo_anterior_fecha_cambio,
          isnull(dp.vl_documento_pagar_moeda * @Cotacao,0 ) as 'ValorReal',  
          dp.dt_emissao_documento_paga,  
          tf.nm_tipo_frete,  
          cp.nm_condicao_pagamento,  
          dp.nm_observacao_documento,  
          dp.cd_fornecedor
   From documento_pagar dp  
        left outer join moeda m on m.cd_moeda = dp.cd_moeda   
        left outer join invoice i on i.cd_invoice = dp.cd_invoice  
        left outer join tipo_frete tf on tf.cd_tipo_frete = i.cd_tipo_frete  
        left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = i.cd_condicao_pagamento  
        left outer join fornecedor f on f.cd_fornecedor = dp.cd_fornecedor  
   Where f.cd_fornecedor = @cd_fornecedor and  
         dp.vl_saldo_documento_pagar > 0  and
         isNull(dp.cd_fechamento_cambio,0) = 0 and
         m.cd_moeda = @cd_moeda and 
         isnull(dp.vl_documento_pagar_moeda,0) > 0
---------------------------------------------------------------  ---------------------------------------------------------------
Else If @ic_parametro = 4     -- Documentos em aberto   e fechados
------------------------------------------------------------------------------------------------------------------------------
   Select (case isnull(dp.cd_fechamento_cambio,0)
           when 0 then
               0
           else 
               1 
           end)   as 'Seleciona',  
          dp.cd_fechamento_cambio,
	       dp.cd_documento_pagar,
          dp.dt_vencimento_documento,  
          i.nm_invoice,  
          m.sg_moeda,  
          isnull(dp.vl_documento_pagar_moeda,0) as vl_documento_pagar_moeda,  
          dp.vl_saldo_documento_pagar,
          dp.vl_saldo_anterior_fecha_cambio,
          isNull(dp.vl_documento_pagar_moeda * @Cotacao,0 ) as 'ValorReal',   
          dp.dt_emissao_documento_paga,  
          tf.nm_tipo_frete,  
          cp.nm_condicao_pagamento,  
          dp.nm_observacao_documento,  
          dp.cd_fornecedor
   From documento_pagar dp  
        left outer join moeda m on m.cd_moeda = dp.cd_moeda   
        left outer join invoice i on i.cd_invoice = dp.cd_invoice  
        left outer join tipo_frete tf on tf.cd_tipo_frete = i.cd_tipo_frete  
        left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = i.cd_condicao_pagamento  
        left outer join fornecedor f on f.cd_fornecedor = dp.cd_fornecedor  
   Where f.cd_fornecedor = @cd_fornecedor and 
         dp.vl_saldo_documento_pagar > 0  and
         (isNull(dp.cd_fechamento_cambio,0) = 0 and m.cd_moeda = @cd_moeda) or
         (isNull(dp.cd_fechamento_cambio,0) = @cd_fechamento_cambio ) and
         isnull(dp.vl_documento_pagar_moeda,0) > 0
         


