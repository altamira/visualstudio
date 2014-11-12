create procedure pr_importar_produto_composicao_agrupamento

@cd_produto_pai int,
@cd_agrupamento_produto int,
@cd_minimo_componentes int,
@cd_maximo_componentes int
  
  
as  
declare @nm_mensagem                varchar(100)  
  
    If Exists (Select 'x' from Produto_Composicao_Agrupamento where cd_produto_pai         = @cd_produto_pai and  
      								    cd_agrupamento_produto = @cd_agrupamento_produto)                          
    begin    
      set @nm_mensagem = 'Produto Composição Agrupamento já cadastrado!'  
      raiserror(@nm_mensagem,16,1)  
      return  
    end  
    Else    
    Insert into Produto_Composicao_Agrupamento  
    (  
 cd_produto_pai,
 cd_agrupamento_produto,
 cd_minimo_componentes,
 cd_maximo_componentes

    ) values  
    (  
 @cd_produto_pai,
 @cd_agrupamento_produto,
 @cd_minimo_componentes,
 @cd_maximo_componentes
     )  
  

