
-- DROP INDEX NOTA_SAIDA_ITEM.IX_NOTA_SAIDA_ITEM
-- CREATE INDEX IX_NOTA_SAIDA_ITEM
--    ON Nota_Saida_Item (cd_pedido_venda,cd_item_pedido_venda)


-- CREATE INDEX IX_Pedido_Venda_Origem
-- ON PEDIDO_VENDA (cd_pedido_venda_origem )

CREATE  PROCEDURE pr_consulta_pedido

 @ic_parametro              int = 1, --Filtrando pela data 
 @cd_cliente                int,
 @dt_inicial                datetime,
 @dt_final                  datetime,
 @cd_pedido_venda           int,
 @cd_pedido_compra_cliente  varchar(40),
 @cd_nota_fiscal            int        = 0,
 @cd_os                     varchar(15),
 @cd_posicao                varchar(15),
 @nm_referencia             varchar(40),
 @consignacao               varchar(1) = 'N',
 @nt_cancelados             varchar(1) = 'N',
 @ic_exportacao             varchar(1) = 'N',
 @ic_faturado               varchar(1) = 'S',
 @cd_item_pedido_venda      int = 0,
 @cd_usuario                int = 0,
 @ic_tipo_pesq_Produto      varchar(1)   = 'F', 
 @nm_produto                varchar(100) = '',
 @cd_servico                int          = 0

as

  --pedido_venda_item

  declare @cd_loja         int
  declare @cd_fase_produto int

  set @cd_loja = 0

  if IsNull(@cd_usuario,0) <> 0
  begin
    Select top 1 
      @cd_Loja = IsNull(us.cd_loja,0) 
    from 
      EgisAdmin.dbo.Usuario us with (nolock) 
    where 
      us.cd_usuario = @cd_usuario
     
  end

  if IsNull(@cd_pedido_venda,0) > 0 
     set @dt_final = getdate()

  --Manter compatibilidade

  if ( @consignacao is null )
     set @consignacao = 'S'

  if ( @nt_cancelados is null )
     set @nt_cancelados = 'N'

  --Fase Padrão

  select
    @cd_fase_produto = isnull(cd_fase_produto,0) 
  from
    parametro_comercial with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()


  if IsNull(@ic_parametro,1) = 1 
    SELECT 
			distinct  
			c.nm_fantasia_cliente,  
			pv.dt_pedido_venda,  
			pv.cd_pedido_venda,  
			pvi.cd_item_pedido_venda,  
        
                       case when isnull(pvi.cd_servico,0)>0 then
                             case when cast(pvi.ds_produto_pedido_venda as varchar(50))=''
                                  then cast(s.nm_servico as varchar(50))
                                  else cast(pvi.ds_produto_pedido_venda as varchar(50))
                             end
                        else   
                             pvi.nm_produto_pedido 
                        end as nm_produto,  
			IsNull(pvi.nm_fantasia_produto,s.nm_servico) as nm_fantasia_produto,  
                        case when isnull(pvi.cd_servico,0)>0 then
                             cast(pvi.cd_servico as varchar(25)) 
                        else
                            case when isnull(pvi.cd_produto,0) = 0 
                            then cast(pvi.cd_grupo_produto as varchar(20) )
                            else p.cd_mascara_produto end 
                        end as cd_mascara_produto,
			pvi.cd_consulta,  
			pvi.cd_item_consulta,  
			pv.nm_referencia_consulta,  
			pvi.qt_item_pedido_venda,  
			pvi.vl_unitario_item_pedido,  
			pvi.pc_desconto_item_pedido,  
		  case 
		    when(pvi.dt_cancelamento_item is null) then  
		      (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) 
		    else 
		      0.00 
		  end AS vl_total,  

		  case  when(pvi.dt_cancelamento_item is null) and (isnull(pvi.qt_saldo_pedido_venda,0)>0) then                   
		      (pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido) 
		    else 
		      0.00 
		  end AS vl_total_saldo,  

		  case 
		    when (pvi.dt_cancelamento_item is not null) then  
		      (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) 
		    else 
		      0 
		  end AS vl_totalcanc,  

		  pvi.dt_entrega_fabrica_pedido,  
		  pvi.dt_entrega_vendas_pedido,  
		  pvi.dt_reprog_item_pedido,  

                  --Este Trecho Duplica a Consulta quando tem faturamento parcial para o Pedido de Venda

-- 		  nsi.cd_nota_saida,  
-- 
-- 		  (Select top 1 dt_nota_saida       from nota_saida where cd_nota_saida = nsi.cd_nota_saida) as dt_nota_saida,  
-- 		  (Select top 1 dt_saida_nota_saida from nota_saida where cd_nota_saida = nsi.cd_nota_saida) as dt_saida_nota_saida,  
-- 
-- 		  nsi.cd_item_nota_saida,
-- 		  nsi.qt_item_nota_saida,  
-- 		  nsi.qt_devolucao_item_nota,

                  -------------------------------------------------------------------------------------------------
                  --View's Agrupado
                  --Carlos Fernandes - 12.02.2009 
                  -------------------------------------------------------------------------------------------------
                  nsi.cd_identificacao_nota_saida              as cd_nota_saida,
                  nsi.dt_nota_saida,
                  nsi.dt_saida_nota_saida,
                  nsi.cd_item_nota_saida,
                  nsi.qt_item_nota_saida,
                  nsi.qt_devolucao_item_nota,
                  nsi.qt_item_nota_saida                        as qt_faturada,
  
                  --cast( 0 as Float) qt_faturada,
	
   	          pvi.dt_cancelamento_item,  
		  cp.nm_condicao_pagamento,  
		  t.nm_transportadora,  
		  pvi.cd_os_tipo_pedido_venda,  
		  pvi.cd_posicao_item_pedido,  
		  pv.cd_pdcompra_pedido_venda,  
		  pvi.cd_pdcompra_item_pedido,  
		  pvi.ic_tipo_montagem_item,  
		  pvi.ic_montagem_g_item_pedido,  
		  pvi.ic_subs_tributaria_item,  
                  case when isnull(pvi.qt_saldo_pedido_venda,0)>0 then
    		    pvi.qt_saldo_pedido_venda
                  else
                    0.00
                  end                                  as qt_saldo_pedido_venda,
		  tp.nm_tipo_pedido,  
		  tp.sg_tipo_pedido,  
		  st.nm_status_pedido,  
                  cg.nm_cliente_grupo,

--select * from status_pedido

   	    case when (isnull(pvi.qt_saldo_pedido_venda,0) = 0) and (pvi.dt_cancelamento_item is null) then
              'PL'
            else
              case when (pvi.dt_cancelamento_item is not null) then
                 'PC'
              else     
                  st.sg_status_pedido
              end
       end                               as sg_status_pedido, 

      pvi.nm_desconto_item_pedido,  
      pvi.nm_observacao_fabrica1,
      pvi.nm_observacao_fabrica2,
      cap.nm_categoria_produto,
  	  v.nm_fantasia_vendedor,
      ve.nm_fantasia_vendedor as nm_fantasia_vendedor_i,
      IsNull(vl_unitario_item_pedido,0) / ( case 
                                              when IsNull((pvi.vl_moeda_cotacao),1) = 0 then
				                                        1 
                                              else 
                                                IsNull((pvi.vl_moeda_cotacao),1) 
                                              end ) as vl_outra_moeda,
      pv.dt_entrada_pedido,
      pvi.qt_area_produto,
      isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.qt_area_produto,0) as qt_total_area,
      ISNULL(pv.ic_amostra_pedido_venda,'N') as ic_amostra_pedido_venda,
