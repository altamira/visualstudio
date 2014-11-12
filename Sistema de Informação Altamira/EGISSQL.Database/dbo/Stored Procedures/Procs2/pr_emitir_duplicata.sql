

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE PROCEDURE pr_emitir_duplicata
------------------------------------------------------------------------------
--pr_emitir_duplicata
------------------------------------------------------------------------------ 
--GBS - Global Business Solution Ltda                                     2004
------------------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server  2000 
--Autor(es)           : Daniel C. Neto 
--Banco de Dados      : EGISSQL 
--Objetivo            : Selecionar dados para a emissão da Duplicata
--Data                : 11/09/2002 
--Alterações          : 25/11/02 - Incluido os campos ( CEP,
--                                 Data de Emissão do Documento,
--                                 Condição Especial,
--                                Praça de Pagamento ) na select - Wagner S. Jr.
--                    : 04/01/2003 - Inclusão do Campo de Extenso - ELIAS
--                    : 14/01/2003 - Incluido collation para evitar acentos - ELIAS
--                                   Incluido função para formatação do CNPJ - ELIAS
--                    : 06/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
-- 11/03/2005 - Incluído view de destinatário - Daniel C. Neto.
--                    : 26.05.2007 - Colocação do Ponto - Duplicata - Carlos Fernandes
--                    : 06.07.2007 - Acertos Diversos - Carlos Fernandes.
--                    : 01.09.2007 - Acerto no Local de Cobrança - Carlos Fernandes.
-- 23.09.2008 - Endereço de Cobrança - Carlos Fernandes
-- 14.10.2008 - Inclusão do Nome Fantasia do Cliente - Carlos Fernandes
-- 21.10.2008 - Ajuste dos dados de Cobrança - Carlos Fernandes
-- 18.12.2008 - Ajuste da Cidade - Carlos Fernandes
-- 23.12.2008 - Ajustes Diversos - Carlos Fernandes
-- 23.10.2010 - Número de Identificação da Nota Fiscal - Carlos Fernandes

---------------------------------------------------------------------------------------

@ic_parametro         int,  
@cd_documento_receber int

AS 

declare @nm_extenso           varchar(500)
declare @vl_documento_receber float

select
  @vl_documento_receber = isnull(vl_documento_receber,0)
from
  Documento_Receber with (nolock) 
where
  cd_documento_receber = @cd_documento_receber


exec pr_valor_extenso @vl_documento_receber, @nm_extenso output

SELECT     
  '.'                                  as PONTO,
  dr.cd_cliente,

--  substring(dr.cd_identificacao,1,6)   as cd_nota_saida, 

  substring(cast(  case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
      ns.cd_identificacao_nota_saida
    else
      dr.cd_nota_saida
    end as varchar),1,6)               as cd_nota_saida,


  cast(@vl_documento_receber as float) as vl_documento_receber,
  dr.cd_identificacao, 
  dr.dt_vencimento_documento, 
  d.nm_razao_social                    as 'nm_razao_social_cliente', 
  d.nm_razao_social                    as 'nm_sacado_doc_receber',
  d.nm_fantasia                        as 'nm_fantasia_cliente',
  dr.dt_emissao_documento,
  0                                    as 'PercDesc',
  0                                    as 'SobreDesc',
  0                                    as 'dt_limite_desc',
  ''                                   as 'condicao_especial',
  '***(' + @nm_extenso + ')***'        as 'valor_extenso',

  --Praça de Pagamento

  isnull( (select top 1
	     cide.nm_cidade
	   from
	     cliente_endereco ce         with (nolock) 
             inner join tipo_endereco te with (nolock) on te.cd_tipo_endereco = ce.cd_tipo_endereco
             left  join cidade cide      with (nolock) on cide.cd_cidade      = ce.cd_cidade and
                                                          cide.cd_estado      = ce.cd_estado
	   where
	     IsNull(te.ic_cobranca_tipo_endereco,'N') = 'S' and
	     cd_cliente = dr.cd_cliente),

  cid.nm_cidade)                        as 'praca_pagamento',

  dr.cd_cliente, 
 
  rtrim(ltrim(d.nm_endereco)) + ', ' + 
	rtrim(ltrim(IsNull(d.cd_numero_endereco,''))) + '-'+rtrim(ltrim(isnull(d.nm_bairro,'')))+
		  rtrim(ltrim(IsNull('' + d.nm_complemento_endereco,''))) as 'nm_endereco_cliente', 

  isnull( (select top 1
	     este.sg_estado
	   from
	     cliente_endereco ce         with (nolock) 
             inner join tipo_endereco te with (nolock) on te.cd_tipo_endereco = ce.cd_tipo_endereco
             left outer join Estado este with (nolock) on este.cd_estado      = ce.cd_estado
                  
	   where
	     IsNull(te.ic_cobranca_tipo_endereco,'N') = 'S' and
	     cd_cliente = dr.cd_cliente),

  es.sg_estado ) as sg_estado , 

  isnull( (select top 1
	     cide.nm_cidade
	   from
	     cliente_endereco ce         with (nolock) 
             inner join tipo_endereco te with (nolock) on te.cd_tipo_endereco = ce.cd_tipo_endereco
             left  join cidade cide      with (nolock) on cide.cd_cidade      = ce.cd_cidade and
                                                          cide.cd_estado      = ce.cd_estado
	   where
	     IsNull(te.ic_cobranca_tipo_endereco,'N') = 'S' and
	     cd_cliente = dr.cd_cliente),

  cid.nm_cidade)  as 'nm_cidade', 
  cid.nm_cidade   as 'nm_cidade_cliente',

  case when d.cd_tipo_pessoa = 1 then
		    dbo.fn_formata_cnpj(d.cd_cnpj) 
		  else
		    dbo.fn_formata_mascara('999.999.999-99',d.cd_cnpj) 
		  end as 'cd_cnpj_cliente', 

  d.cd_inscestadual as cd_inscestadual,

  --Cep

  isnull( (select top 1
	     ce.cd_cep_cliente
	   from
	     cliente_endereco ce with (nolock) 
             inner join tipo_endereco te on te.cd_tipo_endereco = ce.cd_tipo_endereco
	   where
	     IsNull(te.ic_cobranca_tipo_endereco,'N') = 'S' and
	     cd_cliente = dr.cd_cliente),

  d.cd_cep ) as 'cd_cep',

  d.cd_cep   as 'cd_cep_cliente',
  
  ns.cd_mascara_operacao                                          as 'CFOP',
  tt.nm_tipo_transporte                                           as 'nm_tipo_transporte',
  substring(ns.nm_operacao_fiscal,1,25)                           as 'nm_operacao_fiscal',
  cast(ns.cd_vendedor as varchar) + '-'+ v.nm_fantasia_vendedor   as 'Vendedor',
  'Pedido Venda: '+cast(isnull(dr.cd_pedido_venda,0) as varchar)  as 'Pedido_Venda',
  ''                                                              as ds_banco_boleto,

  (select top 1 
     cd_pedido_venda 
   from 
     nota_saida_item with (nolock) 
   where 
     cd_nota_saida = ns.cd_nota_saida) as 'Pedido',

  case when dr.cd_tipo_destinatario=1 
	then	
	 isnull( (select top 1
	     ltrim(rtrim(isnull(ce.nm_endereco_cliente,''))) + ', ' + isnull(rtrim(ce.cd_numero_endereco),'') +'-'+rtrim(isnull(ce.nm_bairro_cliente,'' ))+ ' - CEP: ' + isnull(ce.cd_cep_cliente,'')
	   from
	     cliente_endereco ce with (nolock) 
             inner join tipo_endereco te on te.cd_tipo_endereco = ce.cd_tipo_endereco
	   where
	     IsNull(te.ic_cobranca_tipo_endereco,'N') = 'S' and
	     cd_cliente = dr.cd_cliente),
             ltrim(rtrim(d.nm_endereco)) + ', ' + 
       	     ltrim(rtrim(IsNull(d.cd_numero_endereco,''))) + '-'+rtrim(ltrim(isnull(d.nm_bairro,'' )))+
		  IsNull(' ' + ltrim(rtrim(d.nm_complemento_endereco)),''))

