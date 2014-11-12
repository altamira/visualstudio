
create procedure pr_transferencia_custo_om
@dt_inicial      datetime,
@dt_final        datetime
as 

select

  ns.cd_nota_saida           as 'NOTA', 
  ns.dt_nota_saida         as 'EMISSAO',
  vw.nm_fantasia           as 'CLIENTE',
  nsi.cd_item_nota_saida   as 'ITEM_NOTA',

  nsi.cd_pedido_venda      as 'PEDIDO',
  nsi.cd_item_pedido_venda as 'ITEM',

  'COD_ITEM' =
       Case When (( nsi.cd_produto is null ) or ( nsi.cd_produto = 0 ))
                 then cast( cast(gp.cd_grupo_produto as varchar(2)) + '9999999' as integer )
            Else IsNull(p.cd_mascara_produto, nsi.cd_mascara_produto)
       End,

  'FANTASIA' =
       Case When (( nsi.cd_produto is null ) or ( nsi.cd_produto = 0 )) and
                 (( nsi.nm_fantasia_produto is null ) or ( nsi.nm_fantasia_produto = '' ))
                 then gp.nm_fantasia_grupo_produto
            Else nsi.nm_fantasia_produto
       End,

  'DESCRICAO' =
    Case When ( IsNull(pv.ic_smo_pedido_venda,'N') = 'S' )
              then pvi.nm_produto_pedido
         Else nsi.nm_produto_item_nota
    End,

  nsi.qt_item_nota_saida  - IsNull(nsi.qt_devolucao_item_nota,0) as 'QT',
  '1'                     as 'STATUS',
  gpc.sg_produto_custo    as 'GRUPO',
  'COMPOSICAO' =
       Case When ( ( Select count(*) From pedido_venda_composicao pvc
                     Where pvc.cd_pedido_venda = nsi.cd_pedido_venda and
                           pvc.cd_item_pedido_venda = nsi.cd_item_pedido_venda ) > 0 ) then 'S'
            Else 'N'
       End,
  'TIPO_PEDIDO' =
       Case When ( IsNull(vw.cd_pais,1) <> 1 )
                 then 1
            When ( IsNull(pv.ic_smo_pedido_venda,'N') = 'S' )
                 then 2
            Else 0
       End
from
  nota_saida ns, 
  nota_saida_item nsi left outer join 
  produto p on p.cd_produto = nsi.cd_produto inner join 
  grupo_produto gp on gp.cd_grupo_produto = nsi.cd_grupo_produto inner join 
  grupo_produto_custo gpc on gpc.cd_grupo_produto = gp.cd_grupo_produto and
                             gpc.ic_om_custo_grupo_produto = 'S', -- controla custos 
  pedido_venda pv,
  pedido_venda_item pvi, 
  operacao_fiscal opf, 
  vw_Destinatario_Rapida vw

where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.cd_status_nota <> 7 and -- a nota não pode estar cancelada
  ns.cd_status_nota <> 4 and -- a nota não pode estar devolvida.
  nsi.cd_nota_saida = ns.cd_nota_saida and
  pv.cd_pedido_venda = nsi.cd_pedido_venda and
  pvi.cd_pedido_venda = nsi.cd_pedido_venda and
  pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda and
  opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal and
  opf.ic_custo_operacao_fiscal = 'S' and-- controla custos
  vw.cd_destinatario = ns.cd_cliente and
  vw.cd_tipo_destinatario = ns.cd_tipo_destinatario

--Excluído após a inclusão do campo "TIPO_PEDIDO"
--  and vw.cd_pais = 1 -- apenas clientes do Brasil

 