-- Anderson 11/11/2006 Adicionando campos ao grid da consulta
      isnull(pvi.cd_desenho_item_pedido,p.cd_desenho_produto)     as cd_desenho_item_pedido,
      isnull(pvi.cd_rev_des_item_pedido,p.cd_rev_desenho_produto) as cd_rev_des_Item_pedido,
      pvi.cd_lote_item_pedido,
      dbo.fn_ultima_ordem_producao_item_pedido(pv.cd_pedido_venda, pvi.cd_item_pedido_venda) 
                                         as cd_processo,
      isnull(pvi.vl_frete_item_pedido,0) as vl_frete_item_pedido,
      isnull(pvi.pc_ipi,0)               as pc_ipi,
      isnull(pvi.pc_icms,0)              as pc_icms,
      isnull((pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * (isnull(pvi.pc_ipi,0)/100 )),0)
                                         as vl_item_ipi,
      cli.nm_fantasia_cliente            as ClienteOrigem ,
      case when isnull(p.cd_marca_produto,0)<>0 then
        mp.nm_marca_produto
      else
        isnull(p.nm_marca_produto,mp.nm_marca_produto)
      end                                as nm_marca_produto,
      isnull(pvi.cd_programacao_entrega,0) as cd_programacao_entrega,
      dp.nm_destinacao_produto,
      tpr.sg_tabela_preco
 

  FROM  
      Pedido_Venda pv                        with (nolock)
      INNER JOIN Cliente c                   with (nolock) ON pv.cd_cliente            = c.cd_cliente  
      LEFT OUTER JOIN Cliente_Grupo cg       with (nolock) ON cg.cd_cliente_grupo      = c.cd_cliente_grupo 
      INNER JOIN Pedido_Venda_Item pvi       with (nolock, INDEX(PK_Pedido_Venda_Item))
                                                           ON pv.cd_pedido_venda       = pvi.cd_pedido_venda 
      left outer join Tabela_Preco tpr       with (nolock) ON tpr.cd_tabela_preco      = pvi.cd_tabela_preco
      left outer join Cliente_Origem corig   with (nolock) ON corig.cd_cliente         = pv.cd_cliente and
                                                              corig.cd_cliente_origem  = pv.cd_cliente_origem

      left outer join Cliente        cli     with (nolock) ON cli.cd_cliente           = corig.cd_cliente_origem 
                                                               
      LEFT OUTER JOIN Produto p              with (nolock) ON pvi.cd_produto           = p.cd_produto 
      LEFT OUTER JOIN Categoria_Produto cap  with (nolock) ON cap.cd_categoria_produto = pvi.cd_categoria_produto 
      LEFT OUTER JOIN Condicao_Pagamento cp  with (nolock) ON pv.cd_condicao_pagamento = cp.cd_condicao_pagamento 
      LEFT OUTER JOIN Destinacao_Produto dp  with (nolock) ON pv.cd_destinacao_produto = dp.cd_destinacao_produto 
      LEFT OUTER JOIN Vendedor v             with (nolock) ON pv.cd_vendedor           = v.cd_vendedor 
      LEFT OUTER JOIN Vendedor ve            with (nolock) ON pv.cd_vendedor_interno   = ve.cd_vendedor 
      LEFT OUTER JOIN Transportadora t       with (nolock) ON pv.cd_transportadora     = t.cd_transportadora 
      LEFT OUTER JOIN Tipo_Pedido tp         with (nolock) ON pv.cd_tipo_pedido        = tp.cd_tipo_pedido 
      LEFT OUTER JOIN Status_Pedido st       with (nolock) ON pv.cd_status_pedido      = st.cd_status_pedido 
      LEFT OUTER JOIN Servico s              with (nolock) ON pvi.cd_servico           = s.cd_servico and 
                                                              IsNull(pvi.ic_pedido_venda_item,'P') = 'S' 
      LEFT OUTER JOIN Marca_Produto mp       with (nolock) ON mp.cd_marca_produto    = p.cd_marca_produto

      ---Antes

--       LEFT OUTER JOIN Nota_Saida_item nsi    with (nolock, INDEX(IX_Nota_Saida_Item))
--                                            ON nsi.cd_pedido_venda = pvi.cd_pedido_venda and 
--                                               nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
--                                             (IsNull(nsi.qt_item_nota_saida,0) > IsNull(nsi.qt_devolucao_item_nota,0)) --Trás somente as nota que possuem saldo
-- 	                                      and (nsi.cd_status_nota not in (7,4)) --Desconsidera as notas canceladas ou totalmente devolvidas 

      --View - 12.02.2009 - Agrupados ** Ver Performance
      LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                      nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda

   WHERE 
		  --Pedido de Venda especificamente
		  pv.cd_pedido_venda = (case IsNull(@cd_pedido_venda,0)
		                          when 0 then
		                            pv.cd_pedido_venda
		                          else
		                            IsNull(@cd_pedido_venda,0)
		                        end) 
		  and --Data de Emissão do Pedido de venda
		  pv.dt_pedido_venda  between (case IsNull(@cd_pedido_venda,0)
		                                when 0 then 
		                                  @dt_inicial
		                                else
		                                  pv.dt_pedido_venda
		                              end) and
		                             (case IsNull(@cd_pedido_venda,0)
		                                when 0 then 
		                                  @dt_final
		                                else
		                                  pv.dt_pedido_venda
		                              end) 
		  and --Filtra por POS
		  IsNull(pvi.cd_posicao_item_pedido,'')  = (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@cd_posicao,'')
		                                                  when '' then
		                                                    IsNull(pvi.cd_posicao_item_pedido,'')
		                                                  else
		                                                    IsNull(@cd_posicao,'')
		                    end )
		                                             else
		                                               IsNull(pvi.cd_posicao_item_pedido,'')
		                                             end)
		  and --Filtra por OS
		  IsNull(pvi.cd_os_tipo_pedido_venda,'') like (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@cd_os,'')
		                                                  when '' then
		                                                    IsNull(pvi.cd_os_tipo_pedido_venda,'')
		                                                  else
		                                        IsNull(@cd_os + '%','')
		                                                end )
		                                             else
		                                               IsNull(pvi.cd_os_tipo_pedido_venda,'')
		                                             end)
		  and --Filtra por Referencia
		  IsNull(pv.nm_referencia_consulta,'') like (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@nm_referencia,'')
		                                                  when '' then
		                                                    IsNull(pv.nm_referencia_consulta,'')
		                                                  else
		                                                    IsNull(@nm_referencia + '%','')
		                                                end )
		                                             else
		                                               IsNull(pv.nm_referencia_consulta,'')
		                                             end)
		  and --Filtra por Pedido de Compra do Cliente
		  IsNull(pv.cd_pdcompra_pedido_venda,'') like (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@cd_pedido_compra_cliente,'')
		                                                  when '' then
		                                                    IsNull(pv.cd_pdcompra_pedido_venda,'')
		                                                  else
		                                                    IsNull(@cd_pedido_compra_cliente + '%','')
		                                                end )
		                                             else
		                                               IsNull(pv.cd_pdcompra_pedido_venda,'')
		                                             end)
    and --Cancelamento - Pedido de Venda
    IsNull(pv.dt_cancelamento_pedido, DateAdd(day,1,@dt_final)) >
      (case IsNull(@cd_pedido_venda,0)
         when 0 then
           ( case IsNull(@nt_cancelados,'N')
    	         when 'N' then
                 DateAdd(day,-2,IsNull(pv.dt_cancelamento_pedido, DateAdd(day,1,@dt_final)))
               else
                 @dt_final
             end
            )
          else   
            DateAdd(day,-2,IsNull(pv.dt_cancelamento_pedido, DateAdd(day,1,@dt_final)))
        end )
    
    and --Cancelamento - Item do Pedido de Venda
    IsNull(pvi.dt_cancelamento_item, DateAdd(day,1,@dt_final)) >
      (case IsNull(@cd_pedido_venda,0)
         when 0 then
           ( case IsNull(@nt_cancelados,'N')
    	         when 'N' then
                 DateAdd(day,-2,IsNull(pvi.dt_cancelamento_item, DateAdd(day,1,@dt_final)))
               else
                 @dt_final
             end
            )
          else   
            DateAdd(day,-2,IsNull(pvi.dt_cancelamento_item, DateAdd(day,1,@dt_final)))
        end )
		  
		  and
       
       --Filtra por Nota Fiscal

