
create view vw_pedido_importacao_item
as

select 
  cast(pimp.cd_pedido_importacao as int) as PedidoImportacao,  
  cast(pimp.cd_item_ped_imp as int) as ItemPedidoImportacao,
  cast(te.nm_tipo_embalagem as varchar(50)) as Packing,
  cast(pimp.qt_item_ped_imp as decimal(25,4)) as Quantity,
  case when (isnull((select ic_descricao_tecnica from parametro_importacao
                     where cd_empresa = dbo.fn_empresa()),'N') = 'S') then
      case when (isnull(cast(pi.ds_produto_idioma as varchar(500)), cast(p.ds_produto as varchar(500))) <> '') then
        char(13)+isnull(cast(pi.ds_produto_idioma as varchar(500)), cast(p.ds_produto as varchar(500))) end
  else
    rtrim(isnull(pi.nm_produto_idioma,p.nm_produto))
  end  as ProductDescription,
  cast(pimp.vl_item_ped_imp as decimal(25,4)) as UnitPrice,
  cast((pimp.qt_item_ped_imp * pimp.vl_item_ped_imp) as decimal(25,4)) as TotalPrice,
  Rtrim(mo.sg_moeda) as Coin,
  i.cd_idioma as Idioma

from
  Pedido_Importacao_Item pimp
  left outer join Pedido_Importacao pmp on pmp.cd_pedido_importacao = pimp.cd_pedido_importacao
  left outer join Tipo_Embalagem te on te.cd_tipo_embalagem = pimp.cd_tipo_embalagem
  left outer join Produto p on p.cd_produto = pimp.cd_produto
  left outer join Idioma i on i.cd_idioma = i.cd_idioma
  left outer join Unidade_Idioma ui on ui.cd_idioma = i.cd_idioma
  left outer join Produto_Idioma pi on pi.cd_produto = pimp.cd_produto and pi.cd_idioma = i.cd_idioma
  left outer join Moeda mo on pmp.cd_moeda = mo.cd_moeda

