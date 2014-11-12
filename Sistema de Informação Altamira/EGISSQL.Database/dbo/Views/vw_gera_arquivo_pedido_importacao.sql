
CREATE VIEW dbo.vw_gera_arquivo_pedido_importacao
AS

Select (select top 1 sg_pais_imp_empresa From egisadmin..Empresa Where cd_empresa = dbo.fn_empresa()) as 'CodigoSubsidiaria',
       '00' as 'CodigoFilial',
       'H' as 'CodigoCabecalho',
       IsNull(Cast(pi.cd_identificacao_pedido as VarChar(20)),'') as 'NumeroPedido',    
       IsNull(Convert(VarChar(6), pi.dt_prev_emb_ped_imp, 12),'') as 'DataEntrega',
       Convert(VarChar(6), GetDate(), 12) as 'DiaTransmicao',
       IsNull(Cast(tf.sg_tipo_frete as VarChar(1)),'') as 'EmbarcadaPor',
       Cast(mp.sg_modalidade_pagamento as VarChar(1)) as 'CondicaoPagamento',
       Right('000' + Cast(Sum(cpp.qt_dia_cond_parcela_pgto) as VarChar),3) as 'VencimentoPagamento',
       Cast(tc.sg_termo_comercial as VarChar(1)) as 'CodigoCondicao',
       'T' as 'CodigoTermino',
       pi.cd_pedido_importacao
From Pedido_Importacao pi
     left outer join Tipo_Frete tf on (tf.cd_tipo_frete = pi.cd_tipo_frete)
     left outer join Modalidade_Pagamento mp on (mp.cd_modalidade_pagamento = pi.cd_modalidade_pagamento)
     left outer join Condicao_Pagamento cp on (cp.cd_condicao_pagamento = pi.cd_condicao_pagamento)
     left outer join Condicao_Pagamento_Parcela cpp on (cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento)
     left outer join Termo_Comercial tc on (tc.cd_termo_comercial = pi.cd_termo_comercial)
Group by pi.cd_identificacao_pedido, pi.dt_prev_emb_ped_imp, tf.sg_tipo_frete, 
         mp.sg_modalidade_pagamento, tc.sg_termo_comercial, pi.cd_pedido_importacao

