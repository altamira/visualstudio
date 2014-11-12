
--------------------------------------------------------------------------------------------------------
--vw_pedido_exportacao
--------------------------------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                       2004
--------------------------------------------------------------------------------------------------------
-- Stored Procedure     : Microsoft SQL Server 2000
-- Autor(es)            : Elias Pereira da Silva
-- Banco de Dados       : EGISSQL
-- Objetivo             : Consulta dos Pedidos de Exportação
-- Data                 : ???
-- Atualização          : 14/10/2004 - Inclusão do Idioma, Condição e Tipo de Embarque - ELIAS
--                      : 20/10/2004 - Acerto de campos - Daniel C. Neto.
--                      : 19/11/2004 - Paulo Souza
--                                     Trazer se o tipo de mercado e o endereco formatado para mercado externo
--                      : 22/12/2004 - Inserido campo "PaymentTermsDescriptionMemo," 
--                                     não podendo ser feita conversão, posi não funciona no relatório
--                      : 28/12/2004 -  Acerto do Cabeçalho - Sérgio Cardoso
--                      : 17/02/2005 - Incluído campo Tipo_Embalagem - Andre Gati
--			                : 06/04/2005 - Inclusao do campo Registro - Clelson Camargo - OS 0-sexp-04042005-1119
--                      : 09/05/2005 - Incluído relacionamento do Contato do Exportador com o Pedido de Exportação - ELIAS
--			: 17/11/2005 - Incluído case que virifica se pedido é diferente do embarque na condição de pagamento - Ricardo 
--                      : 01.12.2005 - Verificação da Emissão - Carlos Fernandes.
--                      : 20.12.2005 - Nome do Contato Completo - Carlos Fernandes.
--                      : 22.02.2006 - Campo de Complemento do Beneficiário - Carlos Fernandes
--                        28/08/2006 - Acerto no relacionamento de idioma - Daniel C. neto.
--                        09/10/2006 - Incluído sg_moeda - Daniel C. Neto.
--                        17.04.2007 - Verificação do Sigla do Incoterm  no Valor Total - Carlos Fernandes
--                        18.07.2007 - Local do Incoterm mudança para o Auxiliar - Carlos Fernandes
----------------------------------------------------------------------------------------------------------

CREATE   view vw_pedido_exportacao
as

