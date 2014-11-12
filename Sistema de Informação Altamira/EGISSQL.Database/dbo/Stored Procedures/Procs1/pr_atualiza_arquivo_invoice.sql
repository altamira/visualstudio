
create procedure pr_atualiza_arquivo_invoice

@cd_identificacao_pedido VarChar(20),
@cd_item_ped_imp Int,
@nm_produto_arquivo VarChar(30),
@qt_item_arquivo_texto Float,
@vl_item_arquivo_texto Float,
@sg_origem_importacao Char(1),
@ds_produto_arquivo VarChar(30),
@sg_tipo_embalagem VarChar(2),
@cd_embalagem VarChar(4)

as
Begin
  Declare @cd_pedido_importacao Int
  Declare @vl_unitario_item_ped Float
  Declare @qt_item_ped_imp Float
  Declare @cd_origem_importacao Int
  Declare @nm_produto_pedido VarChar(30)
  Declare @cd_origem_padrao Int
  Declare @sg_origem_padrao Char(1)
  Declare @cd_moeda Int
  Declare @cd_condicao_pagamento Int
  Declare @nm_fantasia_importador VarChar(15)
  Declare @nm_fantasia_fornecedor VarChar(30)
  Declare @cd_produto Int
  Declare @cd_importador Int
  Declare @cd_fornecedor Int
  Declare @pc_frete_tipo_importacao Numeric(7,4)
 
  if charindex('-',@cd_identificacao_pedido,1)-1 > 0 
    set @cd_identificacao_pedido = substring(@cd_identificacao_pedido,1,charindex('-',@cd_identificacao_pedido,1)-1)
  

  -- Dados do pedido
  Select @cd_pedido_importacao = pi.cd_pedido_importacao,
         @pc_frete_tipo_importacao = case when (IsNull(ti.pc_frete_tipo_importacao,0) <> 0)
					  then Cast(ti.pc_frete_tipo_importacao / 100 as Numeric(7,4))
					  else 0 end
  From Pedido_Importacao pi
       Left outer join Tipo_Importacao ti on (ti.cd_tipo_importacao = pi.cd_tipo_importacao)
  Where Left(pi.cd_identificacao_pedido,Len(RTrim(@cd_identificacao_pedido))) = RTrim(@cd_identificacao_pedido)

/*  Select @cd_pedido_importacao = cd_pedido_importacao
  From Pedido_Importacao 
  Where cd_identificacao_pedido = @cd_identificacao_pedido*/
  
  -- Dados dos itens
--  Select @vl_unitario_item_ped = vl_item_ped_imp,
  Select @vl_unitario_item_ped = Round(Round(vl_item_ped_imp + (vl_item_ped_imp * @pc_frete_tipo_importacao),2),0),
         @qt_item_ped_imp = qt_item_ped_imp,
         @nm_produto_pedido = nm_fantasia_produto,
         @cd_produto = cd_produto
  From Pedido_Importacao_Item
  Where cd_pedido_importacao = @cd_pedido_importacao and
        cd_item_ped_imp = @cd_item_ped_imp

  Select @cd_moeda = pi.cd_moeda,
         @cd_condicao_pagamento = pi.cd_condicao_pagamento,
         @nm_fantasia_importador = i.nm_fantasia,
         @nm_fantasia_fornecedor = f.nm_fantasia_fornecedor,
         @cd_importador = pi.cd_importador,
         @cd_fornecedor = pi.cd_fornecedor
  From Pedido_Importacao pi
       Left outer join Importador i on (pi.cd_importador = i.cd_importador)
       Left outer join Fornecedor f on (pi.cd_fornecedor = f.cd_fornecedor)
  Where pi.cd_pedido_importacao = @cd_pedido_importacao 

  -- Dados da origem de importação
  Select @cd_origem_padrao = cd_origem_importacao,
         @sg_origem_padrao = sg_origem_importacao 
  from Origem_Importacao 
  Where IsNull(ic_pad_origem_importacao,'N') = 'S'

  Select @cd_origem_importacao = IsNull(cd_origem_importacao,0)
  From Origem_Importacao
  Where sg_origem_importacao = @sg_origem_importacao

