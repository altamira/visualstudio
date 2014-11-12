
CREATE VIEW vw_importacao_adicao
------------------------------------------------------------------------------------
--sp_helptext vw_importacao_adicao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : 
--Banco de Dados	: EGISSQL ou EGISADMIN
--
--Objetivo	        : Descrição do que a View Realiza
--
--Data                  : 01.01.2009
--Atualização           : 
--
------------------------------------------------------------------------------------
as

--select * from pedido_importacao_item
--select * from embarque_importacao_item
--select * from classificacao_fiscal

select
  cf.cd_mascara_classificacao,
  sum( ei.qt_produto_embarque )            as qt_produto,
  sum( ei.qt_peso_liquido_embarque )       as qt_peso_liquido,
  sum( ei.qt_peso_bruto_embarque   )       as qt_peso_bruto,
  sum( isnull(ei.qt_produto_embarque,0) *
       isnull(ei.vl_produto_embarque,0))   as vl_total_adicao,
  max(cf.pc_importacao)                 as pc_importacao,
  max(cf.pc_ipi_classificacao)          as pc_ipi,
  max(pfe.pc_aliquota_icms_produto)     as pc_icms,
  sum( e.vl_frete_embarque/e.qt_peso_bruto_embarque 
       * ei.qt_peso_bruto_embarque)     as vl_frete,
  sum( (e.vl_frete_embarque/e.qt_peso_bruto_embarque 
       * ei.qt_peso_bruto_embarque)
       * (e.pc_seguro_embarque/100))    as vl_seguro,
  max(0.00)                             as vl_despesa,
  max(0.00)                             as vl_fob,
  max(0.00)                             as vl_cif,
  max(pimp.vl_produto_importacao)       as vl_produto_importacao  

from
  embarque_importacao_item           ei  with (nolock)
  inner join embarque_importacao     e   with (nolock) on e.cd_embarque              = ei.cd_embarque
  inner join pedido_importacao_item  ip  with (nolock) on ip.cd_pedido_importacao    = ei.cd_pedido_importacao and
                                                         ip.cd_item_ped_imp          = ei.cd_item_ped_imp
  inner join produto                 p   with (nolock) on p.cd_produto               = ip.cd_produto
  inner join produto_fiscal         pf   with (nolock) on pf.cd_produto              = p.cd_produto
  inner join produto_fiscal_entrada pfe  with (nolock) on pfe.cd_produto             = p.cd_produto
  inner join produto_importacao     pimp with (nolock) on pimp.cd_produto            = p.cd_produto
  inner join classificacao_fiscal   cf   with (nolock) on cf.cd_classificacao_fiscal = 
                                                          case when isnull(pfe.cd_classificacao_fiscal,0)>0 then
                                                          pfe.cd_classificacao_fiscal else pf.cd_classificacao_fiscal end
group by
  cf.cd_mascara_classificacao