select 
  cast(pexp.cd_pedido_venda as int)                                                    as PedidoExportacao,
  cast(imp.nm_razao_social_cliente +' '+imp.nm_razao_social_cliente_c as varchar(150)) as ImporterName,
  cast(imp.nm_endereco_cliente+', '+cast(imp.cd_numero_endereco as varchar)+' '+
       imp.nm_bairro as varchar(250))                                                  as ImporterAdress,
  imp.cd_cep+' '+ci.nm_cidade+' '+ufi.sg_estado+' '+paimp.sg_pais                      as ImporterCity,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_telefone as varchar(50))            as ImporterPhone,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_fax as varchar(50))                 as ImporterFax,
  cast(export.nm_razao_social as varchar(100))                                         as ExporterName,
  cast(export.nm_endereco+', '+cast(export.cd_numero_endereco as varchar)+' '+
       export.nm_bairro as varchar(250))                                               as ExporterAdress,
  export.cd_cep+' '+ce.nm_cidade+' '+ufe.sg_estado+' '+pexport.sg_pais                 as ExporterCity,
  cast(pexport.cd_ddi_pais+' '+export.cd_ddd+' '+export.cd_telefone as varchar(50))    as ExporterPhone,
  cast(pexport.cd_ddi_pais+' '+export.cd_ddd+' '+export.cd_fax as varchar(50))         as ExporterFax,  
  cast(case when isnull(pexp.cd_identificacao_empresa,'')='' then
    pexp.cd_pedido_venda 
  else
    pexp.cd_identificacao_empresa 
  end as varchar(20))                                as YourReference,
  case when isnull(nm_proforma_invoice,'')='' then
    cast(pexp.cd_pedido_venda as varchar)+' - '+imp.nm_fantasia_cliente
  else 
    nm_proforma_invoice
  end                                                as ProformaInvoice,
  cast(pedexp.dt_prev_emb_ped_venda as datetime)     as ShippingDate,
  cast(null as varchar(50))                          as Packing,
  cast(p.nm_pais as varchar(50))                     as CountryOrigin,
  cast(tti.nm_tipo_transporte_idioma as varchar(50)) as Shipment,
  cast(t.nm_transportadora as varchar(50))           as ShippedBy,
  cast(po.nm_porto as varchar(50))                   as PlaceShipment,
  cast(poo.nm_porto as varchar(50))                  as PlaceDestination,
  cast(null as varchar(150))                         as Consignee,
  cast(cpi.nm_condicao_pgto_idioma as varchar(150))  as PaymentTerms,
  cast(cpi.ds_condicao_pgto_idioma as varchar(8000)) as PaymentTermsDescription,
  cpi.ds_condicao_pgto_idioma                        as PaymentTermsDescriptionMemo,
  cast(pexp.vl_total_pedido_venda as decimal(25,4))  as Value,
  cast(isnull(pexp.vl_frete_pedido_venda,0) as decimal(25,4))        as Freight,
  cast(IsNull(pedexp.vl_seguro_int_pedido_venda,0) as decimal(25,4)) as Insurance,
  cast(pexp.vl_total_pedido_venda + isnull(pexp.vl_frete_pedido_venda,0) + 
       IsNull(pedexp.vl_seguro_int_pedido_venda,0) as decimal(25,2)) as TotalValue,
  cast(desp.nm_razao_social as varchar(50))                          as Dispatcher,
  cast(pedexp.nm_emb_ped_venda as varchar(50))                       as EmbarkmentArea,
  cast(pedexp.nm_responsavel as varchar(25))                         as Responsavel,
  cast(pedexp.nm_numero_carta_credito as varchar(25))                as LetterCredit,
  pedexp.dt_vencimento_carta_credito                                 as ExpirationDateCredit,
  pexp.dt_pedido_venda                                               as EmissaoPedido,
  cast(pexp.qt_volume_pedido_venda as decimal(25,4))  as CubicMeters,
  cast(pexp.qt_liquido_pedido_venda as decimal(25,4)) as NetWeight,
  cast(pexp.qt_bruto_pedido_venda as decimal(25,4))   as GrossWeight,
  i.cd_idioma                                         as Idioma,
  cc.nm_fantasia_contato,
  cc.nm_contato_cliente,
  u.nm_fantasia_usuario               as 'UsuarioResponsavel',
  IsNull(tc.ic_tipo_local_porto,'D')  as 'IncotermLocal',
  IsNull(tca.ic_tipo_local_porto,'D') as 'IncotermLocalAux',
  tc.sg_termo_comercial               as 'Incoterm',
  tca.sg_termo_comercial              as 'IncotermAux',
  ec.nm_contato_exportador,
  IsNull(imp.cd_tipo_mercado,'1')     as 'TipoMercado',
  IsNull(imp.ds_cliente_endereco,'')  as 'EnderecoFormatado',
  tco.nm_tipo_container               as 'NomeTipoContainer',
  tco.qt_tipo_container               as 'QtdTipoContainer',
  e.nm_obs_prazo_embarque             as 'ObsPrazoEmbarque',
  e.ds_cond_pagto_embarque            as 'CondPagtoEmbarque',
  te.sg_tipo_embalagem                as 'Tipo_Embalagem',
  ts.ds_mensagem_seguro               as 'MensagemSeguro',
  export.nm_complemento_endereco      as 'Registro',
  case
   when IsNull(imp.cd_cnpj_cliente,'') = '' then null
   else dbo.fn_formata_cnpj(imp.cd_cnpj_cliente) 
    end as cnpj_cliente,
  e.nm_extenso                       as 'ValorExtenso',
  e.ds_informacao_adicional          as 'InformacaoAdicional',
  pdest.nm_pais                      as 'CountryDestination',
  e.dt_embarque,
  e.cd_governing_law,
  e.cd_arbitration_clause,
  e.cd_condicao_pagamento,
  e.cd_termo_comercial,
  e.cd_tipo_embalagem,
  e.cd_beneficiario,
  e.cd_embarque,
  ppsaida.nm_pais                    as 'Pais_P_Saida',
  ppentrada.nm_pais                  as 'Pais_P_Entrada',
  mo.sg_moeda,
  IsNull(export.cd_tipo_mercado,'1') as TipoMercadoExp,
  export.ds_exportador_endereco,
  export.nm_cidade_mercado_externo,
  export.sg_estado_mercado_externo,
  export.nm_pais_mercado_externo
