
-------------------------------------------------------------------------------
--pr_migracao_industecnica_documento_receber
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Clientes
--Data             : 26.07.06
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_industecnica_documento_receber
as

delete documento_receber

select

identity(int,1,1)												as cd_documento_receber,
case 	when nota = 0 
	then cast(codigo as varchar(10))
	else cast(nota as varchar(10))+'-'+cast(parcela as varchar(2)) 
	end													as cd_identificacao,
isnull(cast((substring(dtemis,4,3)+substring(dtemis,1,3)+substring(dtemis,7,4))as datetime),getdate())		as dt_emissao_documento,
isnull(cast((substring(dtvenc,4,3)+substring(dtvenc,1,3)+substring(dtvenc,7,4))as datetime),getdate())		as dt_vencimento_documento,
isnull(cast((substring(dtvenc,4,3)+substring(dtvenc,1,3)+substring(dtvenc,7,4))as datetime),getdate())		as dt_vencimento_original,--verificar se pode ser = dt_vencimento_documento
vrorig														as vl_documento_receber,--gravar na documento_receber_pagamento se a data de pgto <> null
0														as vl_saldo_documento,--verificar se é campo calculado
null														as dt_cancelamento_documento,
null														as nm_cancelamento_documento,
null														as cd_modulo,
banco														as cd_banco_documento,
rtrim(ltrim(cast([desc]as varchar(510))))+' '+rtrim(ltrim(cast([descricao]as varchar(510))))			as ds_documento_receber,
'N'														as ic_emissao_documento,
null														as dt_envio_banco_documento,
null														as dt_contabil_documento,
0														as cd_portador,
0														as cd_tipo_cobranca,
isnull((select top 1 cd_cliente from cliente where nm_fantasia_cliente = empresa),0)				as cd_cliente,
0														as cd_tipo_documento,
99														as cd_usuario,
getdate()													as dt_usuario,
null														as cd_vendedor,
null														as cd_pedido_venda,
nota														as cd_nota_saida,
'N'														as ic_tipo_abatimento,
null														as cd_tipo_liquidacao,
cast((substring(dtpagt,4,3)+substring(dtpagt,1,3)+substring(dtpagt,7,4))as datetime)				as dt_pagto_document_receber,
null														as vl_pagto_document_receber,
null														as cd_banco_documento_recebe,
ja_enviou													as ic_envio_documento,
null														as dt_fluxo_documento_recebe,
'N'														as ic_tipo_lancamento,
null														as cd_banco_doc_receber,
null														as dt_fluxo_doc_receber,
null														as cd_plano_financeiro,
null														as dt_fluxo_docto_receber,
'N'														as ic_fluxo_caixa,
null														as nm_sacado_doc_receber,
null														as vl_limite_credito_cliente,
'N'														as ic_cobranca_eletronica,
'N'														as ic_informacao_credito,
null														as cd_tipo_destinatario,
null														as dt_retorno_banco_doc,
null														as cd_arquivo_magnetico,
abati														as vl_abatimento_documento,
null														as vl_reembolso_documento,
null														as dt_devolucao_documento,
null														as nm_devolucao_documento,
null														as dt_impressao_documento,
'N'														as ic_credito_icms_documento,
'N'														as ic_anuencia_documento,
null														as cd_rebibo,
1														as cd_moeda,
null														as cd_embarque_chave,
null														as dt_selecao_documento,
null														as cd_loja,
null														as cd_centro_custo,
null														as cd_contrato,
null														as cd_lote_receber,
null														as cd_nota_promissoria

into	#docrec

from kin.dbo.incpr ic

where pagrec = 'R'

insert into documento_receber
select * from #docrec

drop table #docrec