--Carlos 26/1/2005
		  IsNull(nsi.cd_nota_saida,0) = ( case when IsNull(@cd_nota_fiscal,0) = 0
                                                 then
	                                            IsNull(nsi.cd_nota_saida,0)
	                                          else
	                                            @cd_nota_fiscal
	                                          end )

-- 		  IsNull(nsi.cd_nota_saida,0) = (case IsNull(@cd_pedido_venda,0)
-- 		                                    when @cd_nota_fiscal then
-- 		                                      ( case IsNull(@cd_nota_fiscal,0)
-- 		                                          when 0 then
-- 		                                            IsNull(nsi.cd_nota_saida,0)
-- 		                                          else
-- 		                                            @cd_nota_fiscal
-- 		                                          end )
-- 		                                    else
-- 		                                      IsNull(nsi.cd_nota_saida,0)
-- 		                                 end)

		  and --Consignação
		  isnull(pv.ic_consignacao_pedido,'N') = (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@consignacao,'S')
		                                                  when 'S' then
		                                                    isnull(pv.ic_consignacao_pedido,'N')
		                                                  else
		                                                    'N'
		                                                end )
		                                             else
		                                               isnull(pv.ic_consignacao_pedido,'N')
		                                             end)
		  and --Cliente
		  isnull(pv.cd_cliente,0) = (case IsNull(@cd_pedido_venda,0)
		                               when 0 then
		                                 ( case IsNull(@cd_cliente,0)
		                                     when 0 then
		                                       isnull(pv.cd_cliente,0)
		                                     else
		                                       @cd_cliente
		                                   end )
		                               else
		                                 isnull(pv.cd_cliente,0)
		                            end) and
                  isnull(pv.cd_loja,0) = case when @cd_Loja > 0 then @cd_Loja else isnull(pv.cd_loja,0) end
                  and -- Servico
                  isnull(pvi.cd_servico,0) = case when isnull(@cd_servico,0)=0 then pvi.cd_servico else @cd_servico end
                  and -- Somente Pedidos de Produto quando Tiver o Serviço Vinculado - Carlos Fernandes
                  isnull(pvi.cd_produto_servico,0) = 0

	  ORDER BY pv.dt_pedido_venda desc, 
  		       pv.cd_pedido_venda DESC, 
      		   pvi.cd_item_pedido_venda

	else if IsNull(@ic_parametro,1) = 2

  	SELECT distinct  
		  c.nm_fantasia_cliente,  
		  pv.dt_pedido_venda,  
		  pv.cd_pedido_venda,  
		  pvi.cd_item_pedido_venda,  
                       case when isnull(pvi.cd_servico,0)>0 then
                             case when cast(pvi.ds_produto_pedido_venda as varchar(50))=''
                                  then cast(s.nm_servico as varchar(50))
                                  else cast(pvi.ds_produto_pedido_venda as varchar(50))
                             end
                        else   
                             pvi.nm_produto_pedido 
                        end as nm_produto,  
		  IsNull(pvi.nm_fantasia_produto,s.nm_servico) as nm_fantasia_produto,  
                        case when isnull(pvi.cd_servico,0)>0 then
                             cast(pvi.cd_servico as varchar(25)) 
                        else
                            case when isnull(pvi.cd_produto,0) = 0 
                            then cast(pvi.cd_grupo_produto as varchar(20) )
                            else p.cd_mascara_produto end 
                        end as cd_mascara_produto,

		  pvi.cd_consulta,  
		  pvi.cd_item_consulta,  
		  pv.nm_referencia_consulta,  
		  pvi.qt_item_pedido_venda,  
		  pvi.vl_unitario_item_pedido,  
		  pvi.pc_desconto_item_pedido,  
		  case 
		    when(pvi.dt_cancelamento_item is null) then  
		      (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) 
		    else 
		      0 
		  end AS vl_total,  

		  case 
		    when(pvi.dt_cancelamento_item is null) and ( isnull(pvi.qt_saldo_pedido_venda,0)>0 ) then  
		      (pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido) 
		    else 
		      0.00 
		  end AS vl_total,  

		  case 
		    when (pvi.dt_cancelamento_item is not null) then  
		      (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) 
		    else 
		      0 
		  end AS vl_totalcanc,  

		  pvi.dt_entrega_fabrica_pedido,  
		  pvi.dt_entrega_vendas_pedido,  
		  pvi.dt_reprog_item_pedido,  
                  pvi.nm_observacao_fabrica1,
                  pvi.nm_observacao_fabrica2,

                  --Este Trecho Duplica a Consulta quando tem faturamento parcial para o Pedido de Venda


-- 		  nsi.cd_nota_saida,  
-- 		  (Select top 1 dt_nota_saida from nota_saida where cd_nota_saida = nsi.cd_nota_saida) as dt_nota_saida,  
-- 		  (Select top 1 dt_saida_nota_saida from nota_saida where cd_nota_saida = nsi.cd_nota_saida) as dt_saida_nota_saida,  
-- 		  nsi.cd_item_nota_saida,
-- 		  nsi.qt_item_nota_saida,  
-- 		  nsi.qt_devolucao_item_nota,
-----------------------------------------------------------------

                  -------------------------------------------------------------------------------------------------
                  --View's Agrupado
                  --Carlos Fernandes - 12.02.2009 
                  -------------------------------------------------------------------------------------------------
                  --nsi.cd_nota_saida,
                  nsi.cd_identificacao_nota_saida              as cd_nota_saida,
                  nsi.dt_nota_saida,
                  nsi.dt_saida_nota_saida,
                  nsi.cd_item_nota_saida,
                  nsi.qt_item_nota_saida,
                  nsi.qt_devolucao_item_nota,
                  nsi.qt_item_nota_saida as qt_faturada,

