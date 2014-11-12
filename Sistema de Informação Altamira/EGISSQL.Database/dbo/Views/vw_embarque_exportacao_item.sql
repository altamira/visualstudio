
CREATE     view vw_embarque_exportacao_item
--------------------------------------------------------------------
--vw_embarque_exportacao_item
--------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                          2004  
--------------------------------------------------------------------
-- Stored Procedure    : Microsoft SQL Server 2000
-- Autor(es)           : Elias Pereira da Silva
-- Banco de Dados      : EGISSQL
-- Objetivo            : Consulta dos Itens do Pedidos de Exportação
-- Data                : ???
-- Atualização         : 14/10/2004 - Inclusão da Unidade de Medida e Descrição do Produto em 
--                                    Outro Idioma - ELIAS
--                     : 27.10.2004 - Inclusão de campos necessários para o relatório de exportação - IGOR GAMA
-- Atualização         : 01/12/2004 - traz sigla da unidade de medida
--                     : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 17/02/2005 - Inclusão do campo Complemento do produto - Andre Gati
--                     : 21/02/2005 - Incluído o Campo DescriçãoIdioma que traz a descrição em
--                                    todos os idiomas e que é utilizado nos relatórios:
--                                    Quotation, Commercial Invoice, Proforma Invoice, Packing List
--                                    Preshipment Information, Certificate of Analysis - ELIAS
--                     : 20.12.2005 - Novos Campos para emissão dos documentos - Carlos Fernandes
--                                    Banco / Beneficiário
--                     : 22.02.2006 - Acertos Diversos - Carlos Fernandes
--                     : 06.03.2006 - Casas Decimais da Embalagem - Carlos Fernandes
--                       29/08/2006 - Acerto no relacionamento de idioma - Daniel C. Neto.
--                       06.07.2007 - Incoterm Adicional - Carlos Fernandes
-------------------------------------------------------------------------------------------
as


select
  cast(ei.cd_embarque as int)                      as Embarque,
  cast(ei.cd_embarque_item as int)                 as ItemEmbarque,
  cast(pexp.cd_pedido_venda as int)                as PedidoExportacao,  
  cast(pexp.cd_item_pedido_venda as int)           as ItemPedidoExportacao,
  cast(ui.sg_unidade_medida_idioma as varchar(50)) as Packing,
  cast(ei.qt_produto_embarque as decimal(25,4))    as Quantity,
  cast(pi.ds_produto_idioma as varchar(50))        as Produto_Idioma,
  cast(p.nm_produto_complemento as varchar(50))    as Produto_Complemento,

  --Descrição do Produto

  case when (isnull((select ic_descricao_tecnica from parametro_exportacao
                     where cd_empresa = dbo.fn_empresa()),'N') = 'S') then
    rtrim(isnull(pi.nm_produto_idioma,p.nm_produto))+
    LTrim(p.nm_produto_complemento)+ 
      case when (isnull(cast(pi.ds_produto_idioma as varchar(500)),'') <> '') then
        char(13)+isnull(cast(pi.ds_produto_idioma as varchar(500)),'') end
  else
