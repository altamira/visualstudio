
Create procedure pr_altamira_migracao_documento_receber_2009
as

--Deleta os Registros da Tabela Destino
--delete from documento_receber
--delete from documento_receber_pagamento

--select * from migracao.dbo.Conta_Receber_Jan2009
--select * from documento_receber 

-- select 
--   REPLACE(cd_doc_receber_interno,'.','')    as cd_doc_receber_interno,  
--   CRND_CNPJ           AS CRND_CNPJ,
--   CRND_NOTAFISCAL     AS CRND_NOTAFISCAL,
--   CRND_DATAVENCIMENTO AS CRND_DATAVENCIMENTO,
--   CRND_EMISSAONF      AS CRND_EMISSAONF,
--   CRND_VALORPARCELA   AS CRND_VALORPARCELA,
--   CRND_BANCO          AS CRND_BANCO,
--   CRND_PEDIDO 	      AS CRND_PEDIDO,
--   CRND_DATAPAGAMENTO  AS CRND_DATAPAGAMENTO,
--   CRND_VALORTOTAL     AS CRND_VALORTOTAL,
--   CRND_VALORDESCONTO  AS CRND_VALORDESCONTO
-- 
-- into
--  #DCR
-- from
--   migracao.dbo.ContaReceber_Jan2009   
-- group by 
--   cd_doc_receber_interno,
--   CRND_CNPJ,
--   CRND_NOTAFISCAL,
--   CRND_DATAVENCIMENTO,
--   CRND_EMISSAONF,
--   CRND_VALORPARCELA,
--   CRND_BANCO,
--   CRND_PEDIDO,
--   CRND_DATAPAGAMENTO,
--   CRND_VALORTOTAL,
--   CRND_VALORDESCONTO
-- 
-- 
-- select * from #DCR order by CRND_NOTAFISCAL
--select * from nota_saida_recibo

--select * from migracao.dbo.Conta_Receber_2009   

delete from documento_receber_pagamento
delete from documento_receber where dt_emissao_documento < '08/01/2009'

--select * from documento_receber  order by dt_emissao_documento

--select * from vendedor

--cliente

-- select
--   'C'+cast(CRND_CNPJ as varchar(18)) ,
--   c.cd_cnpj_cliente
-- from
--    migracao.dbo.Conta_Receber_2009  x  
--   left outer join cliente c  on c.cd_cnpj_cliente = x.CRND_CNPJ

-- where
--   c.cd_cnpj_cliente is null  
-- group by
--   CRND_CNPJ,c.cd_cnpj_cliente
-- order by
--   CRND_CNPJ

declare @cd_documento_receber int

select @cd_documento_receber = max(cd_documento_receber) +1
from
  documento_receber

if @cd_documento_receber = 0
   set @cd_documento_receber = 1

-- DOCUMENTOS A RECEBER
-- Select * From DOCUMENTO_RECEBER
Select
--Atributos da Tabela origem com o nome da tabela destino
  --cd_doc_receber_interno       	        AS cd_documento_receber,
  @cd_documento_receber                 as cd_documento_receber,
  cast(CAST(CRND_NOTAFISCAL AS VARCHAR)+
  '-'+CAST(CRND_PARCELA AS VARCHAR ) as varchar(25))        AS cd_identificacao,
  CRND_EMISSAONF			AS dt_emissao_documento,
  CRND_DATAVENCIMENTO  	   	        AS dt_vencimento_documento,
  CRND_DATAVENCIMENTO  	   	        AS dt_vencimento_original,
  CRND_VALORPARCELA 			AS vl_documento_receber,
  case when CRND_DATAPAGAMENTO is null then
  CRND_VALORPARCELA		       
  else 0
  end                                   AS vl_saldo_documento,
  NULL 					AS dt_cancelamento_documento,
  NULL 					AS nm_cancelamento_documento,
  NULL 					AS cd_modulo,
  NULL	 				AS cd_banco_documento,
  CAST('' as varchar)                   AS ds_documento_receber,
  'N' 					AS ic_emissao_documento,
  NULL 					AS dt_envio_banco_documento,
  NULL  				AS dt_contabil_documento,
  999 	 				AS cd_portador,
  1 				        AS cd_tipo_cobranca,
  C.CD_CLIENTE 				AS cd_cliente,   -- OBS: FAZER UM LEFT INNER
  1				 	AS cd_tipo_documento,
  4 		  	 	        AS cd_usuario,
  GETDATE() 				AS dt_usuario,
  cast(CRND_REPRESENTANTE as int )	AS cd_vendedor,
  CRND_PEDIDO 				AS cd_pedido_venda,
  CRND_NOTAFISCAL			AS cd_nota_saida,
  NULL 					AS ic_tipo_abatimento,
  10					AS cd_tipo_liquidacao,
  CRND_DATAPAGAMENTO			AS dt_pagto_document_receber,
  CRND_VALORTOTAL			AS vl_pagto_document_receber,
  NULL					AS cd_banco_documento_recebe,
  NULL 					AS ic_envio_documento,
  CRND_DATAPAGAMENTO			AS dt_fluxo_documento_recebe,
  NULL 					AS ic_tipo_lancamento,
  CRND_BANCO 				AS cd_banco_doc_receber,
  CRND_DATAPAGAMENTO			AS dt_fluxo_doc_receber,
  99 					AS cd_plano_financeiro,
  NULL      			AS dt_fluxo_docto_receber,
  'N' 					AS ic_fluxo_caixa,
  cast(c.nm_razao_social_cliente as varchar(40))		AS nm_sacado_doc_receber,
  NULL 					AS vl_limite_credito_cliente,
  'N' 					AS ic_cobranca_eletronica,
  'S' 					AS ic_informacao_credito,
  1 					AS cd_tipo_destinatario,
  NULL 					AS dt_retorno_banco_doc,
  identity(int,1,1)              	AS cd_arquivo_magnetico,
  NULL     			AS vl_abatimento_documento,
  NULL					AS vl_reembolso_documento,
  NULL 					AS dt_devolucao_documento,
  NULL					AS nm_devolucao_documento,
  NULL					AS dt_impressao_documento,
  'N'				 	AS ic_credito_icms_documento,
  'N' 					AS ic_anuencia_documento,
  NULL					AS cd_rebibo,
  1 					AS cd_moeda,
  NULL					AS cd_embarque_chave,
  NULL					AS dt_selecao_documento,
  NULL					AS cd_loja,
  5 					AS cd_centro_custo,
  NULL					AS cd_contrato,
  NULL					AS cd_lote_receber,
  NULL					AS cd_nota_promissoria,
  x.crnd_parcela			AS cd_parcela_nota_saida,
  NULL					AS cd_ordem_servico,
  NULL					AS cd_cheque_terceiro,
  NULL					AS cd_conta_banco_remessa,
  NULL					AS cd_nosso_numero_documento,
  NULL					AS cd_digito_bancario,
  NULL					AS cd_movimento_caixa,
  NULL					AS cd_tipo_fluxo_caixa

