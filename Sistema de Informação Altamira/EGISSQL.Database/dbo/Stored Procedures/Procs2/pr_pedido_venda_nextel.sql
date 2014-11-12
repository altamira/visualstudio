
-------------------------------------------------------------------------------
--sp_helptext pr_pedido_venda_nextel
-------------------------------------------------------------------------------
--pr_pedido_venda_nextel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 23.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_pedido_venda_nextel    
@dt_Inicial datetime,    
@dt_Final    datetime,    
@cd_pedido   int,    
@filtro      char(1)    
    
AS    
    
if @filtro = '1'    
  begin    
    
   select     
      cd_pedido_venda,    
      c.nm_razao_social_cliente,    
      pvn.cd_cliente,    
      pvn.cd_status_pedido_nextel,    
      spn.nm_status_pedido_nextel,    
      v.nm_vendedor,    
      pvn.cd_vendedor,    
      cd_nota_saida,    
      dt_pedido_venda_nextel,     
      qt_dia_pagamento,  
      p.nm_produto,    
      pvn.cd_produto,    
      qt_item_pedido_venda_nextel,    
      vl_item_total_pedido            as vl_produto,    
      qt_item_pedido_venda_nextel * vl_item_total_pedido as vl_item_total_pedido,    
      pvn.cd_tabela_preco,    
      qt_itens_pedido_venda,  
      cd_item_pedido_venda,
      cast(pvn.cd_cliente as varchar) + ' - ' + rtrim(ltrim(c.nm_fantasia_cliente)) as cliente,  
      rtrim(ltrim(c.nm_endereco_cliente)) + ' ' + rtrim(ltrim(c.cd_numero_endereco)) + ' ' + rtrim(ltrim(c.nm_bairro))      as endereco, 
      c.cd_ddd + ' ' +  c.cd_telefone as telefone,
      p.nm_produto  as nome_produto,
      um.sg_unidade_medida
  from    
    pedido_venda_nextel                  pvn with(nolock)    
    left outer join produto              p   with(nolock) on p.cd_produto                = pvn.cd_produto    
    left outer join cliente              c   with(nolock) on c.cd_cliente                = pvn.cd_cliente    
    left outer join vendedor             v   with(nolock) on v.cd_vendedor               = pvn.cd_vendedor    
    left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pvn.cd_status_pedido_nextel    
    left outer join unidade_medida       um  with(nolock) on um.cd_unidade_medida        = p.cd_unidade_medida

  where     
    pvn.dt_pedido_venda_nextel between @dt_Inicial and @dt_Final and
    pvn.cd_item_pedido_venda = 1 and
    isnull(pvn.ic_gerado_pedido_venda,'N') = 'N'
  Order by   
    pvn.cd_pedido_venda,  
    pvn.cd_item_pedido_venda    
    
  end    

else if @filtro = '2'    
  begin    
    
    select     
      cd_pedido_venda,    
      c.nm_razao_social_cliente,    
      pvn.cd_cliente,    
      pvn.cd_status_pedido_nextel,    
      spn.nm_status_pedido_nextel,    
      v.nm_vendedor,    
      pvn.cd_vendedor,    
      cd_nota_saida,    
      dt_pedido_venda_nextel,     
      qt_dia_pagamento,  
      p.nm_produto,    
      pvn.cd_produto,    
      qt_item_pedido_venda_nextel,    
      vl_item_total_pedido            as vl_produto,    
      qt_item_pedido_venda_nextel * vl_item_total_pedido as vl_item_total_pedido,    
      pvn.cd_tabela_preco,    
      qt_itens_pedido_venda,  
      cd_item_pedido_venda,
      cast(pvn.cd_cliente as varchar) + ' - ' + rtrim(ltrim(c.nm_fantasia_cliente)) as cliente,  
      rtrim(ltrim(c.nm_endereco_cliente)) + ' ' + rtrim(ltrim(c.cd_numero_endereco)) + ' ' + rtrim(ltrim(c.nm_bairro))      as endereco, 
      c.cd_ddd + ' ' +  c.cd_telefone as telefone,
      p.nm_produto  as nome_produto,
      um.sg_unidade_medida
  

  from    
    pedido_venda_nextel                  pvn with(nolock)    
    left outer join produto              p   with(nolock) on p.cd_produto                = pvn.cd_produto    
    left outer join cliente              c   with(nolock) on c.cd_cliente                = pvn.cd_cliente    
    left outer join vendedor             v   with(nolock) on v.cd_vendedor               = pvn.cd_vendedor    
    left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pvn.cd_status_pedido_nextel    
    left outer join unidade_medida       um  with(nolock) on um.cd_unidade_medida        = p.cd_unidade_medida

  where     
    pvn.cd_pedido_venda = @cd_pedido and
    pvn.cd_item_pedido_venda = 1 and
    pvn.ic_gerado_pedido_venda = 'N'   
  Order by   
    pvn.cd_pedido_venda,  
    pvn.cd_item_pedido_venda     
    
  end    
    
else    
    
    select     
      cd_pedido_venda,    
      c.nm_razao_social_cliente,    
      pvn.cd_cliente,    
      pvn.cd_status_pedido_nextel,    
      spn.nm_status_pedido_nextel,    
      v.nm_vendedor,    
      pvn.cd_vendedor,    
      cd_nota_saida,    
      dt_pedido_venda_nextel,     
      qt_dia_pagamento,  
      p.nm_produto,    
      pvn.cd_produto,    
      qt_item_pedido_venda_nextel,    
      vl_item_total_pedido            as vl_produto,    
      qt_item_pedido_venda_nextel * vl_item_total_pedido as vl_item_total_pedido,    
      pvn.cd_tabela_preco,    
      qt_itens_pedido_venda,  
      cd_item_pedido_venda,
      cast(pvn.cd_cliente as varchar) + ' - ' + rtrim(ltrim(c.nm_fantasia_cliente)) as cliente,  
      rtrim(ltrim(c.nm_endereco_cliente)) + ' ' + rtrim(ltrim(c.cd_numero_endereco)) + ' ' + rtrim(ltrim(c.nm_bairro))      as endereco, 
      c.cd_ddd + ' ' +  c.cd_telefone as telefone,
      p.nm_produto  as nome_produto,
      um.sg_unidade_medida     

  from    
    pedido_venda_nextel                  pvn with(nolock)    
    left outer join produto              p   with(nolock) on p.cd_produto                = pvn.cd_produto    
    left outer join cliente              c   with(nolock) on c.cd_cliente                = pvn.cd_cliente    
    left outer join vendedor             v   with(nolock) on v.cd_vendedor               = pvn.cd_vendedor    
    left outer join status_pedido_nextel spn with(nolock) on spn.cd_status_pedido_nextel = pvn.cd_status_pedido_nextel    
    left outer join unidade_medida       um  with(nolock) on um.cd_unidade_medida        = p.cd_unidade_medida

  where     
    pvn.dt_pedido_venda_nextel between @dt_Inicial and @dt_final and    
    pvn.cd_pedido_venda = @cd_pedido and
    pvn.cd_item_pedido_venda = 1 and
    pvn.ic_gerado_pedido_venda = 'N'   
  Order by   
    pvn.cd_pedido_venda,  
    pvn.cd_item_pedido_venda 
