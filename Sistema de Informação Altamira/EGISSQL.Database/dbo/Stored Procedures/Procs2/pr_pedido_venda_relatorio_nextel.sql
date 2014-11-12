
-------------------------------------------------------------------------------
--sp_helptext pr_pedido_venda_relatorio_nextel
-------------------------------------------------------------------------------
--pr_pedido_venda_relatorio_nextel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 06.08.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_pedido_venda_relatorio_nextel
@dt_Inicial datetime,
@dt_Final    datetime,
@cd_pedido   int,
@filtro      char(1)

AS

if @filtro = '1'
  begin

   select 
      pvn.cd_pedido_venda,
      c.nm_fantasia_cliente,
      cast(pvn.cd_cliente as varchar) + ' - ' + rtrim(ltrim(c.nm_fantasia_cliente)) as cliente,
      rtrim(ltrim(c.nm_endereco_cliente)) + ' ' + rtrim(ltrim(c.cd_numero_endereco)) + ' ' + rtrim(ltrim(c.nm_bairro))      as endereco,
      max(c.cd_telefone) as telefone, 
      pvn.cd_cliente,
      p.qt_peso_bruto,
      pvn.cd_status_pedido_nextel,
      spn.nm_status_pedido_nextel,
      v.nm_vendedor,
      pvn.cd_vendedor,
      pvn.cd_nota_saida,
      pvn.dt_pedido_venda_nextel, 
      pvn.qt_dia_pagamento,
      p.nm_produto,
      p.cd_mascara_produto + ' - ' + rtrim(ltrim(p.nm_produto))  as nome_produto,
      p.vl_produto,
      p.pc_comissao_produto,
      case when isnull(p.pc_comissao_produto,0) <> 0 or isnull(p.pc_comissao_produto,0) <> null then -- Encontra o Valor do Percentual
        (isnull(pvn.vl_item_total_pedido,0) - (isnull(pvn.vl_item_total_pedido,0) - (isnull(pvn.vl_item_total_pedido,0) * (isnull(p.pc_comissao_produto,0) / 100))))   
      end                                                        as comissao,           
      pvn.cd_produto,
      pvn.qt_itens_pedido_venda,
      pvn.vl_item_total_pedido,
      pvn.cd_tabela_preco,
      pvn.qt_item_pedido_venda_nextel,
      0.00 as pc_comissao_item_pedido,
      0.00 as pc_desconto_item_pedido,
      ''   as sg_unidade_medida,
      cast(null as datetime) as dt_credito_pedido_venda,
      0 as cd_item_pedido_venda

  from
    pedido_venda_nextel                  pvn with(nolock)
    left outer join produto              p   with(nolock) on p.cd_produto                = pvn.cd_produto
    left outer join cliente              c   with(nolock) on c.cd_cliente                = pvn.cd_cliente
    left outer join vendedor             v   with(nolock) on v.cd_vendedor               = pvn.cd_vendedor
    left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pvn.cd_status_pedido_nextel
  where 
    pvn.dt_pedido_venda_nextel between @dt_Inicial and @dt_Final
  
  group by
      pvn.cd_pedido_venda,
      c.nm_fantasia_cliente,
      pvn.cd_cliente,
      p.qt_peso_bruto,
      pvn.cd_status_pedido_nextel,
      spn.nm_status_pedido_nextel,
      v.nm_vendedor,
      pvn.cd_vendedor,
      pvn.cd_nota_saida,
      pvn.dt_pedido_venda_nextel, 
      pvn.qt_dia_pagamento,
      p.nm_produto,
      p.vl_produto,
      p.pc_comissao_produto,        
      pvn.cd_produto,
      pvn.qt_itens_pedido_venda,
      pvn.vl_item_total_pedido,
      pvn.cd_tabela_preco,
      pvn.qt_item_pedido_venda_nextel,
      c.nm_endereco_cliente,
      c.cd_numero_endereco,
      c.nm_bairro,
      p.cd_mascara_produto
  end
