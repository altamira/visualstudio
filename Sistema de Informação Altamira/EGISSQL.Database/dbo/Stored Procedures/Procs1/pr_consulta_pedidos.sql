
CREATE PROCEDURE pr_consulta_pedidos

@ic_parametro_data int,
@ic_tipo_produto   int,
@dt_inicial        datetime,
@dt_final          datetime,
@cd_usuario        int = 0
as

Begin

  declare @cd_vendedor int
  
    --Define o vendedor para o cliente
    Select
    	@cd_vendedor = dbo.fn_vendedor_internet(@cd_usuario)

    Select  
      a.cd_cliente                as 'CodCliente',  
      b.nm_fantasia_cliente       as 'Cliente',  
      a.cd_pedido_venda           as 'Pedido',  
      d.cd_item_pedido_venda      as 'Item',  
      a.dt_pedido_venda           as 'Emissao',  
      d.qt_item_pedido_venda      as 'Qtde',  
     (d.qt_item_pedido_venda *  
      d.vl_unitario_item_pedido)  as 'Venda',  
      d.dt_entrega_vendas_pedido  as 'Comercial',  
      d.dt_entrega_fabrica_pedido as 'Fabrica',  
      d.dt_reprog_item_pedido     as 'Reprogramacao',  
      a.cd_vendedor               as 'CodVendedor',    
      c.nm_fantasia_vendedor      as 'Setor',  
      d.qt_Saldo_pedido_venda     as 'Saldo',  
      Atraso =  
      Case   
      when @ic_parametro_data = 1 then  
         Case when Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int) >= 0 then Null  
              else Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int)  
         end  
      when @ic_parametro_data = 2 then  
         Case when Cast(d.dt_reprog_item_pedido-(GetDate()-1) as Int) >= 0 then Null  
              else Cast(d.dt_reprog_item_pedido-(GetDate()-1) as Int)  
         end  
      else 0 end,  
      -- Tipo do Pedido : 1 = Normal, 2 = Especial  
      sp.sg_tipo_pedido        as 'TipoPedido',  
      d.nm_produto_pedido      as 'Descricao',
      d.ic_controle_pcp_pedido as 'Pcp',
      d.nm_observacao_fabrica1,
      d.nm_observacao_fabrica2,
      ( select top 1 pp.cd_processo
        from
          Processo_Producao pp with (nolock) 
        where
          pp.cd_pedido_venda      = d.cd_pedido_venda and
          pp.cd_item_pedido_venda = d.cd_item_pedido_venda ) as cd_processo

    -------  
    into #TmpPedidosGeral  
    -------  
    from  
      Pedido_Venda a               with (nolock)

    Inner Join Cliente b           with (nolock) On a.cd_cliente = b.cd_cliente
    Left Outer Join Vendedor c     with (nolock) On a.cd_vendedor = c.cd_vendedor
    Inner Join Pedido_Venda_Item d with (nolock) On a.cd_pedido_venda = d.cd_pedido_venda
    left outer join Tipo_Pedido sp with (nolock) on sp.cd_tipo_pedido = a.cd_tipo_pedido
  
    where
        --Implementada a filtragem das consultas por vendedor para os casos de conexão remota de vendedor/usuário
        --Fabio 24.01.2006
        IsNull(c.cd_vendedor,0) = ( case @cd_vendedor
                                          when 0 then IsNull(c.cd_vendedor,0)
                                          else @cd_vendedor
                                        end ) and
        
        --Melhoria de performance trocando "OR" por "AND"
        --Filtro pela data de fabricação
        (IsNull(d.dt_entrega_fabrica_pedido,getdate()) between  ( case 
                                                                    when @ic_parametro_data = 1 then  
                                                                      @dt_inicial
                                                                    else
                                                                      IsNull(d.dt_entrega_fabrica_pedido,getdate())
                                                                 end )
                                                        and 
                                                        ( case 
                                                            when @ic_parametro_data = 1 then  
                                                              @dt_final
                                                            else
                                                              IsNull(d.dt_entrega_fabrica_pedido,getdate()) 
                                                            end )) and

        --Filtro pela data de reprogramação
        (IsNull(d.dt_reprog_item_pedido,getdate()) between    ( case 
                                                                    when @ic_parametro_data = 2 then  
                                                                      @dt_inicial
                                                                    else
                                                                      IsNull(d.dt_reprog_item_pedido,getdate())
                                                                 end )
                                                        and 
                                                        ( case 
                                                            when @ic_parametro_data = 2 then  
                                                              @dt_final
                                                            else
                                                              IsNull(d.dt_reprog_item_pedido,getdate()) 
                                                            end )) and

        --Filtro pela emissão
        (IsNull(a.dt_pedido_venda,getdate()) between    ( case 
                                                            when @ic_parametro_data = 3 then  
                                                              @dt_inicial
                                                            else
                                                              IsNull(a.dt_pedido_venda,getdate())
                                                            end )
                                                        and 
                                                        ( case 
                                                            when @ic_parametro_data = 3 then  
                                                              @dt_final
                                                            else
                                                              IsNull(a.dt_pedido_venda,getdate()) 
                                                            end )) and 
         d.dt_cancelamento_item is null                       AND    
         a.ic_consignacao_pedido = 'N'                        AND  
         d.cd_item_pedido_venda < 80                          AND  
        (d.qt_item_pedido_venda*d.vl_unitario_item_pedido) > 0
  


  -----------------------------------------------------------------------------------------  
  if @ic_tipo_produto = 1 -- Consulta todos os pedidos  
  -----------------------------------------------------------------------------------------  
  begin  
    -- Seleciona o filtro da data : 1 : Entrega ou 2 : Reprogramação ou 3 : Emissão  
    if @ic_parametro_data = 1   
       select * from #TmpPedidosGeral  
       order by Fabrica, Pedido  
  
    if @ic_parametro_data = 2   
       select * from #TmpPedidosGeral  
       order by Reprogramacao, Pedido  
  
    if @ic_parametro_data = 3   
       select Pedido,  
              Max(Cliente)     as 'Cliente',   
              Max(Setor)       as 'Setor',   
              Max(Emissao)     as 'Emissao',   
              Max(CodCliente)  as 'CodCliente',  
              Max(CodVendedor) as 'CodVendedor',  
              Max(Pcp)         as 'Pcp',   
              Sum(Qtde)        as 'QtdeTotal',  
              Sum(Venda)       as 'ValorTotal',  
              Especial =   
              Case when Max(TipoPedido) = 'PV' then 'N'  
                   when Max(TipoPedido) = 'PVE' then 'S'  
              else '' end  
       from #TmpPedidosGeral  
       group by Pedido  
       order by Emissao  
  end  
  -----------------------------------------------------------------------------------------  
  else if @ic_tipo_produto = 2 -- Consulta somente pedidos do Pcp  
  -----------------------------------------------------------------------------------------  
  begin  
    -- Seleciona o filtro da data : 1 : Entrega ou 2 : Reprogramação ou 3 : Emissão  
    if @ic_parametro_data = 1   
       select * from #TmpPedidosGeral  
       where Pcp = 'S'  
       order by Fabrica, Pedido  
  
    if @ic_parametro_data = 2   
       select * from #TmpPedidosGeral  
       where Pcp = 'S' and  
             Saldo > 0 and  
             Reprogramacao is not null  
       order by Reprogramacao, Pedido  
  
    if @ic_parametro_data = 3   
       select Pedido,  
              Max(Cliente)     as 'Cliente',   
              Max(Setor)       as 'Setor',   
              Max(Emissao)     as 'Emissao',   
              Max(CodCliente)  as 'CodCliente',  
              Max(CodVendedor) as 'CodVendedor',  
              Max(Pcp)         as 'Pcp',   
              Sum(Qtde)        as 'QtdeTotal',  
              Sum(Venda)       as 'ValorTotal',  
              Especial =   
              Case when Max(TipoPedido) = 'PV' then 'N'  
                   when Max(TipoPedido) = 'PVE' then 'S'  
              else '' end  
       from #TmpPedidosGeral  
       where Pcp = 'S'  
       group by Pedido  
       order by Emissao  
  end  

end