--                  cast( 0 as Float) qt_faturada,
		  pvi.dt_cancelamento_item,  
		  cp.nm_condicao_pagamento,  
		  t.nm_transportadora,  
		  pvi.cd_os_tipo_pedido_venda,  
		  pvi.cd_posicao_item_pedido,  
		  pv.cd_pdcompra_pedido_venda,  
		  pvi.cd_pdcompra_item_pedido,  
		  pvi.ic_tipo_montagem_item,  
		  pvi.ic_montagem_g_item_pedido,  
		  pvi.ic_subs_tributaria_item,  
		  case when isnull(pvi.qt_saldo_pedido_venda,0)>0 then
                     pvi.qt_saldo_pedido_venda
                  else
                     0.00
                  end                  as qt_saldo_pedido_venda,
		  tp.nm_tipo_pedido,  
		  tp.sg_tipo_pedido,  
		  st.nm_status_pedido,  
                  cg.nm_cliente_grupo,
		  case when (isnull(pvi.qt_saldo_pedido_venda,0) = 0) and (pvi.dt_cancelamento_item is null) 
        then
          'PL'
        else
           case when (pvi.dt_cancelamento_item is not null) 
           then
             'PC'
           else     
             st.sg_status_pedido
           end
        end  as sg_status_pedido, 
		  pvi.nm_desconto_item_pedido,  
                  cap.nm_categoria_produto,
		  v.nm_fantasia_vendedor,
		  ve.nm_fantasia_vendedor as nm_fantasia_vendedor_i,
      IsNull(vl_unitario_item_pedido,0) / ( case when IsNull((pvi.vl_moeda_cotacao),1) = 0 then
				   1 else IsNull((pvi.vl_moeda_cotacao),1) end ) as vl_outra_moeda,
      pv.dt_entrada_pedido,
 		pvi.qt_area_produto,
 		isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.qt_area_produto,0) as qt_total_area,
      ISNULL(pv.ic_amostra_pedido_venda,'N') as ic_amostra_pedido_venda,
	   dbo.fn_ultima_ordem_producao_item_pedido(pv.cd_pedido_venda, pvi.cd_item_pedido_venda) as cd_processo,
-- Anderson 11/11/2006 Adicionando campos ao grid da consulta
      pvi.cd_desenho_item_pedido,
      pvi.cd_rev_des_item_pedido,
      pvi.cd_lote_item_pedido,
      isnull(pvi.vl_frete_item_pedido,0) as vl_frete_item_pedido,
      isnull(pvi.pc_ipi,0)               as pc_ipi,
      isnull(pvi.pc_icms,0)              as pc_icms,
      isnull((pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * (isnull(pvi.pc_ipi,0)/100 )),0) as vl_item_ipi,
      cli.nm_fantasia_cliente            as ClienteOrigem,
      case when isnull(p.cd_marca_produto,0)<>0 then
        mp.nm_marca_produto
      else
        isnull(p.nm_marca_produto,mp.nm_marca_produto)
      end                                as nm_marca_produto,
      isnull(pvi.cd_programacao_entrega,0) as cd_programacao_entrega,
      dp.nm_destinacao_produto,
      tpr.sg_tabela_preco



   FROM  
	  Pedido_Venda pv                        with (nolock)
          INNER JOIN Cliente c                   with (nolock) ON pv.cd_cliente = c.cd_cliente 
          LEFT OUTER JOIN Cliente_Grupo cg       with (nolock) ON cg.cd_cliente_grupo = c.cd_cliente_grupo
          left outer join Cliente_Origem corig   with (nolock) ON corig.cd_cliente = pv.cd_cliente and
                                                                  corig.cd_cliente_origem = pv.cd_cliente_origem

          left outer join Cliente        cli     with (nolock) ON cli.cd_cliente   = corig.cd_cliente_origem

          INNER JOIN Pedido_Venda_Item pvi       with (nolock, INDEX(PK_Pedido_Venda_Item))
		                                               ON pv.cd_pedido_venda       = pvi.cd_pedido_venda 
          left outer join Tabela_Preco tpr       with (nolock) ON tpr.cd_tabela_preco  = pvi.cd_tabela_preco

          LEFT OUTER JOIN Produto p              with (nolock) ON pvi.cd_produto           = p.cd_produto 
          LEFT OUTER JOIN Marca_Produto mp       with (nolock) ON mp.cd_marca_produto      = p.cd_marca_produto
          LEFT OUTER JOIN Categoria_Produto cap  with (nolock) ON cap.cd_categoria_produto = pvi.cd_categoria_produto 
          LEFT OUTER JOIN Condicao_Pagamento cp                ON pv.cd_condicao_pagamento = cp.cd_condicao_pagamento 
          LEFT OUTER JOIN  Destinacao_Produto dp               ON pv.cd_destinacao_produto = dp.cd_destinacao_produto 
          LEFT OUTER JOIN Vendedor v                           ON pv.cd_vendedor           = v.cd_vendedor 
          LEFT OUTER JOIN Vendedor ve                          ON pv.cd_vendedor_interno   = ve.cd_vendedor 
          LEFT OUTER JOIN Transportadora t                     ON pv.cd_transportadora     = t.cd_transportadora 
          LEFT OUTER JOIN Tipo_Pedido tp                       ON pv.cd_tipo_pedido        = tp.cd_tipo_pedido 
          LEFT OUTER JOIN Status_Pedido st                     ON pv.cd_status_pedido      = st.cd_status_pedido 
          LEFT OUTER JOIN Servico s                            ON pvi.cd_servico           = s.cd_servico and 
                                                                  IsNull(pvi.ic_pedido_venda_item,'P') = 'S' 
--           LEFT OUTER JOIN Nota_Saida_item nsi with (nolock, INDEX(IX_Nota_Saida_Item))
-- 		    ON nsi.cd_pedido_venda = pvi.cd_pedido_venda and 
--                nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
-- 		      (IsNull(nsi.qt_item_nota_saida,0) > IsNull(nsi.qt_devolucao_item_nota,0)) --Trás somente as nota que possuem saldo
-- 		      and (nsi.cd_status_nota not in (7,4)) --Desconsidera as notas canceladas ou totalmente devolvidas 

         --View - 12.02.2009 - Agrupados ** Ver Performance
         LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                                nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda

	   WHERE 
		  --Pedido de Venda especificamente
		  pv.cd_pedido_venda = (case IsNull(@cd_pedido_venda,0)
		                          when 0 then
		                            pv.cd_pedido_venda
		                          else
		                            IsNull(@cd_pedido_venda,0)
		                        end) 
		  and --Filtra por POS
		  IsNull(pvi.cd_posicao_item_pedido,'')  = (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@cd_posicao,'')
		                                                  when '' then
		                                                    IsNull(pvi.cd_posicao_item_pedido,'')
		                                                  else
		                                                    IsNull(@cd_posicao,'')
		                                                end )
		                                             else
		                                               IsNull(pvi.cd_posicao_item_pedido,'')
		                                             end)
		  and --Filtra por OS
		  IsNull(pvi.cd_os_tipo_pedido_venda,'') like (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@cd_os,'')
		                                                  when '' then
		                                                    IsNull(pvi.cd_os_tipo_pedido_venda,'')
		                                                  else
		                                                    IsNull(@cd_os + '%','')
		                                                end )
		                                             else
		                                               IsNull(pvi.cd_os_tipo_pedido_venda,'')
		                                             end)
		  and --Filtra por Referencia
		  IsNull(pv.nm_referencia_consulta,'') like (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@nm_referencia,'')
		                                                  when '' then
		                                                    IsNull(pv.nm_referencia_consulta,'')
		                                                  else
		                                                    IsNull(@nm_referencia + '%','')
		                                                end )
		     else
		                                               IsNull(pv.nm_referencia_consulta,'')
		                                             end)
		
		  and --Filtra por Pedido de Compra do Cliente
		  IsNull(pv.cd_pdcompra_pedido_venda,'') like (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@cd_pedido_compra_cliente,'')
		                                                  when '' then
		                                                    IsNull(pv.cd_pdcompra_pedido_venda,'')
		                                                  else
		                                                    IsNull(@cd_pedido_compra_cliente + '%','')
		                                                end )
		                                             else
		                                               IsNull(pv.cd_pdcompra_pedido_venda,'')
		                                             end)
		  
    and --Cancelamento - Pedido de Venda
    IsNull(pv.dt_cancelamento_pedido, DateAdd(day,1,@dt_final)) >
      (case IsNull(@cd_pedido_venda,0)
         when 0 then
           ( case IsNull(@nt_cancelados,'N')
    	         when 'N' then
                 DateAdd(day,-2,IsNull(pv.dt_cancelamento_pedido, DateAdd(day,1,@dt_final)))
               else
                 @dt_final
             end
            )
          else   
            DateAdd(day,-2,IsNull(pv.dt_cancelamento_pedido, DateAdd(day,1,@dt_final)))
        end )
    
    and --Cancelamento - Item do Pedido de Venda
    IsNull(pvi.dt_cancelamento_item, DateAdd(day,1,@dt_final)) >
      (case IsNull(@cd_pedido_venda,0)
         when 0 then
           ( case IsNull(@nt_cancelados,'N')
    	         when 'N' then
                 DateAdd(day,-2,IsNull(pvi.dt_cancelamento_item, DateAdd(day,1,@dt_final)))
               else
                 @dt_final
             end
            )
          else   
            DateAdd(day,-2,IsNull(pvi.dt_cancelamento_item, DateAdd(day,1,@dt_final)))
        end )
		  
		  and --Filtra por Nota Fiscal