else if @filtro = '2'
  begin

    select 
      pvn.cd_pedido_venda,
      c.nm_fantasia_cliente,
      cast(pvn.cd_cliente as varchar) + ' - ' + rtrim(ltrim(c.nm_fantasia_cliente)) as cliente,
      rtrim(ltrim(c.nm_endereco_cliente)) + ' ' + rtrim(ltrim(c.cd_numero_endereco)) + ' ' + rtrim(ltrim(c.nm_bairro))      as endereco,
      max(c.cd_telefone) as telefone, 
      pvn.cd_cliente,
      p.qt_peso_bruto,
      pvn.cd_status_pedido_nextel,
      spn.nm_status_pedido_nextel,
      v.nm_vendedor,
      pvn.cd_vendedor,
      pvn.cd_nota_saida,
      pvn.dt_pedido_venda_nextel, 
      pvn.qt_dia_pagamento,
      p.nm_produto,
      p.cd_mascara_produto + ' - ' + rtrim(ltrim(p.nm_produto))  as nome_produto,
      p.vl_produto,
      p.pc_comissao_produto,
      case when isnull(p.pc_comissao_produto,0) <> 0 or isnull(p.pc_comissao_produto,0) <> null then -- Encontra o Valor do Percentual
        (isnull(pvn.vl_item_total_pedido,0) - (isnull(pvn.vl_item_total_pedido,0) - (isnull(pvn.vl_item_total_pedido,0) * (isnull(p.pc_comissao_produto,0) / 100))))   
      end                                                        as comissao,           
      pvn.cd_produto,
      pvn.qt_itens_pedido_venda,
      pvn.vl_item_total_pedido,
      pvn.cd_tabela_preco,
      pvn.qt_item_pedido_venda_nextel,
      0.00 as pc_comissao_item_pedido,
      0.00 as pc_desconto_item_pedido,
      ''   as sg_unidade_medida,
      cast(null as datetime) as dt_credito_pedido_venda,
      0 as cd_item_pedido_venda





  from
    pedido_venda_nextel                  pvn with(nolock)
    left outer join produto              p   with(nolock) on p.cd_produto                = pvn.cd_produto
    left outer join cliente              c   with(nolock) on c.cd_cliente                = pvn.cd_cliente
    left outer join vendedor             v   with(nolock) on v.cd_vendedor               = pvn.cd_vendedor
    left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pvn.cd_status_pedido_nextel
  where 
    pvn.cd_pedido_venda = @cd_pedido
  group by
      pvn.cd_pedido_venda,
      c.nm_fantasia_cliente,
      pvn.cd_cliente,
      p.qt_peso_bruto,
      pvn.cd_status_pedido_nextel,
      spn.nm_status_pedido_nextel,
      v.nm_vendedor,
      pvn.cd_vendedor,
      pvn.cd_nota_saida,
      pvn.dt_pedido_venda_nextel, 
      pvn.qt_dia_pagamento,
      p.nm_produto,
      p.vl_produto,
      p.pc_comissao_produto,        
      pvn.cd_produto,
      pvn.qt_itens_pedido_venda,
      pvn.vl_item_total_pedido,
      pvn.cd_tabela_preco,
      pvn.qt_item_pedido_venda_nextel,
      c.nm_endereco_cliente,
      c.cd_numero_endereco,
      c.nm_bairro,
      p.cd_mascara_produto
  end

else

    select 
      pvn.cd_pedido_venda,
      c.nm_fantasia_cliente,
      cast(pvn.cd_cliente as varchar) + ' - ' + rtrim(ltrim(c.nm_fantasia_cliente)) as cliente,
      rtrim(ltrim(c.nm_endereco_cliente)) + ' ' + rtrim(ltrim(c.cd_numero_endereco)) + ' ' + rtrim(ltrim(c.nm_bairro))      as endereco,
      max(c.cd_telefone) as telefone, 
      pvn.cd_cliente,
      p.qt_peso_bruto,
      pvn.cd_status_pedido_nextel,
      spn.nm_status_pedido_nextel,
      v.nm_vendedor,
      pvn.cd_vendedor,
      pvn.cd_nota_saida,
      pvn.dt_pedido_venda_nextel, 
      pvn.qt_dia_pagamento,
      p.nm_produto,
      p.cd_mascara_produto + ' - ' + rtrim(ltrim(p.nm_produto))  as nome_produto,
      p.vl_produto,
      p.pc_comissao_produto,
      case when isnull(p.pc_comissao_produto,0) <> 0 or isnull(p.pc_comissao_produto,0) <> null then -- Encontra o Valor do Percentual
        (isnull(pvn.vl_item_total_pedido,0) - (isnull(pvn.vl_item_total_pedido,0) - (isnull(pvn.vl_item_total_pedido,0) * (isnull(p.pc_comissao_produto,0) / 100))))   
      end                                                        as comissao,           
      pvn.cd_produto,
      pvn.qt_itens_pedido_venda,
      pvn.vl_item_total_pedido,
      pvn.cd_tabela_preco,
      pvn.qt_item_pedido_venda_nextel,
      0.00 as pc_comissao_item_pedido,
      0.00 as pc_desconto_item_pedido,
      ''   as sg_unidade_medida,
      cast(null as datetime) as dt_credito_pedido_venda,
      0 as cd_item_pedido_venda




  from
    pedido_venda_nextel                  pvn with(nolock)
    left outer join produto              p   with(nolock) on p.cd_produto                = pvn.cd_produto
    left outer join cliente              c   with(nolock) on c.cd_cliente                = pvn.cd_cliente
    left outer join vendedor             v   with(nolock) on v.cd_vendedor               = pvn.cd_vendedor
    left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pvn.cd_status_pedido_nextel
  where 
    pvn.dt_pedido_venda_nextel between @dt_Inicial and @dt_final and
    pvn.cd_pedido_venda = @cd_pedido
  group by
      pvn.cd_pedido_venda,
      c.nm_fantasia_cliente,
      pvn.cd_cliente,
      p.qt_peso_bruto,
      pvn.cd_status_pedido_nextel,
      spn.nm_status_pedido_nextel,
      v.nm_vendedor,
      pvn.cd_vendedor,
      pvn.cd_nota_saida,
      pvn.dt_pedido_venda_nextel, 
      pvn.qt_dia_pagamento,
      p.nm_produto,
      p.vl_produto,
      p.pc_comissao_produto,        
      pvn.cd_produto,
      pvn.qt_itens_pedido_venda,
      pvn.vl_item_total_pedido,
      pvn.cd_tabela_preco,
      pvn.qt_item_pedido_venda_nextel,
      c.nm_endereco_cliente,
      c.cd_numero_endereco,
      c.nm_bairro,
      p.cd_mascara_produto

