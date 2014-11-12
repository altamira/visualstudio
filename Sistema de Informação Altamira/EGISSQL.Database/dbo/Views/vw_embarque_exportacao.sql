
create view vw_embarque_exportacao

-----------------------------------------------------------------
--vw_embarque_exportacao
-----------------------------------------------------------------
-- GBS - Global Business Solution Ltda                       2004
-----------------------------------------------------------------
-- Stored Procedure     : Microsoft SQL Server 2000
-- Autor(es)            : Elias Pereira da Silva
-- Banco de Dados       : EGISSQL
-- Objetivo             : Consulta dos Embarques de Exportação
-- Data                 : 14/10/2004
-- Atualização          : 04/11/2004 - Acertado Relacionamento com a Tabela de Idioma e Pais de Destino - ELIAS
--                      : 19/11/2004 - Paulo Souza
--                                     Trazer se é mercado interno/externo e o endereço formatado para mercado externo
-- Alteração            : 01/12/2004 - Paulo Santos - Traz tipo de frete
-- Alteração            : 15/12/2004 - Paulo Santos - Traz tipo container e tipo embalagem
--                      : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--			: 05.04.2005 - Acerto do campo insurance de e.vl_outra_despesa_embarque para pedexp.vl_seguro_int_pedido_venda - Clelson Camargo
--			: 06.04.2005 - Inclusao do campo Registro - Clelson Camargo - OS 0-sexp-04042005-1119
--			: 07.04.2005 - Inclusao do CNPJ - Clelson Camargo - OS 0-sexp-04042005-1712
--                      : 22.02.2006 - Acertos Diversos - Carlos Fernandes
--                        28/08/2006 - Acerto no relacionamento com idioma - Daniel C. Neto.
--                        29/09/2006 - Incluído campos de país para os portos de embarque e desembarque - Daniel C. Neto.
--                        09/10/2006 - Incluído sg_moeda - Daniel C. Neto.
--                        06/01/2007 - Adicionando o Endereço Especial
--                        18.05.2007 - Acerto da Incorterm Adicional - Carlos Fernandes
--                        18.07.2007 - Acerto do Local do Incoterm Adicional - Carlos Fernandes
-----------------------------------------------------------------------------------------------
as

--select rtrim('  Carlos   ')+'a'

