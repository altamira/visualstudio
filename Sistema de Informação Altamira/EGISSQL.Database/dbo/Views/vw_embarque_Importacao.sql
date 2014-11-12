
create view vw_embarque_Importacao
-------------------------------------------------------------------------------------------
--vw_embarque_Importacao
-------------------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                                 2004
-------------------------------------------------------------------------------------------
-- Stored Procedure      : Microsoft SQL Server 2000
-- Autor(es)             : Daniel C. Neto.
-- Banco de Dados        : EGISSQL
-- Objetivo              : Consulta dos Embarques de Importação
-- Data                  : 18/11/2004
-- Atualização           : 28/12/2004 - Acerto do Cabeçalho - Sérgrio Cardoso
-------------------------------------------------------------------------------------------
as

select 
  pexp.cd_pedido_importacao as PedidoImportacao,
  e.cd_embarque as Embarque ,
  cast(imp.nm_razao_social +' '+imp.nm_razao_social_comple as varchar(150)) as ImporterName,
  cast(imp.nm_endereco_Fornecedor+', '+cast(imp.cd_numero_endereco as varchar)+' '+imp.nm_bairro as varchar(250)) as ImporterAdress,
  cast(imp.cd_cep+' '+ci.nm_cidade+' '+ufi.sg_estado+' '+paimp.sg_pais as varchar(100)) as ImporterCity,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_telefone as varchar(50)) as ImporterPhone,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_fax as varchar(50)) as ImporterFax ,
  cast(export.nm_razao_social as varchar(100)) as ExporterName,
  cast(export.nm_endereco+', '+cast(export.cd_numero_endereco as varchar)+' '+export.nm_bairro as varchar(250)) as ExporterAdress,
  cast(export.cd_cep+' '+ce.nm_cidade+' '+ufe.sg_estado+' '+pexport.sg_pais as varchar(100)) as ExporterCity,
  cast(pexport.cd_ddi_pais+' '+export.cd_ddd+' '+export.cd_telefone as varchar(50)) as ExporterPhone,
  cast(pexport.cd_ddi_pais+' '+export.cd_ddd+' '+export.cd_fax as varchar(50)) as ExporterFax,  
  cast(pexp.nm_ref_ped_imp as varchar(20)) as YourReference,
  '' as ProformaInvoice,
  cast(e.dt_previsao_embarque as datetime) as ShippingDate,
  cast(null as varchar(50)) as Packing,
  cast(p.nm_pais as varchar(50)) as CountryOrigin,
  cast(pd.nm_pais as varchar(50)) as CountryDestination,
  cast(tti.nm_tipo_transporte_idioma as varchar(50)) as Shipment,
  cast(t.nm_transportadora as varchar(50)) as ShippedBy,
  cast(po.nm_porto as varchar(50)) as PlaceShipment,
  cast(poo.nm_porto as varchar(50)) as PlaceDestination,
  cast(c.nm_razao_social as varchar(150)) as Consignee,
  cast(cpi.nm_condicao_pgto_idioma as varchar(150)) as PaymentTerms,
  cast(cpi.ds_condicao_pgto_idioma as varchar(8000)) as PaymentTermsDescription,
  cast(e.vl_mercadoria_embarque as decimal(25,4)) as Value,
  cast(isnull(e.vl_frete_embarque,0) as decimal(25,4)) as Freight,
  cast(IsNull(e.vl_outra_despesa_embarque,0) as decimal(25,4)) as Insurance,
  cast(e.vl_mercadoria_embarque + isnull(e.vl_frete_embarque,0) + 
       IsNull(e.vl_outra_despesa_embarque,0) as decimal(25,2)) as TotalValue,
  cast(desp.nm_razao_social as varchar(50)) as Dispatcher,
  cast(pexp.nm_emb_ped_imp as varchar(50)) as EmbarkmentArea,
  cast(u.nm_fantasia_usuario as varchar(25)) as Responsavel,
  cast('' as varchar(25)) as LetterCredit,
  '' as ExpirationDateCredit,
  pexp.dt_pedido_importacao as EmissaoPedido,
  cast(null as decimal(25,4)) as CubicMeters,
  cast(e.qt_peso_liquido_embarque as decimal(25,4)) as NetWeight,
  cast(e.qt_peso_bruto_embarque as decimal(25,4)) as GrossWeight,
  i.cd_idioma as Idioma,
  cc.nm_fantasia_contato_forne,
  u.nm_fantasia_usuario as 'UsuarioResponsavel',
  cast(e.dt_previsao_chegada as datetime) as EstimatedArrival,
  cast(e.dt_bl_awb as datetime) as dt_bl_awb,
  ppsaida.nm_pais as 'Pais_P_Saida',
  ppentrada.nm_pais as 'Pais_P_Entrada'

