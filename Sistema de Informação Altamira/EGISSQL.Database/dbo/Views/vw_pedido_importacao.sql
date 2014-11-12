
create view vw_pedido_importacao
as

select 
  cast(pimp.cd_pedido_importacao as int) as PedidoImportacao,
  cast(imp.nm_razao_social as varchar(150)) as ImporterName,
  cast(imp.nm_endereco+', '+cast(imp.cd_numero_endereco as varchar)+' '+imp.nm_bairro as varchar(250)) as ImporterAdress,
  cast(imp.cd_cep+' '+ci.nm_cidade+' '+ufi.sg_estado+' '+paimp.sg_pais as varchar(100)) as ImporterCity,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_telefone as varchar(50)) as ImporterPhone,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_fax as varchar(50)) as ImporterFax,
  cast(pimp.nm_ref_ped_imp as varchar(20)) as YourReference,
  cast(0 as int) as ProformaInvoice,
  pimp.dt_prev_emb_ped_imp as ShippingDate,
  cast(pimp.nm_emb_ped_imp as varchar(50)) as Packing,
  cast(po.nm_pais as varchar(50)) as CountryOrigin,
  cast(null as varchar(50)) as Shipment,
  cast(t.nm_transportadora as varchar(50)) as ShippedBy,
  cast(por.nm_porto as varchar(50)) as PlaceShipment,
  cast(pdt.nm_porto as varchar(50)) as PlaceDestination,
  cast(d.nm_razao_social as varchar(150)) as Consignee,
  cast(cpi.nm_condicao_pgto_idioma as varchar(150)) as PaymentTerms,
  cast(cpi.ds_condicao_pgto_idioma as varchar(8000)) as PaymentTermsDescription,
  cast(pimp.vl_pedido_importacao as decimal(25,4)) as TotalValue,
  cast(0 as decimal(25,4)) as Freight,
  i.cd_idioma as Idioma,
  IsNull(f.nm_razao_social,'') as ExporterName,
  RTrim(IsNull(f.nm_endereco_fornecedor,'')) + ' ' + IsNull(f.cd_numero_endereco,'') as ExporterAdress,
  cid.nm_cidade as ExporterCity,
  f.cd_telefone as ExporterPhone,
  f.cd_fax as ExporterFax,
  IsNull(f.cd_tipo_mercado,1) as TipoMercado,
  f.ds_endereco_fornecedor as EnderecoFormatado
from
  Pedido_Importacao pimp
  left outer join Importador imp on imp.cd_importador = pimp.cd_importador
-- Relacionamentos do Importador
  left outer join Pais paimp on paimp.cd_pais = imp.cd_pais
  left outer join Estado ufi on ufi.cd_pais = imp.cd_pais and
                                ufi.cd_estado = imp.cd_estado
  left outer join Cidade ci  on ci.cd_pais = imp.cd_pais and
                                ci.cd_estado = imp.cd_estado and
                                ci.cd_cidade = imp.cd_cidade
-- Relacionamento do Pais de Origem
  left outer join Pais po on po.cd_pais = pimp.cd_origem_pais
-- Relacionamento do Transportador
  left outer join Transportadora t on t.cd_transportadora = pimp.cd_transportadora
-- Relationamento do Porto de Origem
  left outer join Porto por on por.cd_porto = pimp.cd_porto_origem
-- Relacionamento do Porto de Destino
  left outer join Porto pdt on pdt.cd_porto = pimp.cd_porto
-- Relacionamento do Despachante
  left outer join Despachante d on d.cd_despachante = pimp.cd_despachante
  -- IMPORTANTE, ESTE RELACIONAMENTO EXISTE PARA FORCAR A LISTAGEM DE UM REGISTRO POR IDIOMA
  left outer join Idioma i on i.cd_idioma = i.cd_idioma
-- Relacionamento da Condicao de Pagamento
  left outer join Condicao_Pagamento_Idioma cpi on cpi.cd_condicao_pagamento = pimp.cd_condicao_pagamento and
                                                   cpi.cd_idioma = i.cd_idioma
-- Relacionamento do Exportador (Fornecedor)
  Left outer join Fornecedor f on pimp.cd_fornecedor = f.cd_fornecedor
-- Relacionamento da Cidade do Fornecedor
  Left outer join Cidade cid on f.cd_cidade = cid.cd_cidade