select 
  cast(pexp.cd_pedido_venda as int)                                                                             as PedidoExportacao,
  cast(e.cd_embarque as int)                                                                                    as Embarque,
  cast(imp.nm_razao_social_cliente +' '+imp.nm_razao_social_cliente_c as varchar(150))                          as ImporterName,
  cast(imp.nm_endereco_cliente+', '+cast(imp.cd_numero_endereco as varchar)+' '+imp.nm_bairro as varchar(250))  as ImporterAdress,
  cast(imp.cd_cep+' '+ci.nm_cidade+' '+ufi.sg_estado+' '+paimp.sg_pais as varchar(100))                         as ImporterCity,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_telefone as varchar(50))                                     as ImporterPhone,
  cast(paimp.cd_ddi_pais+' '+imp.cd_ddd+' '+imp.cd_fax as varchar(50))                                          as ImporterFax,
  cast(export.nm_razao_social as varchar(100))                                                                  as ExporterName,
  cast(rtrim(isnull(export.nm_endereco,''))+', '+
       rtrim(isnull(export.cd_numero_endereco,''))+' '+
       rtrim(isnull(export.nm_bairro,'')) as varchar(250))                                                      as ExporterAdress,
  cast(rtrim(isnull(export.cd_cep,'')) +' '+
       rtrim(isnull(ce.nm_cidade,''))  +' '+
       rtrim(isnull(ufe.sg_estado,'')) +' '+
       rtrim(isnull(pexport.nm_pais,'')+'-'+
       rtrim(isnull(pexport.sg_pais,''))) as varchar(250))                                                      as ExporterCity,
  cast(pexport.cd_ddi_pais+' '+export.cd_ddd+' '+export.cd_telefone as varchar(50))                             as ExporterPhone,
  cast(pexport.cd_ddi_pais+' '+export.cd_ddd+' '+export.cd_fax as varchar(50))                                  as ExporterFax,  
  cast(pexp.cd_identificacao_empresa as varchar(20))                                                            as YourReference,
  nm_proforma_invoice as ProformaInvoice,
  cast(e.dt_previsao_embarque as datetime)                                                                      as ShippingDate,
  cast(null as varchar(50))                                                                                     as Packing,
  cast(p.nm_pais as varchar(50)) as CountryOrigin,
  cast(pd.nm_pais as varchar(50)) as CountryDestination,
  cast(tti.nm_tipo_transporte_idioma as varchar(50)) as Shipment,
  cast(t.nm_transportadora as varchar(50)) as ShippedBy,
  cast(po.nm_porto as varchar(50)) as PlaceShipment,
  cast(poo.nm_porto as varchar(50)) as PlaceDestination,
  cast(c.nm_razao_social as varchar(150)) as Consignee,
  cast(cpi.nm_condicao_pgto_idioma as varchar(150)) as PaymentTerms,
  cast(cpi.ds_condicao_pgto_idioma as varchar(8000)) as PaymentTermsDescription,
  cpi.ds_condicao_pgto_idioma as PaymentTermsDescriptionMemo,
  cast(e.vl_mercadoria_embarque as decimal(25,4)) as Value,
  cast(isnull(e.vl_frete_embarque,0) as decimal(25,4)) as Freight,
  fr.nm_tipo_frete as Freight_Type, -- psantos
  --te.nm_tipo_embalagem        as tipo_embalagem, -- psantos 15/12/2004
  --te.sg_tipo_embalagem        as tipo_embalagem,
  --Sigla - Carlos 22.02.2006
  case when isnull(te.sg_tipo_embalagem,'') <> '' then te.sg_tipo_embalagem else te.nm_tipo_embalagem end as tipo_embalagem,
  tc.nm_tipo_container        as tipo_container, -- psantos 15/12/2004
  e.nm_marca_numero_container as Marca_Numero_Container,
  e.nm_compl_01_container     as Complemento_Container_01,
  e.nm_compl_02_container     as Complemento_Container_02,
  e.nm_compl_03_container     as Complemento_Container_03,
  cast(IsNull(pedexp.vl_seguro_int_pedido_venda,0) as decimal(25,4)) as Insurance,
  cast(e.vl_mercadoria_embarque + isnull(e.vl_frete_embarque,0) + Isnull(e.vl_cobertura_seguro,0) +
       IsNull(e.vl_outra_despesa_embarque,0) as decimal(25,2)) as TotalValue,
  cast(desp.nm_razao_social as varchar(50)) as Dispatcher,
  cast(pedexp.nm_emb_ped_venda as varchar(50)) as EmbarkmentArea,
  cast(pedexp.nm_responsavel as varchar(25)) as Responsavel,
  cast(pedexp.nm_numero_carta_credito as varchar(25)) as LetterCredit,
  pedexp.dt_vencimento_carta_credito as ExpirationDateCredit,
  pexp.dt_pedido_venda as EmissaoPedido,
  cast(pexp.qt_volume_pedido_venda as decimal(25,4)) as CubicMeters,
  cast(e.qt_peso_liquido_embarque as decimal(25,4)) as NetWeight,
  cast(e.qt_peso_bruto_embarque as decimal(25,4)) as GrossWeight,
  i.cd_idioma                             as Idioma,
  cc.nm_fantasia_contato,
  u.nm_fantasia_usuario                   as 'UsuarioResponsavel',
  cast(e.dt_previsao_chegada as datetime) as EstimatedArrival,
  cast(e.dt_bl_awb as datetime)           as dt_bl_awb,
  IsNull(imp.cd_tipo_mercado,'1')         as TipoMercado,
  IsNull(imp.ds_cliente_endereco,'')      as EnderecoFormatado,
  IsNull(tcm.ic_tipo_local_porto,'D')     as 'IncotermLocal',
  IsNull(tcm.sg_termo_comercial,'')       as 'Incoterm',
  IsNull(tca.ic_tipo_local_porto,'D')     as 'IncotermLocalAux',
  Isnull(tca.sg_termo_comercial,'')       as 'IncotermAux',
  e.ds_obs_bancario                       as Observacao_Bancaria,
  e.ds_mensagem_packing_list              as ObsPackingList,
  (
    select 
      max(dt_vcto_parcela_embarque)
    from 
      embarque_parcela 
    where 
      cd_pedido_venda = e.cd_pedido_venda and 
      cd_embarque = e.cd_embarque
  ) as DueDate,
  e.nm_navio_aviao as Vessel,
  export.nm_complemento_endereco as Registro,
  case
    when IsNull(imp.cd_cnpj_cliente,'') = '' then null
    else dbo.fn_formata_cnpj(imp.cd_cnpj_cliente) 
  end as cnpj_cliente,
  (
    select nm_empresa from egisadmin..empresa where cd_empresa = dbo.fn_empresa()
  ) as Empresa,
  ppsaida.nm_pais as 'Pais_P_Saida',
  ppentrada.nm_pais as 'Pais_P_Entrada',
  mo.sg_moeda,
  IsNull(export.cd_tipo_mercado,'1') as TipoMercadoExp,
  export.ds_exportador_endereco,
  export.nm_cidade_mercado_externo,
  export.sg_estado_mercado_externo,
  export.nm_pais_mercado_externo
