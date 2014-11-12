
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_litragem
-------------------------------------------------------------------------------
--pr_consulta_litragem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Litragem conforme o Faturamento do Período
--Data             : 15.01.2009
--Alteração        : 30.01.2009 - Ajuste Diversos - Carlos
-- 09.02.2009 - Ajustes Diversos - Carlos Fernandes
-- 11.02.2009 - Complemento das informações do Cliente - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_litragem
@cd_produto int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from nota_saida
--select * from status_nota
--select * from nota_saida_item

select
  ns.dt_nota_saida,
  c.nm_fantasia_cliente,
  ra.nm_ramo_atividade,
  v.nm_fantasia_vendedor,
  ns.cd_nota_saida,
  nsi.cd_item_nota_saida,
  --case when isnull(nsi.cd_produto,0)=0 then 'Especial' else 'Padrão' end as 'Tipo_Produto',
  cfp.nm_classificacao_produto as 'Tipo_Produto',
  nsi.cd_produto,
  p.cd_mascara_produto,
  nsi.nm_fantasia_produto,
  nsi.nm_produto_item_nota,
  um.sg_unidade_medida,
  case when isnull(tp.ic_qtd_analise,'S')='S' then
    nsi.qt_item_nota_saida
  else
    0
  end                                                                    as 'qt_item_nota_saida',
  case when isnull(tp.ic_qtd_analise,'S')='S' then
    isnull(p.vl_fator_conversao_produt,0) 
  else
    0
  end
                                   as 'Litragem',
  case when isnull(tp.ic_qtd_analise,'S')='S' then
    nsi.qt_item_nota_saida * isnull(p.vl_fator_conversao_produt,1)      
  else
    0.00
  end   as 'Total_Litragem',
  nsi.vl_unitario_item_nota,
  nsi.vl_total_item,
  nsi.qt_liquido_item_nota,
  nsi.qt_bruto_item_nota_saida,
  tp.sg_tipo_pedido,
  nsi.cd_pedido_venda,
  nsi.cd_item_pedido_venda,
  pv.dt_pedido_venda,
  cp.nm_condicao_pagamento,

  --Comissão (* ver como é calculado na Full Coat)

  isnull(p.pc_comissao_produto,0)                           as pc_comissao,
  nsi.vl_total_item * (isnull(p.pc_comissao_produto,0)/100) as vl_comissao
  
--select * from ramo_atividade

from
  Nota_Saida ns                            with (nolock) 
  inner join Nota_Saida_Item nsi           with (nolock) on nsi.cd_nota_saida            = ns.cd_nota_saida
  left outer join Cliente c                with (nolock) on c.cd_cliente                 = ns.cd_cliente
  left outer join Ramo_Atividade ra        with (nolock) on ra.cd_ramo_atividade         = c.cd_ramo_atividade
  left outer join Vendedor       v         with (nolock) on v.cd_vendedor                = ns.cd_vendedor
  left outer join Pedido_Venda   pv        with (nolock) on pv.cd_pedido_venda           = nsi.cd_pedido_venda
  left outer join Tipo_Pedido    tp        with (nolock) on tp.cd_tipo_pedido            = pv.cd_tipo_pedido
  left outer join Condicao_Pagamento cp    with (nolock) on cp.cd_condicao_pagamento     = ns.cd_condicao_pagamento
  left outer join Produto p                with (nolock) on p.cd_produto                 = nsi.cd_produto
  left outer join Unidade_Medida um        with (nolock) on um.cd_unidade_medida         = p.cd_unidade_medida
  left outer join Produto_Classificacao pc with (nolock) on pc.cd_produto                = p.cd_produto
  left outer join Classificao_Produto cfp  with (nolock) on cfp.cd_classificacao_produto = pc.cd_classificacao_produto
where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  ns.dt_cancel_nota_saida is null                    and
  ns.cd_status_nota = 5                              and
  nsi.dt_restricao_item_nota is null                 and
  nsi.cd_produto = case when isnull(@cd_produto,0) = 0 then nsi.cd_produto else @cd_produto end  
   
--select * from tipo_pedido
--select * from produto where cd_produto = 576

