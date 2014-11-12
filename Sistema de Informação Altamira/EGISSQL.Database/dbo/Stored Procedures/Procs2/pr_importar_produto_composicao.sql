create procedure pr_importar_produto_composicao
@cd_produto_pai int,
@cd_produto int,
@cd_item_produto int,
@qt_item_produto int,
@qt_produto_composicao float,
@qt_peso_liquido_produto float,
@qt_peso_bruto_produto float,
@cd_ordem_produto int,
@cd_fase_produto int,
@cd_materia_prima int,
@cd_bitola int,
@cd_usuario int,
@dt_usuario datetime,
@nm_obs_produto_composicao varchar(40),
@ic_calculo_peso_produto char(1),
@pc_composicao_produto float,
@ic_montagemg_produto char(1),
@ic_montagemq_produto char(1),
@ic_tipo_montagem_produto char(1),
@cd_versao_produto_comp int,
@cd_ordem_produto_comp int,
@cd_produto_composicao int,
@cd_versao_produto int,
@nm_produto_comp varchar(50)

as
declare @nm_mensagem                varchar(100)

    If Exists (Select 'x' from Produto_Composicao where cd_produto             = @cd_produto     and
							cd_produto_pai         = @cd_produto_pai )                        
    begin  
      set @nm_mensagem = 'Produto Composição já cadastrado!'
      raiserror(@nm_mensagem,16,1)
      return
    end
    Else  
    Insert into Produto_Composicao
    (
	cd_produto_pai,
	cd_produto,
	cd_item_produto,
	qt_item_produto,
	qt_produto_composicao,
	qt_peso_liquido_produto,
	qt_peso_bruto_produto,
	cd_ordem_produto,
	cd_fase_produto,
	cd_materia_prima,
	cd_bitola,
	cd_usuario,
	dt_usuario,
	nm_obs_produto_composicao,
	ic_calculo_peso_produto,
	pc_composicao_produto,
	ic_montagemg_produto,
	ic_montagemq_produto,
	ic_tipo_montagem_produto,
	cd_versao_produto_comp,
	cd_ordem_produto_comp,
	cd_produto_composicao,
	cd_versao_produto,
	nm_produto_comp
    ) values
    (
	@cd_produto_pai,
	@cd_produto,
	@cd_item_produto,
	@qt_item_produto,
	@qt_produto_composicao,
	@qt_peso_liquido_produto,
	@qt_peso_bruto_produto,
	@cd_ordem_produto,
	@cd_fase_produto,
	@cd_materia_prima,
	@cd_bitola,
	@cd_usuario,
	@dt_usuario,
	@nm_obs_produto_composicao,
	@ic_calculo_peso_produto,
	@pc_composicao_produto,
	@ic_montagemg_produto,
	@ic_montagemq_produto,
	@ic_tipo_montagem_produto,
	@cd_versao_produto_comp,
	@cd_ordem_produto_comp,
	@cd_produto_composicao,
	@cd_versao_produto,
	@nm_produto_comp
     )