from
  Pedido_venda pexp
  left outer join Tipo_Frete fr on fr.cd_tipo_frete = pexp.cd_tipo_frete 
  left outer join Embarque e on e.cd_pedido_venda = pexp.cd_pedido_venda
  left outer join tipo_embalagem te on e.cd_tipo_embalagem = te.cd_tipo_embalagem -- psantos
  left outer join tipo_container tc on e.cd_tipo_container = tc.cd_tipo_container -- psantos
  left outer join Cliente imp on imp.cd_cliente = pexp.cd_cliente
  left outer join Exportador export on export.cd_exportador = pexp.cd_exportador
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
-- Relacionamento do Pedido Exportacao
  left outer join Pedido_Venda_Exportacao pedexp on pedexp.cd_pedido_venda = pexp.cd_pedido_venda
-- Relacionamento do Despachante
  left outer join Despachante desp on desp.cd_despachante = e.cd_despachante
-- Relacionamento do Pais Origem
  left outer join Pais p on p.cd_pais = pedexp.cd_origem_pais
-- Relacionamento do Pais Destino
  left outer join Pais pd on pd.cd_pais = pedexp.cd_destino_pais
-- Relacionamento do Metodo de Embarque
  left outer join Tipo_Importacao ti on ti.cd_tipo_importacao = pedexp.cd_tipo_importacao
-- Relacionamento do Porto origem e destino
  left outer join Porto po on po.cd_porto = e.cd_porto_saida
  left outer join Porto poo on poo.cd_porto = e.cd_porto_destino
  left outer join Cliente_Contato cc on cc.cd_cliente = pexp.cd_cliente and
                                        cc.cd_contato = pexp.cd_contato
  left outer join EGISADMIN.dbo.Usuario u on u.cd_usuario = pexp.cd_usuario 
  -- IMPORTANTE, ESTE RELACIONAMENTO EXISTE PARA FORCAR A LISTAGEM DE UM REGISTRO POR IDIOMA
  left outer join Idioma i on i.cd_idioma = pedexp.cd_idioma
  left outer join Tipo_Transporte_Idioma tti on e.cd_tipo_transporte = tti.cd_tipo_transporte and
                                                tti.cd_idioma = i.cd_idioma
  left outer join Condicao_Pagamento_Idioma cpi on pexp.cd_condicao_pagamento = cpi.cd_condicao_pagamento and
                                                   cpi.cd_idioma = i.cd_idioma
  left outer join Consignatario c on c.cd_consignatario = e.cd_consignatario
  left outer join Termo_Comercial tcm on tcm.cd_termo_comercial = pedexp.cd_termo_comercial
  left outer join Termo_Comercial tca on tca.cd_termo_comercial = e.cd_aux_termo_comercial
  left outer join Pais ppsaida on ppsaida.cd_pais = po.cd_pais
-- Relacionamento do Pais Destino
  left outer join Pais ppentrada on ppentrada.cd_pais = poo.cd_pais
  left outer join Moeda mo on mo.cd_moeda = pexp.cd_moeda

