
create procedure pr_previsao_pagamento_importacao
@dt_inicial datetime, 
@dt_final datetime,
@ic_parametro int
as

  declare @cd_pis int,    
          @cd_cofins int,    
          @pc_pis money,    
          @pc_cofins money

--Pegando última cotação das moedas
select
  m.cd_moeda,
  m.sg_moeda,
  cast((select top 1 vl_moeda from Valor_Moeda where cd_moeda = m.cd_moeda order by dt_moeda desc) as decimal(15,6)) as vl_moeda
into
  #Moeda
from
  Moeda m


 --Impostos que serão retidos na fonte    
  --PIS    
  Select top 1 @cd_pis = cd_imposto from imposto where sg_imposto = 'PIS' order by cd_imposto    
  --COFINS    
  Select top 1 @cd_cofins = cd_imposto from imposto where sg_imposto = 'COFINS' order by cd_imposto    
 
   --PIS    
  Select     
    top 1    
    @pc_pis = (IsNull(pc_imposto,0)/100)    
  from     
    Imposto_Aliquota     
  where     
    cd_imposto = @cd_pis and    
    dt_imposto_aliquota <= getdate()    
  order by     
    dt_imposto_aliquota desc    
    
  --COFINS    
  Select     
    top 1    
    @pc_cofins = (IsNull(pc_imposto,0)/100)    
  from     
    Imposto_Aliquota     
  where     
    cd_imposto = @cd_cofins and    
    dt_imposto_aliquota <= getdate()    
  order by     
    dt_imposto_aliquota desc  
 

