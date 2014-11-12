
CREATE PROCEDURE pr_analise_previsao_venda_anual
@cd_vendedor  int      = 0,
@cd_cliente   int      = 0,
@cd_pais      int      = 0 ,
@cd_ano       int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_moeda     int      = 1,
@ic_parametro char(2)  = 'VC' --VC Vendedor Cliente, PC Pais Cliente, P Pais, T Todos	

AS

--select * from parametro_previsao_venda

declare @ic_fator_conversao     char(1)
declare @ic_impostos_previsao   char(1)
declare @ic_demo_custo_previsao char(1)

select
  @ic_fator_conversao   = isnull(ic_conversao_qtd_fator,0),
  @ic_impostos_previsao = isnull(ic_impostos_previsao,0)

from
  Parametro_BI
where
  cd_empresa = dbo.fn_empresa()


	--Dados para Conversão caso não localize o valor na data base do pedido ou nota fiscal

	declare @vl_moeda float

	set @vl_moeda = ( case 	when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  			else dbo.fn_vl_moeda(@cd_moeda) 
							end )

	declare @ic_conv_moeda_previsao char(1)

	select 
 		@ic_conv_moeda_previsao = isnull(ic_conv_moeda_previsao,'N'),
 		@cd_moeda               = isnull(cd_moeda,@cd_moeda),
                @ic_demo_custo_previsao = isnull(ic_demo_custo_previsao,'N')
	from 	
 		parametro_previsao_venda
	where
 		cd_empresa = dbo.fn_empresa()

	--Ano

	if @cd_ano = 0
	begin
          set @cd_ano = year( getdate() )
	end

	--Verifica se a empresa fará a conversão de Moeda

	--Venda Realizado no Ano

	Select 
          IDENTITY(int, 1,1)                   AS 'Posicao',
          p.cd_produto, 
          dbo.fn_mascara_produto(p.cd_produto) As cd_mascara_produto,
          p.nm_fantasia_produto,
          p.nm_produto,
          um.sg_unidade_medida,
          max(p.vl_fator_conversao_produt)    as fator,

         case @ic_parametro
           when 'P' then
             0
           when 'PC' then
             0
          else
             isnull(pv.cd_vendedor,0) 
          end as cd_vendedor,
    
        case @ic_parametro
        when 'P' then
          0
        else
          isnull(pv.cd_cliente,0) 
      end as cd_cliente,

      case @ic_parametro
        when 'P' then
          ''
        else
          c.nm_fantasia_cliente 
      end as nm_fantasia_cliente,
      isnull(c.cd_pais,0)                       as cd_pais,

      --isnull(pv.cd_vendedor,0) as cd_vendedor,
      --isnull(pv.cd_cliente,0) as cd_cliente,
      --isnull(c.cd_pais,0) as cd_pais,
      --c.nm_fantasia_cliente,     

     -- Quantidade Realizada

     sum(isnull(pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end,0)) as 'qt_realizado',
 
     --Valores de Venda

      sum(isnull(	
       case @ic_impostos_previsao 
 			when  'N' then  
  			     round((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido),2)  				
			else
                 round((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         			- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         			- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         			- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0),2) /*ICMS*/
         end,0)) 
		as 'vl_realizado',

     --Valores de Venda em Outra Moeda

      sum(isnull((
       case @ic_impostos_previsao 
 			when  'N' then  0.00
         else
                 round((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         			- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         			- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         			- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0),2)
         end )
        / (case when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 
         then dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
        else @vl_moeda end ),0))                            as 'vl_Realizado_Moeda'
	into
  		#VendaReal
	from
     Pedido_Venda pv
     inner join Pedido_Venda_Item pvi      on pvi.cd_pedido_venda   = pv.cd_pedido_venda
     left outer join  Produto p            on p.cd_produto          = pvi.cd_produto
     left outer join Unidade_Medida um     on um.cd_unidade_medida  = p.cd_unidade_medida
     left outer join Cliente c             on c.cd_cliente          = pv.cd_cliente
	where 
   		isnull(pv.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
   		isnull(pv.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(pv.cd_cliente,0)  else @cd_cliente end and
   		isnull(c.cd_pais,0)      = case when @cd_pais     = 0 then isnull(c.cd_pais,0)     else @cd_pais end and
       	pvi.dt_cancelamento_item is null 
       	and year(pv.dt_pedido_venda) = @cd_ano 
        and pv.dt_pedido_venda <= @dt_final 
	Group By 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,
      case @ic_parametro
        when 'P' then
          0
        when 'PC' then
          0
        else
          isnull(pv.cd_vendedor,0) 
      end,
      case @ic_parametro
        when 'P' then
          0
        else
          isnull(pv.cd_cliente,0) 
      end,
      case @ic_parametro
        when 'P' then
          ''
        else
          c.nm_fantasia_cliente 
      end,
      isnull(c.cd_pais,0)
 
     --c.nm_fantasia_cliente    ,
      --isnull(pv.cd_vendedor,0),
      --isnull(pv.cd_cliente,0),
      --isnull(c.cd_pais,0)
   
-- Select * from #VendaReal
--Faturamento

	Select 
          p.cd_produto, 
          case @ic_parametro
          when 'P' then
            0
          when 'PC' then
            0
          else
            isnull(ns.cd_vendedor,0) 
          end                           as cd_vendedor,
      case @ic_parametro
        when 'P' then
          0
        else
          isnull(ns.cd_cliente,0) 
      end as cd_cliente,
      case @ic_parametro
        when 'P' then
          ''
        else
          c.nm_fantasia_cliente 
      end as nm_fantasia_cliente,
      isnull(c.cd_pais,0) as cd_pais,

      --isnull(ns.cd_vendedor,0) as cd_vendedor,
      --isnull(ns.cd_cliente,0) as cd_cliente,
      --isnull(c.cd_pais,0) as cd_pais,

      --Quantidade do Faturamento

      sum(isnull(nsi.qt_item_nota_saida,0))                           as 'qt_faturado',
 
     --Valores do Faturamento

      sum( round(isnull((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)),0),2)
         ) as 'vl_faturado',

     --Valores do Faturamento Convertido em Outra Moeda
 
      sum(round(isnull(((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
						 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
						 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)))
						/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 
                  		  then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
                       	  else @vl_moeda end),0),2)

          )                        as 'vl_faturado_moeda',
        max(pc.vl_custo_produto)   as vl_custo_produto,
        max(pc.vl_custo_previsto_produto) as vl_custo_moeda

	into
  		#NotaReal
	from
     Nota_Saida ns
     inner join Nota_Saida_Item nsi     on ns.cd_nota_saida       = nsi.cd_nota_saida
     inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
     left outer join Produto p          on p.cd_produto           = nsi.cd_produto
     left outer join Unidade_Medida um  on um.cd_unidade_medida   = p.cd_unidade_medida
     left outer join Cliente c          on c.cd_cliente           = ns.cd_cliente
     left outer join Produto_Custo pc   on pc.cd_produto          = p.cd_produto     

