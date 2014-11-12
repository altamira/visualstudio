

CREATE PROCEDURE pr_consulta_programacao_pagamento 
---------------------------------------------------------------------
-- pr_consulta_programacao_pagamento 
--------------------------------------------------------------------- 
--GBS - Global Business Solution Ltda                            2004 
---------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000 
--Autor(es)           : Daniel C. Neto 
--Banco de Dados      : EGISSQL 
--Objetivo            : Consultar Programação de Pagamentos. 
--Data                : 11/09/2002 
--Atualizado          : 07/05/2003 - Acertinho na flag de ic_bordero ( conversão pra varchar)
--                                 - Daniel C. Neto.
--                    : 22/12/2003 - Acerto na flag de Aprovação de Pedido de COmpra - Daniel C> Neto
--                    : 07/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                    : 24.07.2006 - Acertos Diversos 
--                                 - Empresa Diversa - Nome Fantasia - Carlos Fernandes
------------------------------------------------------------------------------------------------------ 

@ic_parametro     int,  -- 1 para Emissão, 2 para Vencimento, e 3 para Pagamento. 
@dt_inicial       datetime, 
@dt_final         datetime, 
@cd_identificacao varchar(20), 
@cd_empresa       int 


AS 

declare @SQL varchar(8000) 

--select * from documento_pagar
--select * from funcionario
--select * from empresa_diversa

begin 

set @SQL = 'SELECT '+
          --'dp.nm_fantasia_fornecedor, ' + 

           ' case when isnull(dp.cd_fornecedor,0)>0      then f.nm_fantasia_fornecedor else '+
           ' case when isnull(dp.cd_funcionario,0)>0     then fu.nm_funcionario        else '+
           ' case when isnull(dp.cd_empresa_diversa,0)>0 then ed.nm_empresa_diversa    else '+
           ' case when isnull(dp.cd_contrato_pagar,0)>0  then ( select top 1 x.nm_fantasia_fornecedor from contrato_pagar cp '+
           ' inner join fornecedor x on x.cd_fornecedor=cp.cd_fornecedor  where dp.cd_contrato_pagar = cp.cd_contrato_pagar ) '+
           ' else dp.nm_fantasia_fornecedor end '+
           ' end '+                                 
           ' end '+                                 
           ' end as nm_fantasia_fornecedor, '+ 

           'dp.cd_identificacao_document, ' + 
           'dp.dt_emissao_documento_paga, ' + 
           'dp.dt_vencimento_documento, ' + 
           'dp.vl_documento_pagar, ' + 
           'dp.vl_saldo_documento_pagar, ' + 
           'dp.cd_pedido_compra, ' + 
           'dp.cd_nota_fiscal_entrada, ' + 
           'dpp.dt_pagamento_documento, ' + 
           'dpp.vl_pagamento_documento, ' + 
           'f.cd_conta_banco, ' + 
           'dp.nm_observacao_documento, ' + 
	   ' ( select b.cd_bordero from Bordero b where ' + 
           ' cast(b.cd_bordero as varchar(20)) = dpp.cd_identifica_documento ' +
           ' and dpp.cd_tipo_pagamento = 1 ) as cd_bordero, ' + 
     ' case when dp.dt_vencimento_documento < GetDate() and IsNull(dp.vl_saldo_documento_pagar, 0) <> 0 ' + 
     ' then ''S'' else ' +  -- Não pode estar pago. 
     '''N'' end as ic_atraso, ' + 
     ' case when dp.dt_vencimento_documento < GetDate() and IsNull(dp.vl_saldo_documento_pagar, 0) <> 0 ' + 
     ' then cast(GetDate() - dp.dt_vencimento_documento as Integer) else ' +  -- Não pode estar pago. 
     ' cast(0 as integer) end as qt_atraso, ' + 
     ' case when dpp.dt_pagamento_documento < dp.dt_vencimento_documento ' + 
     ' then ''S'' else ' + 
     ' ''N'' end as ic_adiantamento, ' + -- Deve estar pago e estar na tabela de Adiantamento de Fornecedor. 
     ' case when IsNull(dpp.dt_pagamento_documento,0) <> 0 and ' + 
     ' IsNull(dp.vl_saldo_documento_pagar,0) = 0 then ''S'' else ' + 
     ' ''N'' end as ic_pagamento, ' + -- Deve estar pago e estar na tabela de Pagamento. 
     ' case when IsNull(dpp.dt_pagamento_documento,0) > dp.dt_vencimento_documento and ' + 
     ' IsNull(dp.vl_saldo_documento_pagar,0) = 0 then ''S'' else ' + 
     ' ''N'' end as ic_pag_atraso, ' + -- Deve estar pago, na tabela de Pagamento e ser maior que o vencimento. 
     ' case when IsNull(dpp.cd_identifica_documento,'''') <> '''' ' +
     ' and dpp.cd_tipo_pagamento = 1 then ''S'' else ''N'' end as ic_bordero, ' + 
     ' case when IsNull(dp.cd_tipo_pagamento,0) = 3 then ''S'' else ' + 
     ' ''N'' end as ic_fundo_fixo, ' + 
     ' ''N'' as ic_cheque, ' + 
     ' ( select IsNull(pc.ic_aprov_pedido_compra,''N'') ' +
     ' from ' +
     '  Pedido_Compra pc ' +
     '  where ' + 
     '  pc.cd_pedido_compra = dp.cd_pedido_compra ) as ic_ped_nao_aprovado,  '+
     '  case when isnull(dp.cd_pedido_compra,0)>0 then '''' else ''N'' end as ic_pedido '+
     ' FROM Documento_Pagar dp left outer join ' + 
     ' Documento_Pagar_Pagamento dpp ON dp.cd_documento_pagar = dpp.cd_documento_pagar left outer join ' + 
     ' Fornecedor_Adiantamento af on af.cd_documento_pagar = dp.cd_documento_pagar left outer join ' + 
     ' Fornecedor f ON dp.cd_fornecedor = f.cd_fornecedor '+
     ' left outer join Empresa_Diversa ed on ed.cd_empresa_diversa = dp.cd_empresa_diversa '+
     ' left outer join Funcionario fu on fu.cd_funcionario = dp.cd_funcionario '+
     ' WHERE  ' 

