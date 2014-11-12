CREATE procedure pr_importar_cor
     
@cd_grupo_produto as int,
@cd_cor as int,
@nm_cor as varchar(40),
@sg_cor as char(10),
@pc_acresc_cor as float(8),
@cd_usuario as int,
@dt_usuario as datetime,
@vl_hexa_cor as char(20),
@cd_cor_texto as int

    
as        
declare @nm_mensagem                varchar(100)        
        
    If Exists (Select 'x' from cor where cd_cor = @cd_cor )                                
    begin          
      set @nm_mensagem = 'Cor já cadastrada!'        
      raiserror(@nm_mensagem,16,1)        
      return        
    end        
    Else          
    Insert into cor  
    (        
	cd_grupo_produto,
	cd_cor,
	nm_cor,
	sg_cor,
	pc_acresc_cor,
	cd_usuario,
	dt_usuario,
	vl_hexa_cor,
	cd_cor_texto
   )       
values        
    (        
	@cd_grupo_produto,
	@cd_cor,
	@nm_cor,
	@sg_cor,
	@pc_acresc_cor,
	@cd_usuario,
	@dt_usuario,
	@vl_hexa_cor,
	@cd_cor_texto
     )        
        
      
    
  

