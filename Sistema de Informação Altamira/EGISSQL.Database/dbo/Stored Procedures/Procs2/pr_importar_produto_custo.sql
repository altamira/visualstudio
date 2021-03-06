﻿create procedure pr_importar_produto_custo

@cd_produto int,
@ic_peps_produto char(1),
@ic_lista_preco_produto char(1),
@ic_lista_rep_produto char(1),
@ic_reposicao_produto char(1),
@vl_custo_produto float(8),
@ic_estoque_produto char(1),
@ic_orcamento_produto char(1),
@ic_imediato_produto char(1),
@ic_importacao_produto char(1),
@ic_reserva_estoque_produto char(1),
@ic_estoque_fatura_produto char(1),
@ic_estoque_venda_produto char(1),
@ic_venda_saldo_negativo char(1),
@ic_controle_desconto_produto char(1),
@ic_fechamento_mensal_produto char(1),
@qt_dia_valoracao float(8),
@cd_tipo_valoracao int,
@cd_tipo_lucro int,
@cd_aplicacao int,
@cd_grupo_preco_produto int,
@cd_cab_lista_preco int,
@cd_usuario int,
@dt_usuario varchar(12),
@qt_mes_consumo_produto int,
@cd_grupo_produto int,
@cd_tipo_valoracao_produto int,
@ic_exportacao_produto char(1),
@vl_custo_anterior_produto float(8),
@cd_mat_prima int,
@qt_consumo_mensal float(8),
@ic_reserva_estoque_produt char(1),
@ic_fechamento_mensal_prod char(1),
@ic_controle_desconto_prod char(1),
@cd_aplicacao_markup int,
@cd_plano_financeiro int,
@ic_smo_produto char(1),
@vl_custo_contabil_produto float(8),
@vl_custo_medio_produto float(8),
@ic_atualiza_custo_nf char(1),
@cd_grupo_inventario int,
@cd_bitola int,
@cd_metodo_valoracao int,
@cd_lancamento_padrao int,
@vl_net_outra_moeda float(8),
@cd_grupo_estoque int,
@nm_obs_custo_produto varchar(40),
@dt_custo_produto varchar(12),
@vl_base_custo_produto float(8), 
@dt_base_custo_produto varchar(12),
@vl_simulado_custo_produto float(8),
@dt_simulado_custo_produto varchar(12),
@vl_temp_custo_produto float(8),
@dt_temp_custo_produto varchar(12),
@cd_overprice int,
@dt_net_outra_moeda varchar(12),
@vl_custo_previsto_produto float,
@ic_mat_prima_produto char(1),
@vl_custo_exportacao float
as  
declare @nm_mensagem                varchar(100)  
  
    If Exists (Select 'x' from Produto_Custo where cd_produto = @cd_produto )                          
    begin    
      set @nm_mensagem = 'Produto Custo já cadastrado!'  
      raiserror(@nm_mensagem,16,1)  
      return  
    end  
    Else    
    Insert into Produto_Custo
    (  
	cd_produto,
	ic_peps_produto,
	ic_lista_preco_produto,
	ic_lista_rep_produto,
	ic_reposicao_produto,
	vl_custo_produto,
	ic_estoque_produto,
	ic_orcamento_produto,
	ic_imediato_produto,
	ic_importacao_produto,
	ic_reserva_estoque_produto,
	ic_estoque_fatura_produto,
	ic_estoque_venda_produto,
	ic_venda_saldo_negativo,
	ic_controle_desconto_produto,
	ic_fechamento_mensal_produto,
	qt_dia_valoracao,
	cd_tipo_valoracao,
	cd_tipo_lucro,
	cd_aplicacao,
	cd_grupo_preco_produto,
	cd_cab_lista_preco,
	cd_usuario,
	dt_usuario,
	qt_mes_consumo_produto,
	cd_grupo_produto,
	cd_tipo_valoracao_produto,
	ic_exportacao_produto,
	vl_custo_anterior_produto,
	cd_mat_prima,
	qt_consumo_mensal,
	ic_reserva_estoque_produt,
	ic_fechamento_mensal_prod,
	ic_controle_desconto_prod,
	cd_aplicacao_markup,
	cd_plano_financeiro,
	ic_smo_produto,
	vl_custo_contabil_produto,
	vl_custo_medio_produto,
	ic_atualiza_custo_nf,
	cd_grupo_inventario,
	cd_bitola,
	cd_metodo_valoracao,
	cd_lancamento_padrao,
	vl_net_outra_moeda,
	cd_grupo_estoque,
	nm_obs_custo_produto,
	dt_custo_produto,
	vl_base_custo_produto,
	dt_base_custo_produto,
	vl_simulado_custo_produto,
	dt_simulado_custo_produto,
	vl_temp_custo_produto,
	dt_temp_custo_produto,
	cd_overprice,
	dt_net_outra_moeda,
	vl_custo_previsto_produto,
	ic_mat_prima_produto,
	vl_custo_exportacao
    ) 
values  
    (  
	@cd_produto,
	@ic_peps_produto,
	@ic_lista_preco_produto,
	@ic_lista_rep_produto,
	@ic_reposicao_produto,
	@vl_custo_produto,
	@ic_estoque_produto,
	@ic_orcamento_produto,
	@ic_imediato_produto,
	@ic_importacao_produto,
	@ic_reserva_estoque_produto,
	@ic_estoque_fatura_produto,
	@ic_estoque_venda_produto,
	@ic_venda_saldo_negativo,
	@ic_controle_desconto_produto,
	@ic_fechamento_mensal_produto,
	@qt_dia_valoracao,
	@cd_tipo_valoracao,
	@cd_tipo_lucro,
	@cd_aplicacao,
	@cd_grupo_preco_produto,
	@cd_cab_lista_preco,
	@cd_usuario,
	@dt_usuario,
	@qt_mes_consumo_produto,
	@cd_grupo_produto,
	@cd_tipo_valoracao_produto,
	@ic_exportacao_produto,
	@vl_custo_anterior_produto,
	@cd_mat_prima,
	@qt_consumo_mensal,
	@ic_reserva_estoque_produt,
	@ic_fechamento_mensal_prod,
	@ic_controle_desconto_prod,
	@cd_aplicacao_markup,
	@cd_plano_financeiro,
	@ic_smo_produto,
	@vl_custo_contabil_produto,
	@vl_custo_medio_produto,
	@ic_atualiza_custo_nf,
	@cd_grupo_inventario,
	@cd_bitola,
	@cd_metodo_valoracao,
	@cd_lancamento_padrao,
	@vl_net_outra_moeda,
	@cd_grupo_estoque,
	@nm_obs_custo_produto,
	@dt_custo_produto,
	@vl_base_custo_produto,
	@dt_base_custo_produto,
	@vl_simulado_custo_produto,
	@dt_simulado_custo_produto,
	@vl_temp_custo_produto,
	@dt_temp_custo_produto,
	@cd_overprice,
	@dt_net_outra_moeda,
	@vl_custo_previsto_produto,
	@ic_mat_prima_produto,
	@vl_custo_exportacao
     )  
  

