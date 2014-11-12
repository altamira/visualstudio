
CREATE PROCEDURE pr_analise_previsao_venda_mensal
@cd_vendedor int      = 0,
@cd_cliente  int      = 0,
@cd_pais     int      = 0,
@cd_ano      int      = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = '',
@cd_moeda    int      = 1,
@ic_parametro char(2) = 'VC' --VC Vendedor Cliente, PC Pais Cliente, P Pais, T Todos
AS

--Quantidades Reais de Venda
--Carlos 15.12.2005

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

--Print @ic_impostos_previsao
--Dados para Conversão caso não localize o valor na data base do pedido ou nota fiscal

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


--Ano						

if @cd_ano = 0
begin
   set @cd_ano = year( getdate() )
   --select @cd_ano
end

--Verifica se a empresa fará a conversão de Moeda

declare @ic_conv_moeda_previsao char(1)

select 
  @ic_conv_moeda_previsao = isnull(ic_conv_moeda_previsao,'N'),
  @cd_moeda               = isnull(cd_moeda,@cd_moeda),
  @ic_demo_custo_previsao = isnull(ic_demo_custo_previsao,'N')
from 
  parametro_previsao_venda
where
  cd_empresa = dbo.fn_empresa()

--Venda

Select 
      IDENTITY(int, 1,1)                   AS 'Posicao',
      p.cd_produto, 
      dbo.fn_mascara_produto(p.cd_produto) As cd_mascara_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,
      sum(isnull(case when month(pv.dt_pedido_venda) = 1  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Janeiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Fevereiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Marco',
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Abril',
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Maio',
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Junho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Julho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Agosto',
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Setembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Outubro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Novembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) as 'Dezembro',

     (sum(isnull(case when month(pv.dt_pedido_venda) = 1  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda  end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda  end,0)) ) as 'Qtd_ano',


     (sum(isnull(case when month(pv.dt_pedido_venda) = 1  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) ) as 'Total_ano',

     (sum(isnull(case when month(pv.dt_pedido_venda) = 1  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0))) / 12 as 'Media',

      max(p.vl_fator_conversao_produt) as fator,

      sum(isnull(case when month(pv.dt_pedido_venda) = 1  then pvi.qt_item_pedido_venda end,0)) as 'qtdJaneiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then pvi.qt_item_pedido_venda end,0)) as 'qtdFevereiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then pvi.qt_item_pedido_venda end,0)) as 'qtdMarco',
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then pvi.qt_item_pedido_venda end,0)) as 'qtdAbril',
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then pvi.qt_item_pedido_venda end,0)) as 'qtdMaio',
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then pvi.qt_item_pedido_venda end,0)) as 'qtdJunho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then pvi.qt_item_pedido_venda end,0)) as 'qtdJulho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then pvi.qt_item_pedido_venda end,0)) as 'qtdAgosto',
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then pvi.qt_item_pedido_venda end,0)) as 'qtdSetembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then pvi.qt_item_pedido_venda end,0)) as 'qtdOutubro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then pvi.qt_item_pedido_venda end,0)) as 'qtdNovembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then pvi.qt_item_pedido_venda end,0)) as 'qtdDezembro',
 
     --Valores de Venda

      sum(isnull(case when month(pv.dt_pedido_venda) = 1  then 
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end
		end,0)) as 'vlJaneiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then 
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end
		end,0)) as 'vlFevereiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then 
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end	   end,0)) as 'vlMarco',
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then  
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end      end,0)) as 'vlAbril',
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then 
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end      end,0)) as 'vlMaio',
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then 
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end		end,0)) as 'vlJunho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then  
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end		end,0)) as 'vlJulho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then  
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end		end,0)) as 'vlAgosto',
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then  
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end		end,0)) as 'vlSetembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then  
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end		end,0)) as 'vlOutubro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then  
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end		end,0)) as 'vlNovembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then  
       case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
  				(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         	- isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * pvi.pc_icms)  /100),0) /*ICMS*/
			end		end,0)) as 'vlDezembro',

     --Valores de Venda em Outra Moeda
      sum(isnull(
		case when month(pv.dt_pedido_venda) = 1  then 
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)
        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
		end,0)) as 'vmJaneiro',

      sum(isnull(case when month(pv.dt_pedido_venda) = 2  then 
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)
        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
  	   end,0)) as 'vmFevereiro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 3  then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)
        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmMarco',
      sum(isnull(case when month(pv.dt_pedido_venda) = 4  then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmAbril',
      sum(isnull(case when month(pv.dt_pedido_venda) = 5  then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmMaio',
      sum(isnull(case when month(pv.dt_pedido_venda) = 6  then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmJunho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 7  then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmJulho',
      sum(isnull(case when month(pv.dt_pedido_venda) = 8  then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmAgosto',
      sum(isnull(case when month(pv.dt_pedido_venda) = 9  then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmSetembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 10 then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmOutubro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 11 then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmNovembro',
      sum(isnull(case when month(pv.dt_pedido_venda) = 12 then  
       (case @ic_impostos_previsao 
 			when  'N' then  
  			     (pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  				
			else
			((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)  
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 1.65 )  /100),0) /*PIS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * (case isnull(pvi.pc_icms,0)
	 																									 when 0 then
																												isnull(dbo.fn_vl_icms_produto_estado(c.cd_estado, c.cd_pais, p.cd_produto), pvi.pc_icms)	 
     																									  else
       																										isnull(pvi.pc_icms,0)  
																											end)	)  /100),0)) /*ICMS*/
			end)        / 
			(case 
				when dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda)>0 then 
					dbo.fn_vl_moeda_periodo(@cd_moeda,pv.dt_pedido_venda) 
				else @vl_moeda 
				end ) 
	   end,0)) as 'vmDezembro',

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
      isnull(c.cd_pais,0) as cd_pais
into
  #VendaReal

from  
     Pedido_Venda pv                       with (nolock) 
     inner join Pedido_Venda_Item pvi      with (nolock) on pvi.cd_pedido_venda   = pv.cd_pedido_venda
     left outer join  Produto p            on p.cd_produto          = pvi.cd_produto
     left outer join Unidade_Medida um     on um.cd_unidade_medida  = p.cd_unidade_medida
     left outer join Cliente c             on c.cd_cliente          = pv.cd_cliente
where 
       isnull(pv.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
       isnull(pv.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(pv.cd_cliente,0)  else @cd_cliente  end and
       isnull(c.cd_pais,0)      = case when @cd_pais     = 0 then isnull(c.cd_pais,0)      else @cd_pais     end and
       pv.cd_pedido_venda       = pvi.cd_pedido_venda and
       pvi.dt_cancelamento_item is null 
       and year(pv.dt_pedido_venda) = @cd_ano

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


-- Select qtdMarco, vlmarco, * from #VendaReal
-- where cd_produto = 2 and cd_cliente = 6

--
-- having 
--     year(pv.dt_pedido_venda) = @cd_ano 



--Faturamento

Select 
      p.cd_produto, 
      sum(isnull(case when month(ns.dt_nota_saida) = 1  then nsi.qt_item_nota_saida end,0)) as 'qtdJaneiroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then nsi.qt_item_nota_saida end,0)) as 'qtdFevereiroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then nsi.qt_item_nota_saida end,0)) as 'qtdMarcoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then nsi.qt_item_nota_saida end,0)) as 'qtdAbrilFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then nsi.qt_item_nota_saida end,0)) as 'qtdMaioFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then nsi.qt_item_nota_saida end,0)) as 'qtdJunhoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then nsi.qt_item_nota_saida end,0)) as 'qtdJulhoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then nsi.qt_item_nota_saida end,0)) as 'qtdAgostoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then nsi.qt_item_nota_saida end,0)) as 'qtdSetembroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 10 then nsi.qt_item_nota_saida end,0)) as 'qtdOutubroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 11 then nsi.qt_item_nota_saida end,0)) as 'qtdNovembroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 12 then nsi.qt_item_nota_saida end,0)) as 'qtdDezembroFaturamento',
 
     --Valores do Faturamento

      sum(isnull(case when month(ns.dt_nota_saida) = 1  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlJaneiroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		 as 'vlFevereiroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlMarcoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlAbrilFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlMaioFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlJunhoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlJulhoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlAgostoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlSetembroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 10 then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlOutubroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 11 then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlNovembroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 12 then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlDezembroFaturamento',

     --Valores do Faturamento Convertido em Outra Moeda
 
      sum(isnull(case when month(ns.dt_nota_saida) = 1  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmJaneiroFaturamento',

      sum(isnull(case when month(ns.dt_nota_saida) = 2  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmFevereiroFaturamento',

      sum(isnull(case when month(ns.dt_nota_saida) = 3  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmMarcoFaturamento',

      sum(isnull(case when month(ns.dt_nota_saida) = 4  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmAbrilFaturamento',

      sum(isnull(case when month(ns.dt_nota_saida) = 5  then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmMaioFaturamento',

      sum(isnull(case when month(ns.dt_nota_saida) = 6  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmJunhoFaturamento',	
    
  		sum(isnull(case when month(ns.dt_nota_saida) = 7  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmJulhoFaturamento',
   
   	sum(isnull(case when month(ns.dt_nota_saida) = 8  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmAgostoFaturamento',
   
   	sum(isnull(case when month(ns.dt_nota_saida) = 9  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmSetembroFaturamento',
  
    	sum(isnull(case when month(ns.dt_nota_saida) = 10 then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmOutubroFaturamento',
 
     	sum(isnull(case when month(ns.dt_nota_saida) = 11 then
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmNovembroFaturamento',
 
     	sum(isnull(case when month(ns.dt_nota_saida) = 12 then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 
		/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) else @vl_moeda end ) end,0)) as 'vmDezembroFaturamento',

      case @ic_parametro
        when 'P' then
          0
        when 'PC' then
          0
        else
          isnull(ns.cd_vendedor,0) 
      end as cd_vendedor,
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
      end                                as nm_fantasia_cliente,
      isnull(c.cd_pais,0)                as cd_pais,
      max(pc.vl_custo_produto)           as vl_custo_produto,
      max(pc.vl_custo_previsto_produto)  as vl_custo_moeda

into
  #NotaReal
from
     Nota_Saida ns
     inner join Nota_Saida_Item nsi     on ns.cd_nota_saida       = nsi.cd_nota_saida
     inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
     left outer join Produto p          on p.cd_produto           = nsi.cd_produto
     left outer join Produto_Custo pc   on pc.cd_produto          = p.cd_produto
     left outer join Unidade_Medida um  on um.cd_unidade_medida   = p.cd_unidade_medida
     left outer join Cliente c          on c.cd_cliente           = ns.cd_cliente
     
where 
  isnull(ns.cd_vendedor,0)  = case when @cd_vendedor = 0 then isnull(ns.cd_vendedor,0) else @cd_vendedor end and
  isnull(ns.cd_cliente,0)   = case when @cd_cliente  = 0 then isnull(ns.cd_cliente,0)  else @cd_cliente end and
  isnull(c.cd_pais,0)       = case when @cd_pais     = 0 then isnull(c.cd_pais,0)      else @cd_pais end and
  ns.cd_nota_saida          = nsi.cd_nota_saida and
  year(ns.dt_nota_saida)    = @cd_ano  and
  isnull(opf.ic_comercial_operacao,'N')='S'   
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

-- Select * from #VendaReal
-- Select * from #NotaReal

--select * from #temp order by nm_fantasia_produto

--Dados da Quantidades Previstas Digitada pelos Vendedores

SELECT
   pvc.cd_previsao_venda,
   case
    when isnull(pv.cd_produto,0) > 0        then p.nm_fantasia_produto
    when isnull(pv.cd_produto_desenv,0) > 0 then pd.nm_fantasia_produto
   end as nm_produto_previsao_mensal,
   case
    when isnull(pv.cd_produto,0) > 0        then pv.cd_produto
    when isnull(pv.cd_produto_desenv,0) > 0 then pv.cd_produto_desenv
   end as cd_produto,

  --Quantidades / Valores Unitários Previstos

  isnull(pvc.vl_jan_previsao,0) as vl_jan_previsao,
  isnull(pvc.qt_jan_previsao,0) as qt_jan_previsao,
  isnull(pvc.vl_fev_previsao,0) as vl_fev_previsao,
  isnull(pvc.qt_fev_previsao,0) as qt_fev_previsao,
  isnull(pvc.vl_mar_previsao,0) as vl_mar_previsao,
  isnull(pvc.qt_mar_previsao,0) as qt_mar_previsao,
  isnull(pvc.vl_abr_previsao,0) as vl_abr_previsao,
  isnull(pvc.qt_abr_previsao,0) as qt_abr_previsao,
  isnull(pvc.vl_mai_previsao,0) as vl_mai_previsao,
  isnull(pvc.qt_mai_previsao,0) as qt_mai_previsao,
  isnull(pvc.vl_jun_previsao,0) as vl_jun_previsao,
  isnull(pvc.qt_jun_previsao,0) as qt_jun_previsao,
  isnull(pvc.vl_jul_previsao,0) as vl_jul_previsao,
  isnull(pvc.qt_jul_previsao,0) as qt_jul_previsao,
  isnull(pvc.vl_ago_previsao,0) as vl_ago_previsao,
  isnull(pvc.qt_ago_previsao,0) as qt_ago_previsao,
  isnull(pvc.vl_set_previsao,0) as vl_set_previsao,
  isnull(pvc.qt_set_previsao,0) as qt_set_previsao,
  isnull(pvc.vl_out_previsao,0) as vl_out_previsao,
  isnull(pvc.qt_out_previsao,0) as qt_out_previsao,
  isnull(pvc.vl_nov_previsao,0) as vl_nov_previsao,
  isnull(pvc.qt_nov_previsao,0) as qt_nov_previsao,
  isnull(pvc.vl_dez_previsao,0) as vl_dez_previsao,
  isnull(pvc.qt_dez_previsao,0) as qt_dez_previsao,
  
  --Saldo por País

  0.00 as qt_saldo_jan_previsao,
  0.00 as qt_saldo_fev_previsao,
  0.00 as qt_saldo_mar_previsao,
  0.00 as qt_saldo_abr_previsao,
  0.00 as qt_saldo_mai_previsao,
  0.00 as qt_saldo_jun_previsao,
  0.00 as qt_saldo_jul_previsao,
  0.00 as qt_saldo_ago_previsao,
  0.00 as qt_saldo_set_previsao,
  0.00 as qt_saldo_out_previsao,
  0.00 as qt_saldo_nov_previsao,
  0.00 as qt_saldo_dez_previsao,

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
  isnull(pvc.qt_dez_previsao,0))   as consumo_anual,
  isnull(pvc.qt_potencial,0)       as qt_potencial,
  
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
  isnull(pvc.vl_dez_previsao,0))   as vl_consumo_anual,

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
        a.cd_previsao_venda = pv.cd_previsao_venda ) /--Anderson
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
                                1 = Case @ic_parametro
                                      when 'VC' then
                                        --Verificar GBS 
                                        case when isnull(pv.cd_vendedor,0) > 0 or isnull(pv.cd_cliente,0) > 0 then	
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
   				        case when isnull(pv.cd_pais,0) > 0 and isnull(pv.cd_cliente,0) = 0 and isnull(pv.cd_vendedor,0) = 0 then
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
  pvc.cd_usuario,
  pvc.dt_usuario,
  case when isnull(pvc.vl_unitario_previsao,0)=0 then
    p.vl_produto
  else
    pvc.vl_unitario_previsao
  end as vl_unitario_previsao,

  --coalesce(pvc.vl_unitario_previsao,p.vl_produto,0) as vl_unitario_previsao2,
  --Quantidades Reais

  isnull(vr.qtdJaneiro,0)    as qtdJaneiro,
  isnull(vr.qtdFevereiro,0)  as qtdFevereiro,
  isnull(vr.qtdMarco,0)      as qtdMarco, 
  isnull(vr.qtdAbril,0)      as qtdAbril,
  isnull(vr.qtdMaio,0)       as qtdMaio, 
  isnull(vr.qtdJunho,0)      as qtdJunho, 
  isnull(vr.qtdJulho,0)      as qtdJulho, 
  isnull(vr.qtdAgosto,0)     as qtdAgosto,  
  isnull(vr.qtdSetembro,0)   as qtdSetembro, 
  isnull(vr.qtdOutubro,0)    as qtdOutubro,
  isnull(vr.qtdNovembro,0)   as qtdNovembro,
  isnull(vr.qtdDezembro,0)   as qtdDezembro,

  vr.qtd_ano,
  vr.total_ano,

  --preços unitários reais

  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlJaneiro,0)   else isnull(vr.vmJaneiro,0)   end as vlJaneiro,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlFevereiro,0) else isnull(vr.vmFevereiro,0) end as vlFevereiro,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlMarco,0)     else isnull(vr.vmMarco,0)     end as vlMarco,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlAbril,0)     else isnull(vr.vmAbril,0)     end as vlAbril,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlMaio,0)      else isnull(vr.vmMaio,0)      end as vlMaio,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlJunho,0)     else isnull(vr.vmJunho,0)     end as vlJunho, 
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlJulho,0)     else isnull(vr.vmJulho,0)     end as vlJulho,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlAgosto,0)    else isnull(vr.vmAgosto,0)    end as vlAgosto, 
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlSetembro,0)  else isnull(vr.vmSetembro,0)  end as vlSetembro,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlOutubro ,0)  else isnull(vr.vmOutubro ,0)  end as vlOutubro,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlNovembro,0)  else isnull(vr.vmNovembro,0)  end as vlNovembro,
  case when @ic_conv_moeda_previsao='N' then isnull(vr.vlDezembro,0)  else isnull(vr.vmDezembro,0)  end as vlDezembro,

  pv.cd_vendedor,
  pv.cd_cliente,
  c.nm_fantasia_cliente,
  v.nm_vendedor,
  Pais.nm_pais,
  Pais.cd_pais,
  isnull(nr.qtdJaneiroFaturamento,0)    as qtdJaneiroFaturamento,
  isnull(nr.qtdFevereiroFaturamento,0)  as qtdFevereiroFaturamento,
  isnull(nr.qtdMarcoFaturamento,0)      as qtdMarcoFaturamento,
  isnull(nr.qtdAbrilFaturamento,0)      as qtdAbrilFaturamento,
  isnull(nr.qtdMaioFaturamento,0)       as qtdMaioFaturamento,
  isnull(nr.qtdJunhoFaturamento,0)      as qtdJunhoFaturamento,
  isnull(nr.qtdJulhoFaturamento,0)      as qtdJulhoFaturamento,
  isnull(nr.qtdAgostoFaturamento,0)     as qtdAgostoFaturamento,
  isnull(nr.qtdSetembroFaturamento,0)   as qtdSetembroFaturamento,
  isnull(nr.qtdOutubroFaturamento,0)    as qtdOutubroFaturamento,
  isnull(nr.qtdNovembroFaturamento,0)   as qtdNovembroFaturamento,
  isnull(nr.qtdDezembroFaturamento,0)   as qtdDezembroFaturamento,

  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlJaneiroFaturamento,0)     else isnull(nr.vmJaneiroFaturamento,0)   end as vlJaneiroFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlFevereiroFaturamento,0)   else isnull(nr.vmFevereiroFaturamento,0) end as vlFevereiroFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlMarcoFaturamento,0)       else isnull(nr.vmMarcoFaturamento,0)     end as vlMarcoFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlAbrilFaturamento,0)       else isnull(nr.vmAbrilFaturamento,0)     end as vlAbrilFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlMaioFaturamento,0)        else isnull(nr.vmMaioFaturamento,0)      end as vlMaioFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlJunhoFaturamento,0)       else isnull(nr.vmJunhoFaturamento,0)     end as vlJunhoFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlJulhoFaturamento,0)       else isnull(nr.vmJulhoFaturamento,0)     end as vlJulhoFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlAgostoFaturamento,0)      else isnull(nr.vmAgostoFaturamento,0)    end as vlAgostoFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlSetembroFaturamento,0)    else isnull(nr.vmSetembroFaturamento,0)  end as vlSetembroFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlOutubroFaturamento,0)     else isnull(nr.vmOutubroFaturamento,0)   end as vlOutubroFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlNovembroFaturamento,0)    else isnull(nr.vmNovembroFaturamento,0)  end as vlNovembroFaturamento,
  case when @ic_conv_moeda_previsao = 'N' then isnull(nr.vlDezembroFaturamento,0)    else isnull(nr.vmDezembroFaturamento,0)  end as vlDezembroFaturamento,
  nr.vl_custo_produto,
  nr.vl_custo_moeda

