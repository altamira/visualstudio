create procedure pr_importar_produto_imagem
   
@cd_produto as int,
@cd_produto_imagem as int,
@nm_imagem_produto as varchar(100),
@cd_usuario as int,
@dt_usuario as datetime, 
@cd_tipo_imagem_produto as int

  
as      
declare @nm_mensagem                varchar(100)      
      
    If Exists (Select 'x' from Produto_Imagem where cd_produto = @cd_produto and
						    cd_produto_imagem = @cd_produto_imagem )                              
    begin        
      set @nm_mensagem = 'Produto Imagem já cadastrado!'      
      raiserror(@nm_mensagem,16,1)      
      return      
    end      
    Else        
    Insert into Produto_Imagem
    (      
 cd_produto,
 cd_produto_imagem,
 nm_imagem_produto,
 cd_usuario,
 dt_usuario,
 cd_tipo_imagem_produto
   )     
values      
    (      
  @cd_produto,
  @cd_produto_imagem,
  @nm_imagem_produto,
  @cd_usuario,
  @dt_usuario,
  @cd_tipo_imagem_produto  
     )      
      
    
  