/*select 
	     isnull(nm_endereco_cliente,'') + ', ' + isnull(rtrim(cd_numero_endereco),'') + ' - CEP: ' + isnull(cd_cep_cliente,'')
	   from
	     cliente_endereco
	   where
	     cd_tipo_endereco = 3 and
	     cd_cliente = dr.cd_cliente)*/

	when dr.cd_tipo_destinatario=2 then
	  (select 
	     ltrim(rtrim(isnull(nm_endereco_fornecedor,''))) + ', ' + isnull(rtrim(cd_numero_endereco),'') + ' - CEP: ' + isnull(cd_cep_fornecedor,'')
	   from
	     fornecedor_endereco with (nolock) 
	   where
	     cd_tipo_endereco = 3 and
	     cd_fornecedor    = dr.cd_cliente)

	when dr.cd_tipo_destinatario=4 then
	  (select 
	     ltrim(rtrim(isnull(nm_endereco,''))) + ', ' + isnull(rtrim(cd_numero_endereco),'') + ' - CEP: ' + isnull(cd_cep,'')
	   from
	     Transportadora_endereco
	   where
	     cd_tipo_endereco = 3 and
	     cd_transportadora = dr.cd_cliente)
  else
    ltrim(rtrim(d.nm_endereco)) + ', ' + ltrim(rtrim(IsNull(d.cd_numero_endereco,''))) + '-'+ltrim(rtrim(isnull(d.nm_bairro,''))) 
   + IsNull(' ' + ltrim(rtrim(d.nm_complemento_endereco)),'') end as 'nm_endereco_cobranca'

--Antigo
  
--   (select   
--      isnull(nm_endereco_cliente,'') + ', ' + isnull(rtrim(cd_numero_endereco),'') + IsNull('-' + nm_complemento_endereco,'')   
--    from  
--      cliente_endereco  
--    where  
--      cd_tipo_endereco = 3 and  
--      cd_cliente       = cli.cd_cliente) as 'nm_endereco_cobranca_simples' 

FROM       
  Documento_Receber dr     with (nolock) left JOIN
  vw_Destinatario_Rapida d with (nolock) on d.cd_destinatario      = dr.cd_cliente and
                                            d.cd_tipo_destinatario = dr.cd_tipo_destinatario left outer join
  Cep               c      with (nolock) ON d.cd_cep               = c.cd_cep                           left JOIN
  Estado            es     with (nolock) ON d.cd_pais              = es.cd_pais       and  d.cd_estado = es.cd_estado   left JOIN
  Cidade            cid    with (nolock) ON d.cd_pais            = cid.cd_pais      and  d.cd_estado = cid.cd_estado  and
                                            d.cd_cidade          = cid.cd_cidade  left join
  Nota_Saida        ns     with (nolock) ON dr.cd_nota_saida     = ns.cd_nota_saida left join
  Transportadora    t	   with (nolock) ON ns.cd_transportadora = t.cd_transportadora left join
  Tipo_Transporte   tt     with (nolock) ON t.cd_tipo_transporte = tt.cd_tipo_transporte left join
  Vendedor          v	   with (nolock) ON ns.cd_vendedor       = v.cd_vendedor


WHERE      
  dr.cd_documento_receber = @cd_documento_receber


