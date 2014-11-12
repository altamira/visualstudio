
CREATE PROCEDURE pr_pedido_venda_ultimas_compras  
@dt_inicial as DateTime,  
@dt_final   as DateTime,  
@cd_cliente as int = 0  
  
AS  
  
  declare @vl_total float  
  declare @vl_total_canc float  
  
  set @vl_total = ( select   
                      sum((case when(it.dt_cancelamento_item is null)   
                                then  (it.qt_item_pedido_venda * vl_unitario_item_pedido)   
                           else 0 end))   
                    from Pedido_Venda pe      with(nolock) Left Outer Join  
                         Pedido_Venda_Item it with(nolock) on pe.cd_pedido_venda = it.cd_pedido_venda   
                    Where  
                      pe.dt_pedido_venda between @dt_inicial and @dt_final and  
                    ((pe.cd_cliente = @cd_cliente) or (@cd_cliente = 0)) )  
  
  set @vl_total_canc = ( select   
                      sum((case when (it.dt_cancelamento_item is not null)   
                                then  (it.qt_item_pedido_venda * vl_unitario_item_pedido)   
                           else 0 end))   
                    from Pedido_Venda pe with(nolock) Left Outer Join  
                         Pedido_Venda_Item it with(nolock) on pe.cd_pedido_venda = it.cd_pedido_venda   
                    Where  
                      pe.dt_pedido_venda between @dt_inicial and @dt_final and  
                    ((pe.cd_cliente = @cd_cliente) or (@cd_cliente = 0)) )  
  
  
    Select  
      cast(pe.cd_pedido_venda as varchar) + 'It' + cast(it.cd_item_pedido_venda as varchar) as cd_ident_pv,
      pe.cd_pedido_venda,  
      pe.dt_pedido_venda,  
      pe.cd_cliente,  
      pe.dt_cancelamento_pedido,  
      it.dt_cancelamento_item,  
      pe.ds_cancelamento_pedido,  
      case when(it.dt_cancelamento_item is null) then  (it.qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end as 'vl_pedido',  
      case when (it.dt_cancelamento_item is not null) then  (it.qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end as 'vl_totalcanc',  
      pe.cd_vendedor,  
      (Select nm_fantasia_vendedor From Vendedor with (nolock)
       Where cd_vendedor = pe.cd_vendedor) as 'nm_fantasia_vendedor',  
      pe.cd_vendedor_interno,  
      (Select nm_fantasia_vendedor From Vendedor with (nolock) 
       Where cd_vendedor = pe.cd_vendedor_interno) as 'nm_fantasia_vendedor_interno',  
      IsNull(pe.ic_fatsmo_pedido, 'N') as 'ic_fatsmo_pedido',   
      pe.ic_operacao_triangular,  
      case when isnull(pe.ic_operacao_triangular,'N') = 'N' then '' else   
      ( select nm_fantasia_cliente from Cliente with (nolock)
        where pe.cd_cliente_faturar = cd_cliente ) end as 'ClienteOpTriangular',  
      IsNull(po.cd_produto,se.cd_servico)              as 'cd_produto',  
      IsNull(it.nm_fantasia_produto,se.nm_servico)     as 'nm_fantasia_produto',  
      it.cd_item_pedido_venda,  
      it.qt_item_pedido_venda, it.dt_entrega_fabrica_pedido,   
      it.vl_unitario_item_pedido, it.pc_desconto_item_pedido,     
      it.dt_entrega_vendas_pedido,  
      it.qt_saldo_pedido_venda,  

      case when isnull(it.cd_servico,0)>0 then
         case when cast(it.ds_produto_pedido_venda as varchar(50))=''
              then cast(s.nm_servico as varchar(50))
              else cast(it.ds_produto_pedido_venda as varchar(50))
         end
      else   
         it.nm_produto_pedido 
      end as nm_produto_pedido,  

--      IsNull(it.nm_produto_pedido,cast(se.ds_servico as varchar(50))) as 'nm_produto_pedido',  

      case when(it.dt_cancelamento_item is not null)       then 'C'  
           when(isnull(it.ic_libpcp_item_pedido,'N')= 'S') then 'S'   
      else 'N' end as ic_libpcp_item_pedido,  
      co.nm_condicao_pagamento,  
      co.sg_condicao_pagamento,  
      co.qt_parcela_condicao_pgto,  
      ct.nm_fantasia_contato,  
      ct.nm_contato_cliente,  
      c.cd_cliente,  
      c.nm_fantasia_cliente,  
      c.nm_razao_social_cliente,  
      (IsNull(c.cd_ddd,'') + ' ' + IsNull(c.cd_telefone,'')) as 'cd_telefone',  

      cd_nota_saida = ( select top 1 (case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
                                     ns.cd_identificacao_nota_saida else nsi.cd_nota_saida  end ) 
                        from Nota_Saida_Item nsi      with (NOLOCK)
                             inner join Nota_Saida ns with (NOLOCK) on ns.cd_nota_saida = nsi.cd_nota_saida
                        where nsi.cd_pedido_venda      = it.cd_pedido_venda      and  
                              nsi.cd_item_pedido_venda = it.cd_item_pedido_venda and  
                              nsi.dt_cancel_item_nota_saida is null and  
                              nsi.dt_restricao_item_nota    is null  
                        order by ns.dt_nota_saida ),  

      dt_nota_saida = ( select top 1 ns.dt_nota_saida 
                        from Nota_Saida_Item nsi with (NOLOCK) 
                             inner join Nota_Saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
                        where nsi.cd_pedido_venda      = it.cd_pedido_venda and  
                              nsi.cd_item_pedido_venda = it.cd_item_pedido_venda and  
                              nsi.dt_cancel_item_nota_saida is null and  
                              nsi.dt_restricao_item_nota    is null  
                        order by ns.dt_nota_saida ),  

        

      st.sg_status_pedido,  
      tp.sg_tipo_pedido,  
      it.cd_consulta,  
      it.cd_item_consulta,  
      it.nm_observacao_fabrica1,  
      it.nm_observacao_fabrica2,  
      tr.nm_fantasia                         as nm_fantasia_trasportadora,  
      dest.nm_destinacao_produto,  
      isnull(it.vl_lista_item_pedido,0)      as vl_lista_item_pedido,  
      it.dt_reprog_item_pedido,  
      ISNULL(pe.ic_consignacao_pedido,'N')   as ic_consignacao_pedido,  
      ISNULL(pe.ic_entrega_futura,'N')       as ic_entrega_futura,  
      ISNULL(pe.ic_amostra_pedido_venda,'N') as ic_amostra_pedido_venda,  
      @vl_total                              as 'TotalPedido',  
      @vl_total_canc                         as 'TotalPedidoCanc',  
      m.sg_moeda,  
      Isnull(it.vl_moeda_cotacao,0)          as vl_moeda_cotacao,  
      it.dt_moeda_cotacao,  
      case   
        when(Isnull(it.vl_moeda_cotacao,0) = 0)   
        then 0  
         else (it.vl_unitario_item_pedido / it.vl_moeda_cotacao)  
      end AS vl_unitario_moeda,  
      case   
        when(Isnull(it.vl_moeda_cotacao,0) = 0)   
        then 0  
         else ((it.qt_item_pedido_venda * it.vl_Unitario_item_pedido) / it.vl_moeda_cotacao)  
      end                              AS vl_total_item_moeda,  
      pe.cd_consulta                   as 'Proposta',  
      it.cd_item_consulta              as 'Item Proposta',  
      cons.cd_consulta_representante   as 'Proposta Rep',  
      icons.cd_consulta_representante  as 'Item Proposta Rep',  
      cg.nm_cliente_grupo,  
      cap.nm_categoria_produto,
      isnull(it.qt_area_produto,0)                                     as qt_area_produto,
      isnull(it.qt_area_produto,0) * isnull(it.qt_item_pedido_venda,0) as qt_total_area,
      it.cd_lote_item_pedido     ,
      dbo.fn_ultima_ordem_producao_item_pedido(pe.cd_pedido_venda, it.cd_item_pedido_venda) as cd_processo,
      cli.nm_fantasia_cliente                as ClienteOrigem,

      case when isnull(pc.vl_custo_produto,0)>0 then
           it.vl_unitario_item_pedido/isnull(pc.vl_custo_produto,0)
      else
           0.00 end                          as Margem,
      isnull(pc.vl_custo_produto,0)          as vl_custo_produto,

      --Atendimento do Pedido de Venda

      apv.nm_forma,
      apv.cd_documento,
      apv.cd_item_documento,
      apv.dt_atendimento,
      case when isnull(apv.qt_atendimento,0)>0 then
        apv.qt_atendimento
      else
        case when isnull(epv.qt_estoque,0)>0 then
          epv.qt_estoque
        else
           0
        end
      end                                            as qt_atendimento,

      
      case when isnull(pe.ic_fechado_pedido,'N')<>'S'   
      then 
        'Pedido Não Fechado'
      else
        case when it.qt_saldo_pedido_venda = 0 and it.dt_cancelamento_item is null
        then 
          'Faturado'       
        else
          case when it.dt_cancelamento_item is not null then
            'Cancelado'
          else
            case when isnull(epv.qt_estoque,0)>0 and epv.qt_estoque = it.qt_saldo_pedido_venda         then 'Estoque'
            else 
              case when isnull(apv.cd_documento,0)>0 and apv.qt_atendimento = it.qt_saldo_pedido_venda then 'Previsto'
              else 
              case when 
                isnull(it.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )>0
              then
                'Parcial'
              else
                case when  isnull(it.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )=0 
                then
                  'Estoque/Previsto'
                else
                  'Não Atendido' end
                end
              end
         end
        end
       end
       end                           as nm_atendimento
     

    From  
      Pedido_Venda pe                          with(nolock)  
      Left Outer Join Pedido_Venda_Item it     with(nolock)      on pe.cd_pedido_venda = it.cd_pedido_venda   
      Left Outer Join Produto po               with(nolock)      on po.cd_produto = it.cd_produto   
      Left Outer Join Produto_Custo pc         with(nolock)      on pc.cd_produto = it.cd_produto
      Left Outer Join Servico s                with(nolock)      on it.cd_servico = s.cd_servico
      Left Outer Join Categoria_Produto cap    with(nolock)      on cap.cd_categoria_produto = it.cd_categoria_produto   
      left outer join Cliente c                with(nolock)      on pe.cd_cliente = c.cd_cliente   
      Left Outer Join Condicao_pagamento co    with(nolock)      on pe.cd_condicao_pagamento = co.cd_condicao_pagamento   
      Left Outer Join Cliente_Contato ct       with(nolock)      on pe.cd_contato = ct.cd_contato and   
                                                                    pe.cd_cliente = ct.cd_cliente   
      Left Outer Join Status_Pedido st             with(nolock)  on pe.cd_status_pedido = st.cd_status_pedido   
      Left Outer Join Tipo_Pedido tp               with(nolock)  on pe.cd_tipo_pedido = tp.cd_tipo_pedido  
      LEFT OUTER JOIN Servico se                   with(nolock)  ON it.cd_servico = se.cd_servico  
      LEFT OUTER JOIN Transportadora tr            with(nolock)  on pe.cd_transportadora = tr.cd_transportadora   
      LEFT OUTER JOIN Destinacao_Produto dest      with(nolock)  ON pe.cd_destinacao_produto = dest.cd_destinacao_produto   
      left outer join moeda m                      with(nolock)  on (isnull(it.cd_moeda_cotacao,1) = m.cd_moeda)  
      left outer join consulta cons                with(nolock)  on (pe.cd_consulta = cons.cd_consulta)  
      left outer join consulta_itens icons         with(nolock)  on (it.cd_item_consulta = icons.cd_item_consulta and   
                                                                    pe.cd_consulta           = icons.cd_consulta)  
      left outer join cliente_grupo cg             with(nolock)  on (c.cd_cliente_grupo      = cg.cd_cliente_grupo)   
      left outer join Cliente_Origem corig         with (nolock) ON corig.cd_cliente         = pe.cd_cliente
      left outer join Cliente        cli           with (nolock) ON cli.cd_cliente           = corig.cd_cliente_origem

      left outer join Atendimento_pedido_venda apv with (nolock) on apv.cd_pedido_venda      = pe.cd_pedido_venda and
                                                                    apv.cd_item_pedido_venda = it.cd_item_pedido_venda and
                                                                    apv.cd_produto           = it.cd_produto 


      left outer join Estoque_pedido_venda epv with (nolock) on epv.cd_pedido_venda          = pe.cd_pedido_venda and
                                                                    epv.cd_item_pedido_venda = it.cd_item_pedido_venda and
                                                                    epv.cd_produto           = it.cd_produto 
             
--select * from atendimento_pedido_venda

    Where  
      pe.dt_pedido_venda between @dt_inicial and @dt_final and  
      ((pe.cd_cliente = @cd_cliente) or (@cd_cliente = 0))   

    order by 
      pe.dt_pedido_venda desc, 
      pe.cd_pedido_venda, 
      it.cd_item_pedido_venda   

