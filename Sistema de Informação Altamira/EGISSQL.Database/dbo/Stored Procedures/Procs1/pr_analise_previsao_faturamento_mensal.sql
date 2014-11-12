
CREATE PROCEDURE pr_analise_previsao_faturamento_mensal
@cd_vendedor int = 0,
@cd_cliente  int = 0,
@cd_pais  int = 0,
@cd_ano      int = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = '',
@cd_moeda    int      = 1
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



--Quantidades Reais de Propostas

declare @ic_fator_conversao char(1)

select
  @ic_fator_conversao = isnull(ic_conversao_qtd_fator,0)
from
  Parametro_BI
where
  cd_empresa = dbo.fn_empresa()


--Ano

if @cd_ano = 0
begin
   set @cd_ano = year( getdate() )
   --select @cd_ano
end

--select * from nota_saida
--select * from nota_saida_item

Select 
      IDENTITY(int, 1,1)                   AS 'Posicao',
      p.cd_produto, 
      dbo.fn_mascara_produto(p.cd_produto) As cd_mascara_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,

      sum(isnull(case when month(ns.dt_nota_saida) = 1  then nsi.qt_item_nota_saida end,0)) as 'qtdJaneiro',
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then nsi.qt_item_nota_saida end,0)) as 'qtdFevereiro',
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then nsi.qt_item_nota_saida end,0)) as 'qtdMarco',
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then nsi.qt_item_nota_saida end,0)) as 'qtdAbril',
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then nsi.qt_item_nota_saida end,0)) as 'qtdMaio',
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then nsi.qt_item_nota_saida end,0)) as 'qtdJunho',
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then nsi.qt_item_nota_saida end,0)) as 'qtdJulho',
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then nsi.qt_item_nota_saida end,0)) as 'qtdAgosto',
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then nsi.qt_item_nota_saida end,0)) as 'qtdSetembro',
      sum(isnull(case when month(ns.dt_nota_saida) = 10 then nsi.qt_item_nota_saida end,0)) as 'qtdOutubro',
      sum(isnull(case when month(ns.dt_nota_saida) = 11 then nsi.qt_item_nota_saida end,0)) as 'qtdNovembro',
      sum(isnull(case when month(ns.dt_nota_saida) = 12 then nsi.qt_item_nota_saida end,0)) as 'qtdDezembro',
 
     --Valores das Propostas

      sum(isnull(case when month(ns.dt_nota_saida) = 1  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlJaneiro',
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then 
							nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota end,0)) 
		as 'vlFevereiro',
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlMarco',
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlAbril',
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlMaio',
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlJunho',
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlJulho',
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlAgosto',
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlSetembro',
      sum(isnull(case when month(ns.dt_nota_saida) = 10 then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlOutubro',
      sum(isnull(case when month(ns.dt_nota_saida) = 11 then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlNovembro',
      sum(isnull(case when month(ns.dt_nota_saida) = 12 then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) end,0))
		as 'vlDezembro',


     (sum(isnull(case when month(ns.dt_nota_saida) = 1  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 10 then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 11 then nsi.qt_item_nota_saida  end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 12 then nsi.qt_item_nota_saida  end,0)) ) as 'Qtd_ano',

     (sum(isnull(case when month(ns.dt_nota_saida) = 1  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 10 then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 11 then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 12 then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) ) as 'Total_ano',



     (sum(isnull(case when month(ns.dt_nota_saida) = 1  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 10 then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 11 then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0)) +
      sum(isnull(case when month(ns.dt_nota_saida) = 12 then nsi.qt_item_nota_saida * case when @ic_fator_conversao='N' then 1 else isnull(p.vl_fator_conversao_produt,1) end end,0))) / 12 as 'Media',

     --Valores do Faturamento Convertido em Outra Moeda
 
      sum(isnull(case when month(ns.dt_nota_saida) = 1  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0)) 
		as 'vmJaneiroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 2  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0)) 
       as 'vmFevereiroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 3  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0)) 
		as 'vmMarcoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 4  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmAbrilFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 5  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmMaioFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 6  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmJunhoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 7  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmJulhoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 8  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmAgostoFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 9  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmSetembroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 10  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmOutubroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 11  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmNovembroFaturamento',
      sum(isnull(case when month(ns.dt_nota_saida) = 12  then 
				 			 (IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0) 
							 /*--IsNull(nsi.vl_ipi,0)  */ - IsNull(nsi.vl_desp_acess_item,0) - IsNull(nsi.vl_icms_item,0) - IsNull(nsi.vl_desp_aduaneira_item,0) 
							 - IsNull(nsi.vl_ii,0) - IsNull(nsi.vl_pis,0) - IsNull(nsi.vl_cofins,0)) 

							/(case when dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida)>0 then 
									 	dbo.fn_vl_moeda_periodo(@cd_moeda,ns.dt_nota_saida) 
									 else @vl_moeda 
									 end ) 
							end,0))  
		as 'vmDezembroFaturamento',

      max(p.vl_fator_conversao_produt) as fator,
      ns.cd_vendedor,
      ns.cd_cliente,
      c.nm_fantasia_cliente,     
      v.nm_fantasia_vendedor,
      Pais.nm_pais
into
  #NotaReal
from
     Nota_Saida ns
     inner join Nota_Saida_Item nsi     on ns.cd_nota_saida       = nsi.cd_nota_saida
     inner join Operacao_Fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
     left outer join  Produto p         on p.cd_produto           = nsi.cd_produto
     left outer join Unidade_Medida um  on um.cd_unidade_medida   = p.cd_unidade_medida
     left outer join Cliente c          on c.cd_cliente           = ns.cd_cliente
     left join Vendedor V 	        on v.cd_vendedor          = ns.cd_vendedor  
     left join Pais                     on Pais.cd_pais           = c.cd_pais
     
where 
       isnull(ns.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(ns.cd_vendedor,0) else @cd_vendedor end and
       isnull(ns.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(ns.cd_cliente,0)  else @cd_cliente end and
       isnull(c.cd_pais,0)      = case when @cd_pais     = 0 then isnull(c.cd_pais,0)      else @cd_pais end and
       year(ns.dt_nota_saida) = @cd_ano  and
       isnull(opf.ic_comercial_operacao,'N')='S' and 
		 ns.dt_cancel_nota_saida is null and 
       ns.cd_status_nota <> 7               --Nota Cancelada não Entra
Group By 
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,
      ns.cd_vendedor,
      ns.cd_cliente,
      c.nm_fantasia_cliente,
      v.nm_fantasia_vendedor,
      Pais.nm_pais  


Select 
      Posicao,
      cd_produto, 
      cd_mascara_produto,
      nm_fantasia_produto,
      nm_produto,
      sg_unidade_medida,
		qtdJaneiro,
		qtdFevereiro,
		qtdMarco,
		qtdAbril,
		qtdMaio,
		qtdJunho,
		qtdJulho,
		qtdAgosto,
		qtdSetembro,
		qtdOutubro,
		qtdNovembro,
		qtdDezembro,
  		fator,
  		cd_vendedor,
  		cd_cliente,
  		nm_fantasia_cliente,   
      nm_pais,
      nm_fantasia_vendedor,  
      Qtd_ano,
      Total_ano,
      Media,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlJaneiro,0)     else isnull(vmJaneiroFaturamento,0)   end as vlJaneiro,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlFevereiro,0)   else isnull(vmFevereiroFaturamento,0) end as vlFevereiro,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlMarco,0)       else isnull(vmMarcoFaturamento,0)     end as vlMarco,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlAbril,0)       else isnull(vmAbrilFaturamento,0)     end as vlAbril,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlMaio,0)        else isnull(vmMaioFaturamento,0)      end as vlMaio,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlJunho,0)       else isnull(vmJunhoFaturamento,0)     end as vlJunho,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlJulho,0)       else isnull(vmJulhoFaturamento,0)     end as vlJulho,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlAgosto,0)      else isnull(vmAgostoFaturamento,0)    end as vlAgosto,
 		case when @ic_conv_moeda_previsao='N' then isnull(vlSetembro,0)    else isnull(vmSetembroFaturamento,0)  end as vlSetembro,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlOutubro,0)     else isnull(vmOutubroFaturamento,0)   end as vlOutubro,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlNovembro,0)    else isnull(vmNovembroFaturamento,0)  end as vlNovembro,
  		case when @ic_conv_moeda_previsao='N' then isnull(vlDezembro,0)    else isnull(vmDezembroFaturamento,0)  end as vlDezembro
from #NotaReal