if @ic_parametro = 1 
begin
select --PAGAMENTO DE IMPOSTOS 
  p.cd_pedido_importacao,
  pais.nm_pais 			as 'Procedencia',
  f.nm_fantasia_fornecedor 	as 'Nome_Fornecedor',
  p.cd_identificacao_pedido 	as 'Ident_Pedido',
  p.dt_pedido_importacao 	as 'Data_Pedido',
  tf.nm_tipo_frete 		as 'Embarque',
 
  case When isnull(i.cd_invoice,0) = 0 then 
    p.dt_prev_emb_ped_imp
  else 
    i.dt_invoice
  end 				as 'Data',

  case When isnull(i.cd_invoice,0) = 0 then 
    Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
  else 
    Sum(ii.qt_invoice_item * ii.vl_invoice_item)
  end 				as 'FOB',

  mo.sg_moeda 			as 'Moeda',

  max(mo.vl_moeda)		as 'Cotacao',

  case When isnull(i.cd_invoice,0) = 0 then 
    Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
  else 
    Sum(ii.qt_invoice_item * ii.vl_invoice_item)
  end 				
  * 
  max(mo.vl_moeda)		as 'FobReais',
 
  isnull(i.nm_invoice,'')	as 'Invoice',

   right('0' + cast(Month(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2)
   + '/' + 
   right(cast(year(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2)		as 'Vencimento',

-- início cálculo impostos 
  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    max(ti.pc_ii_tipo_importacao) / 100
    *
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item)
    end 				
  else
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
    end
  end 				
  * 
  max(mo.vl_moeda)		as 'II',


  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    0.00
  else

    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
           cf.pc_ipi_classificacao / 100) 

    else 
      Sum(((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
           cf.pc_ipi_classificacao / 100)
    end
  end 
  * 
  max(mo.vl_moeda)		as 'IPI',


  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  

    (max(ti.pc_ii_tipo_importacao) / 100
    *
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item)
    end 	
    +
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item)
    end)
    *
    max(ti.pc_icms_tipo_importacao) / 100

  else

    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
           cf.pc_ipi_classificacao / 100)
          +
          (pii.qt_item_ped_imp * pii.vl_item_ped_imp)
          +
          (pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100))
          *
          case when isnull(cfe.pc_redu_icms_class_fiscal,0) = 0 then
            cfe.pc_icms_classif_fiscal / 100
          else
            cfe.pc_icms_classif_fiscal * isnull(cfe.pc_redu_icms_class_fiscal,1) / 100 /100
          end )       
    else 
      Sum(((((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
           cf.pc_ipi_classificacao / 100)
          +
          (ii.qt_invoice_item * ii.vl_invoice_item)
          +
          (ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100))
          *
          case when isnull(cfe.pc_redu_icms_class_fiscal,0) = 0 then
            cfe.pc_icms_classif_fiscal / 100
          else
            cfe.pc_icms_classif_fiscal * isnull(cfe.pc_redu_icms_class_fiscal,1) / 100 /100
          end )
    end
  end 
  * 
  max(mo.vl_moeda)		as 'ICMS',

  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    0.00
  else

    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
@pc_pis  	   
)
    else 
      Sum(((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
  	   @pc_pis) 
    end
  end 
  * 
  max(mo.vl_moeda)		as 'PIS',

  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    0.00
  else
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
  	   @pc_cofins)

    else 
      Sum(((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
  	   @pc_cofins)
    end
  end 
  * 
  max(mo.vl_moeda)		as 'COFINS',

--   tf.ic_courier_importacao,
-- fim Cálculo Impostos
   dateadd(d,isnull(cpp.qt_dia_cond_parcela_pgto,0),
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_prev_emb_ped_imp
   else
     i.dt_invoice
   end) as 'PagtoFornecedorVencto',
  case When isnull(i.cd_invoice,0) = 0 then 
    Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
  else 
    Sum(ii.qt_invoice_item * ii.vl_invoice_item)
  end 				
  * 
  max(mo.vl_moeda)		as 'TotalReais',

  ' ' as 'ic_courier_importacao'
  
into #tmp_impostos

from 
  Pedido_Importacao 	 p    									left outer join 
  Pedido_Importacao_Item pii  on p.cd_pedido_importacao 	= pii.cd_pedido_importacao 	left outer join 
  Invoice_Item 		 ii   on pii.cd_pedido_importacao 	= ii.cd_pedido_importacao	
                             and pii.cd_item_ped_imp		= ii.cd_item_ped_imp		left outer join 

  Invoice 		 i    on ii.cd_invoice 			= i.cd_invoice			left outer join 
  Produto 		 pro  on pro.cd_produto 	       	= pii.cd_produto 		left outer join 
  Pais 			 Pais on p.cd_pais_procedencia 		= pais.cd_pais			left outer join 
  Fornecedor 		 f    on p.cd_fornecedor        	= f.cd_fornecedor  		left outer join 
  Tipo_Importacao 	 ti   on p.cd_tipo_importacao 		= ti.cd_tipo_importacao 	left outer join 
  Termo_Comercial 	 tc   on p.cd_termo_comercial 		= tc.cd_termo_comercial         left outer join 
  #Moeda 		 mo   on mo.cd_moeda 			= case When isnull(i.cd_invoice,0) = 0 then 
                                                		    p.cd_moeda
		                                                  else 
                    			                            i.cd_moeda
                                        			  end 				left outer join 
  Tipo_Frete 		 tf   on tf.cd_tipo_frete 		= case When isnull(i.cd_invoice,0) = 0 then 
                                                     		    p.cd_tipo_frete
		                                                  else 
                		                                    i.cd_tipo_frete
                                		                  end				left outer join 
  Produto_Fiscal	 pf  on pro.cd_produto 		= pf.cd_produto				left outer join
  Classificacao_Fiscal 	 cf  on cf.cd_classificacao_fiscal      = pf.cd_classificacao_fiscal    left outer join 
  EGISADmin.dbo.Empresa	 e   on e.cd_empresa = dbo.fn_empresa()					left outer join
  Classificacao_Fiscal_Estado cfe on cfe.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
                                 and cfe.cd_estado		= e.cd_estado			left outer join
  Condicao_Pagamento	 cp  on cp.cd_condicao_pagamento		= case When isnull(i.cd_invoice,0) = 0 then 
                                                     		    p.cd_condicao_pagamento
		                                                  else 
                		                                    i.cd_condicao_pagamento
                                		                  end				left outer join 
  Condicao_Pagamento_Parcela cpp on cp.cd_condicao_pagamento = cpp.cd_condicao_pagamento
where -- Pagamento de Impostos 
   -- dateadd(d,isnull(cpp.qt_dia_cond_parcela_pgto,0),
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end between @dt_inicial and @dt_final
  and pii.dt_cancel_item_ped_imp is null
  and pii.cd_pedido_importacao is not null
Group By
  p.cd_pedido_importacao,
  pais.nm_pais,
  f.nm_fantasia_fornecedor,
  p.cd_identificacao_pedido,
  p.dt_pedido_importacao,
  tf.nm_tipo_frete,
 
  case When isnull(i.cd_invoice,0) = 0 then 
    p.dt_prev_emb_ped_imp
  else 
    i.dt_invoice
  end,
  i.cd_invoice,
  mo.sg_moeda,
  isnull(i.nm_invoice,''),

   right('0' + cast(Month(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2)
   + '/' + 
   right(cast(year(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2),

   dateadd(d,isnull(cpp.qt_dia_cond_parcela_pgto,0),
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_prev_emb_ped_imp
   else
     i.dt_invoice
   end),

  tf.ic_courier_importacao
--  p.dt_entrega_ped_imp,
--  i.dt_chegada_empresa_prev,
--  cpp.qt_dia_cond_parcela_pgto
order by
  1

  select 
    (isnull(ii,0) + isnull(ipi,0) + isnull(icms,0) + isnull(pis,0) + isnull(cofins,0)) as 'Totalimposto', 
    * 
  from 
    #tmp_impostos

end
else
begin
select --PAGAMENTO DE FORNECEDORES 
  p.cd_pedido_importacao,
  pais.nm_pais 			as 'Procedencia',
  f.nm_fantasia_fornecedor 	as 'Nome_Fornecedor',
  p.cd_identificacao_pedido 	as 'Ident_Pedido',
  p.dt_pedido_importacao 	as 'Data_Pedido',
  tf.nm_tipo_frete 		as 'Embarque',
 
  case When isnull(i.cd_invoice,0) = 0 then 
    p.dt_prev_emb_ped_imp
  else 
    i.dt_invoice
  end 				as 'Data',

  case When isnull(i.cd_invoice,0) = 0 then 
    Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
  else 
    Sum(ii.qt_invoice_item * ii.vl_invoice_item)
  end 				as 'FOB',

  mo.sg_moeda 			as 'Moeda',

  max(mo.vl_moeda)		as 'Cotacao',

  case When isnull(i.cd_invoice,0) = 0 then 
    Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
  else 
    Sum(ii.qt_invoice_item * ii.vl_invoice_item)
  end 				
  * 
  max(mo.vl_moeda)		as 'FobReais',
 
  isnull(i.nm_invoice,'')	as 'Invoice',

   right('0' + cast(Month(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2)
   + '/' + 
   right(cast(year(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2)		as 'Vencimento',

-- início cálculo impostos 
  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    max(ti.pc_ii_tipo_importacao) / 100
    *
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item)
    end 				
  else
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
    end
  end 				
  * 
  max(mo.vl_moeda)		as 'II',


  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    0.00
  else

    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
           cf.pc_ipi_classificacao / 100) 

    else 
      Sum(((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
           cf.pc_ipi_classificacao / 100)
    end
  end 
  * 
  max(mo.vl_moeda)		as 'IPI',


  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  

    (max(ti.pc_ii_tipo_importacao) / 100
    *
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item)
    end 	
    +
    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
    else 
      Sum(ii.qt_invoice_item * ii.vl_invoice_item)
    end)
    *
    max(ti.pc_icms_tipo_importacao) / 100

  else

    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
           cf.pc_ipi_classificacao / 100)
          +
          (pii.qt_item_ped_imp * pii.vl_item_ped_imp)
          +
          (pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100))
          *
          case when isnull(cfe.pc_redu_icms_class_fiscal,0) = 0 then
            cfe.pc_icms_classif_fiscal / 100
          else
            cfe.pc_icms_classif_fiscal * isnull(cfe.pc_redu_icms_class_fiscal,1) / 100 /100
          end )       
    else 
      Sum(((((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
           cf.pc_ipi_classificacao / 100)
          +
          (ii.qt_invoice_item * ii.vl_invoice_item)
          +
          (ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100))
          *
          case when isnull(cfe.pc_redu_icms_class_fiscal,0) = 0 then
            cfe.pc_icms_classif_fiscal / 100
          else
            cfe.pc_icms_classif_fiscal * isnull(cfe.pc_redu_icms_class_fiscal,1) / 100 /100
          end )
    end
  end 
  * 
  max(mo.vl_moeda)		as 'ICMS',

  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    0.00
  else

    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
  	   @pc_pis)  
        
    else 
      Sum(((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
  	   @pc_pis) 
    end
  end 
  * 
  max(mo.vl_moeda)		as 'PIS',



  case when isnull(tf.ic_courier_importacao,'N') = 'S' then  
    0.00
  else

    case When isnull(i.cd_invoice,0) = 0 then 
      Sum(((pii.qt_item_ped_imp * pii.vl_item_ped_imp * cf.pc_importacao / 100)
           +
           (pii.qt_item_ped_imp * pii.vl_item_ped_imp))
           *
  	   @pc_cofins)

    else 
      Sum(((ii.qt_invoice_item * ii.vl_invoice_item * cf.pc_importacao / 100)
           +
           (ii.qt_invoice_item * ii.vl_invoice_item))
           *
  	   @pc_cofins)
    end
  end 
  * 
  max(mo.vl_moeda)		as 'COFINS',

--   tf.ic_courier_importacao,

-- fim Cálculo Impostos
   dateadd(d,isnull(cpp.qt_dia_cond_parcela_pgto,0),
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_prev_emb_ped_imp
   else
     i.dt_invoice
   end) as 'PagtoFornecedorVencto',

  case When isnull(i.cd_invoice,0) = 0 then 
    Sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) 
  else 
    Sum(ii.qt_invoice_item * ii.vl_invoice_item)
  end 				
  * 
  max(mo.vl_moeda)		as 'TotalReais',

  ' ' as 'ic_courier_importacao'
  
into #tmp_fornecedores

from 
  Pedido_Importacao 	 p    									left outer join 
  Pedido_Importacao_Item pii  on p.cd_pedido_importacao 	= pii.cd_pedido_importacao 	left outer join 
  Invoice_Item 		 ii   on pii.cd_pedido_importacao 	= ii.cd_pedido_importacao	
                             and pii.cd_item_ped_imp		= ii.cd_item_ped_imp		left outer join 

  Invoice 		 i    on ii.cd_invoice 			= i.cd_invoice			left outer join 
  Produto 		 pro  on pro.cd_produto 	       	= pii.cd_produto 		left outer join 
  Pais 			 Pais on p.cd_pais_procedencia 		= pais.cd_pais			left outer join 
  Fornecedor 		 f    on p.cd_fornecedor        	= f.cd_fornecedor  		left outer join 
  Tipo_Importacao 	 ti   on p.cd_tipo_importacao 		= ti.cd_tipo_importacao 	left outer join 
  Termo_Comercial 	 tc   on p.cd_termo_comercial 		= tc.cd_termo_comercial         left outer join 
  #Moeda 		 mo   on mo.cd_moeda 			= case When isnull(i.cd_invoice,0) = 0 then 
                                                		    p.cd_moeda
		                                                  else 
                    			                            i.cd_moeda
                                        			  end 				left outer join 
  Tipo_Frete 		 tf   on tf.cd_tipo_frete 		= case When isnull(i.cd_invoice,0) = 0 then 
                                                     		    p.cd_tipo_frete
		                                                  else 
                		                                    i.cd_tipo_frete
                                		                  end				left outer join 
  Produto_Fiscal	 pf  on pro.cd_produto 		= pf.cd_produto				left outer join
  Classificacao_Fiscal 	 cf  on cf.cd_classificacao_fiscal      = pf.cd_classificacao_fiscal    left outer join 
  EGISADmin.dbo.Empresa	 e   on e.cd_empresa = dbo.fn_empresa()					left outer join
  Classificacao_Fiscal_Estado cfe on cfe.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
                                 and cfe.cd_estado		= e.cd_estado			left outer join
  Condicao_Pagamento	 cp  on cp.cd_condicao_pagamento		= case When isnull(i.cd_invoice,0) = 0 then 
                                                     		    p.cd_condicao_pagamento
		                                                  else 
                		                                    i.cd_condicao_pagamento
                                		                  end				left outer join 
  Condicao_Pagamento_Parcela cpp on cp.cd_condicao_pagamento = cpp.cd_condicao_pagamento
where --2 - Pagamento de Fornecedores
   dateadd(d,isnull(cpp.qt_dia_cond_parcela_pgto,0),
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_prev_emb_ped_imp
   else
     i.dt_invoice
   end) between @dt_inicial and @dt_final	and
  pii.dt_cancel_item_ped_imp 	is null 	and
  pii.cd_pedido_importacao 	is not null 	
Group By
  p.cd_pedido_importacao,
  pais.nm_pais,
  f.nm_fantasia_fornecedor,
  p.cd_identificacao_pedido,
  p.dt_pedido_importacao,
  tf.nm_tipo_frete,
 
  case When isnull(i.cd_invoice,0) = 0 then 
    p.dt_prev_emb_ped_imp
  else 
    i.dt_invoice
  end,
  i.cd_invoice,
  mo.sg_moeda,
  isnull(i.nm_invoice,''),
   right('0' + cast(Month(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2)
   + '/' + 
   right(cast(year(
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_entrega_ped_imp
   else
     i.dt_chegada_pais_prev
   end) as varchar),2),

   dateadd(d,isnull(cpp.qt_dia_cond_parcela_pgto,0),
   case when Isnull(i.cd_invoice,0) = 0 then
     p.dt_prev_emb_ped_imp
   else
     i.dt_invoice
   end),

  tf.ic_courier_importacao
--   p.dt_entrega_ped_imp,
--   i.dt_chegada_empresa_prev,
--   cpp.qt_dia_cond_parcela_pgto
order by
  1

select (isnull(ii,0) + isnull(ipi,0) + isnull(icms,0) + isnull(pis,0) + isnull(cofins,0)) as 'Totalimposto', 
* from #tmp_fornecedores

end