end 

if @ic_parametro = 1 
  set @SQL = @SQL + ' dp.dt_emissao_documento_paga BETWEEN ' 
else if @ic_parametro = 2 
  set @SQL = @SQL + ' dp.dt_vencimento_documento BETWEEN ' 
else if @ic_parametro = 3 
  set @SQL = @SQL + ' dpp.dt_pagamento_documento BETWEEN ' 


print ( @SQL +  cast(cast(@dt_inicial as DateTime) as varchar(20)) + ' AND ' + cast(cast(@dt_final as DateTime) as varchar(20)) + 
              ' AND ' + '((' + QuoteName(@cd_identificacao,'''') + ' = '''' ) OR ( dp.cd_identificacao_document = ' + 
QuoteName(@cd_identificacao,'''') + ')) and ' + 
              ' dp.dt_cancelamento_documento is null ' + 
       ' ORDER BY dp.dt_vencimento_documento desc, dp.cd_identificacao_document ' ) 


exec ( @SQL + '''' + @dt_inicial + '''' + ' AND ' + '''' + @dt_final + '''' + 
              ' AND ' + '((' + '''' + @cd_identificacao + '''' + ' = '''' ) OR ( dp.cd_identificacao_document = ' + 
       '''' + @cd_identificacao + '''' + ')) and ' + 
              ' dp.dt_cancelamento_documento is null ' + 
       ' ORDER BY dp.dt_vencimento_documento desc, dp.cd_identificacao_document ' ) 

