
---------------------------------------------------------------------------------------
--sp_helptext fn_tabela_preco_categoria_produto
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2008
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo		: Busca o Preço de Venda do Produto conforme a Tabela de Preço
--                        do Cliente e pela Categoria do Produto
--
--Data			: 29.08.2008
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_tabela_preco_categoria_produto
( @cd_produto int, 
 @cd_cliente int )
RETURNS NUMERIC(18,2)  
AS  
Begin  

  declare @vl_preco decimal(25,2)
  set @vl_preco             = 0

  if @cd_produto > 0
  begin

    declare @cd_categoria_produto int
    set @cd_categoria_produto = 0
  
    select
      @cd_categoria_produto = isnull(cd_categoria_produto,0)
    from
      Produto p with (nolock)
    where
      cd_produto = @cd_produto

    select 
      @vl_preco = isnull(tp.vl_tabela_preco,0)
    from
      Cliente c 
    inner join Tabela_Preco_Categoria_produto tp on tp.cd_tabela_preco      = c.cd_tabela_preco   and
                                                  tp.cd_categoria_produto = @cd_categoria_produto

    where
      c.cd_cliente = @cd_cliente




    if @vl_preco is null  
       set @vl_preco = 0  


 end

  
 RETURN @vl_preco
   
end  

