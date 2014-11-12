

-------------------------------------------------------------------------------
--sp_helptext pr_geracao_fornecedor_produto_cotacao
-------------------------------------------------------------------------------
--pr_geracao_fornecedor_produto_cotacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração Automática da Tabela Fornecedor x Produto com os 
--                   produtos da Requisição de
--Data             : 09.08.2007
--Alteração        : 09.08.2007
------------------------------------------------------------------------------
create procedure pr_geracao_fornecedor_produto_cotacao
@cd_requisicao_compra int = 0,
@cd_usuario           int = 0

as


--	
--select * from fornecedor_produto

if @cd_requisicao_compra>0 
begin

  --Montagem da Tabela temporária dos produtos da requisição

  select
    ir.cd_produto
  into
    #ProdutoRequisicao
  from
    Requisicao_Compra_Item ir
  where
    cd_requisicao_compra = @cd_requisicao_compra and
    isnull(ir.cd_produto,0)>0
  group by 
    ir.cd_produto


--  select * from #ProdutoRequisicao

  --Montagem da Tabela temporária como os fornecedores selecionados

  select
    rf.cd_fornecedor
  into
    #Fornecedor
  from
    requisicao_compra_fornecedor rf
  where
    rf.cd_requisicao_compra = @cd_requisicao_compra
  group by
    rf.cd_fornecedor
 

--  select * from #Fornecedor

  declare @cd_fornecedor int
  declare @cd_produto    int
  
  while exists ( select top 1 cd_fornecedor from #Fornecedor )
  begin

    select top 1 
      @cd_fornecedor = cd_fornecedor
    from
      #Fornecedor

    select
      @cd_fornecedor as cd_fornecedor,
      pr.cd_produto  as cd_produto,
      'S'            as ic_cotacao_fornecedor,
      @cd_usuario    as cd_usuario,
      getdate()      as dt_usuario
           
    into 
      #Fornecedor_Produto
    from
      #ProdutoRequisicao pr     

    --Deleta os Códigos já Cadastrados

--    select * from #Fornecedor_Produto
    
    delete #Fornecedor_Produto 
    from
      #Fornecedor_Produto fp
    inner join Fornecedor_Produto xfp on xfp.cd_fornecedor = fp.cd_fornecedor and xfp.cd_produto = fp.cd_produto

    --verifica se existe o registro

    insert into
     fornecedor_Produto 
     ( cd_fornecedor,
       cd_produto,
       ic_cotacao_fornecedor,
       cd_usuario,
       dt_usuario )
    select
      *
    from
      #Fornecedor_Produto 

      
    delete from #Fornecedor where cd_fornecedor = @cd_fornecedor
    drop table #Fornecedor_Produto

  end

--select * from fornecedor_produto

end

