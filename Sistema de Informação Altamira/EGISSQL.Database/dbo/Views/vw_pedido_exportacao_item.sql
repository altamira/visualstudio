-------------------------------------------------------------------------------------------
--vw_pedido_exportacao_item
-------------------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                                                2004
-------------------------------------------------------------------------------------------
-- Stored Procedure      : Microsoft SQL Server 2000
-- Autor(es)             : Elias Pereira da Silva
-- Banco de Dados        : EGISSQL
-- Objetivo              : Consulta dos Itens do Pedidos de Exportação
-- Data                  : ???
-- Atualização           : 14/10/2004 - Inclusão da Unidade de Medida e Descrição do Produto em 
--                                      Outro Idioma - ELIAS
--                       : 17/11/2004 - Tirada nm_produto quando ic_descricao_tecnica = 'S' - Daniel C. Neto.
--                       : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                       : 21/02/2005 - Incluído o Campo DescriçãoIdioma que traz a descrição em
--                                      todos os idiomas e que é utilizado nos relatórios:
--                                      Quotation, Commercial Invoice, Proforma Invoice, Packing List
--                                      Preshipment Information, Certificate of Analysis - ELIAS
--                       : 01.12.2005 - Descrição do Idioma - Carlos Fernandes
--                       : 06.03.2006 - Máscara da Unidade de Medida - Carlos Fernandes
--                       : 29/08/2006 - Acerto no relacionamento da Unidade de Medida - Daniel Carrasco  
--                       : 21.10.2007 - Acertos conforme solicitação Cliente (Mellon) - Carlos Fernandes
--
---------------------------------------------------------------------------------------------------


create view vw_pedido_exportacao_item
as

select 
  cast(pexp.cd_pedido_venda as int)                as PedidoExportacao,  
  cast(pexp.cd_item_pedido_venda as int)           as ItemPedidoExportacao,
  cast(ui.nm_unidade_medida_idioma as varchar(50)) as Packing,
  cast(pexp.qt_item_pedido_venda as decimal(25,4)) as Quantity,

  --Descrição do Produto

  case when (isnull((select ic_descricao_tecnica from parametro_exportacao
                     where cd_empresa = dbo.fn_empresa()),'N') = 'S') then
--    rtrim(isnull(pi.nm_produto_idioma,p.nm_produto))+
      case when (isnull(cast(pi.ds_produto_idioma as varchar(500)), 
                        cast(p.ds_produto as varchar(500))) <> '') then
          isnull(cast(pi.ds_produto_idioma as varchar(500)), 
                 cast(p.ds_produto as varchar(500))) end
  else
    rtrim(isnull(pi.nm_produto_idioma + char(13) +
    LTrim(p.nm_produto_complemento)+ char (13) + 
    LTrim(cast(pi.ds_produto_idioma as VarChar(500))),p.nm_produto))
  end                                                   as ProductDescription,

  pi.nm_produto_idioma                                  as ProductName,


  cast(pexp.qt_bruto_item_pedido as decimal(25,4))      as GrossWeight,
  cast(pexp.qt_liquido_item_pedido as decimal(25,2))    as NetWeight,
  cast(pexp.vl_unitario_item_pedido as decimal(25,4))   as UnitPrice,
  cast((pexp.qt_item_pedido_venda * 
        pexp.vl_unitario_item_pedido) as decimal(25,4)) as TotalPrice,
  Rtrim(mo.sg_moeda)                                    as Coin,
  i.cd_idioma                                           as Idioma,
  pexp.dt_entrega_vendas_pedido                         as RequiredDelivery,
  p.nm_produto_complemento                              as 'Complemento',
  pe.ds_produto_exportacao                              as 'Descricao',
  cast(dbo.fn_descritivo_produto_idioma(pexp.cd_produto,
       i.cd_idioma) as text)                            as 'DescricaoIdioma',
  p.ds_produto                                          as 'DescricaoTecnica',
  dbo.fn_mascara_quantidade(  case when um.qt_decimal_unidade_medida is null then 
                                       isnull(
                                              (select isnull(qt_casa_decimal_documento,0)
                                               from
                                                 Parametro_Exportacao
                                               where
                                                 cd_empresa = dbo.fn_empresa() ),isnull(um.qt_decimal_unidade_medida,0) )     
                                    else um.qt_decimal_unidade_medida end )             as 'MascaraDocumento'


from
  Pedido_Venda_Item pexp with (nolock) 
  inner join      Pedido_Venda_exportacao pve    on pexp.cd_pedido_venda = pve.cd_pedido_venda
  left outer join Produto p                      on p.cd_produto = pexp.cd_produto
  left outer join Unidade_Medida um              on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join Moeda mo                       on pexp.cd_moeda_cotacao = mo.cd_moeda
  left outer join Idioma i                       on i.cd_idioma = pve.cd_idioma 
  left outer join Unidade_Idioma ui              on ui.cd_idioma = i.cd_idioma and
                                                    ui.cd_unidade_medida = um.cd_unidade_medida
  left outer join Produto_Idioma pi              on pi.cd_produto = pexp.cd_produto and 
                                                    pi.cd_idioma = i.cd_idioma
  left outer join Produto_Exportacao pe          on pe.cd_produto=p.cd_produto and 
					            pe.cd_categoria_produto = p.cd_categoria_produto
 