from
  Pedido_venda pexp
  left outer join Cliente imp on imp.cd_cliente = pexp.cd_cliente
  left outer join Exportador export on export.cd_exportador = pexp.cd_exportador
-- Relacionamentos do Importador
  left outer join Pais paimp on paimp.cd_pais = imp.cd_pais
  left outer join Estado ufi on ufi.cd_pais = imp.cd_pais and
                                ufi.cd_estado = imp.cd_estado
  left outer join Cidade ci  on ci.cd_pais = imp.cd_pais and
                                ci.cd_estado = imp.cd_estado and
                                ci.cd_cidade = imp.cd_cidade
-- Relacionamentos do Exportador
  left outer join Pais pexport on pexport.cd_pais = export.cd_pais
  left outer join Estado ufe   on ufe.cd_pais = export.cd_pais and
                                  ufe.cd_estado = export.cd_estado
  left outer join Cidade ce    on ce.cd_pais = export.cd_pais and
                                  ce.cd_estado = export.cd_estado and
                                  ce.cd_cidade = export.cd_cidade
-- Relacionamento do Transportador
  left outer join Transportadora t on t.cd_transportadora = pexp.cd_transportadora
-- Relacionamento do Pedido Exportacao
  left outer join Pedido_Venda_Exportacao pedexp on pedexp.cd_pedido_venda = pexp.cd_pedido_venda
-- Relacionamento do Despachante
  left outer join Despachante desp on desp.cd_despachante = pedexp.cd_despachante
-- Relacionamento do Pais Origem
  left outer join Pais p on p.cd_pais = pedexp.cd_origem_pais
  left outer join Pais pdest on pdest.cd_pais = pedexp.cd_destino_pais
-- Relacionamento do Metodo de Embarque
  left outer join Tipo_Importacao ti on ti.cd_tipo_importacao = pedexp.cd_tipo_importacao
-- Relacionamento do Porto origem e destino
  left outer join Porto po on po.cd_porto = pedexp.cd_porto_origem
  left outer join Porto poo on poo.cd_porto = pedexp.cd_porto_destino
  left outer join Cliente_Contato cc on cc.cd_cliente = pexp.cd_cliente and
                                        cc.cd_contato = pexp.cd_contato
  left outer join EGISADMIN.dbo.Usuario u       on u.cd_usuario = pexp.cd_usuario 
  left outer join Idioma i                      on i.cd_idioma = pedexp.cd_idioma
  left outer join Tipo_Transporte_Idioma tti    on pedexp.cd_tipo_transporte = tti.cd_tipo_transporte and
                                                   tti.cd_idioma = i.cd_idioma
  left outer join Embarque e                    on e.cd_pedido_venda = pexp.cd_pedido_venda
  left outer join Termo_Comercial tca           on tca.cd_termo_comercial = e.cd_aux_termo_comercial
  left outer join Condicao_Pagamento_Idioma cpi on cpi.cd_idioma = i.cd_idioma and

  -- Ricardo -- 17-nov-2005     
  case when e.cd_condicao_pagamento <> pexp.cd_condicao_pagamento then
    e.cd_condicao_pagamento   
  else
    pexp.cd_condicao_pagamento
  end = cpi.cd_condicao_pagamento

  left outer join Termo_Comercial tc on (tc.cd_termo_comercial = pedexp.cd_termo_comercial)
  left outer join Exportador_Contato ec on (ec.cd_exportador = pexp.cd_exportador) and
                                           (ec.cd_contato_exportador = pedexp.cd_contato_exportador)

  left outer join tipo_container tco on e.cd_tipo_container = tco.cd_tipo_container 
-- Relacionamento do tipo de embalagem - 17/02/05 - Andre Gati
  left outer join tipo_embalagem te on te.cd_tipo_embalagem=pedexp.cd_tipo_embalagem
-- Relacionamento do tipo de seguro - 17/02/05 - Andre Gati
  left outer join tipo_seguro ts on ts.cd_tipo_seguro=pedexp.cd_tipo_seguro
  left outer join Pais ppsaida on ppsaida.cd_pais = po.cd_pais
-- Relacionamento do Pais Destino
  left outer join Pais ppentrada on ppentrada.cd_pais = poo.cd_pais
  left outer join Moeda mo on mo.cd_moeda = pexp.cd_moeda