/*  If IsNull(@sg_origem_importacao,'') = '' 
    Begin
      Set @cd_origem_importacao = @cd_origem_padrao
      Set @sg_origem_importacao = @sg_origem_padrao
    End  */

  If Exists (Select 'x'
             from Arquivo_Texto_Invoice_Item 
             where cd_identificacao_pedido = @cd_identificacao_pedido and
                   cd_item_ped_imp = @cd_item_ped_imp)                      

    Update Arquivo_Texto_Invoice_Item set qt_item_arquivo_texto = qt_item_arquivo_texto + @qt_item_arquivo_texto
    where Left(cd_identificacao_pedido,Len(RTrim(@cd_identificacao_pedido))) = RTrim(@cd_identificacao_pedido) and
        --cd_identificacao_pedido = @cd_identificacao_pedido and
          cd_item_ped_imp = @cd_item_ped_imp                      
  Else
	  Insert into Arquivo_Texto_Invoice_Item (ic_produto_diferente, ic_produto_cadastrado, ic_quantidade_diferente,
	                                          ic_preco_diferente, cd_pedido_importacao, nm_produto_pedido,
	                                          qt_item_pedido, vl_unitario_item_ped, cd_identificacao_pedido,
	                                          cd_item_ped_imp, cd_origem_importacao, qt_peso, nm_produto_arquivo,
	                                          qt_item_arquivo_texto, vl_item_arquivo_texto,
	                                          ds_produto_arquivo, sg_origem_importacao, cd_moeda, cd_condicao_pagamento,
	                                          nm_fantasia_importador, nm_fantasia_fornecedor,
	                                          cd_produto, cd_importador, cd_fornecedor, sg_tipo_embalagem, cd_embalagem)
	              Values ('N','N','N','N', @cd_pedido_importacao, @nm_produto_pedido, @qt_item_ped_imp, @vl_unitario_item_ped,
	                      @cd_identificacao_pedido, @cd_item_ped_imp, @cd_origem_importacao, 0, @nm_produto_arquivo,
	                      @qt_item_arquivo_texto, @vl_item_arquivo_texto, @ds_produto_arquivo, @sg_origem_importacao,
	                      @cd_moeda, @cd_condicao_pagamento, @nm_fantasia_importador, @nm_fantasia_fornecedor,
	                      @cd_produto, @cd_importador, @cd_fornecedor, @sg_tipo_embalagem, @cd_embalagem)

  Update Arquivo_Texto_Invoice_Item set ic_produto_diferente = 'S'
  Where nm_produto_pedido <> nm_produto_arquivo

  Update Arquivo_Texto_Invoice_Item set ic_produto_cadastrado = 'S'
  From Arquivo_Texto_Invoice_Item atii
  Where IsNull((select nm_fantasia_produto 
                from produto p
                where p.nm_fantasia_produto = atii.nm_produto_arquivo),'') = ''

  Update Arquivo_Texto_Invoice_Item set ic_quantidade_diferente = 'S'
  Where qt_item_pedido <> qt_item_arquivo_texto

  Update Arquivo_Texto_Invoice_Item set ic_quantidade_diferente = 'N'
  Where qt_item_pedido = qt_item_arquivo_texto

  Update Arquivo_Texto_Invoice_Item set ic_preco_diferente = 'S'
  Where vl_unitario_item_ped <> vl_item_arquivo_texto

  Update Arquivo_Texto_Invoice_Item set ic_pedido_nao_encontrado = 'S'
  Where IsNull(cd_pedido_importacao,0)=0
End
--------------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------------
--exec pr_atualiza_arquivo_invoice
