

create procedure pr_transferencia_custo
@dt_inicial      datetime,
@dt_final        datetime
as 

select

  ns.cd_nota_saida             as 'NF'
  , ns.dt_nota_saida           as 'DATANF'

  , nsi.qt_item_nota_saida     as 'QT'
  , nsi.vl_total_item + IsNull(nsi.vl_frete_item,0) + 
    isnull(nsi.vl_seguro_item,0) + isnull(nsi.vl_desp_acess_item,0) as 'VLR' 
  , nsi.cd_pedido_venda        as 'PEDIDO'
  , nsi.qt_devolucao_item_nota as 'QTDEV'
  , nsi.cd_item_nota_saida     as 'ITEMNF'

  , ''                         as 'EMPRESA' 
--  , cast('1' as char(1) )      as 'EMPRESA' 
  , cast('F' as char(1) )      as 'TIPONF'
  , ''                         as 'SERIE'
--  , IsNull(snf.sg_serie_nota_fiscal,'NFF') as 'SERIE'
  , 'DEVPARC' =
       Case When ns.cd_status_nota in ( 3, 4 ) then 'S' Else 'N' End

  -- Dados do Produto Padrão
  , p.cd_mascara_produto     as 'COD_ITEM_PADR' 

  , nsi.nm_produto_item_nota as 'DESCRICAO_PADR'
  , 'PRODREV_PADR' =
    Case When ( IsNull(gp.ic_revenda_grupo_produto,'N') = 'S' ) then 'S'
         When ( IsNull(p.ic_revenda_produto,'N') = 'S' ) then 'S'
         Else 'N' End
  , cpp.cd_mascara_categoria     as 'NCMAPA_PADR'

  -- Dados do Produto Especial
  , cast( cast(gp.cd_grupo_produto as varchar(2)) + '9999999' as integer ) as 'COD_ITEM_ESP'
  , nsi.nm_produto_item_nota    as 'DESCRICAO_ESP'
  , cpg.cd_mascara_categoria    as 'NCMAPA_ESP'

  , 'PRODUTOESPECIAL' =
       Case When  gp.ic_especial_grupo_produto = 'S' then 'S' --(( nsi.cd_produto is null ) or ( nsi.cd_produto = 0 )) then 'S'
            Else 'N'
       End
     
from
  nota_saida ns

--  left outer join serie_nota_fiscal snf
--  on snf.cd_serie_nota_fiscal = ns.cd_serie_nota

  , nota_saida_item nsi

  left outer join produto p
  on p.cd_produto = nsi.cd_produto

  left outer join produto_custo pc
  on pc.cd_produto = p.cd_produto

  left outer join categoria_produto cpp
  on cpp.cd_categoria_produto = p.cd_categoria_produto

  inner join grupo_produto gp
  on gp.cd_grupo_produto = nsi.cd_grupo_produto

  inner join categoria_produto cpg
  on cpg.cd_categoria_produto = gp.cd_categoria_produto

  inner join grupo_produto_custo gpc
  on gpc.cd_grupo_produto = gp.cd_grupo_produto and
     gpc.ic_custo = 'S' -- controla custos 

  , pedido_venda pv
  , operacao_fiscal opf
  , vw_Destinatario_Rapida vw

where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.cd_status_nota <> 7 -- a nota não pode estar cancelada
  and
  nsi.cd_nota_saida = ns.cd_nota_saida
  and
  pv.cd_pedido_venda = nsi.cd_pedido_venda
  and
  opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal and
  opf.ic_custo_operacao_fiscal = 'S' -- controla custos
  and
  vw.cd_destinatario = ns.cd_cliente and
  vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
  vw.cd_pais = 1 -- apenas clientes do Brasil
 
