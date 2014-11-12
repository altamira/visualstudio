
CREATE PROCEDURE pr_resumo_previsao_venda_produto
@dt_inicial   datetime,
@dt_final     datetime,
@cd_produto   int = 0,
@cd_moeda     int = 1,
@cd_pais      int = 0,
@cd_cliente   int = 0
as

--Dados para Conversão caso não localize o valor na data base do pedido ou nota fiscal

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


--Verifica se a empresa fará a conversão de Moeda

declare @ic_conv_moeda_previsao char(1)

select 
 	@ic_conv_moeda_previsao = isnull(ic_conv_moeda_previsao,'N'),
 	@cd_moeda               = isnull(cd_moeda,@cd_moeda)
from 
 	parametro_previsao_venda
where
 	cd_empresa = dbo.fn_empresa()


-------------------------------------------------------------------------------
--Produto
-------------------------------------------------------------------------------
  select
     p.cd_produto,                             
     p.cd_mascara_produto                     as Codigo,
     p.nm_fantasia_produto                    as Produto,
     max(p.nm_produto)                        as Descricao,
     max(um.sg_unidade_medida)                as Sigla,
     sum(isnull(pv.qt_programado_previsao,0)) as Programado,
     sum(isnull(pv.qt_potencial_previsao,0))  as Potencial,
     --     sum(isnull(pvi.qt_item_pedido_venda ,0)) as Realizado,
     --   cast( 0 as float )                       as Realizado,
     --   sum(isnull(pvi.qt_item_pedido_venda ,0) - isnull(pv.qt_programado_previsao  ,0)) as Realizado,
     Realizado = ( select sum(isnull(ip.qt_item_pedido_venda,0))
                   from Pedido_Venda_Item ip
                   inner join Pedido_Venda pe on ip.cd_pedido_venda = pe.cd_pedido_venda 
                   where 
                      ip.cd_produto      = p.cd_produto  and
                      ip.dt_cancelamento_item is null    and
                      pe.dt_pedido_venda between @dt_inicial and @dt_final),

     Faturado = ( select sum(isnull(nsi.qt_item_nota_saida,0))
                   from Nota_Saida_Item nsi
                   inner join Nota_Saida ns on ns.cd_nota_saida       = nsi.cd_nota_saida
     					 inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
                   where 
                      nsi.cd_produto      = p.cd_produto  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S'),

     sum(isnull(pv.qt_programado_previsao,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorProgramado,
     sum(isnull(pv.qt_potencial_previsao ,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorPotencial,

     ValorRealizado = 
  					  (case when @ic_conv_moeda_previsao='S' then 
									( select 
                   					sum((ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,pe.dt_pedido_venda)>0 then 
											                                     										  dbo.fn_vl_moeda_periodo(@cd_moeda,pe.dt_pedido_venda) 
                                    																				else @vl_moeda 
                               																				 end ))
                 				  from Pedido_Venda pe 
                   					 left outer join pedido_venda_item ip on ip.cd_pedido_venda = pe.cd_pedido_venda
                			     where 
                      				ip.cd_produto      = p.cd_produto  and
                      			   ip.dt_cancelamento_item is null    and
                      				pe.dt_pedido_venda between @dt_inicial and @dt_final)
				    else  
								 ( select 
                   				 sum(ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)
                 				from Pedido_Venda pe 
                   				 left outer join pedido_venda_item ip on ip.cd_pedido_venda = pe.cd_pedido_venda
                				where 
                               ip.cd_produto      = p.cd_produto  and
                               ip.dt_cancelamento_item is null    and
                               pe.dt_pedido_venda between @dt_inicial and @dt_final)

				    end), 



     ValorFaturado = 
  					  (case when @ic_conv_moeda_previsao='S' then 
						 ( select sum((isnull(nsi.qt_item_nota_saida,0) * isNull(nsi.vl_unitario_item_nota,0))/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
											                                     										  dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
                                    																				else @vl_moeda 
                               																				 end ))  
                     from Nota_Saida_Item nsi
                          inner join Nota_Saida ns on ns.cd_nota_saida       = nsi.cd_nota_saida
     					 		  inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
                   	where 
                      nsi.cd_produto      = p.cd_produto  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S')
				    else  
						 ( select sum(isnull(nsi.qt_item_nota_saida,0) * isNull(nsi.vl_unitario_item_nota,0))  
                     from Nota_Saida_Item nsi
                          inner join Nota_Saida ns on ns.cd_nota_saida       = nsi.cd_nota_saida
     					 		  inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
                   	where 
                      nsi.cd_produto      = p.cd_produto  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S')
				    end), 


     --sum(isnull(pvi.qt_item_pedido_venda ,0) * isnull(pvi.vl_unitario_item_pedido,0)) As ValorRealizado,
     max(pvc.vl_unitario_previsao)            as Unitario,
     --max(pvi.vl_unitario_item_pedido)         as Unitario_Item_Pedido
     cast(0 as float )                        as Unitario_Item_Pedido
  into
    #AuxPrevProduto
  from
    Previsao_Venda pv
    left outer join Previsao_Venda_Composicao pvc       on pvc.cd_previsao_venda = pv.cd_previsao_venda
    left outer join Produto p         		        on p.cd_produto = pv.cd_produto
    left outer join Unidade_Medida um 		        on um.cd_unidade_medida = p.cd_unidade_medida
  where
    isnull(pv.cd_cliente,0) = case when isnull(@cd_cliente,0) = 0 then isnull(pv.cd_cliente,0) else isnull(@cd_cliente,0) end and
    isnull(pv.cd_pais,0) = case when isnull(@cd_pais,0) = 0 then isnull(pv.cd_pais,0) else isnull(@cd_pais,0) end and
    ((@cd_produto = 0) or (p.cd_produto = @cd_produto)) and
    pv.dt_inicio_previsao_venda between @dt_inicial and @dt_final
  group by
    p.cd_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto
    

  select
    *,
    --    ValorRealizado  = (Realizado * Unitario_Item_Pedido),
    PercAtingido    = (case when Programado      = 0 then 1 else Realizado      / Programado      end)*100,
    PerVlrRealizado = (case when ValorProgramado = 0 then 1 else ValorRealizado / ValorProgramado end)*100
  from
    #AuxPrevProduto
  order by
    Programado desc

