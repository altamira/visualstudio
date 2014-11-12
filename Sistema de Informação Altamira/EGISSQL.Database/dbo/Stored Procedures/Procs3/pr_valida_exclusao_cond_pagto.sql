CREATE procedure pr_valida_exclusao_cond_pagto  
  
@cd_condicao_pagamento int  
  
as  
  
SELECT        top 1  
                      cota.cd_cotacao as 'Cotação',  
                      fo.cd_fornecedor as Fornecedor,  
                      cpi.cd_idioma as 'Condição de Pagamento Idioma',  
                      emb.cd_bitola as 'Evolução Mensal Bitola',   
                      cpf.cd_fornecedor AS 'Condição de Pagamento do Fornecedor',   
                      pw.cd_pedidoWap as 'Pedido Wap',   
                      fp.cd_produto AS 'Fornecedor Produto',   
                      cs.cd_contrato_servico as 'Contrato Servico',   
                      hcp.cd_historico_compra as 'Histórico de Compra do Produto',   
                      c.cd_cliente as 'Cliente',  
                      pim.cd_pedido_importacao as 'Pedido Importação',   
                      ne.cd_nota_entrada as 'Nota Entrada',   
                      cpp.cd_condicao_parcela_pgto as 'Condição Pagamento Parcela',   
                      cf.cd_contrato_fornecimento as 'Contrato Fornecimento',   
                      os.cd_ordem_servico as 'Ordem Serviço',   
                      cons.cd_consulta as 'Consulta',   
                      ns.cd_nota_saida as 'Nota Saída',   
                      pv.cd_pedido_venda as 'Pedido Venda',  
                      pc.cd_pedido_compra as 'Pedido Compra',  
        emc.cd_produto as 'Evolução Mensal Componente'   
FROM         Condicao_Pagamento cp LEFT OUTER JOIn  
                      Cotacao cota ON cp.cd_condicao_pagamento = cota.cd_condicao_pagamento LEFT OUTER JOIn  
                      Fornecedor fo ON cp.cd_condicao_pagamento = fo.cd_condicao_pagamento LEFT OUTER JOIn  
                      Condicao_Pagamento_Idioma cpi ON cp.cd_condicao_pagamento = cpi.cd_condicao_pagamento LEFT OUTER JOIn  
                      Evolucao_Mensal_Bitola emb ON cp.cd_condicao_pagamento = emb.cd_condicao_pagamento LEFT OUTER JOIn  
                      Condicao_Pagamento_Fornecedor cpf ON cp.cd_condicao_pagamento = cpf.cd_condicao_pagamento LEFT OUTER JOIn  
                      PedidoWap pw ON cp.cd_condicao_pagamento = pw.cd_condicao_pagamento LEFT OUTER JOIn  
                      Fornecedor_Produto fp ON cp.cd_condicao_pagamento = fp.cd_condicao_pagamento LEFT OUTER JOIn  
                      Contrato_Servico cs ON cp.cd_condicao_pagamento = cs.cd_condicao_pagamento LEFT OUTER JOIn  
                      Historico_Compra_Produto hcp ON cp.cd_condicao_pagamento = hcp.cd_condicao_pagamento LEFT OUTER JOIn  
                      Cliente c ON cs.cd_cliente = c.cd_cliente LEFT OUTER JOIn  
                      Pedido_Importacao pim ON cp.cd_condicao_pagamento = pim.cd_condicao_pagamento LEFT OUTER JOIn  
                     Nota_Entrada ne ON cp.cd_condicao_pagamento = ne.cd_condicao_pagamento LEFT OUTER JOIn  
                      condicao_pagamento_parcela cpp ON cp.cd_condicao_pagamento = cpp.cd_condicao_pagamento LEFT OUTER JOIn  
                      Contrato_Fornecimento cf ON cp.cd_condicao_pagamento = cf.cd_condicao_pagamento LEFT OUTER JOIn  
                      Ordem_Servico os ON cp.cd_condicao_pagamento = os.cd_condicao_pagamento LEFT OUTER JOIn  
                      Consulta cons ON cp.cd_condicao_pagamento = cons.cd_condicao_pagamento LEFT OUTER JOIn  
                      Nota_Saida ns ON cp.cd_condicao_pagamento = ns.cd_condicao_pagamento LEFT OUTER JOIn  
                      Pedido_Venda pv ON cp.cd_condicao_pagamento = pv.cd_condicao_pagamento LEFT OUTER JOIn  
                      Pedido_Compra pc ON cp.cd_condicao_pagamento = pc.cd_condicao_pagamento LEFT OUTER JOIn  
                      evolucao_mensal_componente emc ON cp.cd_condicao_pagamento = emc.cd_condicao_pagamento  
  
where cp.cd_condicao_pagamento = @cd_condicao_pagamento  
  
  