from
  Pedido_Importacao pexp
  left outer join Embarque_Importacao e on e.cd_pedido_importacao = pexp.cd_pedido_importacao
  left outer join Fornecedor imp on imp.cd_Fornecedor = pexp.cd_Fornecedor
  left outer join Importador export on export.cd_importador = pexp.cd_importador
-- Relacionamentos do Importador
  left outer join Pais paimp on paimp.cd_pais = imp.cd_pais
  left outer join Estado ufi on ufi.cd_pais = imp.cd_pais and
                                ufi.cd_estado = imp.cd_estado
  left outer join Cidade ci on ci.cd_pais = imp.cd_pais and
                               ci.cd_estado = imp.cd_estado and
                               ci.cd_cidade = imp.cd_cidade
-- Relacionamentos do Exportador
  left outer join Pais pexport on pexport.cd_pais = export.cd_pais
  left outer join Estado ufe on ufe.cd_pais = export.cd_pais and
                                ufe.cd_estado = export.cd_estado
  left outer join Cidade ce on ce.cd_pais = export.cd_pais and
                               ce.cd_estado = export.cd_estado and
                               ce.cd_cidade = export.cd_cidade
-- Relacionamento do Transportador
  left outer join Transportadora t on t.cd_transportadora = e.cd_transportadora
-- Relacionamento do Despachante
  left outer join Despachante desp on desp.cd_despachante = e.cd_despachante
-- Relacionamento do Pais Origem
  left outer join Pais p on p.cd_pais = pexp.cd_origem_pais
-- Relacionamento do Pais Destino
  left outer join Pais pd on pd.cd_pais = pexp.cd_destino_pais
-- Relacionamento do Metodo de Embarque
  left outer join Tipo_Importacao ti on ti.cd_tipo_importacao = pexp.cd_tipo_importacao
-- Relacionamento do Porto origem e destino
  left outer join Porto po on po.cd_porto = e.cd_porto_saida
  left outer join Porto poo on poo.cd_porto = e.cd_porto_destino
  left outer join Fornecedor_Contato cc on cc.cd_Fornecedor = pexp.cd_Fornecedor and
                                        cc.cd_contato_fornecedor = pexp.cd_contato_fornecedor
  left outer join EGISADMIN.dbo.Usuario u on u.cd_usuario = pexp.cd_usuario_requisitante 
  -- IMPORTANTE, ESTE RELACIONAMENTO EXISTE PARA FORCAR A LISTAGEM DE UM REGISTRO POR IDIOMA
  left outer join Idioma i on i.cd_idioma = i.cd_idioma
  left outer join Tipo_Transporte_Idioma tti on e.cd_tipo_transporte = tti.cd_tipo_transporte and
                                                tti.cd_idioma = i.cd_idioma
  left outer join Condicao_Pagamento_Idioma cpi on pexp.cd_condicao_pagamento = cpi.cd_condicao_pagamento and
                                                   cpi.cd_idioma = i.cd_idioma
  left outer join Consignatario c on c.cd_consignatario = e.cd_consignatario
  left outer join Pais ppsaida on ppsaida.cd_pais = po.cd_pais
-- Relacionamento do Pais Destino
  left outer join Pais ppentrada on ppentrada.cd_pais = poo.cd_pais



