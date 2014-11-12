
CREATE PROCEDURE pr_analise_previsao_proposta_mensal
@cd_vendedor int = 0,
@cd_cliente  int = 0,
@cd_pais     int = 0,
@cd_ano      int = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = ''
AS

--Quantidades Reais de Propostas
declare @vl_moeda float

declare @ic_fator_conversao char(1)

select
  		@ic_fator_conversao = isnull(ic_conversao_qtd_fator,0)
from
  		Parametro_BI
where
  		cd_empresa = dbo.fn_empresa()


declare @ic_conv_moeda_previsao char(1)
declare @cd_moeda int
set @cd_moeda = 1

set @vl_moeda = ( case 	when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                 			else dbo.fn_vl_moeda(@cd_moeda) 
						end )

select 
 @ic_conv_moeda_previsao = isnull(ic_conv_moeda_previsao,'N'),
 @cd_moeda               = isnull(cd_moeda,@cd_moeda)
from 
 parametro_previsao_venda
where
 cd_empresa = dbo.fn_empresa()



--Ano

if @cd_ano = 0
begin
   set @cd_ano = year( getdate() )
   --select @cd_ano
end

--select * from consulta
--select * from consulta_itens

Select 
      IDENTITY(int, 1,1)                   AS 'Posicao',
      p.cd_produto, 
      dbo.fn_mascara_produto(p.cd_produto) As cd_mascara_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,

      sum(isnull(case when month(co.dt_consulta) = 1  then ci.qt_item_consulta end,0)) as 'qtdJaneiro',
      sum(isnull(case when month(co.dt_consulta) = 2  then ci.qt_item_consulta end,0)) as 'qtdFevereiro',
      sum(isnull(case when month(co.dt_consulta) = 3  then ci.qt_item_consulta end,0)) as 'qtdMarco',
      sum(isnull(case when month(co.dt_consulta) = 4  then ci.qt_item_consulta end,0)) as 'qtdAbril',
      sum(isnull(case when month(co.dt_consulta) = 5  then ci.qt_item_consulta end,0)) as 'qtdMaio',
      sum(isnull(case when month(co.dt_consulta) = 6  then ci.qt_item_consulta end,0)) as 'qtdJunho',
      sum(isnull(case when month(co.dt_consulta) = 7  then ci.qt_item_consulta end,0)) as 'qtdJulho',
      sum(isnull(case when month(co.dt_consulta) = 8  then ci.qt_item_consulta end,0)) as 'qtdAgosto',
      sum(isnull(case when month(co.dt_consulta) = 9  then ci.qt_item_consulta end,0)) as 'qtdSetembro',
      sum(isnull(case when month(co.dt_consulta) = 10 then ci.qt_item_consulta end,0)) as 'qtdOutubro',
      sum(isnull(case when month(co.dt_consulta) = 11 then ci.qt_item_consulta end,0)) as 'qtdNovembro',
      sum(isnull(case when month(co.dt_consulta) = 12 then ci.qt_item_consulta end,0)) as 'qtdDezembro',
 
     --Valores das Propostas

      sum(isnull(case when month(co.dt_consulta) = 1  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlJaneiro',
      sum(isnull(case when month(co.dt_consulta) = 2  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlFevereiro',
      sum(isnull(case when month(co.dt_consulta) = 3  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlMarco',
      sum(isnull(case when month(co.dt_consulta) = 4  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlAbril',
      sum(isnull(case when month(co.dt_consulta) = 5  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlMaio',
	   sum(isnull(case when month(co.dt_consulta) = 6  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlJunho',
      sum(isnull(case when month(co.dt_consulta) = 7  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlJulho',
      sum(isnull(case when month(co.dt_consulta) = 8  then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlAgosto',
      sum(isnull(case when month(co.dt_consulta) = 9  then 
				((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlSetembro',
      sum(isnull(case when month(co.dt_consulta) = 10 then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlOutubro',
      sum(isnull(case when month(co.dt_consulta) = 11 then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlNovembro',
      sum(isnull(case when month(co.dt_consulta) = 12 then 
			((ci.qt_item_consulta*ci.vl_unitario_item_consulta)  
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 1.65 )  /100),0) /*PIS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * 7.6 )  /100),0) /*COFINS*/
         - isnull((((ci.qt_item_consulta*ci.vl_unitario_item_consulta) * ci.pc_icms)  /100),0)) /*ICMS*/		
			/ (case when dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta)>0 and @ic_conv_moeda_previsao = 'S'
                 then dbo.fn_vl_moeda_periodo(@cd_moeda,co.dt_consulta) 
                 else 1 end )
        end,0)) 	
		as 'vlDezembro',

     (sum(isnull(case when month(co.dt_consulta) = 1  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 2  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 3  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 4  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 5  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 6  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 7  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 8  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 9  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 10 then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 11 then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 12 then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) ) as 'Total_ano',

     (sum(isnull(case when month(co.dt_consulta) = 1  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 2  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 3  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 4  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 5  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 6  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 7  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 8  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 9  then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 10 then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 11 then ci.qt_item_consulta end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 12 then ci.qt_item_consulta end,0)) ) as 'Qtd_ano',


     (sum(isnull(case when month(co.dt_consulta) = 1  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 2  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 3  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 4  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 5  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 6  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 7  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 8  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 9  then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 10 then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 11 then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(co.dt_consulta) = 12 then ci.qt_item_consulta * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0))) / 12 as 'Media',

      max(p.vl_fator_conversao_produt) as fator,
      co.cd_vendedor,
      co.cd_cliente,
      c.nm_fantasia_cliente,
      max(nm_fantasia_vendedor) as nm_fantasia_vendedor     
into
  #ConsultaReal
from
     Consulta co
     inner join Consulta_itens ci       on ci.cd_consulta        = co.cd_consulta
     left outer join  Produto p         on p.cd_produto          = ci.cd_produto
     left outer join Unidade_Medida um  on um.cd_unidade_medida  = p.cd_unidade_medida
     left outer join Cliente c          on c.cd_cliente          = co.cd_cliente
     left outer join Vendedor v         on v.cd_vendedor         = c.cd_vendedor
where 
       isnull(co.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(co.cd_vendedor,0) else @cd_vendedor end and
       isnull(co.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(co.cd_cliente,0)  else @cd_cliente end and
       isnull(c.cd_pais,0)      = case when @cd_pais     = 0 then isnull(c.cd_pais,0)      else @cd_pais end and
       co.cd_consulta       = ci.cd_consulta and
       year(co.dt_consulta) = @cd_ano 
Group By 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,
      co.cd_vendedor,
      co.cd_cliente,
      c.nm_fantasia_cliente    


Select * from #ConsultaReal