--select * from produto_custo

	where 
   	isnull(ns.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(ns.cd_vendedor,0) else @cd_vendedor end and
   	isnull(ns.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(ns.cd_cliente,0)  else @cd_cliente end and
   	isnull(c.cd_pais,0)      = case when @cd_pais     = 0 then isnull(c.cd_pais,0)      else @cd_pais end and
       ns.cd_nota_saida       = nsi.cd_nota_saida and
       year(ns.dt_nota_saida) = @cd_ano  and
       ns.dt_nota_saida <= @dt_final and
       isnull(opf.ic_comercial_operacao,'N')='S'
--       and ns.dt_nota_saida between @dt_inicial and @dt_final 
       
       and ns.dt_cancel_nota_saida is null
       and ns.cd_status_nota <> 7               --Nota Cancelada não Entra

--select * from status_nota
--select * from nota_saida

Group By 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,
      case @ic_parametro
        when 'P' then
          0
        when 'PC' then
          0
        else
          isnull(ns.cd_vendedor,0) 
      end,
      case @ic_parametro
        when 'P' then
          0
        else
          isnull(ns.cd_cliente,0) 
      end,
      case @ic_parametro
        when 'P' then
          ''
        else
          c.nm_fantasia_cliente 
      end,
      isnull(c.cd_pais,0)

      --isnull(ns.cd_vendedor,0),
      --isnull(ns.cd_cliente,0),
      --isnull(c.cd_pais,0),
      --c.nm_fantasia_cliente   


--Dados da Quantidades Previstas Digitada pelos Vendedores

SELECT
   pvc.cd_previsao_venda,

   case
    when isnull(pv.cd_produto,0) > 0        then p.nm_fantasia_produto
    when isnull(pv.cd_produto_desenv,0) > 0 then pd.nm_fantasia_produto
   end                                                          as nm_produto_previsao_mensal,

  --Quantidades

 (isnull(pvc.qt_jan_previsao,0) +
  isnull(pvc.qt_fev_previsao,0) +
  isnull(pvc.qt_mar_previsao,0) +
  isnull(pvc.qt_abr_previsao,0) +
  isnull(pvc.qt_mai_previsao,0) +
  isnull(pvc.qt_jun_previsao,0) +
  isnull(pvc.qt_jul_previsao,0) +
  isnull(pvc.qt_ago_previsao,0) +
  isnull(pvc.qt_set_previsao,0) +
  isnull(pvc.qt_out_previsao,0) +
  isnull(pvc.qt_nov_previsao,0) +
  isnull(pvc.qt_dez_previsao,0))                                as qt_previsao,

  --Valores Unitários Previstos

 (isnull(pvc.vl_jan_previsao,0) + 
  isnull(pvc.vl_fev_previsao,0) + 
  isnull(pvc.vl_mar_previsao,0) + 
  isnull(pvc.vl_abr_previsao,0) + 
  isnull(pvc.vl_mai_previsao,0) +  
  isnull(pvc.vl_jun_previsao,0) + 
  isnull(pvc.vl_jul_previsao,0) + 
  isnull(pvc.vl_ago_previsao,0) + 
  isnull(pvc.vl_set_previsao,0) + 
  isnull(pvc.vl_out_previsao,0) + 
  isnull(pvc.vl_nov_previsao,0) + 
  isnull(pvc.vl_dez_previsao,0) )                               as vl_previsao,
  
  
  (( SELECT SUM(
      isnull(a.qt_jan_previsao,0) +
      isnull(a.qt_fev_previsao,0) +
      isnull(a.qt_mar_previsao,0) +
      isnull(a.qt_abr_previsao,0) +
      isnull(a.qt_mai_previsao,0) +
      isnull(a.qt_jun_previsao,0) +
      isnull(a.qt_jul_previsao,0) +
      isnull(a.qt_ago_previsao,0) +
      isnull(a.qt_set_previsao,0) +
      isnull(a.qt_out_previsao,0) +
      isnull(a.qt_nov_previsao,0) +
      isnull(a.qt_dez_previsao,0) )  
     FROM 
        Previsao_venda_Composicao a
     WHERE
        a.cd_previsao_venda = pv.cd_previsao_venda ) /
     ( SELECT SUM(
      isnull(b.qt_jan_previsao,0) +
      isnull(b.qt_fev_previsao,0) +
      isnull(b.qt_mar_previsao,0) +
      isnull(b.qt_abr_previsao,0) +
      isnull(b.qt_mai_previsao,0) +
      isnull(b.qt_jun_previsao,0) +
      isnull(b.qt_jul_previsao,0) +
      isnull(b.qt_ago_previsao,0) +
      isnull(b.qt_set_previsao,0) +
      isnull(b.qt_out_previsao,0) +
      isnull(b.qt_nov_previsao,0) +
      isnull(b.qt_dez_previsao,0)
     )
       FROM 
         Previsao_venda_Composicao b
       where 
         b.cd_previsao_venda in (select 
                                   cd_previsao_venda 
                                 from 
                                   Previsao_Venda c 
                                 where 
   											isnull(c.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(c.cd_vendedor,0) else @cd_vendedor end and
   											isnull(c.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(c.cd_cliente,0)  else @cd_cliente end and
   											isnull(c.cd_pais,0)     = case when @cd_pais     = 0 then isnull(c.cd_pais,0)     else @cd_pais end and
   											1  =
   												Case @ic_parametro
   													when 'VC' then
   														case when isnull(c.cd_vendedor,0) > 0 and isnull(c.cd_cliente,0) > 0 then	
   															1
   														else
   															0
   														end
   													when 'PC' then
   														case when isnull(c.cd_pais,0) > 0 and isnull(c.cd_cliente,0) > 0 and isnull(c.cd_vendedor,0) = 0 then	
   															1
   														else
   															0
   														end
   													when 'P' then
   														case when isnull(c.cd_pais,0) > 0 and isnull(c.cd_vendedor,0) = 0 and isnull(c.cd_cliente,0) = 0 then	
   															1
   														else
   															0
   														end
   													else 
   														1
   												end
											)
		)
	) * 100 as '(%)',
  vr.qt_realizado,
  case when @ic_conv_moeda_previsao='N' then 
			isnull(vr.vl_Realizado,0)    
		else 
			isnull(vr.vl_Realizado_moeda,0)  end as vl_Realizado,
  nr.qt_faturado,
  case when @ic_conv_moeda_previsao='N' then 
			isnull(nr.vl_faturado,0)    
		else 
			isnull(nr.vl_faturado_moeda,0)  end as vl_faturado,

  pvc.cd_usuario,
  pvc.dt_usuario,
  pv.cd_vendedor,
  pv.cd_cliente,
  c.nm_fantasia_cliente,
  v.nm_vendedor,
  Pais.nm_pais,
  nr.vl_custo_produto,
  nr.vl_custo_moeda
  --nr.vl_custo_previso_produto as vl_custo_moeda
into 
  #AuxPrevisaoAnual
   
FROM
  Previsao_Venda_Composicao pvc 
  LEFT JOIN   Previsao_Venda pv              ON pvc.cd_previsao_venda = pv.cd_previsao_venda
  LEFT OUTER JOIN vendedor   v               ON v.cd_vendedor         = pv.cd_vendedor   
  LEFT OUTER JOIN cliente c                  ON c.cd_cliente          = pv.cd_cliente
  LEFT OUTER JOIN Pais                       ON Pais.cd_pais          = pv.cd_pais 
  LEFT OUTER JOIN Produto p                  ON pv.cd_produto         = p.cd_produto
  LEFT OUTER JOIN Produto_Desenvolvimento pd ON pv.cd_produto_desenv  = pd.cd_produto_desenv
  LEFT OUTER JOIN #VendaReal vr              ON vr.cd_produto         = pv.cd_produto  and
                                                1 = 
																Case @ic_parametro
       		                                       when 'VC' then
                                                        case when isnull(vr.cd_vendedor,0) = isnull(pv.cd_vendedor,0) and isnull(vr.cd_cliente,0)  = isnull(pv.cd_cliente,0) then
																				 1
																			    else			
                                                             0 
                                                        end
       		                                       when 'PC' then
                                                        case when isnull(vr.cd_pais,0) = isnull(pv.cd_pais,0) and isnull(vr.cd_cliente,0)  = isnull(pv.cd_cliente,0) then
																				 1
																			    else			
                                                             0 
                                                        end
       		                                       when 'P' then
                                                        case when isnull(vr.cd_pais,0) = isnull(pv.cd_pais,0) then
																				 1
																			    else			
                                                             0 
                                                        end
																	else
                                                      1
                                                 end   	
  LEFT OUTER JOIN #NotaReal nr               ON nr.cd_produto         = pv.cd_produto  and
                                                1 = 
																Case @ic_parametro
       		                                       when 'VC' then
                                                        case when isnull(nr.cd_vendedor,0) = isnull(pv.cd_vendedor,0) and isnull(nr.cd_cliente,0)  = isnull(pv.cd_cliente,0) then
																				 1
																			    else			
                                                             0 
                                                        end
       		                                       when 'PC' then
                                                        case when isnull(nr.cd_pais,0) = isnull(pv.cd_pais,0) and isnull(nr.cd_cliente,0)  = isnull(pv.cd_cliente,0) then
																				 1
																			    else			
                                                             0 
                                                        end
       		                                       when 'P' then
                                                        case when isnull(nr.cd_pais,0) = isnull(pv.cd_pais,0) then
																				 1
																			    else			
                                                             0 
                                                        end
																	else
                                                      1
                                                 end   
WHERE
   -- year(pv.dt_inicio_previsao_venda) = @cd_ano  and
   
   isnull(pv.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
   isnull(pv.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(pv.cd_cliente,0)  else @cd_cliente end and
   isnull(pv.cd_pais,0)     = case when @cd_pais     = 0 then isnull(pv.cd_pais,0)     else @cd_pais end and
   1  =
	Case @ic_parametro
		when 'VC' then
			case when isnull(pv.cd_vendedor,0) > 0 and isnull(pv.cd_cliente,0) > 0 then	
				1
			else
				0
			end
		when 'PC' then
			case when isnull(pv.cd_pais,0) > 0 and isnull(pv.cd_cliente,0) > 0 and isnull(pv.cd_vendedor,0) = 0 then	
				1
			else
				0
			end
		when 'P' then
			case when isnull(pv.cd_pais,0) > 0 and isnull(pv.cd_vendedor,0) = 0 and isnull(pv.cd_cliente,0) = 0 then	
				1
			else
				0
			end
		else 
			1
	end



--Mostra a tabela temporária

select
  *,
  pc_qtd_realizado = case when qt_previsao>0 then (qt_realizado/qt_previsao)*100 else 0.00 end,
  pc_qtd_faturado  = case when qt_previsao>0 then (qt_faturado /qt_previsao)*100 else 0.00 end,
  pc_vl_realizado  = case when vl_previsao>0 then (vl_realizado/vl_previsao)*100 else 0.00 end,
  pc_vl_faturado   = case when vl_previsao>0 then (vl_faturado /vl_previsao)*100 else 0.00 end,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 then 
       vl_previsao/(vl_custo_produto*qt_previsao)
  else
    case when vl_custo_moeda>0 then
       vl_previsao/(vl_custo_moeda*qt_previsao)
    else
       0.00 
  end end as vl_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 then 
       vl_faturado/(vl_custo_produto*qt_faturado)
  else
     case when vl_custo_moeda>0 then
       vl_faturado/(vl_custo_moeda*qt_faturado) 
  else
     0.00 end
  end as vl_custo_real

from
  #AuxPrevisaoAnual
where 
  isnull(nm_produto_previsao_mensal,'') <> '' 
order by
  nm_fantasia_cliente,
  cd_usuario,
  dt_usuario,
  cd_vendedor,
  cd_cliente

