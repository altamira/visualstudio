
CREATE PROCEDURE pr_atualiza_fornecedor
@nm_fornecedor varchar (50),
@cd_fornecedor integer 
AS

update 
  Nota_Saida_Contabil  
    set nm_fantasia_destinatario = @nm_fornecedor 
  where 
    cd_cliente = @cd_fornecedor 
    and 
    cd_tipo_destinatario = 2

update 
  Nota_Entrada_Contabil  
    set nm_fantasia_destinatario = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor 

update 
  Nota_Entrada 
    set nm_fantasia_destinatario = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor
    and 
    cd_tipo_destinatario = 2

update 
  Nota_Saida 
    set nm_fantasia_destinatario = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor
    and 
    cd_tipo_destinatario = 2

update 
  Documento_Pagar
    set nm_fantasia_fornecedor = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor

update 
  Contrato_Pagar
    set nm_fantasia_fornecedor = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor

update 
  Fornecedor_Contato
    set nm_fantasia_fornecedor = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor
  
update 
  Nota_Saida_Entrada
    set nm_fantasia_nota_entrada = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor 

update 
  Nota_Saida
    set nm_fantasia_nota_saida = @nm_fornecedor 
  where 
    cd_fornecedor = @cd_fornecedor
    and 
    cd_tipo_destinatario = 2 
