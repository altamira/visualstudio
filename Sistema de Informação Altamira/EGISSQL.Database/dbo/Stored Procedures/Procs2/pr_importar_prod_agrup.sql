CREATE procedure pr_importar_prod_agrup
     
  
@cd_agrupamento_produto as int,
@nm_agrupamento_produto as varchar(30),
@sg_agrupamento_produto as char(10),
@cd_usuario as int,
@dt_usuario as datetime
    
as        
declare @nm_mensagem                varchar(100)        
        
    If Exists (Select 'x' from Produto_Agrupamento where cd_agrupamento_produto = @cd_agrupamento_produto )                                
    begin          
      set @nm_mensagem = 'Produto Agrupamento já cadastrado!'        
      raiserror(@nm_mensagem,16,1)        
      return        
    end        
    Else          
    Insert into Produto_Agrupamento  
    (        
	cd_agrupamento_produto,
	nm_agrupamento_produto,
	sg_agrupamento_produto,
	cd_usuario,
	dt_usuario
   )       
values        
    (        
	@cd_agrupamento_produto,
	@nm_agrupamento_produto,
	@sg_agrupamento_produto,
	@cd_usuario,
	@dt_usuario
     )        
        
      
    
  