--    rtrim(isnull(pi.nm_produto_idioma,p.nm_produto))
    rtrim(isnull(pi.nm_produto_idioma + char(13) +
    LTrim(p.nm_produto_complemento)+ char(13) + 
    LTrim(cast(pi.ds_produto_idioma as VarChar(500))),p.nm_produto)) 
  end  as ProductDescription,

  pi.nm_produto_idioma as ProductName,
    
  cast(ei.qt_peso_bruto_embarque as decimal(25,4))                         as GrossWeight,
  cast(ei.qt_peso_liquido_embarque as decimal(25,2) )                      as NetWeight,
  cast(ei.vl_produto_embarque as decimal(25,4))                            as UnitPrice,
  cast((ei.qt_produto_embarque * ei.vl_produto_embarque) as decimal(25,4)) as TotalPrice,
  Rtrim(mo.sg_moeda)            as Coin,
  i.cd_idioma                   as Idioma,
  ei.dt_producao_item_embarque  as 'dt_production', --Data produção
  ei.dt_validade_item_embarque  as 'dt_expiry',     --Data validade
  ei.cd_lote_item_embarque      as 'cd_lote',       --numero do lote
  p.nm_produto,
  p.nm_fantasia_produto,
  tc.sg_termo_comercial          as 'Incoterm',
  tca.sg_termo_comercial         as 'IncotermAux',
  p.nm_produto_complemento       as 'Complemento',
  e.nm_ref_bancaria              as 'RefBancaria',
  e.nm_sacado_embarque           as 'Sacado',
  b.nm_banco                     as 'BancoNegociacao',
  cab.nm_conta_banco             as 'ContaNegociacao',
  isnull(b.ds_banco,' ')         as 'ComplBancoNegociacao',
  bx.nm_banco                    as 'BancoCobranca',
  cabx.nm_conta_banco            as 'ContaCobranca',
  isnull(bx.ds_banco,' ')        as 'ComplBancoCobranca',
  be.nm_beneficiario             as 'Beneficiario',
  isnull(be.ds_beneficiario,' ') as 'ComplementoBeneficiario',
  be.cd_swift_beneficiario       as 'SwiftBeneficiario',
  f.nm_fantasia                  as 'Produtor',
  pe.ds_produto_exportacao       as 'Descricao',
  cast(dbo.fn_descritivo_produto_idioma(pexp.cd_produto,i.cd_idioma) as text) as 'DescricaoIdioma',
  ei.cd_laudo                    as 'Laudo',
  um.qt_decimal_unidade_medida   as 'QtdCasaDecimal',
  dbo.fn_mascara_quantidade(  case when um.qt_decimal_unidade_medida is null then 
                                       isnull(
                                              (select isnull(qt_casa_decimal_documento,0)
                                               from
                                                 Parametro_Exportacao
                                               where
                                                 cd_empresa = dbo.fn_empresa() ),isnull(um.qt_decimal_unidade_medida,0) )     
                                    else um.qt_decimal_unidade_medida end )             as 'MascaraDocumento'
from
  Embarque_Item ei
  left outer join Pedido_Venda_Item pexp on pexp.cd_pedido_venda = ei.cd_pedido_venda 
                                        and pexp.cd_item_pedido_venda = ei.cd_pedido_venda_item
  left outer join Pedido_Venda_Exportacao pve on pexp.cd_pedido_venda = pve.cd_pedido_venda
  left outer join Termo_Comercial tc          on (tc.cd_termo_comercial = pve.cd_termo_comercial)
  left outer join Termo_Comercial tca         on (tca.cd_termo_comercial = pve.cd_aux_termo_comercial)
  left outer join Produto p                   on p.cd_produto = pexp.cd_produto
  left outer join Moeda mo                    on pexp.cd_moeda_cotacao = mo.cd_moeda
  left outer join Idioma i                    on i.cd_idioma = pve.cd_idioma
  left outer join Unidade_Medida um           on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join Unidade_Idioma ui           on ui.cd_idioma = i.cd_idioma and
                                                 ui.cd_unidade_medida = um.cd_unidade_medida
  left outer join Produto_Idioma pi           on pi.cd_produto = pexp.cd_produto and pi.cd_idioma = i.cd_idioma
  left outer join embarque e                  on pve.cd_pedido_venda = e.cd_pedido_venda and
  								ei.cd_embarque = e.cd_embarque
  left outer join banco b                     on b.cd_banco=e.cd_banco_negociacao
  left outer join conta_agencia_banco cab     on cab.cd_conta_banco=e.cd_conta_banco_negociacao 
  left outer join banco bx                    on bx.cd_banco=e.cd_banco_cobranca
  left outer join conta_agencia_banco cabx    on cabx.cd_conta_banco=e.cd_conta_banco_cobranca
  left outer join beneficiario be             on be.cd_beneficiario=e.cd_beneficiario 
  left outer join produto_exportacao pe       on pe.cd_produto=p.cd_produto
  left outer join fabricante f                on f.cd_fabricante=pe.cd_fabricante


--select * from embarque_item