Into
  #DOCRECEBER

From
-- Tabela Origem
  --#DCR X
  --migracao.dbo.ContaReceber_Jan2009   x
  migracao.dbo.Conta_Receber_2009 x  
  left outer join cliente c  on c.cd_cnpj_cliente = x.CRND_CNPJ
where
   x.crnd_TipoNota = 'S' and
   c.cd_cnpj_cliente is not null

 
update
  #DOCRECEBER
set
  cd_documento_receber = cd_arquivo_magnetico + @cd_documento_receber
  --cd_arquivo_magnetico = null

Insert Into
--Tabela de Destino
  DOCUMENTO_RECEBER

Select * From #DOCRECEBER 

--Gera a tabela de pagamento
--select * from documento_receber_pagamento

select
  r.cd_documento_receber,
  1                                as cd_item_documento_receber,
  r.dt_pagto_document_receber      as dt_pagamento_documento,
  r.vl_pagto_document_receber      as vl_pagamento_documento,
  null                             as vl_juros_pagamento,
  null                             as vl_desconto_documento,
  null                             as vl_abatimento_documento,
  null                             as vl_despesa_bancaria,
  null                             as cd_recibo_documento,
  null                             as ic_tipo_abatimento,
  null                             as ic_tipo_liquidacao,
  null                             as vl_reembolso_documento,
  null                             as vl_credito_pendente,
  null                             as ic_desconto_comissao,
4 as cd_usuario,
getdate() as dt_usuario,
  'Migração'                       as nm_obs_documento,
  null                             as dt_fluxo_doc_rec_pagament,
  null                             as dt_fluxo_doc_rec_pagto,
  null                             as dt_pagto_contab_documento,
  3                                as cd_tipo_liquidacao,
  r.cd_banco_doc_receber           as cd_banco,
  null                             as cd_conta_banco,
  null                             as cd_lancamento,
  null                             as cd_tipo_caixa,
  null                             as cd_lancamento_caixa

into
 #documento_receber_pagamento

from
 documento_receber r
where
 r.dt_pagto_document_receber is not null
 and
 r.vl_pagto_document_receber>0

insert into
  documento_receber_pagamento
select
  *
from
  #documento_receber_pagamento

drop table #documento_receber_pagamento

update
  documento_receber
set
  cd_arquivo_magnetico = null

--where cd_documento_receber <> 144
--Deleção da Tabela Temporária
--Drop Table #DOCRECEBER

--Mostra os registros migrados
--   Select * From DOCUMENTO_RECEBER
--   where dt_emissao_documento between '2009/01/01' and '2009/01/31'
--  order by dt_emissao_documento

----------------------------------------------------------
--Testando a procedure
----------------------------------------------------------
--EXECUTE pr_altamira_migracao_documento_receber_2009
----------------------------------------------------------
--TESTES
--select * from cliente where cd_cnpj_cliente = 57961310000190
--select * from migracao.dbo.ContaReceber_Jan2009
--Select * From DOCUMENTO_RECEBER 
-- where cd_identificacao = '36733'

--select * from cliente where cd_cliente = 542
