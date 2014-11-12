
create view vw_embarque_importacao_item
-------------------------------------------------------------------------------------------
-- vw_embarque_importacao_item
-------------------------------------------------------------------------------------------
-- GBS - Global Business solution Ltda                                                 2004
-------------------------------------------------------------------------------------------
-- Stored Procedure     : Microsoft SQL Server 2000
-- Autor(es)            : Elias Pereira da Silva
-- Banco de Dados       : EGISSQL
-- Objetivo             : Consulta dos Itens do Pedidos de Exportação
-- Data                 : 
-- Atualização          : 14/10/2004 - Inclusão da Unidade de Medida e Descrição do Produto em 
--                                     Outro Idioma - ELIAS
--                      : 27.10.2004 - Inclusão de campos necessários para o relatório de exportação - IGOR GAMA
--                      : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------------------
as

select 
  cast(ei.cd_embarque as int) as Embarque,
  cast(ei.cd_embarque_item as int) as ItemEmbarque,
  cast(pexp.cd_pedido_importacao as int) as Pedidoimportacao,  
  cast(pexp.cd_item_pedido_venda as int) as ItemPedidoimportacao,
  cast(ui.nm_unidade_medida_idioma as varchar(50)) as Packing,
  cast(ei.qt_produto_embarque as decimal(25,4)) as Quantity,
  case when (isnull((select ic_descricao_tecnica from parametro_importacao
                     where cd_empresa = dbo.fn_empresa()),'N') = 'S') then
    rtrim(isnull(pi.nm_produto_idioma,p.nm_produto))+
      case when (isnull(cast(pi.ds_produto_idioma as varchar(500)),'') <> '') then
        char(13)+isnull(cast(pi.ds_produto_idioma as varchar(500)),'') end
  else
    rtrim(isnull(pi.nm_produto_idioma,p.nm_produto))
  end  as ProductDescription,
  cast(ei.qt_peso_bruto_embarque as decimal(25,4)) as GrossWeight,
  cast(ei.qt_peso_liquido_embarque as decimal(25,2)) as NetWeight,
  cast(ei.vl_produto_embarque as decimal(25,4)) as UnitPrice,
  cast((ei.qt_produto_embarque * ei.vl_produto_embarque) as decimal(25,4)) as TotalPrice,
  Rtrim(mo.sg_moeda) as Coin,
  i.cd_idioma as Idioma,
  ei.dt_producao_item_embarque as 'dt_expiry', --Data validade
  ei.dt_validade_item_embarque as 'dt_production', --Data produção
  ei.cd_lote_item_embarque as 'cd_lote',
  p.nm_produto,
  p.nm_fantasia_produto
from
  Embarque_Importacao_Item ei 
  left outer join Pedido_Importacao pimp on pimp.cd_pedido_importacao = ei.cd_pedido_importacao
  left outer join Pedido_Importacao_Item pexp on pexp.cd_pedido_importacao = ei.cd_pedido_importacao and
                                            pexp.cd_item_ped_imp = ei.cd_item_ped_imp
  left outer join Produto p on p.cd_produto = pexp.cd_produto
  left outer join Moeda mo on pimp.cd_moeda = mo.cd_moeda
  left outer join Idioma i on i.cd_idioma = i.cd_idioma
  left outer join Unidade_Idioma ui on ui.cd_idioma = i.cd_idioma
  left outer join Produto_Idioma pi on pi.cd_produto = pexp.cd_produto and pi.cd_idioma = i.cd_idioma