--Carlos 26/1/2005

		  IsNull(nsi.cd_nota_saida,0) = ( case when IsNull(@cd_nota_fiscal,0) = 0
                                                 then
	                                            IsNull(nsi.cd_nota_saida,0)
	                                          else
	                                            @cd_nota_fiscal
	                                          end )
		  and --Consignação
		  isnull(pv.ic_consignacao_pedido,'N') = (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@consignacao,'S')
		                                                  when 'S' then
		                           isnull(pv.ic_consignacao_pedido,'N')
		                                                  else
		                                                    'N'
		                                                end )
		                                             else
		                                               isnull(pv.ic_consignacao_pedido,'N')
		                                             end)
		  and --Cliente
		  isnull(pv.cd_cliente,0) = (case IsNull(@cd_pedido_venda,0)
		                               when 0 then
		                                 ( case IsNull(@cd_cliente,0)
		                                     when 0 then
		                                       isnull(pv.cd_cliente,0)
		                                     else
		                                       @cd_cliente
		                                   end )
		                               else
		                                 isnull(pv.cd_cliente,0)
		                            end) and
                  isnull(pv.cd_loja,0) = case when @cd_Loja > 0 then @cd_Loja else isnull(pv.cd_loja,0) end
                  and -- Servico
                  isnull(pvi.cd_servico,0) = case when isnull(@cd_servico,0)=0 then pvi.cd_servico else @cd_servico end
                  and -- Somente Pedidos de Produto quando Tiver o Serviço Vinculado - Carlos Fernandes
                  isnull(pvi.cd_produto_servico,0) = 0
 
	  ORDER BY 
       pv.dt_pedido_venda desc, 
       pv.cd_pedido_venda DESC, 
       pvi.cd_item_pedido_venda

--********************************************************
--* Parametro 3
--********************************************************

if IsNull(@ic_parametro,1) = 3
begin

  SELECT 
    distinct
    c.nm_fantasia_cliente,  
    pv.dt_pedido_venda,  
    pv.cd_pedido_venda,  
    pvi.cd_item_pedido_venda,  
    case when isnull(pvi.cd_servico,0)>0 then
      case 
        when cast(pvi.ds_produto_pedido_venda as varchar(50))='' then 
          cast(s.nm_servico as varchar(50))
        else 
          cast(pvi.ds_produto_pedido_venda as varchar(50))
      end
      else   
        pvi.nm_produto_pedido 
    end                                          as nm_produto,  
    IsNull(pvi.nm_fantasia_produto,s.nm_servico) as nm_fantasia_produto,      
    case 
      when isnull(pvi.cd_servico,0)>0 then
        cast(pvi.cd_servico as varchar(25)) 
      else
        case 
          when isnull(pvi.cd_produto,0) = 0 then 
            cast(pvi.cd_grupo_produto as varchar(20) )
          else 
            p.cd_mascara_produto 
        end 
    end as cd_mascara_produto,
    pvi.cd_consulta,  
    pvi.cd_item_consulta,  
    pv.nm_referencia_consulta,  
    pvi.qt_item_pedido_venda,  
    pvi.vl_unitario_item_pedido,  
    pvi.pc_desconto_item_pedido,  
    case 
     when(pvi.dt_cancelamento_item is null) then  
		      (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) 
		    else 
		      0 
	 end AS vl_total,  

    case 
    when(pvi.dt_cancelamento_item is null) and isnull(pvi.qt_saldo_pedido_venda,0)>0 then  
	      (pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido) 
    else 
	      0.00 
    end AS vl_total_saldo,  

    case 
      when (pvi.dt_cancelamento_item is not null) then  
       (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) 
      else 
        0 
    end AS vl_totalcanc,  

    pvi.dt_entrega_fabrica_pedido,  
    pvi.dt_entrega_vendas_pedido,  
    pvi.dt_reprog_item_pedido,  
    pvi.nm_observacao_fabrica1,
    pvi.nm_observacao_fabrica2,

    --Trazer a última nota impressa para o pedido

--    (Select 
--       case 
--         When count(nfs.cd_nota_saida) > 1 then 
--           max(nfs.cd_nota_saida)
--         else 
--           max(nfs.cd_nota_saida) 
--       end
--     from
--       Nota_Saida_Item x              with (nolock) 
--       LEFT OUTER JOIN Nota_Saida nfs with (nolock) on x.cd_nota_saida = nfs.cd_nota_saida 
--     where 
--       x.cd_pedido_venda      = pvi.cd_pedido_venda and
--       x.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
--      (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) and --Trás somente as nota que possuem saldo
--              x.cd_status_nota not in (7,4) 
--    ) as cd_nota_saida,

    --Trazer se há mais de uma nota

   (Select 
      case 
        When count(nfs.cd_nota_saida) > 1 then 
          'S'
        else 
          'N' 
      end
    from
      Nota_Saida_Item x              with (nolock) 
      LEFT OUTER JOIN Nota_Saida nfs with (nolock) on x.cd_nota_saida = nfs.cd_nota_saida 
    where 
      x.cd_pedido_venda      = pvi.cd_pedido_venda and
      x.cd_item_pedido_venda = pvi.cd_item_pedido_venda
   ) as ic_multi_nota_saida,

    --Trazer a data da última nota impressa para o pedido

--    (Select 
--       Max(nfs.dt_nota_saida)
--     from 
--       Nota_Saida_Item x              with (nolock)
--       LEFT OUTER JOIN Nota_Saida nfs with (nolock) on x.cd_nota_saida = nfs.cd_nota_saida 
--     where
--       x.cd_pedido_venda      = pvi.cd_pedido_venda and
--       x.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
--      (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) and --Trás somente as nota que possuem saldo
--              x.cd_status_nota not in (7,4)
--    ) as dt_nota_saida,

    --Trazer a data de saída da última nota impressa para o pedido

