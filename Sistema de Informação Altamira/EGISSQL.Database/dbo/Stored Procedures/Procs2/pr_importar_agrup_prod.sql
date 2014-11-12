CREATE procedure pr_importar_agrup_prod 
     
  
@cd_agrupamento_produto as int,
@nm_agrupamento_produto as varchar(30),
@sg_agrupamento_produto as char(10),
@cd_usuario as int,
@dt_usuario as datetime,
@cd_agrupamento_prod_pai as int

    
as        
declare @nm_mensagem                varchar(100)        
        
    If Exists (Select 'x' from Agrupamento_Produto where cd_agrupamento_produto = @cd_agrupamento_produto )                                
    begin          
      set @nm_mensagem = 'Agrupamento Produto já cadastrado!'        
      raiserror(@nm_mensagem,16,1)        
      return        
    end        
    Else          
    Insert into Agrupamento_Produto  
    (        
	cd_agrupamento_produto,
	nm_agrupamento_produto,
	sg_agrupamento_produto,
	cd_usuario,
	dt_usuario,
	cd_agrupamento_prod_pai
   )       
values        
    (        
	@cd_agrupamento_produto,
	@nm_agrupamento_produto,
	@sg_agrupamento_produto,
	@cd_usuario,
	@dt_usuario,
	@cd_agrupamento_prod_pai   
     )        
        
      
    
  

