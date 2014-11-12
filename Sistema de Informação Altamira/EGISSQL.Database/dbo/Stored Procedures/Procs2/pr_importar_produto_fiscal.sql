CREATE procedure pr_importar_produto_fiscal
 
@cd_produto as int,
@cd_destinacao_produto as int,
@cd_dispositivo_legal_ipi as int,
@cd_dispositivo_legal_icms as int,
@cd_tipo_produto as int,
@cd_procedencia_produto as int,
@cd_classificacao_fiscal as int,
@cd_tributacao as int,
@cd_usuario as int,
@dt_usuario as datetime,
@pc_aliquota_iss_produto as float,
@pc_aliquota_icms_produto as float,
@ic_substrib_produto as char(1),
@qt_aliquota_icms_produto as float,
@pc_interna_icms_produto as float,
@ic_isento_icms_produto as char(1) 
as    
declare @nm_mensagem  varchar(100)    
    
    If Exists (Select 'x' from Produto_Fiscal where cd_produto = @cd_produto )                            
    begin      
      set @nm_mensagem = 'Produto Fiscal já cadastrado!'    
      raiserror(@nm_mensagem,16,1)    
      return    
    end    
    Else      
    Insert into Produto_Fiscal
    (    
	cd_produto,
	cd_destinacao_produto,
	cd_dispositivo_legal_ipi,
	cd_dispositivo_legal_icms,
	cd_tipo_produto,
	cd_procedencia_produto,
	cd_classificacao_fiscal,
	cd_tributacao,
	cd_usuario,
	dt_usuario,
	pc_aliquota_iss_produto,
	pc_aliquota_icms_produto,
	ic_substrib_produto,
	qt_aliquota_icms_produto,
	pc_interna_icms_produto,
	ic_isento_icms_produto
    )   
values    
    (    
 	@cd_produto,
	@cd_destinacao_produto,
	@cd_dispositivo_legal_ipi,
	@cd_dispositivo_legal_icms,
	@cd_tipo_produto,
	@cd_procedencia_produto,
	@cd_classificacao_fiscal,
	@cd_tributacao,
	@cd_usuario,
	@dt_usuario,
	@pc_aliquota_iss_produto,
	@pc_aliquota_icms_produto,
	@ic_substrib_produto,
	@qt_aliquota_icms_produto,
	@pc_interna_icms_produto,
	@ic_isento_icms_produto
     )    
    
  