--    (Select
--       max(nfs.dt_saida_nota_saida)
--     from 
--       Nota_Saida_Item x               with (nolock) 
--       LEFT OUTER JOIN Nota_Saida nfs  with (nolock) on x.cd_nota_saida = nfs.cd_nota_saida 
--     where 
--       x.cd_pedido_venda = pvi.cd_pedido_venda and
--       x.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
--      (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) and --Trás somente as nota que possuem saldo
--              x.cd_status_nota not in (7,4) 
--    ) as dt_saida_nota_saida,
--     0 as cd_item_nota_saida, --Somente para naum dar pau no Grid

    --Trazer as quantidades da última nota impressa para o pedido

--    (Select top 1 
--       isnull(x.qt_item_nota_saida,0)
--     from 
--       Nota_Saida_Item x              with (nolock) 
--       LEFT OUTER JOIN Nota_Saida nfs with (nolock) on x.cd_nota_saida = nfs.cd_nota_saida
--     where 
--       x.cd_pedido_venda      = pvi.cd_pedido_venda      and
--       x.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
--      (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) and --Trás somente as nota que possuem saldo
--              x.cd_status_nota not in (7,4) 
--     order by 
--       nfs.dt_nota_saida desc
--    ) as qt_item_nota_saida,
-- 
    --Trazer as quantidades devolvidas das nota impressa para o pedido

--   (Select 
--      SUM( isnull(x.qt_devolucao_item_nota,0) )
--    from 
--      Nota_Saida_Item x              with (nolock)
--      LEFT OUTER JOIN Nota_Saida nfs with (nolock) on x.cd_nota_saida = nfs.cd_nota_saida
--    where 
--      x.cd_pedido_venda      = pvi.cd_pedido_venda and
--      x.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
--     (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) and --Trás somente as nota que possuem saldo
--             x.cd_status_nota not in (7,4) 
--   ) as qt_devolucao_item_nota,

   --Trazer o total de quantidades da última nota impressa para o pedido

--   (Select
--      sum( isnull(x.qt_item_nota_saida,0) )
--    from 
--      Nota_Saida_Item x              with (nolock) 
--      LEFT OUTER JOIN Nota_Saida nfs with (nolock) on x.cd_nota_saida = nfs.cd_nota_saida 
--    where 
--      x.cd_pedido_venda = pvi.cd_pedido_venda and
--      x.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
--     (IsNull(x.qt_item_nota_saida,0) > IsNull(x.qt_devolucao_item_nota,0)) and --Trás somente as nota que possuem saldo
--             x.cd_status_nota not in (7,4) 
--   ) as qt_faturada,
-- 

-----------------------------------------------------------------------------------------------
--View Agrupada
-----------------------------------------------------------------------------------------------

    --nsi.cd_nota_saida,

    nsi.cd_identificacao_nota_saida              as cd_nota_saida,
    nsi.dt_nota_saida,
    nsi.dt_saida_nota_saida,
    nsi.cd_item_nota_saida,
    nsi.qt_item_nota_saida,
    nsi.qt_devolucao_item_nota,
    nsi.qt_item_nota_saida as qt_faturada,

    pvi.dt_cancelamento_item,  
    cp.nm_condicao_pagamento,  
    t.nm_transportadora,  
    pvi.cd_os_tipo_pedido_venda,  
    pvi.cd_posicao_item_pedido,  
    pv.cd_pdcompra_pedido_venda,  
    pvi.cd_pdcompra_item_pedido,  
    pvi.ic_tipo_montagem_item,  
    pvi.ic_montagem_g_item_pedido,  
    pvi.ic_subs_tributaria_item,  

    case when isnull(pvi.qt_saldo_pedido_venda,0)>0 then
      pvi.qt_saldo_pedido_venda
    else
      0.00
    end                    as qt_saldo_pedido_venda,
    tp.nm_tipo_pedido,  
    tp.sg_tipo_pedido,  
    st.nm_status_pedido,  
    cg.nm_cliente_grupo,
    case when (isnull(pvi.qt_saldo_pedido_venda,0) = 0) and (pvi.dt_cancelamento_item is null)
    then
      'PL'
    else
      case when (pvi.dt_cancelamento_item is not null) then
        'PC'
      else     
         st.sg_status_pedido
      end
    end                             as sg_status_pedido,
    cap.nm_categoria_produto,
    v.nm_fantasia_vendedor,
    ve.nm_fantasia_vendedor         as nm_fantasia_vendedor_i,
    pvi.nm_desconto_item_pedido,
    IsNull(vl_lista_item_pedido,0)  as vl_lista_item_pedido,
    IsNull(vl_unitario_item_pedido,0) / ( case 
                                            when IsNull((pvi.vl_moeda_cotacao),1) = 0 then
				              1 
                                            else 
                                              IsNull((pvi.vl_moeda_cotacao),1) end 
                                        ) as vl_outra_moeda,
    pv.dt_entrada_pedido,
    pvi.qt_area_produto,
    isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.qt_area_produto,0)                     as qt_total_area,
    ISNULL(pv.ic_amostra_pedido_venda,'N')                                                 as ic_amostra_pedido_venda,

    --Antes 14.03.2009 - Carlos
    --dbo.fn_ultima_ordem_producao_item_pedido(pv.cd_pedido_venda, pvi.cd_item_pedido_venda) as cd_processo,
    pp.cd_processo,
    pp.qt_planejada_processo,
    sp.nm_status_processo,

    -- Anderson 11/11/2006 Adicionando campos ao grid da consulta

    pvi.cd_desenho_item_pedido,
    pvi.cd_rev_des_item_pedido,
    pvi.cd_lote_item_pedido,
    pv.dt_cancelamento_pedido,
    isnull(pvi.vl_frete_item_pedido,0)    as vl_frete_item_pedido,
    isnull(pvi.pc_ipi,0)                  as pc_ipi,
    isnull(pvi.pc_icms,0)                 as pc_icms,
    isnull((pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * (isnull(pvi.pc_ipi,0)/100 )),0) as vl_item_ipi,
    cli.nm_fantasia_cliente               as ClienteOrigem,
    isnull(ps.qt_saldo_reserva_produto,0) as Disponivel,
    isnull(pc.vl_custo_produto,0)         as vl_custo_produto,
    case when isnull(pc.vl_custo_produto,0)>0 then
         pvi.vl_unitario_item_pedido/isnull(pc.vl_custo_produto,0)
    else
        0.00 end                          as Margem,
    case when isnull(p.cd_marca_produto,0)<>0 then
        mp.nm_marca_produto
      else
        isnull(p.nm_marca_produto,mp.nm_marca_produto)
      end                                as nm_marca_produto,
    isnull(pvi.cd_programacao_entrega,0) as cd_programacao_entrega,
    dp.nm_destinacao_produto,
    tpr.sg_tabela_preco,
    pimp.cd_part_number_produto,
    identity(int,1,1) as cd_chave_pedido,
    --Dados do Atendimento
    apv.nm_forma,
    apv.cd_documento,
    apv.cd_item_documento,
    apv.dt_atendimento,
    apv.qt_atendimento,
    case when isnull(apv.cd_documento,0)=0 then
      'Estoque'
    else
      'Previsto'
    end                                   as nm_atendimento

  into
    #ConsultaPedido

  FROM  
    Pedido_Venda pv with (nolock) 
    inner join (
                 Select 
                   y.cd_cliente,y.cd_tipo_mercado, y.cd_cliente_grupo, y.nm_fantasia_cliente 
                 from 
                   Cliente y with (nolock)
                   LEFT OUTER JOIN Tipo_Mercado u on y.cd_tipo_mercado = u.cd_tipo_mercado
                 Where 
                   IsNull(u.ic_exportacao_tipo_mercado,'N') = (case IsNull(@ic_exportacao,'N')
                                                                 when 'N' then
                                                                   IsNull(@ic_exportacao,'N')
                                                                 else
                                                                   u.ic_exportacao_tipo_mercado
                                                               end)
               ) c ON pv.cd_cliente = c.cd_cliente
    INNER JOIN Pedido_Venda_Item pvi       with (nolock, INDEX(PK_Pedido_Venda_Item)) 
                                                         ON pv.cd_pedido_venda       = pvi.cd_pedido_venda 
    left outer join Tabela_Preco tpr       with (nolock) ON tpr.cd_tabela_preco      = pvi.cd_tabela_preco

    LEFT OUTER JOIN Cliente_Grupo cg       with (nolock) ON cg.cd_cliente_grupo      = c.cd_cliente_grupo 
    left outer join Cliente_Origem corig   with (nolock) ON corig.cd_cliente         = pv.cd_cliente and
                                                            corig.cd_cliente_origem  = pv.cd_cliente_origem
    left outer join Cliente        cli     with (nolock) ON cli.cd_cliente           = corig.cd_cliente_origem
    LEFT OUTER JOIN Produto p              with (nolock) ON pvi.cd_produto           = p.cd_produto 
    LEFT OUTER JOIN Produto_Custo pc       with (nolock) ON pc.cd_produto            = p.cd_produto
    LEFT OUTER JOIN Produto_Saldo ps       with (nolock) ON ps.cd_produto            = pvi.cd_produto and
                                                            ps.cd_fase_produto       = (case when isnull(p.cd_fase_produto_baixa,0)>0 then p.cd_fase_produto_baixa else @cd_fase_produto end ) 
    LEFT OUTER JOIN Categoria_Produto cap  with (nolock) ON cap.cd_categoria_produto = pvi.cd_categoria_produto 
    LEFT OUTER JOIN Condicao_Pagamento cp  with (nolock) ON pv.cd_condicao_pagamento = cp.cd_condicao_pagamento 
    LEFT OUTER JOIN Destinacao_Produto dp  with (nolock) ON pv.cd_destinacao_produto = dp.cd_destinacao_produto 
    LEFT OUTER JOIN Vendedor v             with (nolock) ON pv.cd_vendedor           = v.cd_vendedor 
    LEFT OUTER JOIN Vendedor ve            with (nolock) ON pv.cd_vendedor_interno   = ve.cd_vendedor 
    LEFT OUTER JOIN Transportadora t       with (nolock) ON pv.cd_transportadora     = t.cd_transportadora 
    LEFT OUTER JOIN Tipo_Pedido tp         with (nolock) ON pv.cd_tipo_pedido        = tp.cd_tipo_pedido 
    LEFT OUTER JOIN Status_Pedido st       with (nolock) ON pv.cd_status_pedido      = st.cd_status_pedido 
    LEFT OUTER JOIN Servico s              with (nolock) ON pvi.cd_servico           = s.cd_servico       and 
                                                           IsNull(pvi.ic_pedido_venda_item,'P') = 'S'

    LEFT OUTER JOIN Marca_Produto mp        with (nolock) ON mp.cd_marca_produto = p.cd_marca_produto
    Left outer join Produto_importacao pimp with (nolock) on pimp.cd_produto     = p.cd_produto
    left outer join Processo_Producao  pp   with (nolock) on pp.cd_processo      = dbo.fn_ultima_ordem_producao_item_pedido(pv.cd_pedido_venda, pvi.cd_item_pedido_venda)
    left outer join Status_Processo    sp   with (nolock) on sp.cd_status_processo = pp.cd_status_processo 