into 
  #AuxPrevisaoMensal
   
FROM
  Previsao_Venda_Composicao pvc
  INNER JOIN  Previsao_Venda pv              ON pvc.cd_previsao_venda = pv.cd_previsao_venda
  LEFT OUTER JOIN vendedor   v               ON v.cd_vendedor         = pv.cd_vendedor   
  LEFT OUTER JOIN cliente c                  ON c.cd_cliente          = pv.cd_cliente
  LEFT OUTER JOIN Pais                       ON Pais.cd_pais          = pv.cd_pais 
  LEFT OUTER JOIN Produto p                  ON pv.cd_produto         = p.cd_produto
  LEFT OUTER JOIN Produto_Desenvolvimento pd ON pv.cd_produto_desenv  = pd.cd_produto_desenv
  LEFT OUTER JOIN #VendaReal vr              ON vr.cd_produto         = pv.cd_produto  
  and
  1 = Case @ic_parametro
        when 'VC' then
          --Verificar GBS
          case when isnull(vr.cd_vendedor,0) = isnull(pv.cd_vendedor,0) or isnull(vr.cd_cliente,0)  = isnull(pv.cd_cliente,0) then
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
  LEFT OUTER JOIN #NotaReal nr ON nr.cd_produto = pv.cd_produto 
  and
  1 = Case @ic_parametro
        when 'VC' then
          --Verificar GBS
          case when isnull(nr.cd_vendedor,0) = isnull(pv.cd_vendedor,0) or isnull(nr.cd_cliente,0)  = isnull(pv.cd_cliente,0) then
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
   isnull(pv.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
   isnull(pv.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(pv.cd_cliente,0)  else @cd_cliente end and
   isnull(pv.cd_pais,0)     = case when @cd_pais     = 0 then isnull(pv.cd_pais,0)     else @cd_pais end and
   1  =
	Case @ic_parametro
		when 'VC' then
                        --Verificar GBS
			case when isnull(pv.cd_vendedor,0) > 0 or isnull(pv.cd_cliente,0) > 0 then	
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
			case when isnull(pv.cd_pais,0) > 0 and isnull(pv.cd_cliente,0) = 0 and isnull(pv.cd_vendedor,0) = 0 then
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

  --(%) Realizado

  case when qt_jan_previsao>0 then (qtdJaneiro/qt_jan_previsao)*100 
                              else 0.00  end                           as pc_qtd_jan,

  case when vl_jan_previsao>0 then (vlJaneiro/vl_jan_previsao )*100    
                              else 0.00  end                           as pc_val_jan,
  case when qt_fev_previsao>0 then (qtdFevereiro/qt_fev_previsao)*100  
                              else 0.00  end                           as pc_qtd_fev,
  case when vl_fev_previsao>0 then (vlFevereiro/vl_fev_previsao)*100   
                              else 0.00  end                           as pc_val_fev,
  case when qt_mar_previsao>0 then (qtdMarco/qt_mar_previsao  )*100    
                              else 0.00  end                           as pc_qtd_mar,
  case when vl_mar_previsao>0 then (vlMarco/vl_mar_previsao   )*100    
                              else 0.00  end                           as pc_val_mar,
  case when qt_abr_previsao>0 then (qtdAbril/qt_abr_previsao  )*100    
                              else 0.00  end                           as pc_qtd_abr,
  case when vl_abr_previsao>0 then (vlAbril/vl_abr_previsao   )*100    
                              else 0.00  end                           as pc_val_abr,
  case when qt_mai_previsao>0 then (qtdMaio/qt_mai_previsao   )*100    
                              else 0.00  end                           as pc_qtd_mai,
  case when vl_mai_previsao>0 then (vlMaio/vl_mai_previsao    )*100    
                              else 0.00  end                           as pc_val_mai,
  case when qt_jun_previsao>0 then (qtdJunho/qt_jun_previsao  )*100    
                              else 0.00  end                           as pc_qtd_jun,
  case when vl_jun_previsao>0 then (vlJunho/vl_jun_previsao   )*100    
                              else 0.00  end                           as pc_val_jun,
  case when qt_jul_previsao>0 then (qtdJulho/qt_jul_previsao  )*100    
                              else 0.00  end                           as pc_qtd_jul,
  case when vl_jul_previsao>0 then (vlJulho/vl_jul_previsao   )*100    
                              else 0.00  end                           as pc_val_jul,
  case when qt_ago_previsao>0 then (qtdAgosto/qt_ago_previsao  )*100   
                              else 0.00  end                           as pc_qtd_ago,
  case when vl_ago_previsao>0 then (vlAgosto/vl_ago_previsao  )*100    
                              else 0.00  end                           as pc_val_ago,
  case when qt_set_previsao>0 then (qtdSetembro/qt_set_previsao)*100  
                              else 0.00  end                           as pc_qtd_set,
  case when vl_set_previsao>0 then (vlSetembro/vl_set_previsao)*100    
                              else 0.00  end                           as pc_val_set,
  case when qt_out_previsao>0 then (qtdOutubro/qt_out_previsao)*100    
                              else 0.00  end                           as pc_qtd_out,
  case when vl_out_previsao>0 then (vlOutubro/vl_out_previsao )*100    
                              else 0.00  end                           as pc_val_out,
  case when qt_nov_previsao>0 then (qtdNovembro/qt_nov_previsao)*100   
                              else 0.00  end                           as pc_qtd_nov,
  case when vl_nov_previsao>0 then (vlNovembro/vl_nov_previsao)*100    
                              else 0.00  end                           as pc_val_nov,
  case when qt_dez_previsao>0 then (qtdDezembro/qt_dez_previsao)*100   
                              else 0.00  end                           as pc_qtd_dez,
  case when vl_dez_previsao>0 then (vlDezembro/vl_dez_previsao )*100   
                              else 0.00  end                           as pc_val_dez,

  --(%) Faturado

  case when qt_jan_previsao>0 then (qtdJaneiroFaturamento/qt_jan_previsao)*100 
                              else 0.00  end                           as pc_fat_qtd_jan,

  case when vl_jan_previsao>0 then (vlJaneiroFaturamento/vl_jan_previsao )*100    
                              else 0.00  end                           as pc_fat_val_jan,
  case when qt_fev_previsao>0 then (qtdFevereiroFaturamento/qt_fev_previsao)*100  
                              else 0.00  end                           as pc_fat_qtd_fev,
  case when vl_fev_previsao>0 then (vlFevereiroFaturamento/vl_fev_previsao)*100   
                              else 0.00  end                           as pc_fat_val_fev,
  case when qt_mar_previsao>0 then (qtdMarcoFaturamento/qt_mar_previsao  )*100    
                              else 0.00  end                           as pc_fat_qtd_mar,
  case when vl_mar_previsao>0 then (vlMarcoFaturamento/vl_mar_previsao   )*100    
                              else 0.00  end                           as pc_fat_val_mar,
  case when qt_abr_previsao>0 then (qtdAbrilFaturamento/qt_abr_previsao  )*100    
                              else 0.00  end                           as pc_fat_qtd_abr,
  case when vl_abr_previsao>0 then (vlAbrilFaturamento/vl_abr_previsao   )*100    
                              else 0.00  end                           as pc_fat_val_abr,
  case when qt_mai_previsao>0 then (qtdMaioFaturamento/qt_mai_previsao   )*100    
                              else 0.00  end                           as pc_fat_qtd_mai,
  case when vl_mai_previsao>0 then (vlMaioFaturamento/vl_mai_previsao    )*100    
                              else 0.00  end                           as pc_fat_val_mai,
  case when qt_jun_previsao>0 then (qtdJunhoFaturamento/qt_jun_previsao  )*100    
                              else 0.00  end                           as pc_fat_qtd_jun,
  case when vl_jun_previsao>0 then (vlJunhoFaturamento/vl_jun_previsao   )*100    
                              else 0.00  end                           as pc_fat_val_jun,
  case when qt_jul_previsao>0 then (qtdJulhoFaturamento/qt_jul_previsao  )*100    
                              else 0.00  end                           as pc_fat_qtd_jul,
  case when vl_jul_previsao>0 then (vlJulhoFaturamento/vl_jul_previsao   )*100    
                              else 0.00  end                           as pc_fat_val_jul,
  case when qt_ago_previsao>0 then (qtdAgostoFaturamento/qt_ago_previsao  )*100   
                              else 0.00  end                           as pc_fat_qtd_ago,
  case when vl_ago_previsao>0 then (vlAgostoFaturamento/vl_ago_previsao  )*100    
                              else 0.00  end                           as pc_fat_val_ago,
  case when qt_set_previsao>0 then (qtdSetembroFaturamento/qt_set_previsao)*100  
                              else 0.00  end                           as pc_fat_qtd_set,
  case when vl_set_previsao>0 then (vlSetembroFaturamento/vl_set_previsao)*100    
                              else 0.00  end                           as pc_fat_val_set,
  case when qt_out_previsao>0 then (qtdOutubroFaturamento/qt_out_previsao)*100    
                              else 0.00  end                           as pc_fat_qtd_out,
  case when vl_out_previsao>0 then (vlOutubroFaturamento/vl_out_previsao )*100    
                              else 0.00  end                           as pc_fat_val_out,
  case when qt_nov_previsao>0 then (qtdNovembroFaturamento/qt_nov_previsao)*100   
                              else 0.00  end                           as pc_fat_qtd_nov,
  case when vl_nov_previsao>0 then (vlNovembroFaturamento/vl_nov_previsao)*100    
                              else 0.00  end                           as pc_fat_val_nov,
  case when qt_dez_previsao>0 then (qtdDezembroFaturamento/qt_dez_previsao)*100   
                              else 0.00  end                           as pc_fat_qtd_dez,
  case when vl_dez_previsao>0 then (vlDezembroFaturamento/vl_dez_previsao )*100   
                              else 0.00  end                           as pc_fat_val_dez,

  --Fator de Custo

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_jan_previsao>0 then 
       vl_jan_previsao/(vl_custo_produto*qt_jan_previsao)
  else
      case when vl_custo_moeda>0 and qt_jan_previsao>0 then
         vl_jan_previsao/(vl_custo_moeda*qt_jan_previsao)              
      else
         0.00 end

  end as vl_jan_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdJaneiroFaturamento>0 then 
       vlJaneiroFaturamento/(vl_custo_produto*qtdJaneiroFaturamento)
  else
       case when vl_custo_moeda>0 and qtdJaneiroFaturamento > 0 then
            vljaneiroFaturamento/(vl_custo_moeda*qtdJaneiroFaturamento)
       else 0.00 end
  end as vl_jan_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_fev_previsao>0 then 
       vl_fev_previsao/(vl_custo_produto*qt_fev_previsao)
  else
      case when vl_custo_moeda>0 and qt_fev_previsao>0 then
         vl_fev_previsao/(vl_custo_moeda*qt_fev_previsao)              
      else
         0.00 end
  end as vl_fev_custo_previsto,


  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdFevereiroFaturamento>0 then 
       vlFevereiroFaturamento/(vl_custo_produto*qtdFevereiroFaturamento)
  else
       case when vl_custo_moeda>0 and qtdFevereiroFaturamento >0 then
            vlFevereiroFaturamento/(vl_custo_moeda*qtdFevereiroFaturamento)
       else 0.00 end
  end as vl_fev_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_mar_previsao>0 then 
       vl_mar_previsao/(vl_custo_produto*qt_mar_previsao)
  else
      case when vl_custo_moeda>0 and qt_mar_previsao>0 then
         vl_mar_previsao/(vl_custo_moeda*qt_mar_previsao)              
      else
         0.00 end
  end as vl_mar_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdMarcoFaturamento>0 then 
       vlMarcoFaturamento/(vl_custo_produto*qtdMarcoFaturamento)
  else
       case when vl_custo_moeda>0 and qtdMarcoFaturamento>0 then
            vlMarcoFaturamento/(vl_custo_moeda*qtdMarcoFaturamento)
       else 0.00 end
  end as vl_mar_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_abr_previsao>0 then 
       vl_abr_previsao/(vl_custo_produto*qt_abr_previsao)
  else
      case when vl_custo_moeda>0 and qt_abr_previsao>0 then
         vl_abr_previsao/(vl_custo_moeda*qt_abr_previsao)              
      else
         0.00 end
  end as vl_abr_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdAbrilFaturamento>0 then 
       vlAbrilFaturamento/(vl_custo_produto*qtdAbrilFaturamento)
  else
       case when vl_custo_moeda>0 and qtdAbrilFaturamento>0 then
            vlAbrilFaturamento/(vl_custo_moeda*qtdAbrilFaturamento)
       else 0.00 end
  end as vl_abr_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_mai_previsao>0 then 
       vl_mai_previsao/(vl_custo_produto*qt_mai_previsao)
  else
      case when vl_custo_moeda>0 and qt_mai_previsao>0 then
         vl_mai_previsao/(vl_custo_moeda*qt_mai_previsao)              
      else
         0.00 end

  end as vl_mai_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdMaioFaturamento >0 then 
       vlMaioFaturamento/(vl_custo_produto*qtdMaioFaturamento)
  else
       case when vl_custo_moeda>0 and qtdMaioFaturamento > 0 then
            vlMaioFaturamento/(vl_custo_moeda*qtdMaioFaturamento)
       else 0.00 end
  end as vl_mai_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_jun_previsao>0 then 
       vl_jun_previsao/(vl_custo_produto*qt_jun_previsao)
  else
      case when vl_custo_moeda>0 and qt_jun_previsao>0 then
         vl_jun_previsao/(vl_custo_moeda*qt_jun_previsao)              
      else
         0.00 end
  end as vl_jun_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdJunhoFaturamento>0 then 
       vlJunhoFaturamento/(vl_custo_produto*qtdJunhoFaturamento)
  else
       case when vl_custo_moeda>0 and qtdJunhoFaturamento>0 then
            vlJunhoFaturamento/(vl_custo_moeda*qtdJunhoFaturamento)
       else 0.00 end
  end as vl_jun_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and vl_jul_previsao>0 then 
       vl_jul_previsao/(vl_custo_produto*qt_jul_previsao)
  else
      case when vl_custo_moeda>0 and vl_jul_previsao>0 then
         vl_jul_previsao/(vl_custo_moeda*qt_jul_previsao)              
      else
         0.00 end
  end as vl_jul_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdJulhoFaturamento>0 then 
       vlJulhoFaturamento/(vl_custo_produto*qtdJulhoFaturamento)
  else
       case when vl_custo_moeda>0 and qtdJulhoFaturamento>0 then
            vlJulhoFaturamento/(vl_custo_moeda*qtdJulhoFaturamento)
       else 0.00 end
  end as vl_jul_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_ago_previsao>0 then 
       vl_ago_previsao/(vl_custo_produto*qt_ago_previsao)
  else
      case when vl_custo_moeda>0 and qt_ago_previsao>0 then
         vl_ago_previsao/(vl_custo_moeda*qt_ago_previsao)              
      else
         0.00 end
  end as vl_ago_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdAgostoFaturamento>0 then 
       vlAgostoFaturamento/(vl_custo_produto*qtdAgostoFaturamento)
  else
       case when vl_custo_moeda>0 and qtdAgostoFaturamento>0 then
            vlAgostoFaturamento/(vl_custo_moeda*qtdAgostoFaturamento)
       else 0.00 end
  end as vl_ago_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_set_previsao>0 then 
       vl_set_previsao/(vl_custo_produto*qt_set_previsao)
  else
      case when vl_custo_moeda>0 and qt_set_previsao>0 then
         vl_set_previsao/(vl_custo_moeda*qt_set_previsao)              
      else
         0.00 end
  end as vl_set_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdSetembroFaturamento>0 then 
       vlSetembroFaturamento/(vl_custo_produto*qtdSetembroFaturamento)
  else
       case when vl_custo_moeda>0 and qtdSetembroFaturamento>0 then
            vlSetembroFaturamento/(vl_custo_moeda*qtdSetembroFaturamento)
       else 0.00 end
  end as vl_set_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_out_previsao>0 then 
       vl_out_previsao/(vl_custo_produto*qt_out_previsao)
  else
      case when vl_custo_moeda>0 and qt_out_previsao>0 then
         vl_out_previsao/(vl_custo_moeda*qt_out_previsao)              
      else
         0.00 end
  end as vl_out_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdOutubroFaturamento>0 then 
       vlOutubroFaturamento/(vl_custo_produto*qtdOutubroFaturamento)
  else
       case when vl_custo_moeda>0 and qtdOutubroFaturamento>0 then
            vlOutubroFaturamento/(vl_custo_moeda*qtdOutubroFaturamento)
       else 0.00 end
  end as vl_out_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_nov_previsao>0 then 
       vl_nov_previsao/(vl_custo_produto*qt_nov_previsao)
  else
      case when vl_custo_moeda>0 and qt_nov_previsao>0 then
         vl_nov_previsao/(vl_custo_moeda*qt_nov_previsao)              
      else
         0.00 end
  end as vl_nov_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdNovembroFaturamento>0 then 
       vlNovembroFaturamento/(vl_custo_produto*qtdNovembroFaturamento)
  else
       case when vl_custo_moeda>0 and qtdNovembroFaturamento>0 then
            vlNovembroFaturamento/(vl_custo_moeda*qtdNovembroFaturamento)
       else 0.00 end
  end as vl_nov_custo_real,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qt_dez_previsao>0 then 
       vl_dez_previsao/(vl_custo_produto*qt_dez_previsao)
  else
      case when vl_custo_moeda>0 and qt_dez_previsao >0 then
         vl_dez_previsao/(vl_custo_moeda*qt_dez_previsao)              
      else
         0.00 end
  end as vl_dez_custo_previsto,

  case when @ic_conv_moeda_previsao='N' and vl_custo_produto>0 and qtdDezembroFaturamento>0 then 
       vlDezembroFaturamento/(vl_custo_produto*qtdDezembroFaturamento)
  else
       case when vl_custo_moeda>0 and qtdDezembroFaturamento>0 then
            vlDezembroFaturamento/(vl_custo_moeda*qtdDezembroFaturamento)
       else 0.00 end
  end as vl_dez_custo_real

from
  #AuxPrevisaoMensal
order by
  nm_pais,
  nm_fantasia_cliente,
  nm_produto_previsao_mensal

--select * from #AuxPrevisaoMensal2

