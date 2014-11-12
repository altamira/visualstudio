
CREATE PROCEDURE pr_resumo_previsao_venda_vendedor
@dt_inicial   datetime,
@dt_final     datetime,
@cd_vendedor  int = 0,
@cd_moeda     int = 1,
@cd_pais      int = 0,
@ic_parametro Char(1) = 'V'
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
--Vendedor
-------------------------------------------------------------------------------
if @ic_parametro <> 'P'
Begin
  select
     v.cd_vendedor,
     v.nm_fantasia_vendedor                   as Vendedor, 
     sum(isnull(pv.qt_programado_previsao,0)) as Programado,
     sum(isnull(pv.qt_potencial_previsao,0))  as Potencial,
     
     Realizado = ( select sum(isnull(ip.qt_item_pedido_venda,0))
                   from Pedido_Venda_Item ip
                   inner join Pedido_Venda p on ip.cd_pedido_venda = p.cd_pedido_venda 
                   where 
                      p.cd_vendedor      = v.cd_vendedor  and
                      ip.dt_cancelamento_item is null    and
                      p.dt_pedido_venda between @dt_inicial and @dt_final),
     Faturado = ( select sum(isnull(nsi.qt_item_nota_saida,0))
                   from Nota_Saida_Item nsi
                   inner join Nota_Saida ns on ns.cd_nota_saida       = nsi.cd_nota_saida
     					 inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
                   where 
                      ns.cd_vendedor      = v.cd_vendedor  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S'),

     sum(isnull(pv.qt_programado_previsao,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorProgramado,
     sum(isnull(pv.qt_potencial_previsao ,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorPotencial,



     ValorRealizado = 
  					  (case when @ic_conv_moeda_previsao='S' then 
									( select 
                   					sum((ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,p.dt_pedido_venda)>0 then 
											                                     										  dbo.fn_vl_moeda_periodo(@cd_moeda,p.dt_pedido_venda) 
                                    																				else @vl_moeda 
                               																				 end ))
                 				  from Pedido_Venda p 
                   					 left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                			     where 
                      			    p.cd_vendedor      = v.cd_vendedor  and
                                  ip.dt_cancelamento_item is null    and
                                  p.dt_pedido_venda between @dt_inicial and @dt_final)   
				    else  
								 ( select 
                   				 sum(ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)
                 				from Pedido_Venda p 
                   				 left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                				where 
                      			    p.cd_vendedor      = v.cd_vendedor  and
                                  ip.dt_cancelamento_item is null    and
                                  p.dt_pedido_venda between @dt_inicial and @dt_final)

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
                      ns.cd_vendedor      = v.cd_vendedor  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S')
				    else  
						 ( select sum(isnull(nsi.qt_item_nota_saida,0) * isNull(nsi.vl_unitario_item_nota,0))  
                     from Nota_Saida_Item nsi
                          inner join Nota_Saida ns on ns.cd_nota_saida       = nsi.cd_nota_saida
     					 		  inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
                   	where 
                      ns.cd_vendedor      = v.cd_vendedor  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S')
				    end), 



     --sum(isnull(pvi.qt_item_pedido_venda ,0) * isnull(pvi.vl_unitario_item_pedido,0)) As ValorRealizado,
     max(pvc.vl_unitario_previsao)            as Unitario,
     --max(pvi.vl_unitario_item_pedido)         as Unitario_Item_Pedido
     cast( 0 as float )                       as Unitario_Item_Pedido
  into
    #AuxPrevVendedor
  from
    Previsao_Venda pv
    left outer join Previsao_Venda_Composicao pvc on pvc.cd_previsao_venda = pv.cd_previsao_venda
    left outer join Vendedor v                    on v.cd_vendedor = pv.cd_vendedor

  where
    isnull(pv.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
    pv.dt_inicio_previsao_venda between @dt_inicial and @dt_final
  group by
    v.cd_vendedor,
    v.nm_fantasia_vendedor

  select
    *,
    PercAtingido    = (case when Programado      = 0 then 1 else Realizado      / Programado      end)*100,
    PerVlrRealizado = (case when ValorProgramado = 0 then 1 else ValorRealizado / ValorProgramado end)*100
  from
    #AuxPrevVendedor 
  order by
    Programado desc
End
else
begin
  select
     Pais.cd_pais as cd_vendedor,
     Pais.nm_pais as Vendedor, 
     sum(isnull(pv.qt_programado_previsao,0)) as Programado,
     sum(isnull(pv.qt_potencial_previsao,0))  as Potencial,
     
     Realizado = ( select sum(isnull(ip.qt_item_pedido_venda,0))
                   from Pedido_Venda_Item ip
                   inner join Pedido_Venda p on ip.cd_pedido_venda = p.cd_pedido_venda 
                   left join Cliente c on (c.cd_cliente = p.cd_cliente)
                   where 
                      c.cd_pais      = pais.cd_pais  and
                      ip.dt_cancelamento_item is null    and
                      p.dt_pedido_venda between @dt_inicial and @dt_final),
     Faturado = ( select sum(isnull(nsi.qt_item_nota_saida,0))
                   from Nota_Saida_Item nsi
                   inner join Nota_Saida ns on ns.cd_nota_saida   = nsi.cd_nota_saida
     					 inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal 
                   left join Cliente c on (c.cd_cliente = ns.cd_cliente)
                   where 
                      c.cd_pais      = pais.cd_pais  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S'),

     sum(isnull(pv.qt_programado_previsao,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorProgramado,
     sum(isnull(pv.qt_potencial_previsao ,0) * isnull(pvc.vl_unitario_previsao   ,0)) as ValorPotencial,



     ValorRealizado = 
  					  (case when @ic_conv_moeda_previsao='S' then 
									( select 
                   					sum((ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,p.dt_pedido_venda)>0 then 
											                                     										  dbo.fn_vl_moeda_periodo(@cd_moeda,p.dt_pedido_venda) 
                                    																				else @vl_moeda 
                               																				 end ))
                 				  from Pedido_Venda p 
                   					 left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                                  left join Cliente c on (c.cd_cliente = p.cd_cliente)
                			     where 
                                  c.cd_pais      = pais.cd_pais  and
                                  ip.dt_cancelamento_item is null    and
                                  p.dt_pedido_venda between @dt_inicial and @dt_final)   
				    else  
								 ( select 
                   				 sum(ip.qt_item_pedido_venda * ip.vl_unitario_item_pedido)
                 				from Pedido_Venda p 
                   				 left outer join pedido_venda_item ip on ip.cd_pedido_venda = p.cd_pedido_venda
                               left join Cliente c on (c.cd_cliente = p.cd_cliente)
                				where 
                                   c.cd_pais      = pais.cd_pais  and
                                  ip.dt_cancelamento_item is null    and
                                  p.dt_pedido_venda between @dt_inicial and @dt_final)

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
                          left join Cliente c on (c.cd_cliente = ns.cd_cliente)
                   	where 
                      c.cd_pais      = pais.cd_pais  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S')
				    else  
						 ( select sum(isnull(nsi.qt_item_nota_saida,0) * isNull(nsi.vl_unitario_item_nota,0))  
                     from Nota_Saida_Item nsi
                          inner join Nota_Saida ns on ns.cd_nota_saida       = nsi.cd_nota_saida
     					 		  inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
                          left join Cliente c on (c.cd_cliente = ns.cd_cliente)
                   	where 
                      c.cd_pais      = pais.cd_pais  and
                      nsi.dt_cancel_item_nota_saida is null    and
                      ns.dt_nota_saida between @dt_inicial and @dt_final and
       					 isnull(opf.ic_comercial_operacao,'N')='S')
				    end), 



     --sum(isnull(pvi.qt_item_pedido_venda ,0) * isnull(pvi.vl_unitario_item_pedido,0)) As ValorRealizado,
     max(pvc.vl_unitario_previsao)            as Unitario,
     --max(pvi.vl_unitario_item_pedido)         as Unitario_Item_Pedido
     cast( 0 as float )                       as Unitario_Item_Pedido
  into
    #AuxPrevPais
  from
    Previsao_Venda pv
    left outer join Previsao_Venda_Composicao pvc on pvc.cd_previsao_venda = pv.cd_previsao_venda
    left join Pais on (pais.cd_pais = pv.cd_pais)
  where
    isnull(pv.cd_pais,0)     = case when @cd_pais     = 0 then isnull(pv.cd_pais,0)     else @cd_pais end and
    pv.dt_inicio_previsao_venda between @dt_inicial and @dt_final
  group by
    Pais.cd_pais,
    Pais.nm_pais

  select
    *,
    PercAtingido    = (case when Programado      = 0 then 1 else Realizado      / Programado      end)*100,
    PerVlrRealizado = (case when ValorProgramado = 0 then 1 else ValorRealizado / ValorProgramado end)*100
  from
    #AuxPrevPais
  order by
    Programado desc
end