--select * from processo_producao
--     LEFT OUTER JOIN (
--                       Select cd_nota_saida, cd_pedido_venda,cd_item_pedido_venda, qt_item_nota_saida 
--                       from 
--                         Nota_Saida_Item with (nolock, INDEX(IX_Nota_Saida_Item))
--                       where (IsNull(qt_item_nota_saida,0) > IsNull(qt_devolucao_item_nota,0)) --Trás somente as nota que possuem saldo
-- 		         and cd_status_nota not in (7,4)
--                     ) nsi --Desconsidera as notas canceladas ou totalmente devolvidas 
--                           ON pvi.cd_pedido_venda      = nsi.cd_pedido_venda and 
--                              pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda		         

      --View - 12.02.2009 - Agrupados ** Ver Performance
    LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda

    left outer join Atendimento_Pedido_Venda apv          on apv.cd_pedido_venda      = pvi.cd_pedido_venda and
                                                             apv.cd_item_pedido_venda = pvi.cd_item_pedido_venda
  WHERE 
    --Pedido de Venda especificamente
    pv.cd_pedido_venda = (case IsNull(@cd_pedido_venda,0)
                            when 0 then
                              pv.cd_pedido_venda
                            else
                              IsNull(@cd_pedido_venda,0)
                          end) 
    and --Data de Emissão do Pedido de venda
    pv.dt_pedido_venda  between (case 
                                   when IsNull(@cd_pedido_venda,0)=0 and IsNull(@cd_nota_fiscal,0)=0 then 
                                     @dt_inicial
                                   else
                                     pv.dt_pedido_venda
                                 end) and
	                        (case 
                                   when IsNull(@cd_pedido_venda,0)=0 and IsNull(@cd_nota_fiscal,0)=0 then 
                                     @dt_final
                                   else
                                     pv.dt_pedido_venda
                                 end) 
    and --Filtra por POS
    IsNull(pvi.cd_posicao_item_pedido,'')  = (case IsNull(@cd_pedido_venda,0)
                                                when 0 then
                                                 ( case IsNull(@cd_posicao,'')
                                                     when '' then
                                                       IsNull(pvi.cd_posicao_item_pedido,'')
                                                     else
	                                               IsNull(@cd_posicao,'')
	                                           end )
	                                        else
	                                          IsNull(pvi.cd_posicao_item_pedido,'')
	                                      end)
   and --Filtra por OS
    IsNull(pvi.cd_os_tipo_pedido_venda,'') like (case IsNull(@cd_pedido_venda,0)
                                                   when 0 then
                                                    ( case IsNull(@cd_os,'')
                                                        when '' then
                                                          IsNull(pvi.cd_os_tipo_pedido_venda,'')
                                                        else
                                                          IsNull(@cd_os + '%','')
                                                      end )
                                                   else
                                                     IsNull(pvi.cd_os_tipo_pedido_venda,'')
                                                  end)
    and --Filtra por Referencia -- Anderson Continuar a Organizar daqui
		  IsNull(pv.nm_referencia_consulta,'') like (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@nm_referencia,'')
		                                                  when '' then
		                                                    IsNull(pv.nm_referencia_consulta,'')
		                                                  else
		                                                    IsNull(@nm_referencia + '%','')
		                                                end )
		                                             else
		                                               IsNull(pv.nm_referencia_consulta,'')
		                                             end)
		  and --Filtra por Pedido de Compra do Cliente
		  IsNull(pv.cd_pdcompra_pedido_venda,'') like (case IsNull(@cd_pedido_venda,0)
		                              when 0 then
		                                              ( case IsNull(@cd_pedido_compra_cliente,'')
		                                                  when '' then
		                                                    IsNull(pv.cd_pdcompra_pedido_venda,'')
		                                                  else
		                                                    IsNull(@cd_pedido_compra_cliente + '%','')
		                                                end )
		                                             else
		                                               IsNull(pv.cd_pdcompra_pedido_venda,'')
		                                             end)		  

       and --Cancelamento - Pedido de Venda

--Dino / Carlos
--Atenção o Flag abaixo está invertido  NÃO MEXER ( N=S )


      1 = case when pv.dt_cancelamento_pedido is null
            then 1
            else 
              case when IsNull(@nt_cancelados,'N')='N' and pv.dt_cancelamento_pedido is not null
                   then 1
                   else 
                     case when IsNull(@nt_cancelados,'N')='S' and pv.dt_cancelamento_pedido is not null
                      then 2
                      else 1 end
                   end
       end and

      1 = case when pvi.dt_cancelamento_item is null
            then 1
            else 
              case when IsNull(@nt_cancelados,'N')='N' and pvi.dt_cancelamento_item is not null
                   then 1
                   else 
                     case when IsNull(@nt_cancelados,'N')='S' and pvi.dt_cancelamento_item is not null
                      then 2
                      else 1 end
                   end
       end

--Carlos 26/1/2005

      --Nota Fiscal      

		  and IsNull(nsi.cd_nota_saida,0) = ( case when IsNull(@cd_nota_fiscal,0) = 0
                                                 then
	                                            IsNull(nsi.cd_nota_saida,0)
	                                          else
	                                            @cd_nota_fiscal
	                                          end )
        and -- Faturado
		  IsNull(nsi.cd_nota_saida,0) = ( case when (IsNull(@ic_faturado,'N') = 'N') and  IsNull(@cd_nota_fiscal,0) = 0 
                                                then
                                                  --Verifica se o Item tem saldo a Faturar
                                                  --Carlos Fernandes - 28.03.2007
                                                  case when isnull(pvi.qt_saldo_pedido_venda,0)>0 and isnull(nsi.cd_nota_saida,0)>0 
                                                  then
                                                    isnull(nsi.cd_nota_saida,0)
                                                  else
                                                    0
                                                  end
	                                         else
					           isNull(nsi.cd_nota_saida,0)
	                                         end )
        and -- Código Produto
		  IsNull(p.cd_mascara_produto,'') like ( case when (IsNull(@ic_tipo_pesq_Produto,'F') = 'C') and  IsNull(@nm_produto,'') <> '' then
	                                             IsNull(@nm_produto,'') + '%'
	                                          else
						 IsNull(p.cd_mascara_produto,'')
	                                          end )
        and -- Fantasia Produto
		  IsNull(p.nm_fantasia_produto,'') like ( case when (IsNull(@ic_tipo_pesq_Produto,'F') = 'F') and  IsNull(@nm_produto,'') <> '' then
	                                             IsNull(@nm_produto,'') + '%'
	                                          else
    						 IsNull(p.nm_fantasia_produto,'')
	                                          end )
        and -- Descrição Produto
		  IsNull(p.nm_produto,'') like ( case when (IsNull(@ic_tipo_pesq_Produto,'F') = 'D') and  IsNull(@nm_produto,'') <> '' then
	                                             IsNull(@nm_produto,'') + '%'
	                                          else
																 IsNull(p.nm_produto,'')
	                                          end )
		  and --Consignação
		  isnull(pv.ic_consignacao_pedido,'N') = (case IsNull(@cd_pedido_venda,0)
		                                             when 0 then
		                                              ( case IsNull(@consignacao,'S')
		                                when 'S' then
		                   isnull(pv.ic_consignacao_pedido,'N')
		                                                  else
		                                                    'N'
		                                                end )
		                                             else
		                                               isnull(pv.ic_consignacao_pedido,'N')
		                                             end)
		  and --Cliente
		  isnull(pv.cd_cliente,0) = (case IsNull(@cd_pedido_venda,0)
		                               when 0 then
		                                 ( case IsNull(@cd_cliente,0)
		                                     when 0 then
		                                       isnull(pv.cd_cliente,0)
		                                     else
		                                       @cd_cliente
		                                   end )
		                               else
		                                 isnull(pv.cd_cliente,0)
		                            end) and
                  isnull(pv.cd_loja,0) = case when @cd_Loja > 0 then @cd_Loja else isnull(pv.cd_loja,0) end 
                  and -- Servico
                  isnull(pvi.cd_servico,0) = case when isnull(@cd_servico,0)=0 then isnull(pvi.cd_servico,0) else @cd_servico end
                  and -- Somente Pedidos de Produto quando Tiver o Serviço Vinculado - Carlos Fernandes
                  isnull(pvi.cd_produto_servico,0) = 0

	  ORDER BY 
             pv.dt_pedido_venda desc, 
	     pv.cd_pedido_venda DESC, 
             pvi.cd_item_pedido_venda


  --Mostra a Tabela Temporária

    select
      *
    from
      #ConsultaPedido
    ORDER BY 
             dt_pedido_venda       desc, 
	     cd_pedido_venda       desc, 
             cd_item_pedido_venda

end

  Else if IsNull(@ic_parametro,1) = 4
  begin
    if ( IsNull(@cd_pedido_venda,0) > 0 ) and 
       exists (Select top 1 'x' from nota_saida_item with (nolock) 
        where cd_pedido_venda = @cd_pedido_venda and IsNull(cd_item_pedido_venda,0) = (case @cd_item_pedido_venda
                                                                                        when 0 then IsNull(cd_item_pedido_venda,0)
                                                                                        else @cd_item_pedido_venda
                                                                                       end))
    begin

      
      SELECT
        ns.cd_identificacao_nota_saida,
        --ns.cd_nota_saida,
        case when isnull(ns.cd_identificacao_nota_saida,0)<>0 
        then
          ns.cd_identificacao_nota_saida
        else ns.cd_nota_saida 
        end                              as cd_nota_saida,     
        ns.dt_nota_saida,
        ns.dt_saida_nota_saida,
        nsi.cd_item_nota_saida,
        nsi.qt_devolucao_item_nota,
        nsi.qt_item_nota_saida,
        ns.dt_cancel_nota_saida,
        ns.nm_mot_cancel_nota_saida      
      FROM
        Nota_Saida_Item nsi with (nolock) inner join
        Nota_Saida ns       with (nolock) ON ns.cd_nota_saida = nsi.cd_nota_saida
      WHERE
        nsi.cd_pedido_venda = @cd_pedido_venda and
        IsNull(nsi.cd_item_pedido_venda,0) = (case @cd_item_pedido_venda
                                                when 0 then IsNull(nsi.cd_item_pedido_venda,0)
                                                else @cd_item_pedido_venda
                                              end)
      ORDER BY 
        1 desc
    end
    else
    SELECT top 1
--      ns.cd_nota_saida,
      ns.cd_identificacao_nota_saida,

        case when isnull(ns.cd_identificacao_nota_saida,0)<>0 
        then
          ns.cd_identificacao_nota_saida
        else ns.cd_nota_saida 
        end                              as cd_nota_saida,     

      ns.dt_nota_saida,
      ns.dt_saida_nota_saida,
      nsi.cd_item_nota_saida,
      nsi.qt_devolucao_item_nota,
      nsi.qt_item_nota_saida,
      ns.dt_cancel_nota_saida,
      ns.nm_mot_cancel_nota_saida      

    FROM
      Nota_Saida_Item nsi with (nolock) inner join
      Nota_Saida ns       with (nolock) ON ns.cd_nota_saida = nsi.cd_nota_saida

    WHERE
      1=2

  end

